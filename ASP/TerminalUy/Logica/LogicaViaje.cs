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
        public static LogicaViaje getInstance() {return ( (instancia)?? (instancia = new LogicaViaje()) );}

        //constructor por defecto 
        private LogicaViaje() { }

        //operaciones

        //ALTA VIAJE
        public void AltaViaje(Viaje viaje){
            try
            {
                //verificar tipo de viaje
                if (viaje is ViajeInternacional)
                {
                    //llamar persistencia viaje internacional
                    iPersistenciaViajeInternacional fPersistencia = FabricaPersistencia.getPersistenciaViajeInternacional();
                    fPersistencia.AltaViajeInternacional((ViajeInternacional)viaje);
                }
                else
                {
                    //llamar persistencia viaje nacional
                    iPersistenciaViajeNacional fPersistencia = FabricaPersistencia.getPersistenciaViajeNacional();
                    fPersistencia.AltaViajeNacional((ViajeNacional)viaje);
                }
            }
            catch { throw; }
        }

        //MODIFICAR VIAJE
        public void ModificarViaje(Viaje viaje) {
            try
            {
                //verificar tipo de viaje
                if (viaje is ViajeInternacional)
                {
                    //llamar persistencia viaje internacional
                    iPersistenciaViajeInternacional fPersistencia = FabricaPersistencia.getPersistenciaViajeInternacional();
                    fPersistencia.ModificarViajeInternacional((ViajeInternacional)viaje);
                }
                else
                {
                    //llamar persistencia viaje nacional
                    iPersistenciaViajeNacional fPersistencia = FabricaPersistencia.getPersistenciaViajeNacional();
                    fPersistencia.ModificarViajeNacional((ViajeNacional)viaje);
                }
            }
            catch {throw; }
        }

        //BAJA VIAJE
        public void BajaViaje(Viaje viaje) {
            try
            {
                //verificar tipo de viaje
                if (viaje is ViajeInternacional)
                {
                    //llamar persistencia viaje internacional
                    iPersistenciaViajeInternacional fPersistencia = FabricaPersistencia.getPersistenciaViajeInternacional();
                    fPersistencia.BajaViajeInternacional((ViajeInternacional)viaje);
                }
                else
                {
                    //llamar persistencia viaje nacional
                    iPersistenciaViajeNacional fPersistencia = FabricaPersistencia.getPersistenciaViajeNacional();
                    fPersistencia.BajaViajeNacional((ViajeNacional)viaje);
                }
            }
            catch { throw; }
        }

        //LISTAR VIAJES
        public List<Viaje> ListarViajes()
        { 
            //llamar persistencia 
            List<Viaje> lista = FabricaPersistencia.getPersistenciaViajeInternacional().ListarViajesInternacionales();
            lista.AddRange(FabricaPersistencia.getPersistenciaViajeNacional().ListarViajesNacionales());
            return lista;
        }

        //BUSCAR VIAJE
       // public ViajeInternacional BuscarViaje(int NViaje) {
           // try
            //{
             //   return FabricaPersistencia.getPersistenciaViajeInternacional().BuscarViajeInternacional(NViaje);
           // }
          //  catch { throw; }
        //}

    }
}
