package org.asclub.utils
{
	import org.asclub.net.JSFL;
	import org.asclub.string.StringUtil;
	
	public class FileUtil
	{
		
		public function FileUtil()
		{
			
		}
		
		public static function getMacHD() : String
        {
            return unescape(JSFL.exec("fl.configURI").replace("file:///", "").split("/").shift());
        }
		
		public static function dropFileName(param1:String):String
        {
            if (JSFL.isDirectory(param1))
            {
                return param1;
            }
            return StringUtil.beforeLast(param1, "/") + "/";
        }
		
	}//end of class
}