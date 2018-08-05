using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using EntidadesCompartidas;

namespace Persistencia
{
    internal class PersistenciaViajeInternacional : iPersistenciaViajeInternacional
    {
        //singleton
        private static PersistenciaViajeInternacional instancia = null;

        //get instancia 
        public static PersistenciaViajeInternacional getInstance() { return (instancia == null) ? instancia = new PersistenciaViajeInternacional() : instancia; }

        //constructor por defecto 
        private PersistenciaViajeInternacional() { }

        //----------------------------------------------------------------------ABM------------------------------------------------------------------------------------

        //ALTA VIAJE INTERNACIONAL
        public void AltaViajeInternacional(ViajeInternacional viajeInternacional)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("AltaViajeInternacional", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@NViaje", viajeInternacional.pNumeroViaje);
            sp.Parameters.Add("@NCompania", viajeInternacional.pCompania.pNombre);
            sp.Parameters.Add("@Destino", viajeInternacional.pDestino.pCiudad);
            sp.Parameters.Add("@EmpleadoMOG", viajeInternacional.pEmpleado.pCedula);
            sp.Parameters.Add("@FPartida", viajeInternacional.pFPartida);
            sp.Parameters.Add("@FDestino", viajeInternacional.pFDestino);
            sp.Parameters.Add("@CantAsientos", viajeInternacional.pCantAsientos);
            sp.Parameters.Add("@ServicioABordo", viajeInternacional.pServicioAbordo);
            sp.Parameters.Add("@Documentacion", viajeInternacional.pDocumentacion);

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
                    throw new Exception("viaje internacional dado de alta.");
                }
                else if ((int)retorno.Value == -4) { throw new Exception("El viaje internacional " + viajeInternacional.pNumeroViaje + " ya existe."); }
                else if ((int)retorno.Value == -3) { throw new Exception("La compania " + viajeInternacional.pCompania.pNombre + " no existe."); }
                else if ((int)retorno.Value == -2) { throw new Exception("La terminal " + viajeInternacional.pDestino.pCodigo + " no existe."); }
                else if ((int)retorno.Value == -1) { throw new Exception("El empleado " + viajeInternacional.pEmpleado.pCedula + " no existe."); }
                else if ((int)retorno.Value == -6) { throw new Exception("Ya existe un viaje al mismo destino que parte con menos de 2 horas de diferencia."); }
                else if ((int)retorno.Value == -5) { throw new Exception("Error inesperado."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //MODIFICAR VIAJE INTERNACIONAL
        public void ModificarViajeInternacional(ViajeInternacional viajeInternacional)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("ModificarViajeInternacional", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@NViaje", viajeInternacional.pNumeroViaje);
            sp.Parameters.Add("@NCompania", viajeInternacional.pCompania.pNombre);
            sp.Parameters.Add("@Destino", viajeInternacional.pDestino.pCiudad);
            sp.Parameters.Add("@EmpleadoMOG", viajeInternacional.pEmpleado.pCedula);
            sp.Parameters.Add("@FPartida", viajeInternacional.pFPartida);
            sp.Parameters.Add("@FDestino", viajeInternacional.pFDestino);
            sp.Parameters.Add("@CantAsientos", viajeInternacional.pCantAsientos);
            sp.Parameters.Add("@ServicioABordo", viajeInternacional.pServicioAbordo);
            sp.Parameters.Add("@Documentacion", viajeInternacional.pDocumentacion);

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
                    throw new Exception("viaje internacional modificado.");
                }
                else if ((int)retorno.Value == -4) { throw new Exception("El viaje internacional " + viajeInternacional.pNumeroViaje + " no existe."); }
                else if ((int)retorno.Value == -3) { throw new Exception("La compania " + viajeInternacional.pCompania.pNombre + " no existe."); }
                else if ((int)retorno.Value == -2) { throw new Exception("La terminal " + viajeInternacional.pDestino.pCodigo + " no existe."); }
                else if ((int)retorno.Value == -1) { throw new Exception("El empleado " + viajeInternacional.pEmpleado.pCedula + " no existe."); }
                else if ((int)retorno.Value == -7) { throw new Exception("Ya existe un viaje al mismo destino que parte con menos de 2 horas de diferencia."); }
                else if ((int)retorno.Value == -6) { throw new Exception("Error inesperado."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //BAJA VIAJE INTERNACIONAL
        public void BajaViajeInternacional(ViajeInternacional viajeInternacional)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BajaViajeInternacional", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@NViaje", viajeInternacional.pNumeroViaje);

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
                    throw new Exception("viaje internacional eliminado.");
                }
                else if ((int)retorno.Value == -2) { throw new Exception("El viaje internacional " + viajeInternacional.pNumeroViaje + " no existe."); }
                else if ((int)retorno.Value == -3) { throw new Exception("Error inesperado."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //----------------------------------------------------------------------BUSQUEDAS------------------------------------------------------------------------------------


        //LISTAR VIAJES INTERNACICONALES
        public List<Viaje> ListarViajesInternacionales() {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("ListarViajesInternacionales", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //reader
            SqlDataReader reader;
            //Lista
            List<Viaje> lista = new List<Viaje>();

            try
            {
                conect.Open();
                reader=sp.ExecuteReader();

                if(reader.HasRows){
                    while(reader.Read()){
                        ViajeInternacional viaje = new ViajeInternacional(Convert.ToInt32(reader[0]), ((PersistenciaCompania.getInstance()).BuscarCompania(reader[1].ToString())), ((PersistenciaTerminal.getInstance()).BuscarTerminal(reader[2].ToString())), ((PersistenciaEmpleado.getInstance().BuscarEmpleado(Convert.ToInt32(reader[3])))), Convert.ToDateTime(reader[4]), Convert.ToDateTime(reader[5]), Convert.ToInt32(reader[6]), Convert.ToBoolean(reader[7]), reader[8].ToString());
                        lista.Add(viaje); 
                    }
                }
                return lista;
            }
            catch(Exception ex) { throw ex; }

            finally { conect.Close(); }
        }

        //BUSCAR VIAJE INTERNACIONAL
        public ViajeInternacional BuscarViajeInternacional(int NViaje) {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BuscarViajeInternacional", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametro
            sp.Parameters.Add("@NViaje",NViaje);
            //reader
            SqlDataReader reader;

            ViajeInternacional viaje = null;
            try
            {
                conect.Open();
                reader = sp.ExecuteReader();

                if (reader.HasRows)
                {
                    reader.Read();
                    viaje = new ViajeInternacional(Convert.ToInt32(reader[0]), ((PersistenciaCompania.getInstance()).BuscarCompania(reader[1].ToString())), ((PersistenciaTerminal.getInstance()).BuscarTerminal(reader[2].ToString())), ((PersistenciaEmpleado.getInstance().BuscarEmpleado(Convert.ToInt32(reader[3])))), Convert.ToDateTime(reader[4]), Convert.ToDateTime(reader[5]), Convert.ToInt32(reader[6]), Convert.ToBoolean(reader[7]), reader[8].ToString());
                }
                return viaje;
            }
            catch (Exception ex) { throw ex; }
        }
    }
}
