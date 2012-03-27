using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;
using System.Data.Common;

namespace Jive.BusinessRules
{
    /// <summary>
    /// Summary description for Database
    /// </summary>
    // Database Class Wrapper
    public class Database
    {
        // The database interface
        private IDatabase _database;
        // The database connnecion string
        private static readonly string _dbtype = ConfigurationManager.ConnectionStrings["DBTYPE"].ConnectionString;
        private static readonly string _connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        // static constructor
        static Database()
        {
        }

        // Constructor
        public Database(string connectionString)
        {
            // _connectionString = connectionString;
            if (_dbtype.Equals("MSSQL"))
            {
                _database = new MSSQLDatabase(connectionString);
            }
            else
            {
                LogManager.globallog("Info", "Database()", "Creating mysql with " + connectionString);
                _database = new MySqlDatabase(connectionString);
            }
        }

        // The connection string
        public string ConnectionString
        {
            get
            {
                return _database.ConnectionString();
            }
        }

        // Returns a connection
        public DbConnection getConnection()
        {
            return _database.getConnection();
        }

        // Build a query command
        public DbCommand BuildQueryCommand(string sql, IDataParameter[] param)
        {
            return _database.BuildQueryCommand(sql, param);
        }

        // Build a query command
        public DbCommand BuildQueryCommand(MySqlConnection conn, MySqlTransaction trans, string sql, IDataParameter[] param)
        {
            return _database.BuildQueryCommand(conn, trans, sql, param);
        }

        // Executes a dataset
        public DataSet ExecuteDataSet(string sql, IDataParameter[] param, string tableName)
        {
            return _database.ExecuteDataSet(sql, param, tableName);
        }

        // Executes a reader
        public DbDataReader ExecuteReader(string sql, IDataParameter[] param)
        {
            return _database.ExecuteReader(sql, param);
        }

        // Executes a reader
        public DbDataReader ExecuteReader(DbConnection conn, DbTransaction trans, string sql, IDataParameter[] param)
        {
            return _database.ExecuteReader(sql, param);
        }

        // Close connections
        public void closeConnection()
        {
            _database.closeConnection();
        }

        // Executes a non query
        public int ExecuteNonQuery(MySqlConnection conn, MySqlTransaction trans, string sql, IDataParameter[] param)
        {
            return _database.ExecuteNonQuery(conn, trans, sql, param);
        }

        // Executes a non query
        public int ExecuteNonQuery(string sql, IDataParameter[] param)
        {
            return _database.ExecuteNonQuery(sql, param);
        }

        // Executes a non query
        public int ExecuteIdentityNonQuery(string sql, IDataParameter[] param)
        {
            return _database.ExecuteIdentityNonQuery(sql, param);
        }

        // Executes a scalar
        public object ExecuteScalar(string sql, IDataParameter[] param)
        {
            return _database.ExecuteScalar(sql, param);
        }

        // Executes a scalar and returns a string
        public String ExecuteScalarString(string sql, IDataParameter[] param)
        {
            return _database.ExecuteScalarString(sql, param);
        }

        // Executes a scalar and returns a int
        public int ExecuteScalarInt(string sql, IDataParameter[] param)
        {
            return _database.ExecuteScalarInt(sql, param);
        }

        // Executes a scalar and returns a object
        public object ExecuteScalar(DbConnection conn, DbTransaction trans, string sql, IDataParameter[] param)
        {
            return _database.ExecuteScalar(conn, trans, sql, param);
        }

        // Gets the dataabse parameter
        public DbParameter getDbParameter(string paramname, object value)
        {
            return _database.getDbParameter(paramname, value);

        }

        // Gets the dataabse parameter
        public DbParameter getDbParameter(string paramname, object value, int pid)
        {
            return _database.getDbParameter(paramname, value, pid);

        }

        // Converts the sql to the database-specific friendly sql
        public String sanitize(string sql)
        {
            return _database.sanitize(sql);

        }
    }
}