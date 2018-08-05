using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using Persistencia;

namespace Logica
{
    internal class LogicaTerminal : iLogicaTerminal
    {
        //singleton
        private static LogicaTerminal instancia = null;

        //get instancia 
        public static LogicaTerminal getInstance() {return ( (instancia)?? (instancia = new LogicaTerminal()) );}

        //constructor por defecto 
        private LogicaTerminal() { }

        //operaciones

        //alta compania
        public void AltaTerminal(Terminal terminal)
        {
            iPersistenciaTerminal fPersistencia = FabricaPersistencia.getPersistenciaTerminal();

            try { //fPersistencia.AltaTerminal(terminal); 
            }
            catch { throw; }
        }

        //baja compania
        public void BajaTerminal(Terminal terminal)
        {
            iPersistenciaTerminal fPersistencia = FabricaPersistencia.getPersistenciaTerminal();

            try { fPersistencia.BajaTerminal(terminal); }
            catch { throw; }
        }

        //modificar compania
        public void ModificarTerminal(Terminal terminal)
        {
            iPersistenciaTerminal fPersistencia = FabricaPersistencia.getPersistenciaTerminal();

            try { fPersistencia.ModificarTerminal(terminal); }
            catch { throw; }
        }

        //buscar terminal
    }
}
