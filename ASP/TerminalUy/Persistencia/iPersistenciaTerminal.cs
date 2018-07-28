using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Persistencia
{
    public interface iPersistenciaTerminal
    {
        //operaciones

        //ALTA TERMINAL 
        void AltaTerminal(Terminal terminal);

        //BAJA TERMINAL
        void BajaTerminal(Terminal terminal);

        //MODIFICAR TERMINAL
        void ModificarTerminal(Terminal terminal);
    }
}
