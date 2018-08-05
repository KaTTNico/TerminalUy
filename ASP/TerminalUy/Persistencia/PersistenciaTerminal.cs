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
            SqlTransaction transact = null;

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
                transact = conect.BeginTransaction();
                sp.Transaction = transact;
                
                //alta terminal
                sp.ExecuteNonQuery();

                //retorno
                if ((int)retorno.Value == 1)
                {
                    //alta facilidades
                    PersistenciaFacilidades.Altafacilidad(terminal, transact);

                    throw new Exception("Terminal dada de alta.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("La terminal " + terminal.pCodigo + " ya existe."); }
                transact.Commit();
            }
            catch { transact.Rollback(); throw; }

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
            SqlTransaction transact = null;

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
                transact = conect.BeginTransaction();
                sp.Transaction = transact;
                sp.ExecuteNonQuery();

                //retorno
                if ((int)retorno.Value == 1){throw new Exception("Terminal modificada.");}
                if ((int)retorno.Value == -1) { throw new Exception("La terminal " + terminal.pCodigo + " no existe."); }
                sp.Transaction.Commit();
            }
            catch { sp.Transaction.Rollback(); throw; }

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

        //BUSCAR TERMINAL
        public Terminal BuscarTerminal(string codigo) { 
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BuscarTerminal", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametro
            sp.Parameters.Add("@Codigo",codigo);

            //reader
            SqlDataReader reader;
            //Lista
            List<Facilidades> lista = new List<Facilidades>();
            //terminal
            Terminal terminal;

            try
            {
                conect.Open();
                reader=sp.ExecuteReader();

                if (reader.HasRows)
                {
                    reader.Read();
                    terminal = new Terminal(reader[0].ToString(), reader[1].ToString(), reader[2].ToString(), lista);
                    terminal.pFacilidades = PersistenciaFacilidades.BuscarFacilidades(terminal);
                }
                else { throw new Exception("No se encontro ninguna terminal"); }

                return terminal;
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //ListarTerminalesActivas
        //ListarTerminales
    }
}
