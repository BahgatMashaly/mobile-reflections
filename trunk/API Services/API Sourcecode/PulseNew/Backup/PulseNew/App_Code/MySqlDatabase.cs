using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Data.Common;

namespace Jive.BusinessRules
{
    /// <summary>
    /// Summary description for MySqlDatabase
    /// </summary>
    public class MySqlDatabase : IDatabase
    {
        private MySqlConnection _sqlConnection;
        private string _connectionString = @"server=localhost; user id=root; password=sa; database=lms192; pooling=false;";

        public MySqlDatabase(string connectionString)
        {
            _connectionString = connectionString;
            _sqlConnection = new MySqlConnection(connectionString);
        }

        public string ConnectionString()
        {
            return _connectionString;
        }


        public DbConnection getConnection()
        {
            return new MySqlConnection(_connectionString);
        }

        public bool openConnection()
        {
            try
            {
                if (_sqlConnection.State != ConnectionState.Open)
                    _sqlConnection.Open();
            }
            catch (Exception ex)
            {
                _sqlConnection.Dispose();
                _sqlConnection = new MySqlConnection(ConnectionString());
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
            MySqlCommand com = new MySqlCommand(sql, _sqlConnection);
            if (param != null)
                foreach (MySqlParameter sp in param)
                    com.Parameters.Add(sp);
            return com;
        }

        public DbCommand BuildQueryCommand(DbConnection conn, DbTransaction trans, string sql, IDataParameter[] param)
        {
            MySqlCommand com = new MySqlCommand(sql, (MySqlConnection)conn);
            com.Transaction = (MySqlTransaction)trans;
            if (param != null)
                foreach (MySqlParameter sp in param)
                    com.Parameters.Add(sp);
            return com;
        }

        public DataSet ExecuteDataSet(string sql, IDataParameter[] param, string tableName)
        {
            DataSet ds = new DataSet();
            MySqlDataAdapter sda = new MySqlDataAdapter();
            if (openConnection())
            {
                sda.SelectCommand = (MySqlCommand)BuildQueryCommand(sql, param);
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
                MySqlCommand scq = (MySqlCommand)BuildQueryCommand(sql, param);
                MySqlDataReader sdr = scq.ExecuteReader();
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
            MySqlCommand scq = (MySqlCommand)BuildQueryCommand(conn, trans, sql, param);
            MySqlDataReader sdr = scq.ExecuteReader();
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
                MySqlCommand sc = (MySqlCommand)BuildQueryCommand(conn, (MySqlTransaction)trans, sql, param);
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
                MySqlCommand sc = (MySqlCommand)BuildQueryCommand(sql, param);
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
                MySqlCommand sc = (MySqlCommand)BuildQueryCommand(sql, param);
                row = sc.ExecuteNonQuery();
                sc = new MySqlCommand("SELECT @@IDENTITY", _sqlConnection);
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
                MySqlCommand sc = (MySqlCommand)BuildQueryCommand(sql, param);
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
                MySqlCommand sc = (MySqlCommand)BuildQueryCommand(sql, param);
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
                MySqlCommand sc = (MySqlCommand)BuildQueryCommand(sql, param);
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
                MySqlCommand sc = (MySqlCommand)BuildQueryCommand(conn, (MySqlTransaction)trans, sql, param);
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
            return new MySqlParameter(paramname, value);
        }

        public DbParameter getDbParameter(string paramname, object value, int id)
        {
            return new MySqlParameter(paramname, value);

        }

        public String sanitize(string sql)
        {
            return sql;
        }
    }
}