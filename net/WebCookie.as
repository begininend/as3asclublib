package org.asclub.net
{
	import flash.external.ExternalInterface;
	
	public class WebCookie
	{
		public function WebCookie()
		{
		}
		
		private static const FUNCTION_SETCOOKIE:String = 
            "document.insertScript = function ()" +
            "{ " +
                "if (document.snw_setCookie==null)" +
                "{" +
                    "snw_setCookie = function (name, value, days)" +
                    "{" +
                        "if (days) {" +
							"var date = new Date();" +
							"date.setTime(date.getTime()+(days*24*60*60*1000));" +
							"var expires = '; expires='+date.toGMTString();" +
						"}" +
						"else var expires = '';" +
						"document.cookie = name+'='+value+expires+'; path=/';" +
		            "}" +
                "}" +
            "}";
		
		private static const FUNCTION_GETCOOKIE:String = 
            "document.insertScript = function ()" +
            "{ " +
                "if (document.snw_getCookie==null)" +
                "{" +
                    "snw_getCookie = function (name)" +
                    "{" +
                        "var nameEQ = name + '=';" +
						"var ca = document.cookie.split(';');" +
						"for(var i=0;i < ca.length;i++) {" +
							"var c = ca[i];" +
							"while (c.charAt(0)==' ') c = c.substring(1,c.length);" +
							"if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);" +
						"}" +
						"return null;" +
		            "}" +
                "}" +
            "}";
     
            
        private static var INITIALIZED:Boolean = false;
		
		//初始化
		private static function init():void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(FUNCTION_GETCOOKIE);
				ExternalInterface.call(FUNCTION_SETCOOKIE);
				INITIALIZED = true;
			}
		}
		
		/**
		 * 设置cookie值
		 * @param	name      属性名
		 * @param	value     属性值
		 * @param	days      有效期
		 */
		public static function setCookie(name:String, value:Object, days:int):*
		{
			if(!INITIALIZED) init();
			if (ExternalInterface.available)
			var returnValue:* = ExternalInterface.call("snw_setCookie", name, value, days);
			return returnValue;
		}
		
		/**
		 * 获取cookie值
		 * @param	name      属性名
		 * @param	value     属性值
		 * @param	days      有效期
		 */
		public static function getCookie(name:String):*
		{
			if(!INITIALIZED) init();
			if (ExternalInterface.available)
			var returnValue:* = ExternalInterface.call("snw_getCookie", name);
			return returnValue;
		}
		
		/**
		 * 删除cookie值
		 * @param	name      属性名
		 */
		public static function deleteCookie(name:String):void
		{
			if(!INITIALIZED) init();
			if (ExternalInterface.available)
			ExternalInterface.call("snw_setCookie", name, "", -1);
		}

	}//end of class
}