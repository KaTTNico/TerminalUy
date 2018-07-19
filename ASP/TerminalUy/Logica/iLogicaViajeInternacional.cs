using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Logica
{
    public interface iLogicaViajeInternacional
    {
        //operaciones
        //ALTA VIAJE INTERNACIONAL
        void AltaViajeInternacional(ViajeInternacional viajeInternacional);

        //BAJA VIAJE INTERNACIONAL
        void BajaViajeInternacional(ViajeInternacional viajeInternacional);

        //MODIFICAR VIAJE INTERNACIONAL
        void ModificarViajeInternacional(ViajeInternacional viajeInternacional);

    }
}
