using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Logica
{
    public interface iLogicaViajeNacional
    {
        //operaciones
        //ALTA VIAJE NACIONAL
        void AltaViajeNacional(ViajeNacional viajeNaiconal);

        //BAJA VIAJE NACIONAL
        void BajaViajeNacional(ViajeNacional viajeNacional);

        //MODIFICAR VIAJE NACIONAL
        void ModificarViajeNacional(ViajeNacional viajeNacional);

    }
}
