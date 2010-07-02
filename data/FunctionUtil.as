package org.asclub.data
{
	public final class FunctionUtil
	{
		public function FunctionUtil()
		{
			
		}
		
		/**
		 * 代理函数(绑定事件到函数)
		 * @param	_function
		 * @param	...arg
		 * @return
		 */
		public static function eventDelegate(_function:Function, ...arg):Function
		{
			var len:uint = arg.length;
			var args:Array;
			if (len == 1 && arg[0] is Array)
			{
				args = arg[0] as Array;
			}
			else
			{
				args = arg;
			}
			var _fun:Function = function (e:*):void 
			{
				var _arg:Array = [];
				_function.apply(null,_arg.concat(e,args));
			}
			return _fun;
		}
		
		/**
		 * 代理函数
		 * @param	_function
		 * @param	...arg
		 * @return
		 */
		public static function bindingParameters(_function:Function, ...arg):Function
		{
			var len:uint = arg.length;
			var args:Array;
			if (len == 1 && arg[0] is Array)
			{
				args = arg[0] as Array;
			}
			else
			{
				args = arg;
			}
			var _fun:Function = function():void
			{
				_function.apply(null,args);
			}
			return _fun;
		}
	}//end of class
}