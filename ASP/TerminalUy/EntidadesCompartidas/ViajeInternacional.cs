using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace EntidadesCompartidas
{
    public class ViajeInternacional : Viaje
    {
        //atributos

        private bool ServicioAbordo;
        private string Documentacion;

        //propiedades

        public bool pServicioAbordo {
            get { return ServicioAbordo; }
            set { ServicioAbordo = value; }
        }

        public string pDocumentacion {
            get { return Documentacion; }
            set { 
                //verificar que la documentacion sea de hasta 100 caracteres
                if ((Regex.Match(value, @"^([a-zA-Z-0-9]){2,100}$")).Success)
                {
                    Documentacion = value;
                }
                else { throw new Exception("La documentacion debe tener minimo 2 y maximo 100 caracteres."); }
            }
        }

        //constructor
        public ViajeInternacional(int numeroViaje, Compania compania, Terminal destino, Empleado empleado, DateTime fPartida, DateTime fDestino, int cantAsientos,bool servicioAbordo, string documentacion)
            : base(numeroViaje, compania, destino, empleado, fPartida, fDestino, cantAsientos)
        {
            pServicioAbordo = servicioAbordo;
            pDocumentacion = documentacion;
        }
    }
}
