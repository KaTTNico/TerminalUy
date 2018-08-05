using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Logica
{
    public interface iLogicaCompania
    {
        //operaciones
        //ALTA COMPANIA
        void AltaCompania(Compania compania);

        //BAJA COMPANIA
        void BajaCompania(Compania compania);

        //MODIFICAR COMPANIA
        void ModificarCompania(Compania compania);

        //BUSCAR COMPANIA
        Compania BuscarCompania(string Nombre);
    }
}
