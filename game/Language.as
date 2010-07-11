package org.asclub.game
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import org.asclub.net.WebLoader;
	import org.asclub.string.StringUtil;
	
	public final class Language extends EventDispatcher
	{
		private static var _instance:Language = null;
		//语言包中对应key value
		public static var data:Object = { };
		//是否初始化完成
		public static var init:Boolean;
		
		public function Language(privateClass:PrivateClass)
		{
		}
		
		//获取单例
		public static function getInstance():Language
		{
			if ( _instance == null ) _instance = new Language(new PrivateClass());
            return _instance;
		}
		
		/**
		 * 载入语言包文件
		 * @param	url
		 */
		public static function load(url:String):void
		{
			var webLoader:WebLoader = new WebLoader();
			webLoader.addEventListener(Event.COMPLETE,loadCompleteHandler);
			webLoader.load(url);
		}
		
		//载入完成
		private static function loadCompleteHandler(evt:Event):void
		{
			var msg:String = StringUtil.trim(evt.currentTarget.data);
			var lines:Array = msg.split(/(\n|\r|\t|\f)/ig);
			var linelength:int = lines.length;
			for(var i:int = linelength; i > -1;i--)
			{
				//如果是空白行或者是注释行则去掉
				if(StringUtil.isWhitespace(lines[i]) || isAnnotate(lines[i]))
				{
					lines.splice(i,1);
				}
			}
			var d1:Number = new Date().getTime();
			var variables:Array;
			var key:String;
			var value:String;
			for (var j:String in lines)
			{
				//data[StringUtil.trim(lines[j].split("=")[0])] = StringUtil.trim(lines[j].split("=")[1]);
				variables = lines[j].split("=");
				key = StringUtil.trim(variables[0]);
				value = StringUtil.trim(variables[1]);
				trace("key:" + key + "value:" + value);
				data[key] = value;
			}
			trace(new Date().getTime() - d1);
			init = true;
			_instance.dispatchEvent(evt);
		}
		
		//是否为注释
		private static function isAnnotate(str:String):Boolean
		{
			if(str == null) return false;
			return str.indexOf("//") == 0;
		}
		
		
	}//end of class
}

class PrivateClass{}