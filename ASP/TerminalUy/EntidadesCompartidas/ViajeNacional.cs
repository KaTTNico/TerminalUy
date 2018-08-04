using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EntidadesCompartidas
{
    public class ViajeNacional : Viaje
    {
        //atributos
        
        private int CantParadas;

        //pripiedad

        public int pCantParadas {
            get { return CantParadas; }
            set {
                //verificar que haya al menos una parada
                if (value >= 0)
                {
                    CantParadas = value;
                }
                else { throw new Exception("El numero de paradas debe ser positivo."); }
            
            }
        }

        //constructor

        public ViajeNacional(int numeroViaje, Compania compania, Terminal destino, Empleado empleado, DateTime fPartida, DateTime fDestino, int cantAsientos, int cantParadas)
            : base(numeroViaje, compania, destino, empleado, fPartida, fDestino, cantAsientos) {
                pCantParadas = cantParadas;
        }
    }
}
