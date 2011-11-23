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
		private static function parseValues(pageURL:String):Object
		{
			if(pageURL == "" || pageURL == null || pageURL.indexOf("?") == -1)
			{
				return null;
			}
			var param:Object = { };
			var source:String = pageURL.split("?")[1];
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
				var item:Array;
				var value:String;
				for (var i:int = 0; i < num; i++)
				{
					item = params[i].split("=");
					key = item[0];
					value = item.length > 1 ? item[1] : "";
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