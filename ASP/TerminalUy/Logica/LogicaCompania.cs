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
        public static LogicaCompania getInstance() {return (instancia == null) ? instancia = new LogicaCompania() : instancia;}

        //constructor por defecto 
        private LogicaCompania() { }

        //operaciones

        //alta compania
        public void AltaCompania(Compania compania) {
            iPersistenciaCompania fPersistencia = FabricaPersistencia.getPersistenciaCompania();
        }
        
        //baja compania
        public void BajaCompania(Compania compania)
        {
            iPersistenciaCompania fPersistencia = FabricaPersistencia.getPersistenciaCompania();
        }
        
        //modificacion compania
        public void ModificarCompania(Compania compania)
        {
            iPersistenciaCompania fPersistencia = FabricaPersistencia.getPersistenciaCompania();
        }
    }
}
