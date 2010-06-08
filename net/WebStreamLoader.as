package org.asclub.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.ObjectEncoding;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLStream;
	import flash.utils.Endian;
	
	public class WebStreamLoader extends EventDispatcher
	{
		public var urlStream:URLStream;
		public function WebStreamLoader(endian:String = Endian.BIG_ENDIAN,encoding:uint = ObjectEncoding.AMF3)
		{
			urlStream = new URLStream();
			urlStream.endian = endian;
			urlStream.objectEncoding = encoding;
			urlStream.addEventListener(Event.COMPLETE, loadCompleteHandler);
			urlStream.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, loadHTTPStatusHandler);
			urlStream.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);
			urlStream.addEventListener(Event.OPEN, loadOpenHandler);
		}
		
		/**
		 * 开始下载 request 参数中指定的 URL。
		 * @param	webPage
		 * @param	requestData
		 * @param	requestMethod
		 * @param	contentType
		 * @param	requestHeaders
		 */
		public function load(webPage:String,requestData:Object = null,requestMethod:String = null,contentType:String = null,requestHeaders:Array = null):void
		{
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = webPage;
			urlRequest.method = (requestMethod == null ? URLRequestMethod.GET : requestMethod);
			if (contentType != null) urlRequest.contentType = contentType;
			if (requestHeaders != null) urlRequest.requestHeaders = requestHeaders;
			if (requestData != null)
			{
				var urlVariable:URLVariables = new URLVariables();
				for (var i:String in requestData)
				{
					urlVariable[i] = requestData[i];
				}
				urlRequest.data = urlVariable;
			}
			urlStream.load(urlRequest);
		}
		
		public function close():void
		{
			urlStream.close();
		}
		
		// === P R I V A T E   M E T H O D S ===
		
		//加载完成时调度。
		private function loadCompleteHandler(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
		//在发生导致加载操作失败的输入或输出错误时调度。
		private function loadErrorHandler(evt:IOErrorEvent):void
		{
			dispatchEvent(evt);
		}
		
		//在通过 HTTP 发出网络请求并且 Flash Player 可以检测到 HTTP 状态代码时调度
		private function loadHTTPStatusHandler(evt:HTTPStatusEvent):void
		{
			dispatchEvent(evt);
		}
		
		//在下载操作过程中收到数据时调度
		private function loadProgressHandler(evt:ProgressEvent):void
		{
			dispatchEvent(evt);
		}
		
		//加载操作尝试从调用方安全沙箱外部的服务器检索数据时调度
		private function loadSecurityErrorHandler(evt:SecurityErrorEvent):void
		{
			dispatchEvent(evt);
		}
		
		//在加载操作开始时调度。
		private function loadOpenHandler(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
	}//end of class
}