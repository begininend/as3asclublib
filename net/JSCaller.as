package org.asclub.net
{
	import flash.external.ExternalInterface;
	public final class JSCaller
	{
		
		/**
		 * 将 ActionScript 方法注册为可从容器调用。 成功调用 addCallBack() 后，容器中的 JavaScript 或 ActiveX 代码可以调用在 Flash Player 中注册的函数。
		 * @param	functionName	— 容器可用于调用函数的名称。 
		 * @param	closure	— 要调用的 closure 函数。 这可能是一个独立的函数，或者可能是引用对象实例方法的 closure 方法。 通过传递 closure 方法，可以将回调定向到特定对象实例的方法。
		 */
		public static function addCallback(functionName:String, closure:Function):void
		{
			if (ExternalInterface.available)
            {
				ExternalInterface.addCallback(functionName, closure);
			}
		}
		
		public static function call(functionName:String, ... args):*
		{
			if (ExternalInterface.available)
            {
				args.unshift(functionName);
                return ExternalInterface.call.apply(ExternalInterface, args);
			}
			return null;
		}
		
		 public static function get objectID():String
		 {
			 if (ExternalInterface.available)
            {
				ExternalInterface.objectID;
			}
			return null;
		 }
		
		
		
	}//end class
}