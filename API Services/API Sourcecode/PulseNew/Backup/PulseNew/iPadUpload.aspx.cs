using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class iPadUpload : System.Web.UI.Page
{
    string nfilename;

    protected void Page_Load(object sender, EventArgs e)
    {
		nfilename = "abc.gif";
		string ext = "gif";
		
	    try {
			nfilename = Request.QueryString["filename"];
            ////nfilename = nfilename.Replace("../", "");
            ////nfilename = nfilename.Replace("./", "");
            ////nfilename = nfilename.Replace("/", "");
            ////nfilename = nfilename.Replace("@", "");

            if (!ValidateFile())
                return;

            string[] split = nfilename.Split('.');
			ext = split[1];
			bool gotfile = false;

            if (ext.ToLower().Trim() == "gif" || ext.ToLower().Trim() == "jpeg" || ext.ToLower().Trim() == "jpg" || ext.ToLower().Trim() == "png")
            {
                foreach (string f in Request.Files.AllKeys)
                {
                    gotfile = true;
                    DirectoryInfo di = new DirectoryInfo(@Server.MapPath("resource"));
                    HttpPostedFile file = Request.Files[f];
                    if (file.FileName != "")
                    {
                        if (di.Exists)
                        {
                            ////string url = "http://10.0.0.100/pulse/resource/";
                            string url = "";
                            Guid guid = Guid.NewGuid();

                            string FileNamed = file.FileName;
                            // file.SaveAs(Server.MapPath("resource") + "\\" + guid.ToString() + "." + ext);
                            // Response.Write(url + guid.ToString() + "." + ext);
                            file.SaveAs(Server.MapPath("resource") + "\\" + guid.ToString() + "_" + nfilename);
                            Response.Write(url + guid.ToString() + "_" + nfilename);
                        }
                    }
                }
            }
            else
                return;
			if (!gotfile) {
						Response.Write("No file supplied. Extension is ." + ext);
			}
		} catch (Exception ex) {
						Response.Write(ex.ToString());
		}
    }

    private bool ValidateFile()
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
}