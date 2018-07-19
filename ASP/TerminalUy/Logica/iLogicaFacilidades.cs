using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Logica
{
    public interface iLogicaFacilidades
    {
        //operaciones
        //ALTA FACILIDAD
        void AltaFacilidad(Facilidades facilidad);

        //BAJA FACILIDAD
        void BajaFacilidad(Facilidades facilidad);

        //MODIFICAR FACILIDAD
        void ModificarFacilidad(Facilidades facilidad);
    }
}
