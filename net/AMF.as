package org.asclub.net
{
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.events.NetStatusEvent;
	public class AMF
	{
		private static var _amfNetConnection:NetConnection;
		private var _damfNetConnection:NetConnection;
		public static var netStatus:String;
		public function AMF()
		{
			_damfNetConnection = new NetConnection();
			_damfNetConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		/**
		 * 若使用 connect 连接到服务器，则为传递给 NetConnection.connect() 的应用程序服务器的 URI。 如果尚未调用 NetConnection.connect() 或者未传递 URI，则此属性为 undefined。
		 */
		public function get uri():String
		{
			return _damfNetConnection.uri;
		}
		
		/**
		 * 若使用 connect 连接到服务器，则为传递给 NetConnection.connect() 的应用程序服务器的 URI。 如果尚未调用 NetConnection.connect() 或者未传递 URI，则此属性为 undefined。
		 * (静态方法)
		 */
		public static function get uri():String
		{
			return (amfNetConnection == null ? "" : amfNetConnection.uri);
		}
		
		/**
		 * 连接(实例方法)
		 * @param	amfURL     连接地址
		 * @param	encoding   对象编码
		 */
		public function connect(amfURL:String, encoding:uint = 3):void
		{
			_damfNetConnection.objectEncoding = encoding;
			_damfNetConnection.connect(amfURL);
		}
		
		/**
		 * 连接(静态方法)
		 * @param	amfURL     连接地址
		 * @param	encoding   对象编码
		 */
		public static function connect(amfURL:String,encoding:uint = 3):void
		{
			if (_amfNetConnection == null)
			{
				_amfNetConnection = new NetConnection();
				_amfNetConnection.objectEncoding = encoding;
				_amfNetConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			}
			_amfNetConnection.connect(amfURL);
		}
		
		/**
		 * 调用应用程序实例所连接的应用程序服务器上的命令或方法。
		 * @param	command              命令或方法
		 * @param	resultHandler        回调函数
		 * @param	...arg               可选参数，可以为任一 ActionScript 类型，并包括对另一个 ActionScript 对象的引用。 当在远程应用程序服务器上执行 command 参数中指定的方法时，这些参数将被传递给该方法。
		 */
		public function call(command:String, resultHandler:Function, ...arg):void
		{
			var args:Array = [command, new Responder(resultHandler, onFault)];
			_damfNetConnection.call.apply(null, args.concat(arg));
		}
		
		/**
		 * 调用应用程序实例所连接的应用程序服务器上的命令或方法。(静态方法)
		 * @param	command              命令或方法
		 * @param	resultHandler        回调函数
		 * @param	...arg               可选参数，可以为任一 ActionScript 类型，并包括对另一个 ActionScript 对象的引用。 当在远程应用程序服务器上执行 command 参数中指定的方法时，这些参数将被传递给该方法。
		 */
		public static function call(command:String, resultHandler:Function, ...arg):void
		{
			var args:Array = [command, new Responder(resultHandler, onFault)];
			_amfNetConnection.call.apply(null, args.concat(arg));
		}
		
		//监听
		private static function netStatusHandler(Evt:NetStatusEvent):void
		{
			for (var i:String in Evt.info)
			{
				trace(i + ":" + Evt.info[i])
			}
			switch(Evt.info.code)
			{
				case "NetConnection.Call.BadVersion":
					netStatus = "NetConnection.Call.BadVersion";
					trace("不能识别的格式编码的数据包");
				break;
				case "NetConnection.Call.Failed":
					netStatus = "NetConnection.Call.Failed";
					trace("无法调用服务器端的方法或命令");
				break;
			}
		}
		
		//amf错误处理
		private static function onFault(fault:Object):void
		{
			trace("amf错误处理");
			for (var i:String in fault)
			{
				trace(i + ":" + fault[i]);
			}
			if (fault["faultCode"] == "AMFPHP_RUNTIME_ERROR")
			{
				netStatus = "AMFPHP_RUNTIME_ERROR";
				trace("服务器端运行超时");
			}
		}
	}//end of class
}