using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using Jive.BusinessRules;
using System.Data;


/// <summary>
/// Summary description for FileService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class FileService : System.Web.Services.WebService {

        [WebMethod]
        public string TestService()
        {
            return new GetData().TestConnection();
        }

        [WebMethod]
        public string validateUser(string username, string password)
        {
            return new GetData().validateUser(username, password);
        }

        [WebMethod]
        public string getUserInfo(string userid, string ticket)
        {
            return new GetData().getUserInfo(userid, ticket);
        }

        [WebMethod]
        public string markPrivate(string userid, string ticket, string reflectionid)
        {
            return new GetData().markPrivate(userid, ticket, reflectionid);
        }

        [WebMethod]
        public string getAllFolders(string userid, string ticket, string foldername, string returntype)
        {
            return new GetData().getAllFolders(userid, ticket, foldername, returntype);
        }

    /*
        [WebMethod]
        public string getFolders(string userid, string ticket, string foldername, string returntype)
        {
            return new GetData().getFolders(userid, ticket, foldername, returntype);
        }

        [WebMethod]
        public DataSet getFile(string userid, string ticket, string fullpath)
        {
            return new GetData().getFile(userid, ticket, fullpath);
        }

        [WebMethod]
        public bool uploadFile(string userId, string ticket, string fullpath)
        {
            return new GetData().uploadFile(userId, ticket, fullpath);
        }
     * */

        [WebMethod]
        public string deleteFile(string userId, string ticket, string filepath)
        {
            return new GetData().deleteFile(userId, ticket, filepath);
        }

        [WebMethod]
        public string shareResource(string userid, string ticket, string filePath, string otherusers)
        {
            return new GetData().shareResource(userid, ticket, filePath, otherusers);
        }

        [WebMethod]
        public string getAllSharedResource(string userid, string ticket, string otheruser, string folder)
        {
            return new GetData().getAllSharedResource(userid, ticket, otheruser, folder);
        }

    /*
        [WebMethod]
        public string getSharedResource(string userid, string ticket, string otheruser, string folder)
        {
            return new GetData().getSharedResource(userid, ticket, otheruser, folder);
        }
     * */

        [WebMethod]
        public string getReflectionsSummary(string userid, string ticket, string monthyear, bool isPublic)
        {
            return new GetData().getReflectionsSummary(userid, ticket, monthyear, isPublic);
        }

        [WebMethod]
        public string getReflection(string userid, string ticket, string reflectionid, string ispublic)
        {
            return new GetData().getReflection(userid, ticket, reflectionid, ispublic);
        }

        [WebMethod]
        public string saveReflection(string userid, string id, string datetime, string title, string content)
        {
            return new GetData().saveReflection(userid, id, datetime, title, content);
        }

        [WebMethod]
        public string deleteReflection(string userid, int reflectionid)
        {
            return new GetData().deleteReflection(userid, reflectionid);
        }

        [WebMethod]
        public string saveReflectionattachment(string userid, string filename, string reflectionid)
        {
            return new GetData().saveReflectionattachment(userid, filename, reflectionid);
        }

        [WebMethod]
        public string getReflectionComment(string userid, string reflectionid)
        {
            return new GetData().getReflectionComment(userid, reflectionid);
        }

        [WebMethod]
        public string addReflectionComment(string reflectionid, string reflectioncommentid, string userid, string content)
        {
            return new GetData().addReflectionComment(reflectionid, reflectioncommentid, userid, content);
        }

        [WebMethod]
        public string deleteReflectionComment(string userid, string commentid)
        {
            return new GetData().deleteReflectionComment(userid, commentid);
        }

        [WebMethod]
        public string saveReflectionCommentAttachment(string userid, string filename, string commentid)
        {
            return new GetData().saveReflectionCommentAttachment(userid, filename, commentid);
        }

        [WebMethod]
        public string deleteReflectionAttachment(string userid, string attachmentid)
        {
            return new GetData().deleteReflectionAttachment(userid, attachmentid);
        }
        [WebMethod]
        public string emptyTrash(string userid, string ticket)
        {
            return new GetData().deleteReflectionAttachment(userid, ticket);
        }

        [WebMethod]
        public string createFolder(string userid, string ticket, string folderName, string folderPath)
        {
            return new GetData().createFolder(userid, ticket, folderName, folderPath);
        }

        [WebMethod]
        public string logout(string userid)
        {
            return new GetData().logout(userid);
        }
}

