using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace EntidadesCompartidas
{
    public class Facilidades
    {
        //atributo

        private string Facilidad;

        //propiedad

        public string pFacilidad {
            get { return Facilidad; }
            set { 
                //verificar que no se pase de la tabla.
                if ((Regex.Match(value,@"^([a-zA-Z]){5,20}$")).Success)
                {
                    Facilidad = value;
                }
                else { throw new Exception("La facilidad debe tener al menos 5 y hasta 20 caracteres."); }
            }
        }

        //constructor

        public Facilidades(string facilidad) {
            pFacilidad = facilidad;
        }
    }
}
