using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Persistencia
{
    internal class PersistenciaViajeNacional : iPersistenciaViajeNacional
    {
        //singleton
        private static PersistenciaViajeNacional instancia = null;

        //get instancia 
        public static PersistenciaViajeNacional getInstance() { return (instancia == null) ? instancia = new PersistenciaViajeNacional() : instancia; }

        //constructor por defecto 
        private PersistenciaViajeNacional() { }
    }
}
