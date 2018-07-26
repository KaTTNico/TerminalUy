using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using System.Data;
using System.Data.SqlClient;

namespace Persistencia
{
    internal class PersistenciaTerminal : iPersistenciaTerminal
    {
        //singleton
        private static PersistenciaTerminal instancia = null;

        //get instancia 
        public static PersistenciaTerminal getInstance() { return (instancia == null) ? instancia = new PersistenciaTerminal() : instancia; }

        //constructor por defecto 
        private PersistenciaTerminal() { }

        //----------------------------------------------------------------------ABM------------------------------------------------------------------------------------

        //ALTA TERMINAL
        public void AltaTerminal(Terminal terminal)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("AltaTerminal", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@Codigo", terminal.pCodigo);
            sp.Parameters.Add("@Ciudad", terminal.pCiudad);
            sp.Parameters.Add("@Pais", terminal.pPais);

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
                    throw new Exception("Terminal dada de alta.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("La terminal " + terminal.pCodigo + " ya existe."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //MODIFICAR TERMINAL
        public void ModificarTerminal(Terminal terminal)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("ModificarTerminal", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@Codigo", terminal.pCodigo);
            sp.Parameters.Add("@Ciudad", terminal.pCiudad);
            sp.Parameters.Add("@Pais", terminal.pPais);

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
                    throw new Exception("Terminal dada de alta.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("La terminal " + terminal.pCodigo + " no existe."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //BAJA TERMINAL
        public void BajaTerminal(Terminal terminal)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BajaTerminal", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametro
            sp.Parameters.Add("@Codigo", terminal.pCodigo);

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
                    throw new Exception("Terminal dada de alta.");
                }
                else if ((int)retorno.Value == -2) { throw new Exception("La terminal " + terminal.pCodigo + " no existe."); }
                else if ((int)retorno.Value == -1) { throw new Exception("Error inesperado."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }
    }
}
