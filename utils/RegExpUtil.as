package org.asclub.utils 
{
	import org.asclub.string.StringUtil;
	public class RegExpUtil
	{
		
		
		
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
	}//end of class
}
	