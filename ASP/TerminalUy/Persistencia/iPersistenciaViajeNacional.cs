using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Persistencia
{
    public interface iPersistenciaViajeNacional
    {
        //operaciones

        //ALTA VIAJE NACIONAL 
        void AltaViajeNacional(ViajeNacional viajeNacional);

        //BAJA VIAJE NACIONAL
        void BajaViajeNacional(ViajeNacional viajeNacional);

        //MODIFICAR VIAJE NACIONAL
        void ModificarViajeNacional(ViajeNacional viajeNacional);

        //LISTAR VIAJES NACIONALES
        List<Viaje> ListarViajesNacionales();

        //BUSCAR VIAJE NACIONAL
        ViajeNacional BuscarViajeNacional(int NViaje);
    }
}
