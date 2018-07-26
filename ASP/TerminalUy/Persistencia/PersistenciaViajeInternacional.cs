using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Persistencia
{
    internal class PersistenciaViajeInternacional : iPersistenciaViajeInternacional
    {
        //singleton
        private static PersistenciaViajeInternacional instancia = null;

        //get instancia 
        public static PersistenciaViajeInternacional getInstance() { return (instancia == null) ? instancia = new PersistenciaViajeInternacional() : instancia; }

        //constructor por defecto 
        private PersistenciaViajeInternacional() { }
    }
}
