using System;
using System.Collections.Generic;
using System.Web;

namespace Jive.BusinessRules
{
    /// <summary>
    /// Summary description for LogManager
    /// </summary>
    public class LogManager
    {
        // Event Logger
        private static System.Diagnostics.EventLog _glogger = null;

        // The types of log
        public static readonly String STATUS = "Status";
        public static readonly String INFO = "Info";
        public static readonly String WARN = "Warning";
        public static readonly String DEBUG = "Debug";
        public static readonly String MAILDEBUG = "Mail";
        public static readonly String ERR = "Error";
        public static readonly String DISPLAY = "Display";

        // total error count
        public static int errorcount = 0;

        // Set the logegr
        public static void setLogger(System.Diagnostics.EventLog logger)
        {
            _glogger = logger;
        }

        // Creates a log entry
        public static void log(String messagetype, String function, String message)
        {
        }

        // Does a log to the event viewer
        public static void globallog(String messagetype, String function, String message)
        {
            if (_glogger != null)
            {
                _glogger.WriteEntry(messagetype + ":" + function + " - " + message);
            }
        }
    }
}