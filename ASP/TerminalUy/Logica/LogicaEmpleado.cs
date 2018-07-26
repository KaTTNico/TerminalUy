using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using Persistencia;

namespace Logica
{
    internal class LogicaEmpleado : iLogicaEmpleado
    {
        //singleton
        private static LogicaEmpleado instancia = null;

        //get instancia 
        public static LogicaEmpleado getInstance() {return (instancia == null) ? instancia = new LogicaEmpleado() : instancia;}

        //constructor por defecto 
        private LogicaEmpleado() { }

        //operaciones

        //alta compania
        public void AltaEmpleado(Empleado empleado)
        {
            iPersistenciaEmpleado fPersistencia = FabricaPersistencia.getPersistenciaEmpleado();
        }

        //baja compania
        public void BajaEmpleado(Empleado empleado)
        {
            iPersistenciaEmpleado fPersistencia = FabricaPersistencia.getPersistenciaEmpleado();
        }

        //modificar compania
        public void ModificarEmpleado(Empleado empleado)
        {
            iPersistenciaEmpleado fPersistencia = FabricaPersistencia.getPersistenciaEmpleado();
        }

    }
}
