using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace EntidadesCompartidas
{
    public class Empleado
    {
        //atributos

        private int Cedula;
        private string Pass;
        private string Nombre;
        
        //propiedades

        public int pCedula {
            get { return Cedula; }
            set {
                //verificar que no sea muy viejo
                if (value > 999999)
                {
                    Cedula = value;
                }
                else { throw new Exception("Debe introducir una cedula correcta"); }
            }
        }

        public string pPass {
            get { return Pass; }
            set
            {
                //verificar que la pass tenga 6 caracteres
                if (value.Length == 6)
                {
                    Pass = value;
                }
                else { throw new Exception("La password tiene que tener 6 caracteres."); }
            }
        }

        public string pNombre {
            get { return Nombre; }
            set {
                //verificar que no se pase de la tabla
                if ((Regex.Match(value.ToUpper(), @"^([a-zA-Z]){2,25}$")).Success)
                {
                    Nombre = value;
                }
                else { throw new Exception("El nombre debe tener mas de 2 letras y menos de 25"); }
            }
        }

        //constructor
        public Empleado(int cedula, string pass, string nombre) {
            pCedula = cedula;
            pPass = pass;
            pNombre = nombre;
        }
    }
}
