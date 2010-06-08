package org.asclub.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	public class WebLoader extends EventDispatcher
	{
		private var urlLoader:URLLoader;
		public var data:*;
		private var _urlRequest:URLRequest;
		public function WebLoader()
		{
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loadHTTPStatusHandler);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);
			urlLoader.addEventListener(Event.OPEN, loadOpenHandler);
			_urlRequest = new URLRequest();
		}
		
		/**
		 * 开始下载 request 参数中指定的 URL。
		 * @param	webPage
		 * @param	requestData
		 * @param	requestMethod
		 * @param	contentType
		 * @param	requestHeaders
		 */
		public function load(webPage:String,requestData:Object = null,requestMethod:String = null,contentType:String = null,requestHeaders:Array = null,dataFormat:String = null):void
		{
			_urlRequest.url = webPage;
			_urlRequest.method = (requestMethod == null ? URLRequestMethod.GET : requestMethod);
			if (contentType != null) _urlRequest.contentType = contentType;
			if (requestHeaders != null) _urlRequest.requestHeaders = requestHeaders;
			if (requestData != null)
			{
				var urlVariable:URLVariables = new URLVariables();
				for (var i:String in requestData)
				{
					urlVariable[i] = requestData[i];
				}
				_urlRequest.data = urlVariable;
			}
			if(dataFormat != null) urlLoader.dataFormat = dataFormat;
			urlLoader.load(_urlRequest);
		}
		
		/**
		 * 在不需要此实例时销毁掉，由外部调用
		 */
		public function dispose():void
		{
			urlLoader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, loadHTTPStatusHandler);
			urlLoader.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);
			urlLoader.removeEventListener(Event.OPEN, loadOpenHandler);
		}
		
		
		
		// === P R I V A T E   M E T H O D S ===
		
		//加载完成时调度。
		private function loadCompleteHandler(evt:Event):void
		{
			data = evt.currentTarget.data;
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
			data = evt.currentTarget.data;
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