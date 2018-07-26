using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using Persistencia;

namespace Logica
{
    internal class LogicaViaje : iLogicaViaje
    {
        //singleton
        private static LogicaViaje instancia = null;

        //get instancia 
        public static LogicaViaje getInstance() { return (instancia == null) ? instancia = new LogicaViaje() : instancia; }

        //constructor por defecto 
        private LogicaViaje() { }

        //operaciones

        //ALTA VIAJE
        public void AltaViaje(Viaje viaje){
            //verificar tipo de viaje
            if (viaje is ViajeInternacional)
            {
                //llamar persistencia viaje internacional
                iPersistenciaViajeInternacional fPersistencia = FabricaPersistencia.getPersistenciaViajeInternacional();
            }
            else {
                //llamar persistencia viaje nacional
                iPersistenciaViajeNacional fPersistencia = FabricaPersistencia.getPersistenciaViajeNacional();
            }
        }

        //MODIFICAR VIAJE
        public void ModificarViaje(Viaje viaje) {
            //verificar tipo de viaje
            if (viaje is ViajeInternacional)
            {
                //llamar persistencia viaje internacional
                iPersistenciaViajeInternacional fPersistencia = FabricaPersistencia.getPersistenciaViajeInternacional();
            }
            else
            {
                //llamar persistencia viaje nacional
                iPersistenciaViajeNacional fPersistencia = FabricaPersistencia.getPersistenciaViajeNacional();
            }
        }

        //BAJA VIAJE
        public void BajaViaje(Viaje viaje) {
            //verificar tipo de viaje
            if (viaje is ViajeInternacional)
            {
                //llamar persistencia viaje internacional
                iPersistenciaViajeInternacional fPersistencia = FabricaPersistencia.getPersistenciaViajeInternacional();
            }
            else
            {
                //llamar persistencia viaje nacional
                iPersistenciaViajeNacional fPersistencia = FabricaPersistencia.getPersistenciaViajeNacional();
            }
        }

    }
}
