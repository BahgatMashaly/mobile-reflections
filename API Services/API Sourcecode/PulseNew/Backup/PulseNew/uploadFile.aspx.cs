using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using Jive.BusinessRules;

public partial class uploadFile : System.Web.UI.Page
{
        string nfilename = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            String userid = Request.QueryString["userid"];
            String ticket = Request.QueryString["ticket"];

            if (userid == null || ticket == null)
            {
                Response.Write("");
                return;
            }

            GetData gd = new GetData();

            if (!(gd.validateUserTicket(userid, ticket)))
            {
                Response.Write("");
                return;
            }

            FileInfo fInfo = new FileInfo(fileUpload.PostedFile.FileName);
            nfilename = fInfo.Name;
            if (!isValidFile(nfilename, fInfo.Extension))
            {
                Response.Write("");
                return;
            }

            // Check quota here before upload

            foreach (string f in Request.Files.AllKeys)
            {
                HttpPostedFile file = Request.Files[f];
                if (file.FileName != "")
                {
                    String fullpath = gd.getFielPath() + userid + @"\" + Request.QueryString["fullpathtofile"];
                    string dirName = fullpath.Substring(0, fullpath.LastIndexOf("\\") + 1);
                    if (!Directory.Exists(dirName))
                        Directory.CreateDirectory(dirName);
                    if (Directory.Exists(dirName))
                    {
                        file.SaveAs(fullpath);
                        Response.Write(Request.QueryString["fullpathtofile"]);
                    }
                }
            }
        }        

        protected void btn_Click(object sender, EventArgs e)
        {
    /*
            String userid = "victor";
            String ticket = "1";

            GetData gd = new GetData();

            if (!(gd.validateUserTicket(userid, ticket)))
            {
                return;
            }

            FileInfo fInfo = new FileInfo(fileUpload.PostedFile.FileName);
            nfilename = fInfo.Name;
            if (!isValidFile(nfilename, fInfo.Extension))
            {
                return;
            }

            foreach (string f in Request.Files.AllKeys)
            {
                HttpPostedFile file = Request.Files[f];
                if (file.FileName != "")
                {
                    String fullpath = gd.getFielPath() + userid + @"\" + "temp.ppt";
                    string dirName = fullpath.Substring(0, fullpath.LastIndexOf("\\") + 1); 
                    if (Directory.Exists(dirName))
                    {
                        file.SaveAs(fullpath);
                    }
                }
            }
     * */
        }

        private bool isValidFile(string filename, string ext)
        {
            if (ext.ToLower().Trim() == ".gif" || ext.ToLower().Trim() == ".jpeg" || ext.ToLower().Trim() == ".jpg" ||
                ext.ToLower().Trim() == ".png" || ext.ToLower().Trim() == ".doc" || ext.ToLower().Trim() == ".docx" ||
                ext.ToLower().Trim() == ".xls" || ext.ToLower().Trim() == ".xlsx" || ext.ToLower().Trim() == ".ppt" ||
                ext.ToLower().Trim() == ".pptx" || ext.ToLower().Trim() == ".pdf" || ext.ToLower().Trim() == ".htm" ||
                ext.ToLower().Trim() == ".txt" || ext.ToLower().Trim() == ".html")
            {
                if (nfilename.Contains("`") || nfilename.Contains("~") || nfilename.Contains("!") || nfilename.Contains("@") || nfilename.Contains("#") ||
                    nfilename.Contains("$") || nfilename.Contains("%") || nfilename.Contains("^") || nfilename.Contains("&") || nfilename.Contains("*") ||
                    nfilename.Contains("(") || nfilename.Contains(")") || nfilename.Contains("=") || nfilename.Contains("+") || nfilename.Contains("[") ||
                    nfilename.Contains("{") || nfilename.Contains("}") || nfilename.Contains("]") || nfilename.Contains("|") || nfilename.Contains(";") ||
                    nfilename.Contains(":") || nfilename.Contains("'") || nfilename.Contains("<") || nfilename.Contains(",") || nfilename.Contains(">") ||
                    nfilename.Contains("?") || nfilename.Contains("/") || nfilename.Contains("//") || nfilename.Contains("./") || nfilename.Contains("../") ||
                    nfilename.Contains(".//") || nfilename.Contains("..//") || nfilename.Contains(@"\"))
                    
                    return false;
                return true;
            }
            return false;
        }


}