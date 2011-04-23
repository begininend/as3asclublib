package org.asclub.net
{
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	public class QueryString
	{
		public function QueryString()
		{
			
		}
		
		//获取页面地址
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
		private static function parseValues(pageURL:String):Dictionary
		{
			if(pageURL == "" || pageURL == null)
			{
				return null;
			}
			var pairDict:Dictionary = new Dictionary(true);
            var pairs:Array = (pageURL.split("?")[1] == undefined ? [] : pageURL.split("?")[1].split("&"));
            
            var pairName:String;
            var pairValue:String;
            if(pairs.length == 0)
			{
				return null;
			}
            for (var i:int = 0; i < pairs.length; i++)
            {
                pairName = pairs[i].split("=")[0];
                pairValue = pairs[i].split("=")[1];
                
                pairDict[pairName] = pairValue;
            }
			return pairDict;
		}
		
		//获取对应键值
		public static function getValue(key:String):String
		{
			if(parseValues(getPageURL()) == null)
			{
				return "";
			}
			
			var pairDict:Dictionary = new Dictionary(true);
			pairDict = parseValues(getPageURL());
			if (pairDict[key] == null || pairDict[key] == undefined)
        	{
                return "";
       		}
        	else
        	{
          		 return pairDict[key];
       		}
		}
	}//end of class
}