using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Logica
{
    public interface iLogicaViaje
    {
        //operaciones

        //ALTA VIAJES
        void AltaViaje(Viaje viaje);

        //MDOIFICAR VIAJES
        void ModificarViaje(Viaje viaje);

        //BAJA VIAJE
        void BajaViaje(Viaje viaje);

        //LISTAR  VIAJES
        List<Viaje> ListarViajes();
    }
}
