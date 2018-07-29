using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using System.Data;
using System.Data.SqlClient;

namespace Persistencia
{
    internal class PersistenciaViajeNacional : iPersistenciaViajeNacional
    {
        //singleton
        private static PersistenciaViajeNacional instancia = null;

        //get instancia 
        public static PersistenciaViajeNacional getInstance() { return (instancia == null) ? instancia = new PersistenciaViajeNacional() : instancia; }

        //constructor por defecto 
        private PersistenciaViajeNacional() { }

        //----------------------------------------------------------------------ABM------------------------------------------------------------------------------------

        //ALTA VIAJE NACIONAL
        public void AltaViajeNacional(ViajeNacional viajeNacional)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("AltaViajeNacional", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@NViaje", viajeNacional.pNumeroViaje);
            sp.Parameters.Add("@NCompania", viajeNacional.pCompania.pNombre);
            sp.Parameters.Add("@Destino", viajeNacional.pDestino.pCiudad);
            sp.Parameters.Add("@EmpleadoMOG", viajeNacional.pEmpleado.pCedula);
            sp.Parameters.Add("@FPartida", viajeNacional.pFPartida);
            sp.Parameters.Add("@FDestino", viajeNacional.pFDestino);
            sp.Parameters.Add("@CantAsientos", viajeNacional.pCantAsientos);


            //retorno
            SqlParameter retorno = new SqlParameter("@retorno", SqlDbType.Int);
            retorno.Direction = ParameterDirection.ReturnValue;
            sp.Parameters.Add("@retorno", retorno);


            try
            {
                conect.Open();
                sp.ExecuteNonQuery();

                //retorno
                if ((int)retorno.Value == 1)
                {
                    throw new Exception("viaje nacional dado de alta.");
                }
                else if ((int)retorno.Value == -4) { throw new Exception("El viaje nacional " + viajeNacional.pNumeroViaje + " ya existe."); }
                else if ((int)retorno.Value == -3) { throw new Exception("La compania " + viajeNacional.pCompania.pNombre + " no existe."); }
                else if ((int)retorno.Value == -2) { throw new Exception("La terminal " + viajeNacional.pDestino.pCodigo + " no existe."); }
                else if ((int)retorno.Value == -1) { throw new Exception("El empleado " + viajeNacional.pEmpleado.pCedula + " no existe."); }
                else if ((int)retorno.Value == -7) { throw new Exception("Ya existe un viaje al mismo destino que parte con menos de 2 horas de diferencia."); }
                else if ((int)retorno.Value == -6) { throw new Exception("Error inesperado."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //MODIFICAR VIAJE NACIONAL
        public void ModificarViajeNacional(ViajeNacional viajeNacional)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("ModificarViajeNacional", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@NViaje", viajeNacional.pNumeroViaje);
            sp.Parameters.Add("@NCompania", viajeNacional.pCompania.pNombre);
            sp.Parameters.Add("@Destino", viajeNacional.pDestino.pCiudad);
            sp.Parameters.Add("@EmpleadoMOG", viajeNacional.pEmpleado.pCedula);
            sp.Parameters.Add("@FPartida", viajeNacional.pFPartida);
            sp.Parameters.Add("@FDestino", viajeNacional.pFDestino);
            sp.Parameters.Add("@CantAsientos", viajeNacional.pCantAsientos);

            //retorno
            SqlParameter retorno = new SqlParameter("@retorno", SqlDbType.Int);
            retorno.Direction = ParameterDirection.ReturnValue;
            sp.Parameters.Add("@retorno", retorno);


            try
            {
                conect.Open();
                sp.ExecuteNonQuery();

                //retorno
                if ((int)retorno.Value == 1)
                {
                    throw new Exception("viaje nacional modificado.");
                }
                else if ((int)retorno.Value == -4) { throw new Exception("El viaje nacional " + viajeNacional.pNumeroViaje + " no existe."); }
                else if ((int)retorno.Value == -3) { throw new Exception("La compania " + viajeNacional.pCompania.pNombre + " no existe."); }
                else if ((int)retorno.Value == -2) { throw new Exception("La terminal " + viajeNacional.pDestino.pCodigo + " no existe."); }
                else if ((int)retorno.Value == -1) { throw new Exception("El empleado " + viajeNacional.pEmpleado.pCedula + " no existe."); }
                else if ((int)retorno.Value == -8) { throw new Exception("Ya existe un viaje al mismo destino que parte con menos de 2 horas de diferencia."); }
                else if ((int)retorno.Value == -7) { throw new Exception("Error inesperado."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //BAJA VIAJE NACIONAL
        public void BajaViajeNacional(ViajeNacional viajeNacional)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BajaViajeNacional", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@NViaje", viajeNacional.pNumeroViaje);

            //retorno
            SqlParameter retorno = new SqlParameter("@retorno", SqlDbType.Int);
            retorno.Direction = ParameterDirection.ReturnValue;
            sp.Parameters.Add("@retorno", retorno);


            try
            {
                conect.Open();
                sp.ExecuteNonQuery();

                //retorno
                if ((int)retorno.Value == 1)
                {
                    throw new Exception("viaje nacional eliminado.");
                }
                else if ((int)retorno.Value == -2) { throw new Exception("El viaje nacional " + viajeNacional.pNumeroViaje + " no existe."); }
                else if ((int)retorno.Value == -3) { throw new Exception("Error inesperado."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }
    }
}
