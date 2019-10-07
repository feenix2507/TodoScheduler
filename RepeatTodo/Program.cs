using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.IO;
using System.Configuration;
using System.Net;
using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;

using System.Xml.Linq;

namespace RepeatTodoScheduler
{
    class Program
    {
        static void Main(string[] args)
        {
            //SET APP CONFIG
            var ConnectionString = ConfigurationManager.AppSettings["ConnectionString"];

            using (SqlConnection conn = new SqlConnection())
            {
                // Create the connectionString
                conn.ConnectionString = ConnectionString;
                conn.Open();
                //SqlDataAdapter da = new SqlDataAdapter($"select top 1 createdby from todo", ConnectionString);
                SqlCommand cmd = new SqlCommand("repeatScheduler", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.ExecuteNonQuery();
                SqlDataAdapter adp = new SqlDataAdapter(cmd);
                
                //DataSet ds = new DataSet();
                //da.Fill(ds, "createdby");
                //List<dynamic> users = new List<dynamic>();
                //foreach (DataRow row in ds.Tables["createdby"].Rows)
                //{
                //    users.Add(row["createdby"].ToString());
                //}
                //    Console.Write("This is for Channel: ");
                //    Console.WriteLine(users[0]);
                   

            }
        }
    }
}