using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Persistencia
{
    internal class Conexion
    {
        private static string cnn = "Data Source=.; Initial Catalog = TerminalUy; Integrated Security = true";

        //propiedad
        public static string Cnn
        {
            get { return cnn; }
        }

    }
}
