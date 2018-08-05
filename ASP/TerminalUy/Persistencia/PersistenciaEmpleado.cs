using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;
using System.Data;
using System.Data.SqlClient;

namespace Persistencia
{
    internal class PersistenciaEmpleado : iPersistenciaEmpleado
    {
        //singleton
        private static PersistenciaEmpleado instancia = null;

        //get instancia 
        public static PersistenciaEmpleado getInstance() { return (instancia == null) ? instancia = new PersistenciaEmpleado() : instancia; }

        //constructor por defecto 
        private PersistenciaEmpleado() { }

        //----------------------------------------------------------------------ABM------------------------------------------------------------------------------------

        //ALTA EMPLEADO
        public void AltaEmpleado(Empleado empleado)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("AltaEmpleado", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@Cedula", empleado.pCedula);
            sp.Parameters.Add("@Pass", empleado.pPass);
            sp.Parameters.Add("@Nombre", empleado.pNombre);

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
                    throw new Exception("Empleado dado de alta.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("El empleado " + empleado.pNombre + " ya existe."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //MODIFICAR EMPLEADO
        public void ModificarEmpleado(Empleado empleado)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("ModificarEmpleado", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametros
            sp.Parameters.Add("@Cedula", empleado.pCedula);
            sp.Parameters.Add("@Pass", empleado.pPass);
            sp.Parameters.Add("@Nombre", empleado.pNombre);

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
                    throw new Exception("Empleado modificado.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("El empleado " + empleado.pNombre + " no existe."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }

        //BAJA EMPLEADO
        public void BajaEmpleado(Empleado empleado)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BajaEmpleado", conect);
            sp.CommandType = CommandType.StoredProcedure;

            //parametro
            sp.Parameters.Add("@Cedula", empleado.pCedula);

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
                    throw new Exception("Empleado eliminado.");
                }
                else if ((int)retorno.Value == -1) { throw new Exception("El empleado " + empleado.pNombre + " no existe."); }
            }
            catch { throw; }

            finally { conect.Close(); }
        }


        //BUSCAR COMPANIA
        public Empleado BuscarEmpleado(int cedula)
        {
            //conexion
            SqlConnection conect = new SqlConnection(Conexion.Cnn);

            //sp
            SqlCommand sp = new SqlCommand("BuscarEmpleado", conect);
            sp.CommandType = CommandType.StoredProcedure;

            ///parametro
            sp.Parameters.Add("@Cedula", cedula);
            //reader
            SqlDataReader reader;

            Empleado empleado;
            try
            {
                conect.Open();
                reader = sp.ExecuteReader();

                //si hay datos
                if (reader.HasRows)
                {
                    reader.Read();
                    empleado = new Empleado(Convert.ToInt32(reader[0]),reader[1].ToString(),reader[2].ToString());
                }
                else { throw new Exception("No se encontro ninguna compania con ese nombre."); }

                return empleado;
            }
            catch { throw; }

            finally { conect.Close(); }
        }
        //ListarEmpleados
        //ListarEmpleadosActivos
    }
}
