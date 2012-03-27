using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;

namespace Jive.BusinessRules
{
    /// <summary>
    /// Summary description for MSSQLDatabase
    /// </summary>
    public class MSSQLDatabase : IDatabase
    {
        private SqlConnection _sqlConnection;
        private string _connectionString = @"Data Source=localhost;Initial Catalog=communicator;Integrated Security=True";

        public MSSQLDatabase(string connectionString)
        {
            _connectionString = connectionString;
            _sqlConnection = new SqlConnection(connectionString);
        }

        public string ConnectionString()
        {
            return _connectionString;
        }


        public DbConnection getConnection()
        {
            return new SqlConnection(_connectionString);
        }

        public bool openConnection()
        {
            try
            {
                if (_sqlConnection.State != ConnectionState.Open)
                    _sqlConnection.Open();
            }
            catch
            {
                _sqlConnection.Dispose();
                _sqlConnection = new SqlConnection(ConnectionString());
                try
                {
                    _sqlConnection.Open();
                }
                catch
                {
                    return false;
                }
            }
            return true;
        }

        public void closeConnection()
        {
        }

        public DbCommand BuildQueryCommand(string sql, IDataParameter[] param)
        {
            SqlCommand com = new SqlCommand(sql, _sqlConnection);
            if (param != null)
                foreach (SqlParameter sp in param)
                    com.Parameters.Add(sp);
            return com;
        }

        public DbCommand BuildQueryCommand(DbConnection conn, DbTransaction trans, string sql, IDataParameter[] param)
        {
            SqlCommand com = new SqlCommand(sql, (SqlConnection)conn);
            com.Transaction = (SqlTransaction)trans;
            if (param != null)
                foreach (SqlParameter sp in param)
                    com.Parameters.Add(sp);
            return com;
        }

        public DataSet ExecuteDataSet(string sql, IDataParameter[] param, string tableName)
        {
            DataSet ds = new DataSet();
            SqlDataAdapter sda = new SqlDataAdapter();
            if (openConnection())
            {
                sda.SelectCommand = (SqlCommand)BuildQueryCommand(sql, param);
                sda.Fill(ds);
                closeConnection();
                return ds;
            }
            else
            {
                // No point logging as DB out of commission
                return null;
            }
        }

        public DbDataReader ExecuteReader(string sql, IDataParameter[] param)
        {
            if (openConnection())
            {
                openConnection();
                SqlCommand scq = (SqlCommand)BuildQueryCommand(sql, param);
                SqlDataReader sdr = scq.ExecuteReader();
                return sdr;
            }
            else
            {
                // No point logging as DB out of commission
                return null;
            }
        }

        public DbDataReader ExecuteReader(DbConnection conn, DbTransaction trans, string sql, IDataParameter[] param)
        {
            SqlCommand scq = (SqlCommand)BuildQueryCommand(conn, trans, sql, param);
            SqlDataReader sdr = scq.ExecuteReader();
            return sdr;
        }


        public int ExecuteNonQuery(DbConnection conn, DbTransaction trans, string sql, IDataParameter[] param)
        {
            int row = -1;
            if (!openConnection())
            {
                // No point logging as DB out of commission
                return row;
            }
            try
            {
                SqlCommand sc = (SqlCommand)BuildQueryCommand(conn, (SqlTransaction)trans, sql, param);
                row = sc.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteNonQuery", e.ToString());
                return -1;
            }
            catch
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteNonQuery", "Unknown Error");
                return -1;
            }
            finally
            {
                closeConnection();
            }

            return row;
        }

        public int ExecuteNonQuery(string sql, IDataParameter[] param)
        {
            int row = -1;
            if (!openConnection())
            {
                // No point logging as DB out of commission
                return row;
            }
            try
            {
                SqlCommand sc = (SqlCommand)BuildQueryCommand(sql, param);
                row = sc.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteNonQuery", e.ToString());
                return -1;
            }
            catch
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteNonQuery", "Unknown Error");
                return -1;
            }
            finally
            {
                closeConnection();
            }

            return row;
        }

        public int ExecuteIdentityNonQuery(string sql, IDataParameter[] param)
        {
            int row = -1;
            if (!openConnection())
            {
                // No point logging as DB out of commission
                return row;
            }
            try
            {
                SqlCommand sc = (SqlCommand)BuildQueryCommand(sql, param);
                row = sc.ExecuteNonQuery();
                sc = new SqlCommand("SELECT @@IDENTITY", _sqlConnection);
                row = (int)sc.ExecuteScalar();
            }
            catch (Exception e)
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteIdentityNonQuery", e.ToString());
                return -1;
            }
            catch
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteIdentityNonQuery", "Unknown Error");
                return -1;
            }
            finally
            {
                closeConnection();
            }

            return row;
        }

        public object ExecuteScalar(string sql, IDataParameter[] param)
        {
            object scalar = null;
            if (!openConnection())
            {
                // No point logging as DB out of commission
                return null;
            }
            try
            {
                SqlCommand sc = (SqlCommand)BuildQueryCommand(sql, param);
                scalar = sc.ExecuteScalar();
            }
            catch (Exception e)
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteIdentityNonQuery", e.ToString());
                return -1;
            }
            catch
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteIdentityNonQuery", "Unknown Error");
                return -1;
            }
            finally
            {
                closeConnection();
            }
            return scalar;
        }

        public String ExecuteScalarString(string sql, IDataParameter[] param)
        {
            object scalar = null;
            if (!openConnection())
            {
                // No point logging as DB out of commission
                return null;
            }
            try
            {
                SqlCommand sc = (SqlCommand)BuildQueryCommand(sql, param);
                scalar = sc.ExecuteScalar();
            }
            catch (Exception e)
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteScalarString", e.ToString());
                return null;
            }
            catch
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteScalarString", "Unknown Error");
                return null;
            }
            finally
            {
                closeConnection();
            }
            if (scalar == null) return "";
            return (String)scalar;
        }

        public int ExecuteScalarInt(string sql, IDataParameter[] param)
        {
            object scalar = null;
            if (!openConnection())
            {
                // No point logging as DB out of commission
                return 0;
            }
            try
            {
                SqlCommand sc = (SqlCommand)BuildQueryCommand(sql, param);
                scalar = sc.ExecuteScalar();
            }
            catch (Exception e)
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteScalarInt", e.ToString());
                return 0;
            }
            catch
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteScalarInt", "Unknown Error");
                return 0;
            }
            finally
            {
                closeConnection();
            }
            if (scalar == null) return 0;
            return (int)(long)scalar;
        }

        public object ExecuteScalar(DbConnection conn, DbTransaction trans, string sql, IDataParameter[] param)
        {
            object scalar = null;
            try
            {
                SqlCommand sc = (SqlCommand)BuildQueryCommand(conn, (SqlTransaction)trans, sql, param);
                scalar = sc.ExecuteScalar();
            }
            catch (Exception e)
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteScalar", e.ToString());
                return 0;
            }
            catch
            {
                LogManager.log(LogManager.ERR, "MysqlDatabase.ExecuteScalar", "Unknown Error");
                return 0;
            }
            return scalar;
        }

        public DbParameter getDbParameter(string paramname, object value)
        {
            return new SqlParameter(paramname, value);
        }

        public DbParameter getDbParameter(string paramname, object value, int id)
        {
            return new SqlParameter(paramname, value);

        }

        public String sanitize(string sql)
        {
            return sql;
        }
    }
}