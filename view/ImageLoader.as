package org.asclub.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.system.LoaderContext;
	public class ImageLoader extends EventDispatcher
	{
		//是否要将图像按比例缩放到 ImageLoader 实例的大小
		public var scaleContent:Boolean;
		//是要保持原始图像中使用的高宽比，还是要将图像的大小调整为 ImageLoader 组件的当前宽度和高度。
		public var maintainAspectRatio:Boolean;
		//容器
		private var _container:DisplayObjectContainer = null;
		private var _loader:Loader = null;
		private var _source:Object;
		private var containerWidth:Number;
		private var containerHeight:Number;
		public function ImageLoader()
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadCompleteHandler );
			_loader.contentLoaderInfo.addEventListener( Event.INIT, loadInitHandler );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadErrorHandler );
			_loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, loadHTTPStatusHandler );
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, loadProgressHandler );
		}
		
		//------------getter and setter
		
		//获取
		public function get content():DisplayObject
		{
			return _loader.content;
		}
		
		//
		public function get source():Object
		{
			return _source;
		}
		
		
		//------------public function 
		
		
		public function setSource(value:Object,container:DisplayObjectContainer):void
		{
			if (value == null)  return;
			_source = value;
			_container = container;
			containerWidth = _container.width;
			containerHeight = _container.height;
			if (getQualifiedClassName(value) == "String")
			{
				load(value as String, container);
			}
			else if (getQualifiedSuperclassName(value) == "flash.display::MovieClip")
			{
				var image:DisplayObject = new value();
				_container.addChild(image);
			}
			else if (getQualifiedSuperclassName(value) == "flash.display::BitmapData")
			{
				var bitmap:Bitmap = new Bitmap(value as BitmapData);
				_container.addChild(bitmap);
			}
			else
			{
				trace("不支持");
			}
		}
		
		public function load(url:String,container:DisplayObjectContainer,context:LoaderContext = null):void
		{
			var urlReRequest:URLRequest = new URLRequest(url);
			_container = container;
			_container.addChild(_loader);
			containerWidth = _container.width;
			containerHeight = _container.height;
			_loader.load(urlReRequest,context);
		}
		
		public function unload():void
		{
			_loader.unload();
		}
		
		//------------private function
		private function loadCompleteHandler(evt:Event): void
		{
			//dispatchEvent(evt);
			autoResize(_loader.content as DisplayObject);
		}
		
		//已加载的 SWF 文件的属性和方法可访问时调度。
		private function loadInitHandler(evt:Event):void
		{
			//dispatchEvent(evt);
		}
		
		//在调用 URLLoader.load() 方法之后开始下载操作时调度。
		private function loadOpenHandler(evt:Event):void
		{
			//dispatchEvent(evt);
		}
		
		//在发生导致加载操作失败的输入或输出错误时调度。
		private function loadErrorHandler(evt:IOErrorEvent):void
		{
			//dispatchEvent(evt);
		}
		
		//在通过 HTTP 发出网络请求并且 Flash Player 可以检测到 HTTP 状态代码时调度
		private function loadHTTPStatusHandler(evt:HTTPStatusEvent):void
		{
			//dispatchEvent(evt);
		}
		
		//在下载操作过程中收到数据时调度
		private function loadProgressHandler(evt:ProgressEvent):void
		{
			//dispatchEvent(evt);
		}
		
		//按比例适应容器
		private function autoResize(image:DisplayObject):void
		{
			if (maintainAspectRatio)
			{
				image.width = containerWidth;
				image.height = containerHeight;
				return;
			}
			
			if (scaleContent)
			{
				var scale:Number = 1;
				if((image.width >= containerWidth && image.height >= containerHeight) || (image.width < containerWidth && image.height < containerHeight))
					scale = Math.min((containerWidth / image.width),(containerHeight / image.height));
				
				else if(image.width < containerWidth && image.height >= containerHeight)
					scale = containerHeight / image.height;
				
				else if(image.width >= containerWidth && image.height < containerHeight)
					scale = containerWidth / image.width;
				
				image.width *= scale;
				image.height *= scale;
				image.x = (containerWidth - image.width) * 0.5 >> 0;
				image.y = (containerHeight - image.height) * 0.5 >> 0;
			}
		}
		
	}//end of class
}