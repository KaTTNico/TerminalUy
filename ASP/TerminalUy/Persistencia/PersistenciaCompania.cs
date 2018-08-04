using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using System.Data;
using System.Data.SqlClient;

namespace Persistencia
{
    internal class PersistenciaCompania : iPersistenciaCompania
    {
        //singleton
        private static PersistenciaCompania instancia = null;

        //get instancia 
        public static PersistenciaCompania getInstance() {return ( (instancia)?? (instancia=new PersistenciaCompania())  );}

        //constructor por defecto 
        private PersistenciaCompania() { }

        //----------------------------------------------------------------------ABM------------------------------------------------------------------------------------

        //ALTA COMPANIA
        public void AltaCompania(Compania compania) {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);
            
            //sp
            SqlCommand sp = new SqlCommand("AltaCompania", conect);
            sp.CommandType = CommandType.StoredProcedure;
            
            //parametros
            sp.Parameters.Add("@Nombre", compania.pNombre);
            sp.Parameters.Add("@Direccion", compania.pDireccion);
            sp.Parameters.Add("@Telefono", compania.pTelefono);

            //retorno
            SqlParameter retorno = new SqlParameter("@retorno",SqlDbType.Int);
            retorno.Direction=ParameterDirection.ReturnValue;
            sp.Parameters.Add("@retorno", retorno);


            try
            {
                conect.Open();
                sp.ExecuteNonQuery();

                //retorno
                if ((int)retorno.Value == 1)
                {
                    throw new Exception("Compania dada de alta.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("La compania " + compania.pNombre + " ya existe."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //MODIFICAR COMPANIA
        public void ModificarCompania(Compania compania) {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("ModificarCompania", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@Nombre", compania.pNombre);
            sp.Parameters.Add("@Direccion", compania.pDireccion);
            sp.Parameters.Add("@Telefono", compania.pTelefono);

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
                    throw new Exception("Compania modificada.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("La compania " + compania.pNombre + " no existe."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //BAJA COMPANIA
        public void BajaCompania(Compania compania) {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BajaCompania", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametro
            sp.Parameters.Add("@Nombre", compania.pNombre);

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
                    throw new Exception("Compania eliminada.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("La compania " + compania.pNombre + " no existe."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //BUSCAR COMPANIA
        public Compania BusarCompania(string Nombre) {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BuscarCompania", conect);
            sp.CommandType = CommandType.StoredProcedure;

            ///parametro
            sp.Parameters.Add("@Nombre", Nombre);
            //reader
            SqlDataReader reader;

            Compania compania;
            try
            {
                conect.Open();
                reader=sp.ExecuteReader();

                //si hay datos
                if (reader.HasRows)
                {
                    reader.Read();
                    compania = new Compania(reader[0].ToString(), reader[1].ToString(), Convert.ToInt32(reader[2]));
                }
                else { throw new Exception("No se encontro ninguna compania con ese nombre."); }

                return compania; 
            }
            catch { throw; }

            finally { conect.Close(); }
        }
        //ListaCompaniasActivas
        //ListarCompanias
    }
}
