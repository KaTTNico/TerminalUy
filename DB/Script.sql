--drop database TerminalUy
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
	
	--de lo contrario devolver -11
	else
	begin
		return -1
	end
END
GO

--BUSQUEDA
CREATE PROC BuscarEmpleado
@Cedula int
AS BEGIN
	select * from Empleado where Cedula=@Cedula and Estado=1
END
GO

--LSTAR EMPLEADOS ACTIVOS
CREATE PROC ListarEmpleadosActivos
AS BEGIN
	select * from Empleado where Estado=1
END
GO

--LISTAR TODOS LOS EMPLEADOS
CREATE PROC ListarEmpleados
AS BEGIN
	select * from Empleado 
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
			commit transaction
			return 1
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
	select * from Terminal where Codigo=@Codigo and Estado=1
END
GO

--LISTAR TERMINALES ACTIVAS
CREATE PROC ListarTerminalesActivas
AS BEGIN
	select * from Terminal where Estado=1
END		
GO

--LISTAR TERMINALES
CREATE PROC ListarTerminales
AS BEGIN
	select *  from Terminal
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

--BUSCAR FACILIDADES
CREATE PROCEDURE BuscarFacilidades
@codigo varchar(3)
AS BEGIN
	select * from Facilidades where Codigo=@codigo
END
GO

--MODIFICAR FACILIDAD
CREATE PROCEDURE ModificarFacilidad
@Codigo varchar(3),
@Facilidad varchar(20)
AS BEGIN
	--si existe terminal
	if exists(select Codigo from Terminal where Codigo=@Codigo and Estado=1)
	begin
		delete Facilidades where Codigo=@Codigo
		insert into Facilidades values (@Codigo,@Facilidad)
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
		--si no esta activa
		if exists(select Nombre from Compania where Nombre=@Nombre and Estado=0)
		begin
			update Compania set Direccion=@Direccion,Telefono=@Telefono,Estado=1 where Nombre=@Nombre
			return 1

		end
		
		--si esta activa
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
	select * from Compania where Nombre=@Nombre and Estado=1
END
GO

--LISTAR COMPANIAS ACTIVAS
CREATE PROC ListaCompaniasActivas
AS BEGIN
	select * from Compania where Estado=1
END
GO 

--LISTAR TODAS LAS COMPANIAS
CREATE PROC ListarCompanias
AS BEGIN
	select * from Compania
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
	--si no existe viaje 
	if not exists(select NViaje from Viaje where NViaje=@NViaje)
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
					--si no existe ningun viaje al mismo destino que parta en menos de 2 horas de diferencia
					if not exists(select * from Viaje where Destino=@Destino and DATEDIFF(HH ,FPartida,@FPartida)between 0 and 2)
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
						commit transaction
						return 1
					end
					
					--si existe un viaje al mismo destino con 2 horas o menos de diferencia de partida devolver -6
					else
					begin
						return -6
					end
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
		commit transaction
		return 1
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
	--si existe viaje 
	if exists(select NViaje from Viaje where NViaje=@NViaje)
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
					--si no existe ningun viaje al mismo destino que parta en menos de 2 horas de diferencia y que no sea el mismo viaje que estamos modificando
					if not exists(select * from Viaje where Destino=@Destino and DATEDIFF(HH ,FPartida,@FPartida)between 0 and 2 and NViaje!=@NViaje)
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
	
						commit transaction	
						return 1
					end
					--si existe un viaje al mismo destino con 2 horas o menos de diferencia de partida devolver -7
					else
					begin
						return -7
					end
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
--BUSCAR UN VIAJE INTERNACIONAL
CREATE PROC BuscarViajeInternacional
@NViaje int
AS BEGIN
	select Viaje.*,ViajeInternacional.ServicioABordo,ViajeInternacional.Documentacion from ViajeInternacional join Viaje on ViajeInternacional.NViaje=Viaje.NViaje where ViajeInternacional.NViaje=@NViaje and Viaje.FPartida>CURRENT_TIMESTAMP
END
GO

CREATE PROC ListarViajesInternacionales
AS BEGIN
	select viaje.*,ViajeInternacional.ServicioABordo,ViajeInternacional.Documentacion from Viaje join ViajeInternacional on ViajeInternacional.NViaje=Viaje.NViaje where Viaje.FPartida>CURRENT_TIMESTAMP ;
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
	--si no existe viaje 
	if not exists(select NViaje from Viaje where NViaje=@NViaje)
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
					--si no existe ningun viaje al mismo destino que parta en menos de 2 horas de diferencia
					if not exists(select * from Viaje where Destino=@Destino and DATEDIFF(HH ,FPartida,@FPartida)between 0 and 2)
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
					commit transaction
					return 1
					end
					
					--si existe un viaje al mismo destino que parta con menos de 2 horas de diferencia devolver -7
					else
					begin
						return -7
					end
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
			
		commit transaction
		return 1
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
	--si existe viaje 
	if exists(select NViaje from Viaje where NViaje=@NViaje)
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
					--si no existe ningun viaje al mismo destino que parta en menos de 2 horas de diferencia y que no sea el mismo viaje que estamos modificando
					if not exists(select * from Viaje where Destino=@Destino and DATEDIFF(HH ,FPartida,@FPartida)between 0 and 2 and NViaje!=@NViaje)
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
							
						commit transaction
						return 1
					end
					
					--si ya hay un viaje que no sea el que estoy modificando con el mismo destino con menos de 2 horas de diferencia de partida devolver -8
					else
					begin
						return -8
					end
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
--BUSCAR UN VIAJE NACIONAL
CREATE PROC BuscarViajeNacional
@NViaje int
AS BEGIN
	select Viaje.*,ViajeNacional.CantParadas from ViajeNacional join Viaje on ViajeNacional.NViaje=Viaje.NViaje where ViajeNacional.NViaje=@NViaje and Viaje.FPartida>CURRENT_TIMESTAMP
END
GO

--LISTAR TODOS LOS VIAJES NACIONALES
CREATE PROC ListarViajesNacionales
AS BEGIN
    select Viaje.*,ViajeNacional.CantParadas from Viaje join ViajeNacional on ViajeNacional.NViaje=Viaje.NViaje where Viaje.FPartida>CURRENT_TIMESTAMP ;
END
GO

-----------------------------------------------------INSERTS------------------------------------------------------------------------------------
-----------------------------------------------------INSERTS EMPLEADO------------------------------------------------------------------------------------
exec AltaEmpleado 49066859,'passni','Nicolas';
GO
exec AltaEmpleado 49069999,'passan','Andres';
GO
-----------------------------------------------------INTERTS TERMINALES------------------------------------------------------------------------------------
exec AltaTerminal 'AAA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAB','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAC','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAD','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAE','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAF','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAG','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAH','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAI','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAJ','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAK','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAL','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAM','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAN','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAO','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAP','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAQ','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAR','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAS','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAT','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAU','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAV','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAW','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAX','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAY','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AAZ','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'ABA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'ACA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'ADA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AEA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AFA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AGA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AHA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AIA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AJA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AKA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'ALA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AMA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'ANA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AOA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'APA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AQA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'ARA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'ASA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'ATA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AUA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AVA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AWA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AXA','MONTEVIDEO','URUGUAY';
GO
exec AltaTerminal 'AYA','MONTEVIDEO','URUGUAY';
GO

-----------------------------------------------------INTERTS FACILIDADES------------------------------------------------------------------------------------



exec AltaFacilidad 'AAA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAB','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAC','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAD','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAE','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAF','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAG','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAH','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAI','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAJ','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAK','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAL','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAM','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAN','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAO','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAP','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAQ','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAR','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAS','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAT','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAU','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAV','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAW','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAX','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAY','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAZ','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'ABA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'ACA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'ADA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AEA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AFA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AGA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AHA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AIA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AJA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AKA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'ALA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AMA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'ANA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AOA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'APA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AQA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'ARA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'ASA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'ATA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AUA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AVA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AWA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AXA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AYA','CAJ-AUTOMATICO';
GO
exec AltaFacilidad 'AAA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAB','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAC','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAD','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAE','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAF','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAG','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAH','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAI','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAJ','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAK','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAL','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAM','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAN','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAO','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAP','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAQ','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAR','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAS','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAT','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAU','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAV','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAW','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAX','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAY','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAZ','PLAZA-COMIDA';
GO
exec AltaFacilidad 'ABA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'ACA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'ADA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AEA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AFA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AGA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AHA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AIA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AJA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AKA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'ALA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AMA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'ANA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AOA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'APA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AQA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'ARA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'ASA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'ATA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AUA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AVA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AWA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AXA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AYA','PLAZA-COMIDA';
GO
exec AltaFacilidad 'AAA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAB','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAC','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAD','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAE','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAF','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAG','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAH','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAI','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAJ','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAK','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAL','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAM','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAN','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAO','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAP','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAQ','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAR','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAS','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAT','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAU','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAV','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAW','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAX','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAY','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AAZ','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'ABA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'ACA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'ADA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AEA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AFA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AGA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AHA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AIA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AJA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AKA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'ALA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AMA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'ANA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AOA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'APA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AQA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'ARA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'ASA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'ATA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AUA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AVA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AWA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AXA','CAMBIO-MONEDA';
GO
exec AltaFacilidad 'AYA','CAMBIO-MONEDA';
GO

-----------------------------------------------------INTERTS COMPANIA------------------------------------------------------------------------------------
exec AltaCompania 'COETC','PT/SARANDI - ZABALA',26826495
GO
exec AltaCompania 'CUTCSA','25MAYO - ZABALA',26963107
GO
exec AltaCompania 'RAINCOP','R.I.P',26825647
GO
-----------------------------------------------------INTERTS VIAJES INTERNACIONALES------------------------------------------------------------------------------------
--VIAJES INTER DE COETC
exec AltaViajeInternacional 0,'COETC','AAA',49066859,'20180815 10:30:00 AM','20180815 15:00:00 PM',21,1,'DOCUMENTACION-VIAJE-0-COETC';
GO
exec AltaViajeInternacional 1,'COETC','AAA',49066859,'20180815 13:30:00 PM','20180815 18:00:00 PM',21,1,'DOCUMENTACION-VIAJE-1-COETC';
GO
exec AltaViajeInternacional 2,'COETC','AAB',49066859,'20180815 10:30:00 AM','20180815 15:00:00 PM',21,1,'DOCUMENTACION-VIAJE-2-COETC';
GO
exec AltaViajeInternacional 3,'COETC','AAB',49066859,'20180815 13:30:00 PM','20180815 18:00:00 PM',21,1,'DOCUMENTACION-VIAJE-3-COETC';
GO
exec AltaViajeInternacional 4,'COETC','AAC',49066859,'20180815 09:30:00 AM','20180815 14:00:00 PM',21,1,'DOCUMENTACION-VIAJE-4-COETC';
GO
--VIAJES NACIONALES DE COETC
exec AltaViajeNacional 5,'COETC','AAC',49066859,'20180816 05:00:00 AM','20180817 12:00:00 PM',21,3;
GO
exec AltaViajeNacional 6,'COETC','AAD',49066859,'20180815 08:00:00 AM','20180816 13:00:00 PM',21,4;
GO
exec AltaViajeNacional 7,'COETC','AAD',49066859,'20180815 011:00:00 AM','20180816 12:00:00 PM',21,2;
GO
exec AltaViajeNacional 8,'COETC','AAE',49066859,'20180815 09:00:00 AM','20180816 12:00:00 PM',21,3;
GO
exec AltaViajeNacional 9,'COETC','AAE',49066859,'20180815 13:00:00 PM','20180816 15:00:00 PM',21,4;
GO
--VIAJES INTER DE CUTCSA
exec AltaViajeInternacional 10,'CUTCSA','AAA',49066859,'20180816 05:30:00 AM','20180816 09:00:00 AM',21,1,'DOCUMENTACION-VIAJE-10-CUTCSA';
GO
exec AltaViajeInternacional 11,'CUTCSA','AAA',49066859,'20180815 16:30:00 PM','20180815 18:00:00 PM',21,1,'DOCUMENTACION-VIAJE-11-CUTCSA';
GO
exec AltaViajeInternacional 12,'CUTCSA','AAB',49066859,'20180816 10:30:00 AM','20180816 15:00:00 PM',21,1,'DOCUMENTACION-VIAJE-12-CUTCSA';
GO
exec AltaViajeInternacional 13,'CUTCSA','AAB',49066859,'20180816 13:30:00 PM','20180816 18:00:00 PM',21,1,'DOCUMENTACION-VIAJE-13-CUTCSA';
GO
exec AltaViajeInternacional 14,'CUTCSA','AAC',49066859,'20180817 09:30:00 AM','20180817 14:00:00 PM',21,1,'DOCUMENTACION-VIAJE-14-CUTCSA';
GO
--VIAJES NACIONALES DE CUTCSA
exec AltaViajeNacional 15,'CUTCSA','AAC',49066859,'20180818 05:00:00 AM','20180818 12:00:00 PM',21,3;
GO
exec AltaViajeNacional 16,'CUTCSA','AAD',49066859,'20180818 08:00:00 AM','20180818 13:00:00 PM',21,4;
GO
exec AltaViajeNacional 17,'CUTCSA','AAD',49066859,'20180818 011:00:00 AM','20180818 12:00:00 PM',21,2;
GO
exec AltaViajeNacional 18,'CUTCSA','AAE',49066859,'20180818 09:00:00 AM','20180818 12:00:00 PM',21,3;
GO
exec AltaViajeNacional 19,'CUTCSA','AAE',49066859,'20180818 13:00:00 PM','20180818 15:00:00 PM',21,4;
GO
--VIAJES INTER DE RAINCOP
exec AltaViajeInternacional 20,'RAINCOP','AAA',49066859,'20180820 05:30:00 AM','20180820 09:00:00 AM',21,1,'DOCUMENTACION-VIAJE-20-RAINCOP';
GO
exec AltaViajeInternacional 21,'RAINCOP','AAA',49066859,'20180820 16:30:00 PM','20180820 18:00:00 PM',21,1,'DOCUMENTACION-VIAJE-21-RAINCOP';
GO
exec AltaViajeInternacional 22,'RAINCOP','AAB',49066859,'20180820 10:30:00 AM','20180820 15:00:00 PM',21,1,'DOCUMENTACION-VIAJE-22-RAINCOP';
GO
exec AltaViajeInternacional 23,'RAINCOP','AAB',49066859,'20180820 13:30:00 PM','20180820 18:00:00 PM',21,1,'DOCUMENTACION-VIAJE-23-RAINCOP';
GO
exec AltaViajeInternacional 24,'RAINCOP','AAC',49066859,'20180820 09:30:00 AM','20180820 14:00:00 PM',21,1,'DOCUMENTACION-VIAJE-24-RAINCOP';
GO
--VIAJES NACIONALES DE RAINCOP
exec AltaViajeNacional 25,'RAINCOP','AAC',49066859,'20180821 05:00:00 AM','20180821 12:00:00 PM',21,3;
GO
exec AltaViajeNacional 26,'RAINCOP','AAD',49066859,'20180821 08:00:00 AM','20180821 13:00:00 PM',21,4;
GO
exec AltaViajeNacional 27,'RAINCOP','AAD',49066859,'20180821 011:00:00 AM','20180821 12:00:00 PM',21,2;
GO
exec AltaViajeNacional 28,'RAINCOP','AAE',49066859,'20180821 09:00:00 AM','20180821 12:00:00 PM',21,3;
GO
exec AltaViajeNacional 29,'RAINCOP','AAE',49066859,'20180821 13:00:00 PM','20180821 15:00:00 PM',21,4;