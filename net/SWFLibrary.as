/**
 * SWFLibrary v1.5, Pixelwelders Framework
 * Copyright 2008 (c) Zack Jordan, Pixelwelders LLC
 * { P I X E L W E L D E R S . C O M }
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * === I N S T R U C T I O N S ===
 * This class allows items from a Flash library to be used in an ActionScript-only project (e.g. a Flex ActionScript project).
 * 
 * 1 - In Flash, select "Export for ActionScript" in the symbol's Linkage settings in the Library (ex. 'Character').
 * 2 - Publish the Flash file as a SWF.
 * 3 - Load the SWF into an instance of SWFLibrary
 * 4 - Access the symbol through SWFLibrary, using the class name chosen in Step 1.
 * 
 * A SWFLibrary can be used with four lines of code.  Here's what you'll need: 
 * 
 * // === ===
 * // creates an instance of SWFLibrary, adds a listener, and loads a SWF
 * var gameAssets:SWFLibrary = new SWFLibrary
 * gameAssets.addEventListener( Event.COMPLETE, handleAssetsLoaded );
 * gameAssets.load( "myCustomGameAssets.swf" );
 * 
 * // accesses the asset (assumes there is a symbol exported as 'Character' in the loaded SWF, as seen in step 1 above)
 * var mySprite:Sprite = gameAssets.getSprite( "Character" );
 * addChild( mySprite );
 * 
 * // gets the asset as a MovieClip (assuming, of course, that it actually is a movieclip)
 * var myMC:MovieClip = gameAssets.getSprite( "Character" );
 * addChild( myMC );
 * 
 * // getting a sound
 * var mySound:Sound = gameAssets.getSound( "SoundLinkageNameHere" );
 * mySound.play();
 * // === ===
 * 
 * After a symbol has been retrieved from SWFLibrary, it may be treated just like any other object.
 * 
 */
package org.asclub.net
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.text.Font;

	public class SWFLibrary extends EventDispatcher
	{
		
		private var _libraryURL			: String;
		private var _loaded				: Boolean;
		private var _request			: URLRequest;
		private var _loader				: Loader;
		private var _loaderContext:LoaderContext;
		public var loaderInfo			: LoaderInfo;
		
		/**
		 * constructor
		 * 
		 * @param						none
		 * @return						nothing
		 */
		public function SWFLibrary(level:uint = 0)
		{
			_request = new URLRequest();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadCompleteHandler );
			_loader.contentLoaderInfo.addEventListener( Event.INIT, loadInitHandler );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadErrorHandler );
			_loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, loadHTTPStatusHandler );
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, loadProgressHandler );
			loaderInfo = _loader.contentLoaderInfo;
			_loaded = false;
			
			switch(level)
			{
				case 0:
				{
					//加载器自己的 ApplicationDomain
					_loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
					break;
				}
				case 1:
				{
					//加载器的 ApplicationDomain 的子级
					_loaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
					break;
				}
				case 2:
				{
					//系统 ApplicationDomain 的子级
					_loaderContext = new LoaderContext(false,new ApplicationDomain(null));  
					break;
				}
				default:
				{
					//其它 ApplicationDomain 的子级。
					_loaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain.parentDomain.parentDomain));
					break;
				}
			}
			
		}
		
		// === A P I ===
		/**
		 * load a SWF into this 
		 * 
		 * @param		assetURL		the URL of a SWF file to load
		 * @return						nothing
		 */ 
		public function load( assetURL:String ): void
		{
			_loaded = false;
			_request.url = assetURL;
			_loader.load( _request,_loaderContext);
			
			_libraryURL = assetURL;
		}
		
		public function unload():void
		{
			_loader.unload();
			// (_loader.content as IDispose).dispose();
		}
		
		/**
		 * get whether this is loaded or not
		 * 
		 * @param						none
		 * @return						nothing
		 */
		public function get loaded(): Boolean
		{
			return _loaded;
		}
		
		/**
		 * retrieves an instance of the specified Sprite
		 * 
		 * @param		linkage		name of the class that extends Sprite
		 * @return						an instance of that class, or null if not found
		 */ 
		public function getSprite( linkage:String ): Sprite
		{
			var Asset:Class = getAsset( linkage );
			
			if ( Asset ) return Sprite( new Asset() );
			return null;
		}
		
		/**
		 * retrieves an instance of the specified MovieClip
		 * 
		 * @param		linkage		name of the class that extends Sprite
		 * @return						an instance of that class, or null if not found
		 */
		 public function getMovieClip( linkage:String ): MovieClip
		 {
		 	var Asset:Class = getAsset( linkage );
		 	
		 	if ( Asset ) return MovieClip( new Asset() );
		 	return null;
		 }
		
		/**
		 * retrieves an instance of the specified Sound
		 * 检索一个指定的声音实例
		 * @param		linkage		name of the class that extends Sound
		 * @return						an instance of that sound, or null if not found
		 */
		public function getSound( linkage:String ): Sound
		{
			var Asset:Class = getAsset( linkage );
			
			if ( Asset ) return Sound( new Asset() );
			return null;
		}
		
		/**
		 * 获取一个指定的字体实例
		 * @param	linkage   
		 * @return  字体实例
		 */
		public function getFont(linkage:String):Font
		{
			var Asset:Class = getAsset( linkage );
			
			if ( Asset ) return Font( new Asset() );
			return null;
		}
		
		/**
		 * 获取一个指定的位图数据实例
		 * @param	linkage   
		 * @return  位图数据实例
		 */
		public function getBitmapData(linkage:String):BitmapData
		{
			var Asset:Class = getAsset( linkage );
			
			if ( Asset ) return BitmapData( new Asset(0,0) );
			return null;
		}
		
		/**
		 * 获取一个指定的位图据实例
		 * @param	linkage
		 * @return  位图实例
		 */
		public function getBitmap(linkage:String):Bitmap
		{
			var Asset:Class = getAsset( linkage );
			
			if ( Asset ) return new Bitmap(BitmapData( new Asset(0,0) ));
			return null;
		}
		
		/**
		 * 通过链接标识符获取类
		 * @param	linkage
		 * @return
		 */
		public function getAsset( linkage:String ): Class
		{
			try
			{
				var Asset:Class = loaderInfo.applicationDomain.getDefinition( linkage ) as Class;
			} 
			catch ( error:ReferenceError )
			{
				trace( "Asset '" + linkage + "' not found in '" + _libraryURL + "'" );
				return null;
			}
			
			return Asset;
		}
		
		/**
		 * 检查指定的应用程序域之内是否存在一个公共定义。
		 * @param	linkage  定义的名称。
		 * @return  Boolean — 如果指定的定义存在，则返回 true 值；否则，返回 false
		 */
		public function hasDefinition(linkage:String):Boolean
		{
			return loaderInfo.applicationDomain.hasDefinition(linkage);
		}
		
		/**
		 * 在不需要此实例时销毁掉，由外部调用
		 */
		public function dispose():void
		{
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, loadCompleteHandler );
			_loader.contentLoaderInfo.removeEventListener( Event.INIT, loadInitHandler );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, loadErrorHandler );
			_loader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, loadHTTPStatusHandler );
			_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, loadProgressHandler );
		}
		
		// === P R I V A T E   M E T H O D S ===
		/**
		 * finds the requested class in the SWF and returns it uninstantiated as a Class object
		 *
		 * @param		linkage		the name of the requested class
		 * @return						the requested class as a Class object
		 */
		
		// === E V E N T   H A N D L E R S ===
		/**
		 * called when the SWF has been successfully loaded
		 * dispatches AssetEvent.LOADED when called
		 * 
		 * @param		event			an Event object from _loader.contentLoaderInfo
		 * @return						nothing
		 */
		private function loadCompleteHandler(evt:Event): void
		{
			_loaded = true;
			dispatchEvent(evt);
		}
		
		//已加载的 SWF 文件的属性和方法可访问时调度。
		private function loadInitHandler(evt:Event):void
		{
			dispatchEvent(evt);
		}
		
		//在调用 URLLoader.load() 方法之后开始下载操作时调度。
		private function loadOpenHandler(evt:Event):void
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
		
	}//end of class
}