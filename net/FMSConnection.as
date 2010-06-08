package org.asclub.net
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	public class FMSConnection extends EventDispatcher
	{
		private static var _instance:FMSConnection;
		private static var _fmsNetConnection:NetConnection;
		private static var _FMSURI:String;
		private static var _connectArgs:Array;
		private static var _protocolList:Array = ["rtmp:/", "rtmpt:/", "rtmps:/", "rtmpe:/", "rtmpte:/", "rtmfp:/"];
		private static var _portList:Array = ["80", "1111", "1935"];
		private static var _protocolIndex:int;
		private static var _timeOutIntervalID:uint;
		private static var _timeOut:uint = 200;//重新连接间隔时间
		
		public static var client:Object;
		
		public function FMSConnection(privateClass:PrivateClass)
		{
			
		}
		
		/**
		 * [read-only] 指示 Flash Player 是通过持久性的 RTMP 连接连接到服务器 (true) 还是没有连接 (false)。
		 */
		public static function get connected():Boolean
		{
			return _fmsNetConnection.connected;
		}
		
		/**
		 * [read-only] 如果连接成功，则指示使用的是哪种连接方法：直接连接、CONNECT 方法还是 HTTP 隧道。
		 */
		public static function get connectedProxyType():String
		{
			return _fmsNetConnection.connectedProxyType;
		}
		
		/**
		 * 若使用 connect 连接到服务器，则为传递给 NetConnection.connect() 的应用程序服务器的 URI。
		 */
		public static function get uri():String
		{
			return _fmsNetConnection.uri;
		}
		
		/**
		 * 若使用 connect 连接到服务器，则为传递给 NetConnection.connect() 的应用程序服务器的 URI。
		 */
		public static function get usingTLS():Boolean
		{
			return _fmsNetConnection.usingTLS;
		}
		
		/**
		 * 获取单例
		 * @return
		 */
		public static function getInstance():FMSConnection
		{
			if ( _instance == null ) _instance = new FMSConnection(new PrivateClass());
            return _instance;
		}
		
		public static function getNetConnection():NetConnection
		{
			return _fmsNetConnection;
		}
		
		/**
		 * 打开到服务器的连接。
		 * @param	FMSURI       [host][:port]/appname/[instanceName] . 如果要连接的视频不在服务器上（即视频在运行 SWF 文件的本地计算机上），则将此参数设置为 null。 
		 * @param	encoding     此 NetConnection 实例的对象编码（AMF 版本）。
		 * @param	...arg       要传递给 FMSURI 中指定的应用程序的任一类型可选参数。
		 */
		public static function connect(FMSURI:String,encoding:uint = 3, ...rest):void
		{
			//getInstance();
			_connectArgs = rest;
			var protocolTest:RegExp = /^(rtmp|rtmpt|rtmps|rtmpe|rtmpte|rtmfp)/i;
			if (!protocolTest.test(FMSURI)) _FMSURI = FMSURI;
			if (_fmsNetConnection == null)
			{
				_fmsNetConnection = new NetConnection();
				_fmsNetConnection.objectEncoding = encoding;
				client = _fmsNetConnection.client = {};
				_fmsNetConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_fmsNetConnection.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
				_fmsNetConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			}
			if (!_fmsNetConnection.connected)
			{
				var args:Array = (FMSURI == null ? null : (protocolTest.test(FMSURI) ? [FMSURI] : [_protocolList[0] + "/" + FMSURI]));
				if (rest.length == 1 && rest[0] is Array) rest = rest[0] as Array;
				for (var i:String in rest)
				{
					if(args) args.push(rest[i]);
				}
				args == null ? (_fmsNetConnection.connect(null)) : (_fmsNetConnection.connect.apply(null, args));
				trace("args::" + args);
			}
			
			//var xnURL:String = protocol + ((_serverName == null) ? "" : "/" + _serverName + ((port == null) ? "" : (":" + port)) + "/") + ((_wrappedURL == null) ? "" : _wrappedURL + "/") + _appName;
		}
		
		/**
		 * 关闭本地打开的或与服务器一起打开的连接
		 */
		public static function close():void
		{
			_fmsNetConnection.close();
		}
		
		/**
		 * 调用服务器端方法
		 * @param	command
		 * @param	resultHandler
		 * @param	...arg
		 */
		public static function call(command:String, resultHandler:Function, ...arg):void
		{
			var args:Array = [command, new Responder(resultHandler, onFault)];
			for (var i:int = 0; i < arg.length; i++)
			{
				args.push(arg[i]);
			}
			_fmsNetConnection.call.apply(null,args);
		}
		
		//在异步引发异常（即来自本机异步代码）时调度。
		private static function asyncErrorHandler(evt:AsyncErrorEvent):void
		{
			if(_instance) _instance.dispatchEvent(evt);
			trace("asyncErrorHandler");
			for (var i:String in evt.error)
			{
				trace(i + ":" + evt.error[i]);
			}
		}
		
		//在出现输入或输出错误并导致网络操作失败时调度。 
		private static function IOErrorHandler(evt:IOErrorEvent):void
		{
			if(_instance) _instance.dispatchEvent(evt);
			trace("IOErrorHandler:" + evt.text);
		}
		
		//监听
		private static function netStatusHandler(evt:NetStatusEvent):void
		{
			if(_instance) _instance.dispatchEvent(evt);
			trace("netStatusHandler");
			trace(evt.info.code);
			switch(evt.info.code)
			{
				case "NetConnection.Call.BadVersion":
					trace("不能识别的格式编码的数据包");
				break;
				case "NetConnection.Connect.Failed":
					//连接失败时，改用别的协议连接
					_timeOutIntervalID = setTimeout(reconnect, _timeOut);
				break;
				//case "NetConnection.Call.Failed":
					//trace("无法调用服务器端的方法或命令");
				//break;
			}
		}
		
		private static function reconnect():void
		{
			clearTimeout(_timeOutIntervalID);
			_protocolIndex++;
			if (_protocolIndex >= _protocolList.length) _protocolIndex = 0;
			connect(_protocolList[_protocolIndex] + "/" + _FMSURI,3,_connectArgs);
			//trace(_protocolList[_protocolIndex] + "/" + _FMSURI);
			//_fmsNetConnection.connect(null);
		}
		
		//FMSConnection错误处理
		private static function onFault(fault:Object):void
		{
			trace("FMSConnection错误处理");
			for (var i:String in fault)
			{
				trace(i + ":" + fault[i]);
			}
		}
		
	}//end of class
}

class PrivateClass{}