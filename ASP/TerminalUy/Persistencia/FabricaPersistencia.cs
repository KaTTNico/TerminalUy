using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Persistencia
{
    public class FabricaPersistencia
    {
        //fabrica persistencias

        //persistencia compania
        public static iPersistenciaCompania getPersistenciaCompania() { 
            return (PersistenciaCompania.getInstance());
        }

        //persistencia empleado
        public static iPersistenciaEmpleado getPersistenciaEmpleado() {
            return (PersistenciaEmpleado.getInstance());
        }

        //persistencia terminal
        public static iPersistenciaTerminal getPersistenciaTerminal() {
            return (PersistenciaTerminal.getInstance());
        }

        //persistencia viajes internacionales 
        public static iPersistenciaViajeInternacional getPersistenciaViajeInternacional() {
            return (PersistenciaViajeInternacional.getInstance());
        }

        //persistencia viaje 
        public static iPersistenciaViajeNacional getPersistenciaViajeNacional() {
            return (PersistenciaViajeNacional.getInstance());
        }
    }
}
