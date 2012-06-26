package org.asclub.net
{
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	
	public class QueryString
	{
		public function QueryString()
		{
			
		}
		
		/**
		 * 获取页面地址
		 * @return
		 */
		public static function getPageURL():String
		{
			if(ExternalInterface.available)
			{
				try
				{
					var pageurl:String = ExternalInterface.call("eval", "window.location.href");
					if(pageurl != null)
					{
						return pageurl;
					}
					return "";
				}
				catch(e:Error)
				{
					trace(e.toString());
					return "";
				}
			}
			return "";
		}
		
		//获取值对集合
		public static function parseValues(pageURL:String):Object
		{
			if(pageURL == "" || pageURL == null || pageURL.indexOf("?") == -1)
			{
				return null;
			}
			var param:Object = { };
			var source:String = pageURL.substr(pageURL.indexOf("?") + 1);
			try
			{
				var urlVariables:URLVariables = new URLVariables(source);
				for (var key:String in urlVariables)
				{
					param[key] = urlVariables[key];
				}
			}
			catch (error:Error)
			{
				var params:Array = source.split("&");
				var num:int = params.length;
				var item:String;
				var value:String;
				var delimiterIndex:int;
				for (var i:int = 0; i < num; i++)
				{
					item = params[i];
					delimiterIndex = item.indexOf("=");
					key = delimiterIndex == -1 ? item : item.substr(0, delimiterIndex);
					value = delimiterIndex == -1 ? "" : item.substr(delimiterIndex + 1);
					param[key] = value;
				}
			}
			return param;
		}
		
		/**
		 * 获取对应键值
		 * @param	key
		 * @return
		 */
		public static function getValue(key:String):String
		{
			var param:Object = parseValues(getPageURL());
			return param ? (param[key] || "") : "";
		}
	}//end of class
}