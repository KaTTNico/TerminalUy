using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Logica
{
    public class FabricaLogica
    {
        //fabrica logicas

        //logica compania
        public static iLogicaCompania getLogicaCompania() { 
            return (LogicaCompania.getInstance());
        }

        //logica empleado
        public static iLogicaEmpleado getLogiaEmpleado() {
            return (LogicaEmpleado.getInstance());
        }

        //logica terminal
        public static iLogicaTerminal getLogicaTerminal() { 
            return (LogicaTerminal.getInstance());
        }

        //logica viaje
        public static iLogicaViaje getLogicaViaje() { 
            return (new LogicaViaje());
        }
    }
}
