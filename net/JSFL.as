/**
 * 用于实现 JavaScript 可扩展性 (JSAPI) 的 Adobe 工具产品中交互
 */
package org.asclub.net
{
	import flash.system.Capabilities;
	
	import adobe.utils.MMExecute;
	
	import org.asclub.string.StringUtil;
	import org.asclub.system.OSVersion;
	import org.asclub.utils.FileUtil;
	
	public class JSFL
	{
		public static var jsflPath:String = "Project/Project.jsfl";
		
		public function JSFL()
		{
			
		}
		
		/**
		 * 在输出面板中显示输出内容
		 * @param	msg   要输入的内容
		 */
		public static function traces(msg:*):void
		{
			var command:String = "fl.trace('" + msg.toString() + "');";
			MMExecute(command);
		}
		
		public static function runFunction(param1:String, ... args) : String
        {
            var _loc_6:String;
            if (!jsflPath && JSFL.isExternal())
            {
                print("runFunction " + jsflPath);
                throw new Error("jsflPath property must be set: " + jsflPath);
            }// end if
            var _loc_3:Array;
            var _loc_4:* = args.length;
            var _loc_5:uint;
            while (_loc_5++ < _loc_4)
            {
                if (args[_loc_5] == undefined)
                {
                    args[_loc_5] = "";
                }
                _loc_3.push("\'" + args[_loc_5].replace("\'", "\'") + "\'");
            }// end while
            if (_loc_3.length == 0)
            {
                _loc_6 = "fl.runScript(fl.configURI + \'" + jsflPath + "\', \'" + param1 + "\');";
            }
            else
            {
                _loc_6 = "fl.runScript(fl.configURI + \'" + jsflPath + "\', \'" + param1 + "\', " + _loc_3.join(",") + ");";
            }// end else if
            return exec(_loc_6);
        }// end function

        public static function remove(param1:String) : Boolean
        {
            if (!fileExists(param1))
            {
                return false;
            }// end if
            var _loc_2:* = getFileAttributes(param1);
            if (StringUtil.contains(_loc_2, "H") > 0 || StringUtil.contains(_loc_2, "R") > 0)
            {
                setFileAttributes(param1, "WV");
            }// end if
            return exec("FLfile.remove(\"" + param1 + "\")") == "1";
        }// end function

        public static function openDocument(param1:String) : Boolean
        {
            if (!fileExists(param1))
            {
                return false;
            }// end if
            exec("fl.openDocument(\'" + param1 + "\');");
            return true;
        }// end function

        public static function getClassPath(param1:String, param2:String) : String
        {
            return runFunction("findClassesDirectory", param1, param2);
        }// end function

        public static function createFolder(param1:String) : Boolean
        {
            return exec("FLfile.createFolder(\"" + param1 + "\")") == "true";
        }// end function

        public static function set flexSDKPath(param1:String) : void
        {
            exec("fl.flexSDKPath=\"" + formatURIForPaths(param1) + "\"");
            return;
        }// end function

        public static function getAsVersion() : uint
        {
            var _loc_1:* = exec("fl.getDocumentDOM().asVersion");
            return parseInt(_loc_1) == 3 ? (0) : (1);
        }// end function

		/**
		 * 在给定的字符串 command 中执行
		 * @param	command   要执行的命令
		 * @return
		 */
        public static function exec(command:String) : String
        {
            if (!isExternal())
            {
                return "";
            }
            return MMExecute(command);
        }

        public static function get sourcePaths() : Array
        {
            var _loc_1:* = exec("fl.sourcePath");
            if (_loc_1 == null || _loc_1 == "null")
            {
                return null;
            }// end if
            return _loc_1.split(";");
        }// end function

		/**
		 * 是否是用于外部的 Flash Player 或处于测试模式下
		 * @return  Boolean
		 */
        public static function isExternal() : Boolean
        {
            return Capabilities.playerType == "External";
        }// end function

        public static function createFile(param1:String) : Boolean
        {
            return exec("FLfile.createFile(\"" + param1 + "\")") == "true";
        }// end function

        public static function saveFile(param1:String, param2:String) : Boolean
        {
            var _loc_3:* = fileExists(param1) ? (getFileAttributes(param1)) : ("");
            var _loc_4:Boolean;
            if (StringUtil.contains(_loc_3, "H") > 0 || StringUtil.contains(_loc_3, "R") > 0)
            {
                setFileAttributes(param1, "WV");
                _loc_4 = true;
            }// end if
            var _loc_5:* = runFunction("createFile", unescape(param1), escape(param2)) == "true";
            if (_loc_4)
            {
                setFileAttributes(param1, _loc_3);
            }// end if
            return _loc_5;
        }// end function

        public static function openFileWithDefaultApp(param1:String) : void
        {
            var _loc_2:String;
            var _loc_3:String;
            if (OSVersion.isWindows)
            {
                _loc_3 = uriToPath(param1).replace(/\|/ig, ":");
				var charIndex:int = _loc_3.indexOf(":");
                _loc_3 = _loc_3.substr(charIndex--, _loc_3.length);
                _loc_2 = "FLfile.runCommandLine(\'start \"Open With Default Application\" \"" + _loc_3 + "\" /B\')";
            }
            else
            {
                _loc_2 = "FLfile.runCommandLine(\'open \"" + uriToPath(param1) + "\"\')";
            }// end else if
            exec(_loc_2);
            return;
        }// end function

		/**
		 * 导入swf
		 * @param	param1
		 * @return
		 */
        public static function importSWF(param1:String) : Boolean
        {
            if (!fileExists(param1))
            {
                return false;
            }// end if
            runFunction("importSWF", param1);
            return true;
        }// end function

        public static function emptyDirectory(param1:String) : Boolean
        {
            return parseInt(runFunction("emptyDirectory", param1)) == 0;
        }// end function

        public static function set sourcePaths(param1:Array) : void
        {
            var _loc_2:* = formatURIForPaths(param1.join(";"));
            var _loc_3:* = exec("fl.sourcePath=\"" + _loc_2 + "\"");
            return;
        }// end function

        //static function formatLocaleStrings(... args) : String
        //{
            //var _loc_4:String;
            //var _loc_2:* = ModelLocator.getInstance().strings;
            //var _loc_3:* = <locale/>;
            //while (args.length)
            //{
                // label
                //_loc_4 = args.pop() as String;
                //_loc_3[_loc_4] = _loc_2[_loc_4];
            //}// end while
            //return escape(_loc_3.toXMLString());
        //}// end function

        public static function browseForFolder(param1:String) : String
        {
            var _loc_2:* = param1.replace("\'", "\\\'");
            return exec("fl.browseForFolderURL(\'" + _loc_2 + "\')");
        }// end function

        public static function clearOutput() : void
        {
            exec("fl.outputPanel.clear();");
            return;
        }// end function

        public static function readFile(param1:String) : String
        {
            return exec("FLfile.read(\"" + param1 + "\")");
        }// end function

        public static function print(param1:Object) : void
        {
            runFunction("trace", escape(param1.toString()));
            return;
        }// end function

        public static function openScript(param1:String) : Boolean
        {
            if (!fileExists(param1))
            {
                return false;
            }// end if
            exec("fl.openScript(\'" + param1 + "\');");
            return true;
        }// end function

        public static function runScript(param1:String) : Boolean
        {
            if (!fileExists(param1))
            {
                return false;
            }// end if
            exec("fl.runScript(\'" + param1 + "\');");
            return true;
        }// end function

        //public static function getDirectory(param1:String, param2:FilterCollection, param3:FilterCollection, param4:XML) : String
        //{
            //return runFunction("getDirectory", param1, escape(param2.toXML().toXMLString()), escape(param3.toXML().toXMLString()), param4.toXMLString());
        //}// end function

        public static function escapePathParts(param1:String):String
        {
            var _loc_2:* = param1.split("/");
            var _loc_3:int;
            while (_loc_3 < _loc_2.length)
            {
                // label
                _loc_2[_loc_3] = escape(_loc_2[_loc_3]);
                _loc_3++;
            }// end while
            return _loc_2.join("/");
        }// end function

        public static function set externalLibraryPaths(param1:Array) : void
        {
            var _loc_2:* = exec("fl.externalLibraryPath=\"" + formatURIForPaths(param1.join(";")) + "\"");
            return;
        }// end function

        //public static function exportSWF(param1:String) : Boolean
        //{
            //if (!fileExists(param1))
            //{
                //return false;
            //}// end if
            //runFunction("exportSWF", param1, formatLocaleStrings("CM_EXPORT_SWF"));
            //return true;
        //}// end function

        public static function testMovie(param1:String) : Boolean
        {
            if (!fileExists(param1))
            {
                return false;
            }// end if
            runFunction("testMovie", param1);
            return true;
        }// end function

        public static function createFLA(param1:String, param2:Boolean, param3:int) : Boolean
        {
            return runFunction("createFLA", param1, param2.toString(), String(param3)) == "true";
        }// end function

        public static function formatURIForPaths(param1:String) : String
        {
            var _loc_2:* = param1;
            if (OSVersion.isWindows)
            {
                _loc_2 = _loc_2.split("\\").join("\\\\");
            }// end if
            return _loc_2;
        }// end function

        public static function get flexSDKPath() : String
        {
            return exec("fl.flexSDKPath");
        }// end function

        public static function command(param1:String) : void
        {
            exec("FLfile.runCommandLine(\'" + param1 + "\');");
            return;
        }// end function

        //public static function getFileProperties(param1:String) : Object
        //{
            //if (!fileExists(param1))
            //{
                //return {};
            //}// end if
            //var _loc_2:* = new XML(runFunction("fileProperties", param1, formatLocaleStrings("LBL_FILES")));
            //return {size:_loc_2.@size, created:_loc_2.@created, modified:_loc_2.@modified, attr:_loc_2.@attr};
        //}// end function

        public static function getGlobalClassPaths(param1:uint) : Array
        {
            var _loc_2:Array;
            switch(param1)
            {
                case 0:
                {
                    _loc_2 = exec("fl.as3PackagePaths").split(";");
                    break;
                }// end case
                case 1:
                {
                    _loc_2 = exec("fl.packagePaths").split(";");
                    break;
                }// end case
                default:
                {
                    break;
                }// end default
            }// end switch
            return _loc_2;
        }// end function

        public static function pathToURI(param1:String) : String
        {
            if (param1 == "undefined")
            {
                return param1;
            }// end if
            var _loc_2:String;
            if (OSVersion.isWindows)
            {
                _loc_2 = param1.replace("\\", "/").replace(":", "|");
            }
            else if (OSVersion.isMac)
            {
                _loc_2 = FileUtil.getMacHD() + param1;
            }
            else
            {
                _loc_2 = param1;
            }// end else if
            if (_loc_2.indexOf("file://") == -1)
            {
                _loc_2 = "file:///" + (_loc_2.indexOf("/") == 0 ? (_loc_2.slice(1)) : (_loc_2));
            }// end if
            return _loc_2;
        }// end function

        public static function openFolder(param1:String) : void
        {
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:String;
            param1 = FileUtil.dropFileName(param1);
            if (OSVersion.isWindows)
            {
                _loc_3 = "explorer " + param1.replace(/\|/ig, ":");
                _loc_2 = "FLfile.runCommandLine(\"" + _loc_3 + "\")";
            }
            else
            {
                _loc_4 = uriToPath(param1);
                _loc_2 = "FLfile.runCommandLine(\'open \"" + _loc_4 + "\"\')";
            }// end else if
            exec(_loc_2);
            return;
        }// end function

        public static function setGlobalClassPaths(param1:uint, param2:Array) : void
        {
            var _loc_3:* = param2.join(";");
            switch(param1)
            {
                case 0:
                {
                    exec("fl.as3PackagePaths=\"" + _loc_3 + "\"");
                    break;
                }// end case
                case 1:
                {
                    exec("fl.packagePaths=\"" + _loc_3 + "\"");
                    break;
                }// end case
                default:
                {
                    break;
                }// end default
            }// end switch
            return;
        }// end function

        public static function createClass(param1:String, param2:String, param3:XML, param4:XML):*
        {
            return runFunction("createClass", param1, param2, param3.toXMLString(), param4.toXMLString());
        }// end function

        public static function get externalLibraryPaths() : Array
        {
            var _loc_1:* = exec("fl.externalLibraryPath");
            if (_loc_1 == null || _loc_1 == "null")
            {
                return null;
            }// end if
            return _loc_1.split(";");
        }// end function

        public static function publishMovie(param1:String, param2:Boolean = false) : Boolean
        {
            if (!fileExists(param1))
            {
                return false;
            }// end if
            runFunction("publishMovie", param1);
            if (param2)
            {
                JSFL.exec("fl.getDocumentDOM().close()");
            }// end if
            return true;
        }// end function

        public static function isDirectory(param1:String) : Boolean
        {
            return exec("FLfile.getAttributes(\"" + param1 + "\");").indexOf("D") != -1;
        }// end function

        public static function prompt(param1:String, param2:String = null) : String
        {
            var _loc_3:* = exec("prompt(\'" + param1 + "\', \'" + (param2 != null ? (param2) : ("")) + "\');");
            return _loc_3 == "null" ? (null) : (_loc_3);
        }// end function

        public static function set libraryPaths(param1:Array) : void
        {
            var _loc_2:* = exec("fl.libraryPath=\"" + formatURIForPaths(param1.join(";")) + "\"");
            return;
        }// end function

        public static function getFileAttributes(param1:String) : String
        {
            return exec("FLfile.getAttributes(\"" + param1 + "\")");
        }// end function

		/**
		 * 指定要在“警告”对话框中显示的消息
		 * @param	msg  一个字符串，
		 */
        public static function alert(msg:String) : void
        {
            exec("alert(\'" + msg + "\');");
            return;
        }// end function

        public static function docIsOpen() : Boolean
        {
            return exec("fl.getDocumentDOM();") != "null";
        }// end function

        public static function uriToPath(param1:String):String
        {
            var _loc_3:Array;
            if (param1 == "undefined")
            {
                return param1;
            }// end if
            var _loc_2:* = OSVersion.isWindows ? (param1.replace("\\", "/")) : (param1);
            if (_loc_2.indexOf("file://") == 0)
            {
                _loc_2 = _loc_2.split("file://").join("/");
            }// end if
            if (!OSVersion.isWindows)
            {
                _loc_3 = _loc_2.split("/");
                if (_loc_2.indexOf(FileUtil.getMacHD()) == -1)
                {
                    _loc_2 = "/Volumes/" + _loc_3.slice(2, _loc_3.length).join("/");
                }
                else
                {
                    _loc_2 = "/" + _loc_3.slice(3, _loc_3.length).join("/");
                }// end if
            }// end else if
            return unescape(_loc_2);
        }// end function

        public static function openProject(param1:String) : Boolean
        {
            if (!fileExists(param1))
            {
                return false;
            }// end if
            exec("fl.openProject(\'" + param1 + "\');");
            return true;
        }// end function

        public static function get libraryPaths() : Array
        {
            var _loc_1:* = exec("fl.libraryPath");
            if (_loc_1 == null || _loc_1 == "null")
            {
                return null;
            }// end if
            return _loc_1.split(";");
        }// end function

        public static function setFileAttributes(param1:String, param2:String) : Boolean
        {
            return exec("FLfile.setAttributes(\"" + param1 + "\", \"" + param2 + "\")") == "true";
        }// end function

		/**
		 * 文件是否存在
		 * @param	param1
		 * @return
		 */
        public static function fileExists(param1:String) : Boolean
        {
            param1 = StringUtil.endsWith(param1, "/") ? (StringUtil.beforeLast(param1, "/")) : (param1);
            return exec("FLfile.exists(\'" + param1 + "\');") == "true";
        }// end function

        public static function browseForFile(param1:String, param2:String, param3:String) : String
        {
            return runFunction("browseForFile", param1, param2, param3);
        }// end function

        public static function getActiveDocumentPath() : String
        {
            if (exec("fl.getDocumentDOM()") == "null")
            {
                return null;
            }// end if
            return pathToURI(exec("fl.getDocumentDOM().path"));
        }// end function
	}//end of class
}