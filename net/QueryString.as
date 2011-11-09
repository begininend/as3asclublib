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
			try
			{
				var urlVariables:URLVariables = new URLVariables(pageURL.split("?")[1]);
			}
			catch (error:Error)
			{
				return null;
			}
			
			for (var key:String in urlVariables)
			{
				param[key] = urlVariables[key];
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