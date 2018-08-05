using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using Persistencia;

namespace Logica
{
    internal class LogicaCompania : iLogicaCompania
    {
        //singleton
        private static LogicaCompania instancia = null;

        //get instancia 
        public static LogicaCompania getInstance() {return ( (instancia)?? (instancia = new LogicaCompania()) );}

        //constructor por defecto 
        private LogicaCompania() { }

        //operaciones

        //alta compania
        public void AltaCompania(Compania compania) {
            iPersistenciaCompania fPersistencia = FabricaPersistencia.getPersistenciaCompania();
            try{fPersistencia.AltaCompania(compania);}
            catch { throw; }
        }
        
        //baja compania
        public void BajaCompania(Compania compania)
        {
            iPersistenciaCompania fPersistencia = FabricaPersistencia.getPersistenciaCompania();
            try{fPersistencia.BajaCompania(compania);}
            catch { throw; }
        }
        
        //modificacion compania
        public void ModificarCompania(Compania compania)
        {
            iPersistenciaCompania fPersistencia = FabricaPersistencia.getPersistenciaCompania();
            try{fPersistencia.ModificarCompania(compania);}
            catch { throw; }
        }

        //buscar compania
        public Compania BuscarCompania(string nombre)
        {
            iPersistenciaCompania fPersistencia = FabricaPersistencia.getPersistenciaCompania();
            try { return fPersistencia.BuscarCompania(nombre); }
            catch { throw; }
        }
    }
}
