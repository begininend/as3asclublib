package org.asclub.data
{
	public final class FunctionUtil
	{
		public function FunctionUtil()
		{
			
		}
		
		//代理函数
		public static function eventDelegate(_function:Function, ...alt):Function
		{
			var _fun:Function = function (e:*):void 
			{
				var _alt:Array = [];
				_function.apply(null,_alt.concat(e,alt));
			}
			return _fun;
		}
		
		//代理函数
		public static function bindingParameters(_function:Function, ...alt):Function
		{
			var _fun:Function = function():void
			{
				_function.apply(null,alt);
			}
			return _fun;
		}
	}//end of class
}