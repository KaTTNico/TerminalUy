using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace pruebas_regex
{
    class Program
    {
        static void Main(string[] args)
        {
            int value = 26963107;
            //verificar telefono
            if ((Regex.Match(value.ToString(), @"^(09)([0-9]){7}$|^(2)([0-9]){7}$")).Success)
            {
                Console.Write("HOLA SUSANA");
                Console.ReadKey();
            }
            else { Console.WriteLine("CHAU SUSANA."); }
        }
    }
}
