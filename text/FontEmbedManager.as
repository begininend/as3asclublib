package org.asclub.text
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.events.LoaderEvent;
	
	import org.asclub.string.InCommonUseWordTable;
	import org.asclub.data.FunctionUtil;
	import org.asclub.data.ArrayUtil;
	
	public final class FontEmbedManager extends EventDispatcher
	{
		private var _textField:TextField;
		
		private var _font:String = "";
		//已载入的字体的列表({"黑体":[0,2,5]})
		private var _fontMap:Object = { };
		//字体素材路径
		private var _path:String;
		
		private var _beginIndex:int;
		private var _inputText:String;
		
		private var _loading:Boolean;
		
		private var _loadIntervalID:int;
		private const LOAD_TIMEOUT:int = 60 * 1000;
		
		public var onStartLoad:Function;
		public var onLoadedComplete:Function;
		public var onFail:Function;
		public var onRenderComplete:Function;
		
		public function FontEmbedManager()
		{
			
		}
		
		/**
		 * 设置字体素材路径
		 */
		public function set path(value:String):void
		{
			_path = value;
		}
		
		public function set text(value:String):void
		{
			if (value != null)
			{
				var newText:String = value;
				if (value.indexOf(_textField.text) == 0 && value != _textField.text.replace(/\s$/g,""))
				{
					newText = newText.substr(_textField.text.length, newText.length - _textField.text.length);
				}
				else
				{
					_textField.text = "";
				}
				appendText(newText);
			}
			
			/*if (value != null)
			{
				var newText:String = value;
				_textField.text = "";
				appendText(newText);
			}*/
		}
		
		public function set textField(value:TextField):void
		{
			_textField = value;
			_font = _font ? _font : _textField.defaultTextFormat.font;
		}
		
		/**
		 * 附加文字
		 * @param	newText
		 */
		public function appendText(newText:String):void
		{
			_beginIndex = _textField.text.length;
			_inputText = newText;
			_textField.appendText(newText);
			var num:int = _inputText.length;
			var ratio:int;
			var unloadedFonts:Array = [];
			var fontlist:Array = _fontMap[_font] as Array;
			for (var i:int = 0; i < num; i++)
			{
				ratio = InCommonUseWordTable.getRatio(_inputText.charAt(i));
				if (ratio > -1 && fontlist.indexOf(ratio) == -1 && unloadedFonts.indexOf(ratio) == -1)
				{
					unloadedFonts.push(ratio);
				}
			}
			
			if (unloadedFonts.length > 0)
			{
				loadFonts(unloadedFonts, _inputText, _beginIndex, num);
			}
			else
			{
				setTextFormat(_inputText, _beginIndex);
			}
		}
		
		public function set font(value:String):void
		{
			_font = value;
			_fontMap[_font] = _fontMap[_font] ? _fontMap[_font] : [];
			if (_textField && _textField.text)
			{
				var newText:String = _textField.text;
				_textField.text = "";
				appendText(newText);
			}
		}
		
		private function loadFonts(fonts:Array, text:String, beginIndex:int, numChars:int):void
		{
			var num:int = fonts.length;
			if (num > 0)
			{
				var queue:LoaderMax = new LoaderMax( { name:"mainQueue", onProgress:progressHandler, onError:errorHandler, onComplete:FunctionUtil.bindingParameters(netFontLoadedComplete, fonts, text, beginIndex, numChars) } );
				while (num --)
				{
					var securityDomain:SecurityDomain = Security.sandboxType == Security.REMOTE ? SecurityDomain.currentDomain : null;
					var loaderContext:LoaderContext = new LoaderContext(true, new ApplicationDomain(ApplicationDomain.currentDomain), securityDomain);
					queue.append(new SWFLoader(_path + "/" + fonts[num] + ".swf", {name:_font + "_" + fonts[num], context:loaderContext}));
				}
				queue.load();
				if (onStartLoad != null)
				{
					onStartLoad();
				}
				_loading = true;
				if (!_loading)
				{
					_loadIntervalID = setTimeout(loadFontTimeout, LOAD_TIMEOUT);
				}
			}
		}
		
		//字体加载完成
		private function netFontLoadedComplete(fonts:Array, text:String, beginIndex:int, numChars:int):void
		{
			_loading = false;
			clearTimeout(_loadIntervalID);
			setTextFormat(text, beginIndex);
			var fontlist:Array = _fontMap[_font] as Array;
			_fontMap[_font] = fontlist.concat(fonts);
			if (onLoadedComplete != null)
			{
				onLoadedComplete();
			}
		}
		
		//
		private function setTextFormat(text:String, beginIndex:int):void
		{
			//var textFormat:TextFormat = _textField.defaultTextFormat;
			var textFormat:TextFormat = _textField.getTextFormat();
			var ratio:int;
			var numChars:int = text.length;
			for (var i:int = 0; i < numChars; i++)
			{
				ratio = InCommonUseWordTable.getRatio(text.charAt(i));
				if (ratio < 0)
				{
					continue;
				}
				textFormat.font = String(_font + ratio);
				_textField.setTextFormat(textFormat, beginIndex + i);
				//_textField.defaultTextFormat = textFormat;
			}
			if (onRenderComplete != null)
			{
				//setTimeout(onRenderComplete, 1000);
				onRenderComplete();
			}
		}
		
		//加载超时
		private function loadFontTimeout():void
		{
			errorHandler(null);
		}
		
		//加载过程
		private function progressHandler(event:LoaderEvent):void
		{
			var bytesTotal:int = 100;
			var bytesLoaded:int = bytesTotal * event.target.progress;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
		}
		
		//加载失败
		private function errorHandler(event:LoaderEvent):void 
		{
			_loading = false;
			clearTimeout(_loadIntervalID);
			if (onFail != null)
			{
				onFail();
			}
		}
		
	}//end class
}