--base de datpos
CREATE DATABASE TerminalUy
go

USE TerminalUy
go

-----------------------------------------------------TABLAS------------------------------------------------------------------------------------
--EMPLEADOS
CREATE TABLE Empleado(
Cedula int primary key check(Cedula > 999999),
Pass varchar(6) not null check(len(Pass)=6),
Nombre varchar(25) not null check(len(Nombre)>2),
Estado bit not null default 1
);
go

--TERMINALES
CREATE TABLE Terminal(
Codigo varchar(3) primary key check(Codigo like '[a-z][a-z][a-z]'),
Ciudad varchar(30)not null,
Pais varchar(20) check(Pais='ARGENTINA' or Pais='BRAZIL' or Pais='PARAGUAY' or Pais='URUGUAY'),
Estado bit not null default 1
);
go

--FACILIDADES
CREATE TABLE Facilidades(
Codigo varchar(3) foreign key references Terminal (Codigo),
Facilidad varchar(20) not null,
primary key(Codigo,Facilidad)
);
go

--COMPANIAS
CREATE TABLE Compania(
Nombre varchar(20) primary key,
Direccion varchar(30)not null,
Telefono int not null check(len(Telefono)=9 or len(Telefono)=8),
Estado bit not null default 1
);
go

--VIAJES
CREATE TABLE Viaje(
NViaje int primary key not null,
NCompania varchar(20)not null foreign key references Compania(Nombre),
Destino varchar(3) not null foreign key references Terminal(Codigo),
EmpleadoMOG int not null foreign key references Empleado(Cedula),
FPartida datetime not null,
FDestino datetime not null,
CantAsientos int not null check(CantAsientos > 19) default 20,
check(Fpartida < FDestino)
);
go

--VIAJES INTERNACIONALES
CREATE TABLE ViajeInternacional(
NViaje int primary key foreign key references Viaje (NViaje) not null,
ServicioABordo bit not null default 0,
Documentacion varchar(100)not null
);
go

--VIAJES NACIONALES
CREATE TABLE ViajeNacional(
NViaje int primary key foreign key references Viaje (NViaje) not null,
CantParadas int not null check(CantParadas >= 0) default 0
);
go

-----------------------------------------------------STORED PROCEDURES------------------------------------------------------------------------------------


-----------------------------------------------------SP EMPLEADOS------------------------------------------------------------------------------------
--ALTA
CREATE PROC AltaEmpleado
@Cedula int,
@Pass varchar(6),
@Nombre varchar(25)
AS BEGIN
	begin try
		--verificar existencia de empleado
		if exists(select Cedula from Empleado where Cedula=@Cedula)
		begin 
			--si el empleado existente esta desactivado activar y devolver 1
			if exists(select Cedula from Empleado where Cedula=@Cedula and Estado=0)
			begin
				update Empleado set Pass=@Pass,Nombre=@Nombre,Estado=1 where Cedula=@Cedula;
				return 1;
			end
			
			--si el empleado existente esta activo devolver -1
			else
			begin
				return -1;
			end
		end
		
		--si el empleado no existe insertar
		else
		begin
			insert into Empleado values(@Cedula,@Pass,@Nombre,1);
			return 1;
		end
	end try
	
	--error inesperado -2
	begin catch
		return -2;
	end catch
END
go

--BAJA
CREATE PROC BajaEmpleado
@Cedula int
AS BEGIN
	--si existe un empleado
	if exists(select Cedula from Empleado where Cedula = @Cedula and Estado=1)
	begin
		--si este empleado tiene una relacion
		if exists(select EmpleadoMOG from Viaje where EmpleadoMOG=@Cedula)
		begin
			update Empleado set Estado = 0 where Cedula=@Cedula
			return 1
		end
		
		--de lo contrario devolver 
		else
		begin
			delete Empleado where Cedula=@Cedula
			return 1
		end
	end
	
	--si el empleado no existe
	else
	begin
		return -1
	end
END
GO

--MODIFICAR
CREATE PROC ModificarEmpleado
@Cedula int,
@Pass varchar(6),
@Nombre varchar(25)
AS BEGIN
	--si existe un empleado activo
	if exists(select Cedula from Empleado where Cedula=@Cedula and Estado=1)
	begin
		update Empleado set Pass=@Pass,Nombre=@Nombre where Cedula=@Cedula
		return 1
	end
	
	--de lo contrario devolver 0
	else
	begin
		return 0
	end
END
GO

--BUSQUEDA
CREATE PROC BuscarEmpleado
@Cedula int
AS BEGIN
	select * from Empleado where Cedula=@Cedula
END
GO

-----------------------------------------------------SP TERMINAL------------------------------------------------------------------------------------
--ALTLA
CREATE PROC AltaTerminal
@Codigo varchar(3),
@Ciudad varchar(30),
@Pais varchar(20) 
AS BEGIN
	--si la terminal existe
	if exists(select Codigo from Terminal where Codigo=@Codigo)
	begin
		--si esta terminal esta desactiva
		if exists(select Codigo from Terminal where Codigo=@Codigo and Estado=0)
		begin
			update Terminal set Ciudad=@Ciudad,Pais=@Pais,Estado=1 where Codigo=@Codigo
			return 1
		end
		
		--existe y esta activa
		else 
		begin
			return -1
		end
	end
	
	--si no existe
	else
	begin
		insert into Terminal values(@Codigo,@Ciudad,@Pais,1)
		return 1
	end
END
GO

--BAJA
CREATE PROC BajaTerminal
@Codigo varchar(3)
AS BEGIN
	--si existe una terminal
	if exists(select Codigo from Terminal where Codigo=@Codigo and Estado=1)
	begin
		--si esta terminal tiene una relacion
		if exists(select Destino from Viaje where Destino=@Codigo)
		begin
			update Terminal set Estado=0 where Codigo=@Codigo
			return 1
		end
		
		--si no tiene relacion
		else
		begin
			begin transaction
				--eliminar facilidades
				delete Facilidades where Codigo=@Codigo
				--verificar error
				if(@@ERROR!=0)
				begin
					rollback transaction
					return -1
				end
				
				--eliminar terminal
				delete Terminal where Codigo=@Codigo
				--verificar error			
				if(@@ERROR!=0)
				begin
					rollback transaction
					return -1
				end
				return 1
			commit transaction
		end
	end
	
	--si no existe
	else
	begin
		return -2
	end
END
GO

--MODIFICAR
CREATE PROC ModificarTerminal
@Codigo varchar(3),
@Ciudad varchar(30),
@Pais varchar(20) 
AS BEGIN
	--si existe terminal
	if exists(select Codigo from Terminal where Codigo=@Codigo and Estado=1)
	begin
		update Terminal set Ciudad=@Ciudad,Pais=@Pais where Codigo=@Codigo
		return 1
	end
	
	--si no existe
	else
	begin
		return -1
	end
END
GO

--BUSQUEDA
CREATE PROC BuscarTerminal
@Codigo varchar(3)
AS BEGIN
	select * from Terminal where Codigo=@Codigo
END
GO

-----------------------------------------------------SP FACILIDADES------------------------------------------------------------------------------------
--ALTA
CREATE PROC AltaFacilidad
@Codigo varchar(3),
@Facilidad varchar(20) 
AS BEGIN
	--si existe terminal
	if exists(select Codigo from Terminal where Codigo=@Codigo and Estado=1)
	begin
		--si no existe esta facilidad en esta terminal
		if not exists(select Codigo from Facilidades where Codigo=@Codigo and Facilidad=@Facilidad)
		begin
			insert Facilidades values(@Codigo,@Facilidad)
			return 1
		end
		
		--la facilidad ya existe
		else
		begin
			return -2
		end
	end
	
	--de lo contrario
	else
	begin
		return -1
	end	
END
GO

-----------------------------------------------------SP COMPANIA------------------------------------------------------------------------------------
--ALTA
CREATE PROC AltaCompania
@Nombre varchar(20),
@Direccion varchar(30),
@Telefono int
AS BEGIN
	--si existe compania
	if exists(select Nombre from Compania where Nombre=@Nombre)
	begin
		--si esta activa
		if exists(select Nombre from Compania where Nombre=@Nombre and Estado=0)
		begin
			update Compania set Direccion=@Direccion,Telefono=@Telefono,Estado=1 where Nombre=@Nombre
			return 1

		end
		
		--si no esta activa
		else
		begin
			return -1
		end
	end
	
	--si no existe
	else
	begin
		insert into Compania values(@Nombre,@Direccion,@Telefono,1)
		return 1
	end
END 
GO

--BAJA
CREATE PROC BajaCompania
@Nombre varchar(20)
AS BEGIN
	--si existe
	if exists(select Nombre from Compania where Nombre=@Nombre and Estado=1)
	begin
		--si tiene una relacion
		if exists(select NCompania from Viaje where NCompania=@Nombre)
		begin
			update Compania set Estado=0 where Nombre=@Nombre
			return 1	
		end
		
		--si no tiene relacion
		else
		begin
			delete Compania where Nombre=@Nombre
			return 1
		end
	end
	
	--si no existe
	else 
	begin
		return -1
	end
END	
GO

--MODIFICAR
CREATE PROC ModificarCompania
@Nombre varchar(20),
@Direccion varchar(30),
@Telefono int
AS BEGIN
	--si existe una compania activa
	if exists(select Nombre from Compania where Nombre=@Nombre and Estado=1)
	begin
		update Compania set Direccion=@Direccion,Telefono=@Telefono
		return 1
	end
	
	--si no existe
	else
	begin 
		return -1
	end	
END
GO

--BUSQUEDA
CREATE PROC BuscarCompania
@Nombre varchar(20)
AS BEGIN
	select * from Compania where Nombre=@Nombre
END
GO

-----------------------------------------------------SP VIAJES INTERNACIONALES------------------------------------------------------------------------------------
--Alta
CREATE PROC AltaViajeInternacional
@NViaje int,
@NCompania varchar(20),
@Destino varchar(3),
@EmpleadoMOG int,
@FPartida datetime,
@FDestino datetime,
@CantAsientos int,
@ServicioABordo bit,
@Documentacion varchar(100)
AS BEGIN
	--si no existe viaje internacional
	if not exists(select NViaje from ViajeInternacional where NViaje=@NViaje)
	begin
		--si existe compania
		if exists(select Nombre from Compania where Nombre=@NCompania and Estado=1)
		begin
			--si existe terminal
			if exists(select Codigo from Terminal where Codigo=@Destino and Estado=1)
			begin
				--si existe empleado
				if exists(select Cedula from Empleado where Cedula=@EmpleadoMOG and Estado=1)
				begin 
					begin transaction
						--insertar viaje
						insert into Viaje values(@NViaje,@NCompania,@Destino,@EmpleadoMOG,@FPartida,@FDestino,@CantAsientos)
						--verificar error
						if(@@ERROR!=0)
						begin
							rollback transaction
							return -5
						end
						
						--insertar viaje internacional
						insert into ViajeInternacional values(@NViaje,@ServicioABordo,@Documentacion)
						--verificar error
						if(@@ERROR!=0)
						begin
							rollback transaction
							return -5
						end
						return 1
					commit transaction
				end
				
				--si no existe empleado
				else
				begin
					return -1
				end
			end
			
			--si no existe terminal
			else
			begin
				return -2
			end
		end
		
		--si no existe compania
		else
		begin
			return -3
		end
	end
	
	--si existe viaje internacional
	else 
	begin
		return -4
	end	
END
GO

--BAJA
CREATE PROC BajaViajeInternacional
@NViaje int
AS BEGIN
	--verificar si existe viaje internacional
	if exists(select NViaje from ViajeInternacional where NViaje=@NViaje)
	begin
		begin transaction
			--eliminar viaje internacional
			delete ViajeInternacional where NViaje=@NViaje
			--verificar error
			if(@@ERROR!=0)
			begin
				rollback transaction
				return -3
			end
				
			--eliminar viaje
			delete Viaje where NViaje=@NViaje
			--verificar error
			if(@@ERROR!=0)
			begin
				rollback transaction
				return -3
			end
			return 1
		commit transaction
	end
	
	--si no existe viaje internacional
	else 
	begin
		return -2
	end
END
GO

--MODIFICAR
CREATE PROC ModificarViajeInternacional
@NViaje int,
@NCompania varchar(20),
@Destino varchar(3),
@EmpleadoMOG int,
@FPartida datetime,
@FDestino datetime,
@CantAsientos int,
@ServicioABordo bit,
@Documentacion varchar(100)
AS BEGIN
	--si existe viaje nacional
	if exists(select NViaje from ViajeInternacional where NViaje=@NViaje)
	begin
		--si existe compania
		if exists(select Nombre from Compania where Nombre=@NCompania and Estado=1)
		begin
			--si existe terminal
			if exists(select Codigo from Terminal where Codigo=@Destino and Estado=1)
			begin
				--si existe empleado
				if exists(select Cedula from Empleado where Cedula=@EmpleadoMOG and Estado=1)
				begin 
					begin transaction
						--actualizar viaje
						update Viaje set NCompania=@NCompania,Destino=@Destino,EmpleadoMOG=@EmpleadoMOG,FPartida=@FPartida,FDestino=@FDestino,CantAsientos=@CantAsientos where NViaje=@NViaje
						--verificar error
						if(@@ERROR!=0)
						begin
							rollback transaction
							return -6
						end
						
						--actualizar viaje internacional
						update ViajeInternacional set ServicioABordo=@ServicioABordo,Documentacion=@Documentacion where NViaje=@NViaje
						--verificar error
						if(@@ERROR!=0)
						begin
							rollback transaction
							return -6
						end
						
						return 1
					commit transaction	
				end
					
				--si no existe empleado
				else
				begin
					return -1
				end
			end
				
			--si no existe terminal
			else
			begin
				return -2
			end
		end
			
		--si no existe compania
		else
		begin
			return -3
		end
	end
		
	--si no existe viaje internacional
	else
	begin
		return -4
	end
END
GO

--BUSQUEDA
CREATE PROC BuscarViajeInternacional
@NViaje int
AS BEGIN
	select * from ViajeInternacional join Viaje on ViajeInternacional.NViaje=Viaje.NViaje where ViajeInternacional.NViaje=@NViaje and Viaje.FPartida>CURRENT_TIMESTAMP
END
GO

-----------------------------------------------------SP VIAJES NACIONALES------------------------------------------------------------------------------------

--Alta
CREATE PROC AltaViajeNacional
@NViaje int,
@NCompania varchar(20),
@Destino varchar(3),
@EmpleadoMOG int,
@FPartida datetime,
@FDestino datetime,
@CantAsientos int,
@CantParadas int
AS BEGIN
	--si no existe viaje nacional
	if not exists(select NViaje from ViajeNacional where NViaje=@NViaje)
	begin
		--si existe compania
		if exists(select Nombre from Compania where Nombre=@NCompania and Estado=1)
		begin
			--si existe terminal
			if exists(select Codigo from Terminal where Codigo=@Destino and Estado=1)
			begin
				--si existe empleado
				if exists(select Cedula from Empleado where Cedula=@EmpleadoMOG and Estado=1)
				begin 
					begin transaction
						--insertar viaje
						insert into Viaje values(@NViaje,@NCompania,@Destino,@EmpleadoMOG,@FPartida,@FDestino,@CantAsientos)
						--verificar error
						if(@@ERROR!=0)
						begin
							rollback transaction
							return -6
						end
							
						--insertar viaje nacional
						insert into ViajeNacional values(@NViaje,@CantParadas)
						--verificar error
						if(@@ERROR!=0)
						begin
							rollback transaction
							return -6
						end
						return 1
					commit transaction
				end
					
				--si no existe empleado
				else
				begin
					return -1
				end
			end
			
			--si no existe terminal
			else
			begin
				return -2
			end
		end
			
		--si no existe compania
		else
		begin
			return -3
		end
	end
		
	--si existe viaje nacional
	else 
	begin
		return -4
	end	
END
GO

--BAJA
CREATE PROC BajaViajeNacional
@NViaje int
AS BEGIN
	--verificar si existe viaje nacional
	if exists(select NViaje from ViajeNacional where NViaje=@NViaje)
	begin
		begin transaction
			--eliminar viaje nacional
			delete ViajeNacional where NViaje=@NViaje
			--verificar error
			if(@@ERROR!=0)
			begin
				rollback transaction
				return -3
			end
			--eliminar viaje
			delete Viaje where NViaje=@NViaje
			--verificar error
			if(@@ERROR!=0)
			begin
				rollback transaction
				return -3
			end
			return 1
		commit transaction
	end
		
	--si no existe viaje nacional
	else 
	begin
		return -2
	end
END
GO

--MODIFICAR
CREATE PROC ModificarViajeNacional
@NViaje int,
@NCompania varchar(20),
@Destino varchar(3),
@EmpleadoMOG int,
@FPartida datetime,
@FDestino datetime,
@CantAsientos int,
@CantParadas int
AS BEGIN
	--si existe viaje nacional
	if exists(select NViaje from ViajeNacional where NViaje=@NViaje)
	begin
		--si existe compania
		if exists(select Nombre from Compania where Nombre=@NCompania and Estado=1)
		begin
			--si existe terminal
			if exists(select Codigo from Terminal where Codigo=@Destino and Estado=1)
			begin
				--si existe empleado
				if exists(select Cedula from Empleado where Cedula=@EmpleadoMOG and Estado=1)
				begin 
					begin transaction
						--actualizar viaje
						update Viaje set NCompania=@NCompania,Destino=@Destino,EmpleadoMOG=@EmpleadoMOG,FPartida=@FPartida,FDestino=@FDestino,CantAsientos=@CantAsientos where NViaje=@NViaje
						--verificar error
						if(@@ERROR!=0)
						begin
							rollback transaction
							return -7
						end
						--actualizar viaje internacional
						update ViajeNacional set CantParadas=@CantParadas where NViaje=@NViaje
						--verificar error
						if(@@ERROR!=0)
						begin
							rollback transaction
							return -7
						end
						return 1
					commit transaction
				end
					
				--si no existe empleado
				else
				begin
					return -1
				end
			end
				
			--si no existe terminal
			else
			begin
				return -2
			end
		end
		
		--si no existe compania
		else
		begin
			return -3
		end
	end
	
	--si no existe viaje nacional
	else
	begin
		return -4
	end
END
GO

--BUSQUEDA
CREATE PROC BuscarViajeNacional
@NViaje int
AS BEGIN
	select * from ViajeNacional join Viaje on ViajeNacional.NViaje=Viaje.NViaje where ViajeNacional.NViaje=@NViaje and Viaje.FPartida>CURRENT_TIMESTAMP
END
GO


