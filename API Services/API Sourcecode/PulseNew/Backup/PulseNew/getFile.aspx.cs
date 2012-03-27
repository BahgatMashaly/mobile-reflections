using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using Jive.BusinessRules;

public partial class getFile : System.Web.UI.Page
{
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

            String fullpath = gd.getFielPath() + userid + @"\" + Request.QueryString["fullpathtofile"];
            
            if (File.Exists(fullpath))
            {
                Response.Clear();
                System.IO.FileInfo fileToDownload = new System.IO.FileInfo(fullpath);
                string disHeader = "Attachment; Filename=\"" + fileToDownload.Name + "\"";
                Response.AppendHeader("Content-Disposition", disHeader);
                Response.Flush();
                Response.WriteFile(fileToDownload.FullName);
            }
        }

}