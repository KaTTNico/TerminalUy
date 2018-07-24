using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace EntidadesCompartidas
{
    public class Terminal
    {
        //atributos

        private string Codigo;
        private string Ciudad;
        private string Pais;
        private List<Facilidades> facilidades;

        //propiedades

        public string pCodigo {
            get { return Codigo; }
            set {
                //verificar que el codigo este bien escrito
                if ((Regex.Match(value.ToUpper(), @"^([A-Z]){3}$")).Success)
                {
                    Codigo = value.ToUpper();
                }
                else { throw new Exception("El codigo debe estar formado por 3 letras."); }
            }
        }

        public string pCiudad {
            get { return Ciudad; }
            set
            {
                //verificar que no se pase de la tabla
                if ((Regex.Match(value,@"^(\w){4,30}$")).Success)
                {
                    Ciudad = value.ToUpper();
                }
                else { throw new Exception("La ciudad debe ser desde 4 hasta 30 caracteres."); }
            }
        }

        public string pPais {
            get { return Pais; }
            set {
                //verificar paises del mercosur
                if ((Regex.Match(value.ToUpper(), @"^(ARGENTINA)$|^(BRAZIL)$|^(URUGUAY)$|^(PARAGUAY)$")).Success)
                {
                    Pais = value.ToUpper();
                }
                else { throw new Exception("Solo se admiten paises del mercosur."); }
            }
        }

        public List<Facilidades> pFacilidades {
            get { return facilidades; }
            set
            {
                //verificar que tenga al menos una facilidad
                if (value.Count() != null)
                {
                    facilidades = value;
                }
                else { throw new Exception("Error inesperado facilidad."); }
            }
        }

        //constructor

        public Terminal(string codigo, string ciudad, string pais, List<Facilidades> aFacilidades) {
            pCodigo = codigo;
            pCiudad = ciudad;
            pPais = pais;
            pFacilidades = aFacilidades;
        }
    }
}
