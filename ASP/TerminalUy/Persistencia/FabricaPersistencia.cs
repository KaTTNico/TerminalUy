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
            return (new PersistenciaCompania());
        }

        //persistencia empleado
        public static iPersistenciaEmpleado getPersistenciaEmpleado() { 
            return (new PersistenciaEmpleado());
        }

        //persistencia facilidades
        public static iPersistenciaFacilidades getPersistenciaFacilidades() { 
            return(new PersistenciaFacilidades());
        }

        //persistencia terminal
        public static iPersistenciaTerminal getPersistenciaTerminal() { 
            return(new PersistenciaTerminal());
        }

        //persistencia viajes internacionales 
        public static iPersistenciaViajeInternacional getPersistenciaViajeInternacionale() { 
            return(new PersistenciaViajeInternacional());
        }

        //persistencia viaje 
        public static iPersistenciaViajeNacional getPersistenciaViajeNacional() { 
            return (new PersistenciaViajeNacional());
        }
    }
}
