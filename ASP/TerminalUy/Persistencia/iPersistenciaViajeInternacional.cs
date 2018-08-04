using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Persistencia
{
    public interface iPersistenciaViajeInternacional
    {
        //operaciones

        //ALTA VIAJE INTERNACIONAL 
        void AltaViajeInternacional(ViajeInternacional viajeInterNacional);

        //BAJA VIAJE INTERNACIONAL
        void BajaViajeInternacional(ViajeInternacional viajeInterNacional);

        //MODIFICAR VIAJE INTERNACIONAL
        void ModificarViajeInternacional(ViajeInternacional viajeInterNacional);

        //LISTAR VIAJES INTERNACIONALES
        List<Viaje> ListarViajesInternacionales();
    }
}
