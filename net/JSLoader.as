package org.asclub.net
{
	public final class JSLoader
	{
		private static var _inited:Boolean;
		
		public static function load(url:String):void
		{
			init();
			JSCaller.call("loadScriptInternal", url);
		}
		
		//初始化
		private static function init():void
		{
			if (! _inited)
			{
				_inited = true;
				var script:String = "function loadScriptInternal(url){var ss=document.getElementsByTagName('script');for(i=0;i<ss.length;i++){if(ss[i].src&&ss[i].src.indexOf(url)!=-1){return;}}s=document.createElement('script');s.type='text/javascript';s.src=url;var head=document.getElementsByTagName('head')[0];head.appendChild(s);}";
				JSCaller.call("eval", script);
			}
		}
		
		
		
		
		
		
	}//end class
}