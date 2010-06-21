package org.asclub.utils 
{
	import org.asclub.string.StringUtil;
	public class RegExpUtil
	{
		
		
		/**
		 * 是否IP地址
		 * @param	char         IP地址
		 * @return  Booblean    
		 */
		public static function isIPNum(char:String):Boolean
		{
			if (char == null)
			{
				return false;
			}
			char = StringUtil.trim(char);
			var testTelReg:RegExp = /((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d)(\.((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d)){3}/;
			var result:Object = testTelReg.exec(char);
			if(result == null) {
                return false;
            }
            return true;
		}
		
		public static function isIncreasingNum(char:String):Boolean
		{
			if (char == null) return false;
			char = StringUtil.trim(char);
			var testReg:RegExp = /(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){5}\d/;
			
		}
		
		/**
         * 匹配半角字符
         * 
         * @param str
         * @return 
         * 
         */        
        public static function matchAscii(str:String):Array
        {
        	return str.match(/[\x00-\xFF]*/g);
        }
		
		/**
         * 将文件路径字符串切分为数组。最后两个将会是文件名和扩展名。
         * 
         * @param url	路径
         * @return 
         * 
         */        
        public static function splitUrl(url:String):Array
        {
        	return url.split(/\/+|\\+|\.|\?/ig);
        }
		
		
		
	}//end of class
}
	