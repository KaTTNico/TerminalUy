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
Telefono int not null check(len(Telefono)>7),
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
NViaje int foreign key references Viaje (NViaje) not null,
ServicioABordo bit not null default 0,
Documentacion varchar(100)not null
);
go

--VIAJES NACIONALES
CREATE TABLE ViajeNacional(
NViaje int foreign key references Viaje (NViaje) not null,
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
			begin try
				begin transaction
					delete Facilidades where Codigo=@Codigo
					delete Terminal where Codigo=@Codigo
					return 1
				commit transaction
			end try
			
			begin catch
				rollback transaction
				return -1
			end catch
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

-----------------------------------------------------SP FACILIDADES------------------------------------------------------------------------------------
--ALTA
CREATE PROC AltaFacilidad
@Codigo varchar(3),
@Facilidad varchar(20) 
AS BEGIN
	--si existe terminal
	if exists(select Codigo from Terminal where Codigo=@Codigo and Estado=1)
	begin
		insert Facilidades values(@Codigo,@Facilidad)
		return 1
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

-----------------------------------------------------SP VIAJE------------------------------------------------------------------------------------
--Alta
CREATE PROC AltaViaje
@NViaje int,
@NCompania varchar(20),
@Destino varchar(3),
@EmpleadoMOG int,
@FPartida datetime,
@FDestino datetime,
@CantAsientos int
AS BEGIN
	--si no existe viaje
	if  not exists(select NViaje from Viaje where NViaje=@NViaje)
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
					insert into Viaje values(@NViaje,@NCompania,@Destino,@EmpleadoMOG,@FPartida,@FDestino,@CantAsientos)
					return 1
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
	
	--si existe viaje
	else 
	begin
		return -4
	end
END
GO

--BAJA
CREATE PROC BajaViaje
@NViaje int
AS BEGIN
	--si existe viaje
	if exists(select NViaje from Viaje where NViaje=@NViaje)
	begin
		delete Viaje where NViaje=@NViaje
		return 1
	end
	
	--si no existe
	else
	begin
		return -1
	end
END
GO

--MODIFICAR
CREATE PROC ModificarViaje
@NViaje int,
@NCompania varchar(20),
@Destino varchar(3),
@EmpleadoMOG int,
@FPartida datetime,
@FDestino datetime,
@CantAsientos int
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
					update Viaje set NCompania=@NCompania,Destino=@Destino,EmpleadoMOG=@EmpleadoMOG,FPartida=@FPartida,FDestino=@FDestino,CantAsientos=@CantAsientos where NViaje=@NViaje
					return 1
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
	
	--si no existe viaje
	else 
	begin
		return -4
	end
END