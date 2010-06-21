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
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class WebStreamLoader extends EventDispatcher
	{
		private var _urlStream:URLStream;
		public function WebStreamLoader(endian:String = Endian.BIG_ENDIAN,encoding:uint = ObjectEncoding.AMF3)
		{
			_urlStream = new URLStream();
			_urlStream.endian = endian;
			_urlStream.objectEncoding = encoding;
			_urlStream.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_urlStream.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			_urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, loadHTTPStatusHandler);
			_urlStream.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSecurityErrorHandler);
			_urlStream.addEventListener(Event.OPEN, loadOpenHandler);
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
			_urlStream.load(urlRequest);
		}
		
		/**
		 * 立即关闭该流并取消下载操作。 
		 */
		public function close():void
		{
			_urlStream.close();
		}
		
		/**
		 * 指示此 URLStream 对象目前是否已连接。 
		 */
		public function get connected():Boolean
		{
			return _urlStream.connected;
		}
		
		/**
		 * 回可在输入缓冲区中读取的数据的字节数。 
		 */
		public function get bytesAvailable():uint
		{
			return _urlStream.bytesAvailable;
		}
		
		/**
		 * 从该流读取一个布尔值。 读取单个字节，如果字节非零，则返回 true，否则返回 false。
		 * @return
		 */
		public function readBoolean():Boolean
		{
			return _urlStream.readBoolean();
		}
		
		/**
		 * 从该流读取一个带符号字节。
		 * @return  返回值在 -128...127 之间。
		 */
		public function readByte():int
		{
			return _urlStream.readByte();
		}
		
		/**
		 * 从该流读取 length 字节的数据。 这些字节会被读取到由 bytes 指定的 ByteArray 对象中，其起始位置是在 ByteArray 对象中偏移 offset 字节处。
		 * @param	bytes:ByteArray — 要将数据读入的 ByteArray 对象。 
		 * @param	offset:uint (default = 0) — 在 bytes 中的偏移量，即数据读取的起始位置。 默认值为 0。
		 * @param	length:uint (default = 0) — 要读取的字节数。 默认值 0 将导致读取所有可用的数据。 
		 */
		public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			return _urlStream.readBytes(bytes, offset, length);
		}
		
		/**
		 * 从该流读取一个 IEEE 754 双精度浮点数。 
		 * @return
		 */
		public function readDouble():Number
		{
			return _urlStream.readDouble();
		}
		
		/**
		 * 从该流读取一个 IEEE 754 单精度浮点数。 
		 * @return
		 */
		public function readFloat():Number
		{
			return _urlStream.readFloat();
		}
		
		/**
		 * 从该流读取一个带符号的 32 位整数。
		 * @return  返回值在 -2147483648...2147483647 之间。
		 */
		public function readInt():int
		{
			return _urlStream.readInt();
		}
		
		/**
		 * 使用指定的字符集从字节流中读取指定长度的多字节字符串。
		 * 注意：如果当前系统无法识别 charSet 参数的值，则 Flash Player 将采用系统的默认代码页作为字符集。 
		 * 例如，charSet 参数的值（如在使用 01 而不是 1 的 myTest.readMultiByte(22, "iso-8859-01") 中）可能在您的开发计算机上起作用，但在其它计算机上可能不起作用。 
		 * 在另一台计算机上，Flash Player 将使用系统的默认代码页。
		 * @param	length:uint — 要从字节流中读取的字节数。
		 * @param	charSet:String — 表示用于解释字节的字符集的字符串。 可能的字符集字符串包括 "shift_jis"、"CN-GB"、"iso-8859-1"”等。 有关完整列表，请参阅Supported Character 。 
		 * @return  UTF-8 编码的字符串。 
		 */
		public function readMultiByte(length:uint, charSet:String):String
		{
			return _urlStream.readMultiByte(length,charSet);
		}
		
		/**
		 * 从以 Action Message Format (AMF) 编码的套接字读取一个对象。
		 * @return   * — 反序列化的对象。
		 */
		public function readObject():*
		{
			return _urlStream.readObject();
		}
		
		/**
		 * 从该流读取一个带符号的 16 位整数。
		 * @return  返回值在 -32768...32767 之间。
		 */
		public function readShort():int
		{
			return _urlStream.readShort();
		}
		
		/**
		 * 从该流读取一个无符号字节。
		 * @return  返回值在 0...255 之间。
		 */
		public function readUnsignedByte():uint
		{
			return _urlStream.readUnsignedByte();
		}
		
		/**
		 * 从该流读取一个无符号的 32 位整数。
		 * @return  返回值在 0...4294967295 之间。
		 */
		public function readUnsignedInt():uint
		{
			return _urlStream.readUnsignedInt();
		}
		
		/**
		 * 从该流读取一个无符号的 16 位整数。
		 * @return  返回值在 0...65535 之间。
		 */
		public function readUnsignedShort():uint
		{
			return _urlStream.readUnsignedShort();
		}
		
		/**
		 * 从该流读取一个 UTF-8 字符串。 假定字符串的前缀是无符号的短整型（以字节表示长度）。 
		 * @return
		 */
		public function readUTF():String
		{
			return _urlStream.readUTF();
		}
		
		/**
		 * 从该流读取长度为 length 的 UTF-8 字节序列，并返回一个字符串。 
		 * @param	length:uint — 一个 UTF-8 字节序列。 
		 * @return
		 */
		public function readUTFBytes(length:uint):String
		{
			return _urlStream.readUTFBytes(length);
		}
		
		
		// ==================================== P R I V A T E   M E T H O D S ============================================
		
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