package org.asclub.net
{
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.events.NetStatusEvent;
	public class DAMF
	{
		private var amfNetConnection:NetConnection;
		public var netStatus:String;
		public function DAMF()
		{
			
		}
		
		public function get URI():String
		{
			return amfNetConnection.uri;
		}
		
		/**
		 * 连接
		 * @param	amfURL     连接地址
		 * @param	Encoding   对象编码
		 */
		public function connect(amfURL:String,Encoding:uint = 3):void
		{
			connectToServer(amfURL, Encoding);
		}
		
		//连接到amf
		private function connectToServer(amfURL:String, Encoding:uint = 3):void
		{
			amfNetConnection = new NetConnection();
			amfNetConnection.objectEncoding = Encoding;
			amfNetConnection.connect(amfURL);
			amfNetConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		public function call(command:String, resultHandler:Function, ...arg):void
		{
			callServer(command, resultHandler, arg);
		}
		
		private function callServer(command:String, resultHandler:Function, arg:Array):void
		{
			var arguments:Array = [command, new Responder(resultHandler, onFault)];
			for (var i:int = 0; i < arg.length; i++)
			{
				arguments.push(arg[i]);
			}
			netStatus = "Normal";
			amfNetConnection.call.apply(null, arguments);
		}
		
		//监听
		private function netStatusHandler(Evt:NetStatusEvent):void
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
		private function onFault(fault:Object):void 
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