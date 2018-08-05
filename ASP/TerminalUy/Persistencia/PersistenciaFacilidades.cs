using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using System.Data;
using System.Data.SqlClient;

namespace Persistencia
{
    internal class PersistenciaFacilidades
    {

        //----------------------------------------------------------------------AM------------------------------------------------------------------------------------

        //ALTA FACILIDAD
        public static void Altafacilidad(Terminal terminal,SqlTransaction transact) {
            //sp
            SqlCommand sp = new SqlCommand("AltaFacilidad", transact.Connection);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@Codigo", terminal.pCodigo);


            //retorno
            SqlParameter retorno = new SqlParameter("@retorno", SqlDbType.Int);
            retorno.Direction = ParameterDirection.ReturnValue;
            sp.Parameters.Add("@retorno", retorno);


            try
            {
                sp.Transaction = transact;
                
                foreach (Facilidades facilidad in terminal.pFacilidades) {
                        sp.Parameters.Add("@Facilidad", terminal.pFacilidades);
                        sp.ExecuteNonQuery();

                        if ((int)retorno.Value == -1) { throw new Exception("La terminal no existe."); }

                        if ((int)retorno.Value == -2) { throw new Exception("La facilidad ya existe."); }
                }

            }
            catch { throw; }
        }

        //MODIFICAR FACILIDADES
        public void ModificarFacilidades(Terminal terminal,SqlTransaction transact) {
            //sp
            SqlCommand sp = new SqlCommand("ModificarFacilidad", transact.Connection);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@Codigo", terminal.pCodigo);


            //retorno
            SqlParameter retorno = new SqlParameter("@retorno", SqlDbType.Int);
            retorno.Direction = ParameterDirection.ReturnValue;
            sp.Parameters.Add("@retorno", retorno);


            try
            {
                sp.Transaction = transact;

                foreach (Facilidades facilidad in terminal.pFacilidades)
                {
                    sp.Parameters.Add("@Facilidad", terminal.pFacilidades);
                    sp.ExecuteNonQuery();

                    if ((int)retorno.Value == -1) { throw new Exception("La terminal no existe."); }
                }

            }
            catch { throw; }
        }

        //----------------------------------------------------------------------BUSQUEDA------------------------------------------------------------------------------------


        //BUSCAR FACILIDADES
        public static List<Facilidades> BuscarFacilidades(Terminal terminal)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BuscarFacilidades", conect);
            sp.CommandType = CommandType.StoredProcedure;

            ///parametro
            sp.Parameters.Add("@Codigo", terminal.pCodigo);
            //reader
            SqlDataReader reader;

            List<Facilidades> facilidades = new List<Facilidades>();
            try
            {
                conect.Open();
                reader = sp.ExecuteReader();

                while (reader.Read())
                {
                    Facilidades facilidad = new Facilidades(reader[1].ToString());
                    facilidades.Add(facilidad);
                }
                return facilidades;
            }
            catch { throw; }

            finally { conect.Close(); }
        }
    }
}
