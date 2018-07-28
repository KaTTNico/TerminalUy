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
        public static LogicaEmpleado getInstance() {return ( (instancia)?? (instancia = new LogicaEmpleado()) );}

        //constructor por defecto 
        private LogicaEmpleado() { }

        //operaciones

        //alta compania
        public void AltaEmpleado(Empleado empleado)
        {
            iPersistenciaEmpleado fPersistencia = FabricaPersistencia.getPersistenciaEmpleado();

            try { fPersistencia.AltaEmpleado(empleado);}
            catch { throw; }
        }

        //baja compania
        public void BajaEmpleado(Empleado empleado)
        {
            iPersistenciaEmpleado fPersistencia = FabricaPersistencia.getPersistenciaEmpleado();

            try { fPersistencia.BajaEmpleado(empleado); }
            catch { throw; }
        }

        //modificar compania
        public void ModificarEmpleado(Empleado empleado)
        {
            iPersistenciaEmpleado fPersistencia = FabricaPersistencia.getPersistenciaEmpleado();

            try { fPersistencia.ModificarEmpleado(empleado); }
            catch { throw; }
        }

    }
}
