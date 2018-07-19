using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EntidadesCompartidas
{
    public abstract class Viaje
    {
        //atributos

        private int NumeroViaje;
        private Compania compania;
        private Terminal Destino;
        private Empleado EmpleadoMOG;
        private DateTime FPartida;
        private DateTime FDestino;
        private int CantAsientos;

        //propiedades

        public int pNumeroViaje {
            get { return NumeroViaje; }
            set { NumeroViaje = value; }
        }

        public Compania pCompania {
            get { return compania; }
            set
            {
                //verificar compania
                if (value != null)
                {
                    compania = value;
                }
                else { throw new Exception("Debe ingresar una compania."); }
            }
        }

        public Terminal pDestino {
            get { return Destino; }
            set {
                //verificar terminal
                if (value != null)
                {
                    Destino = value;
                }
                else { throw new Exception("Debe ingresar una terminal de destino."); }
            }
        }

        public Empleado pEmpleado {
            get { return EmpleadoMOG; }
            set {
                //verificar empleado
                if (value != null)
                {
                    EmpleadoMOG = value;
                }
                else { throw new Exception("Debe ingresar un empleado."); }
            }
        }

        public DateTime pFPartida {
            get { return FPartida; }
            set { FPartida = value; }
        }

        public DateTime pFDestino {
            get { return FDestino; }
            set { 
                //verificar que la fecha destino sea mayor a fecha partida
                if (value > FPartida)
                {
                    FDestino = value;
                }
                else { throw new Exception("La fecha y hora de destino debe ser mayor a la de partida."); }
            }
        }

        public int pCantAsientos {
            get { return CantAsientos; }
            set { 
                //verificar que hayan al menos 20 asientos
                if (value > 19)
                {
                    CantAsientos = value;
                }
                else { throw new Exception("Deben haber al menos 20 asientos."); }
            }
        }

        public Viaje(int numeroViaje, Compania compania, Terminal destino, Empleado empleado, DateTime fPartida, DateTime fDestino, int cantAsientos) {
            pNumeroViaje = numeroViaje;
            pCompania = compania;
            pDestino = destino;
            pEmpleado = empleado;
            pFPartida = fPartida;
            pFDestino = fDestino;
            pCantAsientos = cantAsientos;

        }
    }
}
