using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EntidadesCompartidas;

namespace Logica
{
    public interface iLogicaEmpleado
    {
        //operaciones
        //ALTA EMPLEADO
        void AltaEmpleado(Empleado empleado);

        //BAJA EMPLEADO
        void BajaEmpleado(Empleado empleado);

        //MODIFICAR EMPLEADO
        void ModificarEmpleado(Empleado empleado);
    }
}
