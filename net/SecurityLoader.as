package org.asclub.net
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * 跨域加载器(可用于加载 SWF 文件或图像（JPG、PNG 或 GIF）文件。)
	 */
	public class SecurityLoader extends Sprite
	{
		//策略文件是否允许
		private var _allowsDomain:Boolean;
		
		//第一次加载
		private var _loader:Loader;
		
		private var _hackLoader:Loader;
		
		public function SecurityLoader()
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderFailHandler);
		}
		
		/*override public function addChild(child:DisplayObject):DisplayObject
		{
			throw new Error("SecurityLoader 类不实现此方法。", 2069);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw new Error("SecurityLoader 类不实现此方法。", 2069);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw new Error("SecurityLoader 类不实现此方法。", 2069);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			throw new Error("SecurityLoader 类不实现此方法。", 2069);
		}*/
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			throw new Error("SecurityLoader 类不实现此方法。", 2069);
		}
		
		public function close():void
		{
			_loader.close();
			if (_hackLoader)
			{
				_hackLoader.close();
			}
		}
		
		public function get content():DisplayObject
		{
			if (_allowsDomain)
			{
				return _loader.content;
			}
			return _hackLoader ? _hackLoader.content : null;
		}
		
		/**
		 * 将 SWF、JPEG、渐进式 JPEG、非动画 GIF 或 PNG 文件加载到此 Loader 对象的子对象中。
		 * @param	request
		 * @param	context
		 */
		public function load(request:URLRequest, context:LoaderContext = null):void
		{
			_loader.load(request, context);
		}
		
		public function unload():void
		{
			_loader.unload();
			if (_hackLoader)
			{
				_hackLoader.unload();
			}
		}
		
		public function unloadAndStop(gc:Boolean = true):void
		{
			_loader.unloadAndStop(gc);
			if (_hackLoader)
			{
				_hackLoader.unloadAndStop(gc);
			}
		}
		
		
		private function loaderCompleteHandler(event:Event):void
		{
			try
			{
				var currentContent:DisplayObject = event.currentTarget.content as DisplayObject;
				_allowsDomain = true;
			}
			catch (error:Error)
			{
				trace("未授权");
			}
			
			while (this.numChildren) 
			{
                this.removeChildAt(0);
			}
			
			if (_allowsDomain)
			{
				this.addChild(_loader);
				this.dispatchEvent(event);
			}
			else
			{
				if (! _hackLoader)
				{
					_hackLoader = new Loader();
					_hackLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, hackLoaderCompleteHandler);
					_hackLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, hackLoaderFailHandler);
				}
				_hackLoader.loadBytes(_loader.contentLoaderInfo.bytes);
				this.addChild(_hackLoader);
			}
		}
		
		private function loaderFailHandler(event:IOErrorEvent):void
		{
			
		}
		
		//hack式加载完成
		private function hackLoaderCompleteHandler(event:Event):void
		{
			this.dispatchEvent(event);
		}
		
		//hack式加载失败
		private function hackLoaderFailHandler(event:IOErrorEvent):void
		{
			
		}
		
	}//end class
}