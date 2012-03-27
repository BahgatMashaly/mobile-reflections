using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.Data.Common;
using System.Data;
using System.Web;
using System.IO;
using System.Security.Cryptography;

namespace Jive.BusinessRules
{
    public class GetData
    { 
        // The database settings
        private static Database _db;
        // The database settings
        private static DateTime _dtdb = DateTime.Now.AddDays(-1);
        // The database settings
        private static readonly string _connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        private static readonly string _filePath = ConfigurationManager.ConnectionStrings["iCloudPath"].ConnectionString;        


        // Creates the database or renews the connection after evry 2 hours
        private static void createDatabase()
        {
            System.TimeSpan diffResult = DateTime.Now.Subtract(_dtdb);
            if (diffResult.Hours > 2 || diffResult.Days >= 1)
            {
                // revalidate the database
                if (_db != null)
                {
                    // Close connection
                    _db.closeConnection();
                    _db = null;
                }
            }
            // If null, recreate
            if (_db == null)
            {
                _db = new Database(_connStr);
                _dtdb = DateTime.Now;
            }
            else
            {
                _dtdb = DateTime.Now;
            }
        }

        private void closeConn()
        {
            _db.closeConnection();
        }

        // Force a shutdown of connections
        public static void forceClose()
        {
            // revalidate the database
            try
            {
                if (_db != null)
                {
                    _db.closeConnection();
                    _db = null;
                }
            }
            catch
            {
            }
            _db = null;
        }

        public string getFielPath()
        {
            return _filePath;
        }

        // Executes an sql statement 
        public static void executeSQL(String sql)
        {
            createDatabase();
            string sql2 = _db.sanitize(sql);
            _db.ExecuteNonQuery(sql2, null);
        }

        public string TestConnection()
        {
            string retVal = "Unable to establish connection!!!";
            try
            {
                createDatabase();

                retVal = "Connection Established!!!";

            }
            catch (Exception ex)
            {
                retVal = "Unable to establish connection: " + ex.Message;
            }
            return retVal;
        }

        /// <summary>
        /// Based upon userid and password will provide ticket from users table
        /// </summary>
        /// <param name="userid"></param>
        /// <param name="password"></param>
        /// <returns>ticket</returns>
        public string validateUser(string userid, string password)
        {
            string retVal = "<result>Invalid userid or password</result>";
            if (userid == null || password == null || userid == "" || password == "") 
            {
                retVal = "<result>userid or password cannot be empty</result>";
            }
            else
            {
                // Ensure that database has been created
                createDatabase();

                // Create the parameters list
                DbParameter[] param = { _db.getDbParameter("?username", userid), _db.getDbParameter("?password", password) };

                // Formulates the sql query
                string sql = _db.sanitize("SELECT username FROM jivedb.ofuser WHERE username = ?username and plainPassword = ?password;");

                // Reads the data set parameters

                object output = _db.ExecuteScalar(sql, param);

                // return true if record exists                
                if (output != null)
                {

                    retVal = "<result>" + getUpdateUserTicket(userid) + "</result>";
                }
                   
            }
            return retVal;
        }

        public string getUpdateUserTicket(string userid)
        {
            createDatabase();
            string retVal = "";
            // Create the parameters list

            DbParameter[] param = { _db.getDbParameter("?userid", userid) };

            // Formulates the sql query
            string sql = _db.sanitize("SELECT ticket FROM user WHERE userid = ?userid;");

            // Reads the data set parameters

            object output = _db.ExecuteScalar(sql, param);
            if (output != null && output.ToString() != "")
            {
                retVal = output.ToString();
            }
            else
            {
                string ticket = generateUserTicket(userid);
                DbParameter[] parameter = { _db.getDbParameter("?userid", userid), _db.getDbParameter("?ticket", ticket) };                
                sql = _db.sanitize("update user set ticket = ?ticket where userid = ?userid;");
                _db.ExecuteScalar(sql, parameter);
                retVal = ticket;
            }
            return retVal;

        }

        public string generateUserTicket(string data)
        {
            HMACSHA1 hash = new HMACSHA1();       
            //consumersecrtet and tokensecret can be pulled from configuration if needed.
            hash.Key = Encoding.ASCII.GetBytes(string.Format("{0}&{1}", OAuthBase.UrlEncode("consumerSecret"), string.IsNullOrEmpty("tokenSecret") ? "" : OAuthBase.UrlEncode("tokenSecret")));
            return OAuthBase.ComputeHash(hash, data);
        }

        public bool validateUserTicket(string userid, string ticket)
        {
            createDatabase();
            DbParameter[] parameter = { _db.getDbParameter("?userid", userid), _db.getDbParameter("?ticket", ticket) };
            //string sql = _db.sanitize("select ticket from user where ticket = ?ticket and userid = ?userid;");
            string sql = _db.sanitize("select ticket from user where userid = ?userid;");
            object retVal = _db.ExecuteScalar(sql, parameter);
            if (retVal != null && retVal.ToString() != "")            
            {
                return true;
            }
            return false;


        }
        /// <summary>
        /// Get User Info
        /// </summary>
        /// <param name="userid"></param>
        /// <param name="ticket"></param>
        /// <returns>Xml</returns>
        public string getUserInfo(string userid, string ticket)
        {
            if (!validateUserTicket(userid, ticket))
                return "";
            
            StringBuilder retVal = new StringBuilder();
            createDatabase();

            // Create the parameters list
            DbParameter[] param = { _db.getDbParameter("?userid", userid.ToLower()), _db.getDbParameter("?ticket", ticket) };

            // Formulates the sql query
            string sql = _db.sanitize("SELECT userid, fullname, quota FROM user WHERE userid = ?userid;");
            
            retVal.Append("<user>");
            string filepath = _filePath + userid + @"\";

            DirectoryInfo dirInfo = new DirectoryInfo(filepath);
            
            // Reads the data set parameters           
            using (DbDataReader reader = _db.ExecuteReader(sql, param))
            {
                while (reader.Read())
                {
                    retVal.Append("<name>" + reader["fullname"] + "</name>");
                    retVal.Append("<quota>" + reader["quota"] + "</quota>");
                    // do do system dir and get size;
                    retVal.Append("<used>" + getUserQuota(filepath) + "</used>");
                }
            }
            retVal.Append("</user>");

            return retVal.ToString();
        }

        public double getUserQuota(string path)
        {
            double fDirSize = 0;

            if (!System.IO.Directory.Exists(path))
                return fDirSize;
            try
            {
                System.IO.DirectoryInfo dirInfo = new
                System.IO.DirectoryInfo(path);


                System.IO.FileInfo[] oFiles = dirInfo.GetFiles();
                if (oFiles.Length > 0)
                {
                    int nFileLen = oFiles.Length;
                    for (int i = 0; i < nFileLen; i++)
                        fDirSize += oFiles[i].Length;
                }

                System.IO.DirectoryInfo[] oDirectories = dirInfo.GetDirectories();
                if (oDirectories.Length > 0)
                {
                    int nDirLen = oDirectories.Length;
                    for (int i = 0; i < nDirLen; i++)
                        fDirSize += getUserQuota(oDirectories[i].FullName);
                }
            }
            catch (Exception ex)
            {
                
            }

            return fDirSize;
        }

        public string getAllFolders(string userid, string ticket, string folderName, string returntype)
        {
            if (!validateUserTicket(userid, ticket))
                return "";

            StringBuilder retVal = new StringBuilder();

            retVal.Append("<result><items>");

            string filepath = _filePath + userid + @"\";

            if (!Directory.Exists(filepath))
                Directory.CreateDirectory(filepath);

            filepath = filepath + folderName;

            if (!Directory.Exists(filepath))
            {
                retVal.Append("</items></result>");
                return retVal.ToString();
            }

            if (returntype.ToLower() == "all")
            {
                DirectoryInfo di = new DirectoryInfo(filepath);
                DirectoryInfo[] sdi = di.GetDirectories();
                foreach (DirectoryInfo ssdi in sdi)
                {
                    if (ssdi.Name == "Shared Folder")
                    {
                        retVal.Append("<folder name='" + ssdi.Name + "' access='Shared'>");
                        if (checkSharedFolder(userid, di.Name + "\\" + ssdi.Name))
                        {
                            //make folder access to shared
                        }
                    }
                    else
                    {
                        retVal.Append("<folder name='" + ssdi.Name + "' >");
                    }
                    GetNestedFolder(ssdi.FullName, retVal, userid);
                    //GetFilesForFolder(ssdi.FullName, retVal);
                    retVal.Append("</folder>");
                }
                GetFilesForFolder(filepath, retVal);

                retVal.Append("</items></result>");
            }
            else if (returntype.ToLower() == "file")
            {
                FileInfo ffi = null;
                foreach (string filePath in Directory.GetFiles(filepath))
                {
                    ffi = new FileInfo(filePath);
                    retVal.Append("<file name='" + ffi.Name + "' mime='" + getMime(ffi.Extension) + "' size='" + ffi.Length + "' />");
                }
                retVal.Append("</items></result>");
            }
            else if (returntype.ToLower() == "folder")
            {
                DirectoryInfo di = new DirectoryInfo(filepath);
                DirectoryInfo[] sdi = di.GetDirectories();
                foreach (DirectoryInfo ssdi in sdi)
                {
                    if (ssdi.Name == "Shared Folder")
                    {
                        retVal.Append("<folder name='" + ssdi.Name + "' access='Shared'>");
                        if (checkSharedFolder(userid, di.Name + "\\" + ssdi.Name))
                        {
                            //make folder access to shared
                        }
                    }
                    else
                    {
                        retVal.Append("<folder name='" + ssdi.Name + "' >");
                    }
                    retVal.Append("</folder>");
                }
                retVal.Append("</items></result>");
            }
            return retVal.ToString();
        }

        public bool checkSharedFolder(string userid, string path)        
        {
            createDatabase();

            DbParameter[] parameter = { _db.getDbParameter("?userid", userid), _db.getDbParameter("?path", path) };
            string sql = _db.sanitize("select userid from sharedFolders userid = ?userid and path = ?path;");
            object retVal = _db.ExecuteScalar(sql, parameter);
            if (retVal != null && retVal.ToString() != "")            
            {
                return true;
            }
            return false;
        }

        public void GetNestedFolder(string filepath, StringBuilder retVal, string userid)
        {
            DirectoryInfo di = new DirectoryInfo(filepath);
            DirectoryInfo[] sdi = di.GetDirectories();
            foreach (DirectoryInfo ssdi in sdi)
            {
                if (ssdi.Name == "Shared Folder")
                {
                    retVal.Append("<folder name='" + ssdi.Name + "' access='Shared'>");
                    if (checkSharedFolder(userid, di.Name + "\\" + ssdi.Name))
                    {
                        //make folder access to shared
                    }
                }
                else
                    retVal.Append("<folder name='" + ssdi.Name + "' >");
                GetNestedFolder(ssdi.FullName, retVal, userid);
                retVal.Append("</folder>");
            }
            GetFilesForFolder(filepath, retVal);
        }

        public void GetFilesForFolder(string filepath, StringBuilder retVal)
        {
            DirectoryInfo di = new DirectoryInfo(filepath);
            FileInfo[] fi = di.GetFiles();
            foreach (FileInfo ffi in fi)
            {
                retVal.Append("<file name='" + ffi.Name + "' mime='" + getMime(ffi.Extension) + "' size='" + ffi.Length + "' />");
            }
        }

        public string getMime(string extension)
        {
            return extension;
        }

        public string getAllSharedResource(string userid, string ticket, string otheruser, string folder)
        {
            if (!validateUserTicket(userid, ticket))
                return "";

            StringBuilder retVal = new StringBuilder();          
            
            retVal.Append("<result><items>");

            string filepath = _filePath + otheruser + @"\Shared Folder";

            if (!Directory.Exists(filepath))
            {
                retVal.Append("</items></result>");
                return retVal.ToString();
            }

            filepath = filepath + folder;

            if (!Directory.Exists(filepath))
            {
                retVal.Append("</items></result>");
                return retVal.ToString();
            }

            DirectoryInfo di = new DirectoryInfo(filepath);
            DirectoryInfo[] sdi = di.GetDirectories();
            foreach (DirectoryInfo ssdi in sdi)
            {
                retVal.Append("<folder name='" + ssdi.Name + "' >");
                GetNestedFolder(ssdi.FullName, retVal, userid);
                //GetFilesForFolder(ssdi.FullName, retVal);
                retVal.Append("</folder>");
            }
            GetFilesForFolder(filepath, retVal);
            retVal.Append("</items></result>");
            return retVal.ToString();
        }




        public string createFolder(string userid, string ticket, string folderName, string folderPath)
        {
            if (!validateUserTicket(userid, ticket))
                return "";

            try
            {
                string filepath = _filePath + userid + @"\";

                if (!Directory.Exists(filepath))
                    Directory.CreateDirectory(filepath);

                filepath = filepath + folderName + "\\" + folderPath;

                if (!Directory.Exists(filepath))
                {
                    if (folderName.ToLower() != "trash")
                    {
                        Directory.CreateDirectory(filepath);
                        return "true";
                    }
                }
            }
            catch (Exception ex)
            {
            }
            return "false";
            }

        public string deleteFolder(string userid, string ticket, string folderName)
        {
            if (!validateUserTicket(userid, ticket))
                return "";

            try
            {
                string trashFilePath = _filePath + userid + @"\Trash";
                string filepath = _filePath + userid + @"\";

                if (!Directory.Exists(filepath))
                    Directory.CreateDirectory(filepath);

                filepath = filepath + folderName;

                if (Directory.Exists(filepath))
                {
                    Directory.Move(filepath, trashFilePath);
                    return "true";
                }
            }
            catch (Exception ex)
            {
            }
            return "false";
        }

        public string deleteFile(string userid, string ticket, string filepath)
        {
            if (!validateUserTicket(userid, ticket))
                return "";

            try
            {
                string trashFilePath = _filePath + userid + @"\Trash";
                string filepaths = _filePath + userid + @"\";

                if (!Directory.Exists(filepaths))
                    Directory.CreateDirectory(filepaths);

                filepaths = filepaths + filepath;

                if (File.Exists(filepaths))
                {
                    File.Move(filepaths, trashFilePath);
                    return "true";
                }
            }
            catch (Exception ex)
            {
            }
            return "false";
        }

        public string emptyTrash(string userid, string ticket)
        {
            if (!validateUserTicket(userid, ticket))
                return "";
            string filepaths = _filePath + userid + @"\Trash";

            if (Directory.Exists(filepaths))
            {
                Directory.Delete(filepaths, true);
                Directory.CreateDirectory(filepaths);
                return "true";
            }
            return "false";
        }

        public string shareResource(string userid, string ticket, string filePath, string otherusers)
        {
            if (!validateUserTicket(userid, ticket))
            {
                createDatabase();
                
				string sql = "";
				DbParameter[] param = { _db.getDbParameter("?userid", userid), 
										  _db.getDbParameter("?filePath", filePath)};   
				
				sql = "insert into sharedfolders(userid, path) values (?userid, ?filePath);";
				
				int retVal = _db.ExecuteNonQuery(sql, param);

				if (retVal > 0)
				{
					return "<result>true</result>";
				}				
            }
            return "<result>false</result>";  
        }
        
    
        public string markPrivate(string userid, string ticket, string reflectionid)
        {
            if (!validateUserTicket(userid, ticket))
               {
                createDatabase();
                
				string sql = "";
				DbParameter[] param = { _db.getDbParameter("?userid", userid), 
										  _db.getDbParameter("?reflectionid", reflectionid)};   
				
				sql = "Update reflection set access ='Private' where userid=?userid and reflectionid= ?reflectionid;";
				
				int retVal = _db.ExecuteNonQuery(sql, param);

				if (retVal > 0)
				{
					return "<result>true</result>";
				}				
            }
            return "<result>false</result>";  
        }
      
        public string getReflectionsSummary(string userid, string ticket, string monthyear, bool isPublic)
        {
            if (!validateUserTicket(userid, ticket))
                return "";

            createDatabase();
            string sql="";
            if(isPublic==true)
            {
				sql = "select reflectionid, userid, title, date, access, data, isdeleted from reflection  " +
                         "where date = ?date and isdeleted = 0 and userid = ?userid and access!=''; ";
           }
           else
           {
			sql = "select reflectionid, userid, title, date, access, data, isdeleted from reflection  " +
                         "where date = ?date and isdeleted = 0 and userid = ?userid; ";
           }

            DbParameter[] param = { _db.getDbParameter("?date", monthyear), _db.getDbParameter("?userid", userid) };

            StringBuilder retVal = new StringBuilder();
            retVal.Append("<result><reflections>");
            using (IDataReader reader = _db.ExecuteReader(sql, param))
            {
                while (reader.Read())
                {
                    retVal.Append("<reflection>");

                    retVal.Append("<id>" + reader["reflectionid"] + "</id>");
                    retVal.Append("<title>" + reader["title"] + "</title>");
                    retVal.Append("<date>" + reader["date"] + "</date>");
                    retVal.Append("<access>" + reader["access"] + "</public>");
                    retVal.Append("<reflectiondata >" + reader["data"] + "</reflectiondata>");

                    retVal.Append("</reflection>");
                }
            }
            retVal.Append("</reflections></result>");

            return retVal.ToString();
        }

        /// <summary>
        /// Get Reflection correspoding to userid and reflectionid
        /// </summary>
        /// <param name="userid">UserId</param>
        /// <param name="reflectionid">ReflectionId</param>
        /// <returns>XML</returns>
        public string getReflection(string userid, string ticket, string reflectionid, string ispublic)
        {
            if (!validateUserTicket(userid, ticket))
                return "";

            createDatabase();
            string sql = "select reflectionid, userid, title, date, access, data, isdeleted from reflection  " +
                                         "where reflectionid = ?reflectionid and isdeleted = 0 and userid = ?userid;";
            if (ispublic.ToLower() == "true" || ispublic.ToLower() == "1")
            {
                sql = "select reflectionid, userid, title, date, access, data, isdeleted from reflection  " +
                                         "where isdeleted = 0 and userid = ?userid and (access is null or access != 'private'); ";
            }
            

            DbParameter[] param = { _db.getDbParameter("?reflectionid", reflectionid), _db.getDbParameter("?userid", userid) };

            StringBuilder retVal = new StringBuilder();
            retVal.Append("<result><reflections>");
            using (IDataReader reader = _db.ExecuteReader(sql, param))
            {
                while (reader.Read())
                {
                    retVal.Append("<reflection>");

                    retVal.Append("<id>" + reader["reflectionid"] + "</id>");
                    retVal.Append("<title>" + reader["title"] + "</title>");
                    retVal.Append("<date>" + Convert.ToString(reader["date"]) + "</date>");
                    retVal.Append("<access>" + reader["access"] + "</access>");
                    retVal.Append("<reflectiondata >" + reader["data"] + "</reflectiondata>");

                    retVal.Append("</reflection>");
                }
            }
            retVal.Append("</reflections></result>");

            return retVal.ToString();
        }

        /// <summary>
        /// Insert/Update Relection
        /// </summary>
        /// <param name="userid">UserId</param>
        /// <param name="id">ReflectionId</param>
        /// <param name="datetime">DateTime</param>
        /// <param name="title">Reflection Title</param>
        /// <param name="content">Reflection Data</param>
        /// <returns>XML</returns>
        public string saveReflection(string userid, string id, string datetime, string title, string content)
        {
            createDatabase();

            string sql = "";
            object dateTime = (datetime == null || datetime == "") ? Convert.ToString(DateTime.Now) : datetime;

            DbParameter[] param = { _db.getDbParameter("?userid", userid), 
                                      _db.getDbParameter("?id", id), 
                                      _db.getDbParameter("?datetime", dateTime),
                                      _db.getDbParameter("?title", title),
                                      _db.getDbParameter("?content", content)};

            if (id == "" || id == null || id == "0")
            {
                //insert
                sql = "insert into reflection(userid, title, date, data) values (?userid, ?datetime, ?title, ?content);";
            }
            else
            {
                //update
                sql = "update reflection set title = ?title, data = ?content, date = ?datetime, userid = ?userid " +
                       " where reflectionid = ?id ; ";
            }
            int retVal = _db.ExecuteNonQuery(sql, param);

            if (retVal > 0)
            {
                return "<result>true</result>";
            }
            return "<result>false</result>";
        }

        /// <summary>
        /// Delete Reflection
        /// </summary>
        /// <param name="userid">UserId</param>
        /// <param name="reflectionid">ReflectionId</param>
        /// <returns>XML</returns>
        public string deleteReflection(string userid, int reflectionid)
        {
            createDatabase();
            string sql = "update reflection set isdeleted = 1 where reflectionid = ?reflectionid ;";

            DbParameter[] param = { _db.getDbParameter("?reflectionid", reflectionid) };

            int retVal = _db.ExecuteNonQuery(sql, param);

            if (retVal > 0)
            {
                return "<result>true</result>";
            }
            return "<result>false</result>";
        }


        public string saveReflectionattachment(string userid, string filename, string reflectionid)
        {
            string sql = "insert into reflectionattachment(reflectionid, attachmentguid, attachmentname) " +
                           "values ( ?reflectionid, ?attachmentguid, ?attachmentname  ) ;" +
                           " select LAST_INSERT_ID(); ";
            createDatabase();
            Guid gu = Guid.NewGuid();

            DbParameter[] param = { _db.getDbParameter("?reflectionid", reflectionid), 
                                       _db.getDbParameter("?attachmentguid", gu.ToString()),
                                       _db.getDbParameter("?attachmentname", filename)};

            object retVal = _db.ExecuteScalar(sql, param);

            if (retVal != null)
            {
                return "<result>" + retVal + "</result>";
            }
            return "<result>0</result>";
        }

        public string deleteReflectionAttachment(string userid, string attachmentid)
        {
            string sql = "delete from reflectionattachment where relectionattachmentid = ?relectionattachmentid; ";
            createDatabase();
            DbParameter[] param = { _db.getDbParameter("?relectionattachmentid", attachmentid) };

            int retVal = _db.ExecuteNonQuery(sql, param);

            if (retVal > 0)
            {
                return "<result>true</result>";
            }
            return "<result>false</result>";
        }

        /// <summary>
        /// Get Reflection Comment and Attachments
        /// </summary>
        /// <param name="userid">UserId</param>
        /// <param name="reflectionid">ReflectionId</param>
        /// <returns>XML</returns>
        public string getReflectionComment(string userid, string reflectionid)
        {
            StringBuilder retVal = new StringBuilder();
            createDatabase();
            string sql = " select reflectioncommentid, reflectionid, userid, date, comment, 'UserName' username from  reflectioncomment " +
                           "where isdeleted = 0 and reflectionid = ?reflectionid and userid = ?userid ;";

            DbParameter[] param = { _db.getDbParameter("?reflectionid", reflectionid), _db.getDbParameter("?userid", userid) };

            DataSet ds = _db.ExecuteDataSet(sql, param, "");

            retVal.Append("<result>");
            retVal.Append("<comments>");
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                retVal.Append("<comment>");
                retVal.Append("<userid>" + row["userid"] + "</userid>");
                retVal.Append("<name>" + row["username"] + "</name>");
                retVal.Append("<comment>" + row["comment"] + "</comment>");
                GetReflectionAttachment(reflectionid, retVal, userid);
                retVal.Append("</comment>");
            }
            retVal.Append("</comments>");
            retVal.Append("</result>");

            return retVal.ToString();
        }

        public void GetReflectionAttachment(string reflectionid, StringBuilder retVal, string userid)
        {
            createDatabase();
            string sql = "select ra.relectionattachmentid, ra.attachmentname " +
                            "from reflectionattachment ra inner join reflection r on r.reflectionid = ra.reflectionid " +
                            "where ra.reflectionid = ?reflectionid and r.userid = ?userid; and r.isdeleted = 0 ";

            DbParameter[] param = { _db.getDbParameter("?reflectionid", reflectionid), _db.getDbParameter("?userid", userid) };

            DataSet ds = _db.ExecuteDataSet(sql, param, "");

            retVal.Append("<attachments>");
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                retVal.Append("<attachment>");
                retVal.Append("<attachmentid>" + row["relectionattachmentid"] + "</attachmentid>");
                retVal.Append("<attahcmentname>" + row["attachmentname"] + "</attachmentname>");
                retVal.Append("</attachment>");
            }
            retVal.Append("</attachments>");
        }

        /// <summary>
        /// Insert/Update Reflection Comment
        /// </summary>
        /// <param name="reflectionid">Reflection Id</param>
        /// <param name="reflectioncommentid">Reflection CommentId for Update</param>
        /// <param name="userid">UserId</param>
        /// <param name="content">Content</param>
        /// <returns>XML</returns>
        public string addReflectionComment(string reflectionid, string reflectioncommentid, string userid, string content)
        {
            createDatabase();
            string sql = "";

            DbParameter[] param = { _db.getDbParameter("?reflectionid", reflectionid), 
                                      _db.getDbParameter("?reflectioncommentid", reflectioncommentid),
                                      _db.getDbParameter("?userid", userid), 
                                      _db.getDbParameter("?date", Convert.ToString(DateTime.Now)),                                      
                                      _db.getDbParameter("?comment", content)};

            if (reflectioncommentid == "" || reflectioncommentid == null || reflectioncommentid == "0")
            {
                sql = "insert into reflectioncomment(reflectionid, userid, date, comment) " +
                         " values (?reflectionid, ?userid, ?date, ?comment);" +
                         "  select LAST_INSERT_ID(); ";
            }
            else
            {
                sql = "update reflectioncomment set reflectionid = ?reflectionid, userid = ?userid, date = ?date, comment = ?comment " +
                        " where reflectioncommentid = ?reflectioncommentid ;" +
                        " select ?reflectioncommentid as reflectioncommentid; ";
            }

            object retV = _db.ExecuteScalar(sql, param);

            if (retV != null)
            {
                return "<result>" + retV + "</result>";
            }
            return "<result>0</result>";
        }

        /// <summary>
        /// Delete Reflection Comments
        /// </summary>
        /// <param name="userid">UserId</param>
        /// <param name="commentid">Reflection Comment Id</param>
        /// <returns>XML</returns>
        public string deleteReflectionComment(string userid, string commentid)
        {
            createDatabase();
            string sql = "update reflectioncomment set isdeleted = 1 where reflectioncommentid = ?reflectioncommentid;";
            DbParameter[] param = { _db.getDbParameter("?reflectioncommentid", commentid) };

            int retVal = _db.ExecuteNonQuery(sql, param);

            if (retVal > 0)
            {
                return "<result>true</result>";
            }
            return "<result>false</result>";
        }

        /// <summary>
        /// Insert ReflectionCommentAttachment
        /// </summary>
        /// <param name="userid">UserId</param>
        /// <param name="filename">FileName</param>
        /// <param name="commentid">ReflectionCommentId</param>
        /// <returns>XML</returns>
        public string saveReflectionCommentAttachment(string userid, string filename, string commentid)
        {
            createDatabase();
            Guid gu = Guid.NewGuid();
            DbParameter[] param = { _db.getDbParameter("?reflectioncommentid", commentid),
                                       _db.getDbParameter("?attachmentguid", gu.ToString()),
                                        _db.getDbParameter("?attachmentname", filename)
                                  };

            string sql = "insert into reflectioncommentattachment(reflectioncommentid, attachmentguid, attachmentname) " +
                          " values(?reflectioncommentid, ?attachmentguid, ?attachmentname)";

            int retVal = _db.ExecuteNonQuery(sql, param);

            if (retVal > 0)
            {
                return "<result>true</result>";
            }
            return "<result>false</result>";
        }
        
        public string logout(string userid)
        {
			 createDatabase();
                
				string sql = "";
				DbParameter[] param = { _db.getDbParameter("?userid", userid)};   
				
				sql = "Update user set ticket ='' where userid=?userid;";
				
				int retVal = _db.ExecuteNonQuery(sql, param);

				if (retVal > 0)
				{
					return "<result>true</result>";
				}		
            return "<result>false</result>";
        }
    }
}
