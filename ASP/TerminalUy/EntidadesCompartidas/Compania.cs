using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace EntidadesCompartidas
{
    public class Compania
    {
        //atributos

        private string Nombre;
        private string Direccion;
        private int Telefono;

        //propiedades

        public string pNombre{
            get { return Nombre; }
            set { 
                //verificar que no se pase de la tabla y que tenga al menos 2 caracteres
                if ((Regex.Match(value.ToUpper(), @"^(\w){2,20}$")).Success)
                {
                    Nombre = value;
                }
                else { throw new Exception("Debe ingresar un nombre de al menos 2 caracteres hasta 20."); }
            }
        }

        public string pDireccion {
            get { return Direccion; }
            set { 
                //verificar que no se pase de la tabla
                if (value.Length <= 30)
                {
                    Direccion = value;
                }
                else { throw new Exception("La direccion debe ser de hasta 30 caracteres."); }
            }
        }

        public int pTelefono {
            get { return Telefono; }
            set { 
                //si el largo del telefono es un celular o un telefono fijo
                if ((Regex.Match(value.ToString(), @"^(09)([0-9]){7}$|^(2)([0-9]){7}$")).Success)
                {
                    Telefono = value;
                }
                else { throw new Exception("Debe ingresar un numero de telefono correcto."); }
            }
        }

        //constructor 

        public Compania(string nombre, string direccion, int telefono) {
            pNombre = nombre;
            pDireccion = direccion;
            pTelefono = telefono;
        }
    }
}
