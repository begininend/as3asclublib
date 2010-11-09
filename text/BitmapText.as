package org.asclub.text
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class BitmapText extends Sprite
	{
		private var _text:String = "";
		
		// 用于缓存的Bitmap
		private var _textBitmap:Bitmap;
		
		//
		private var _textField:TextField;
		
		public function BitmapText()
		{
			init();
		}
		
		private function init():void
		{
			_textField = new TextField();
			//_textField.multiline = false;
			_textField.selectable = false;
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 26;
			textFormat.color = 0xffffff;
			_textField.defaultTextFormat = textFormat;
			//addChild(_textField);
			
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.sharpness = -15;
		}
		
		/**
		 * 更新位图文字
		 * 
		 */			
		private function rerenderTextBitmap():void
		{
			if (_textBitmap)
			{
				this.removeChild(_textBitmap);
				_textBitmap.bitmapData.dispose();
			}
			
			//如果是斜体宽度增加
			//var textWidth:Number = _textField.textWidth + 4;
			//if (_textField.defaultTextFormat.italic)
			//{
				//textWidth += _textField.getLineMetrics(0).height * Math.sin(15 / 180 * Math.PI);
			//}
			//_textField.width = _textField.textWidth + 4;
			//_textField.height = _textField.textHeight + 4;
			_textBitmap = new Bitmap(new BitmapData(Math.ceil(_textField.width),Math.ceil(_textField.height),true,0),"auto",true);
			_textBitmap.x = _textField.x;
			_textBitmap.y = _textField.y;
			this.addChild(_textBitmap);
			_textBitmap.bitmapData.draw(_textField);
			_textBitmap.visible = false;
			addChild(_textField);
			//_textBitmap.bitmapData.draw(_textField,null,null,null,null,true);
			
			var size:int = int(getTextFormat().size);
			if (! _textField.embedFonts && size > 48)
			{
				var rect:Rectangle = new Rectangle(0, 0, _textBitmap.bitmapData.width, _textBitmap.bitmapData.height);
				var pt:Point = new Point(0, 0);
				var filter:BlurFilter = new BlurFilter(size / 127 * 1.5,size / 127 * 1.5);
				_textBitmap.bitmapData.applyFilter(_textBitmap.bitmapData, rect, pt, filter);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		// GETTER AND SETTER
		//------------------------------------------------------------------------------------------------
		
		public function set autoSize(value:String):void
		{
			_textField.autoSize = value;
		}
		
		/**
		 * 设置文本是否显示边框
		 */
		public function set border(value:Boolean):void
		{
			_textField.border = value;
		}
		
		/**
		 * 设置是否使用嵌入字体进行渲染
		 */
		public function set embedFonts(value:Boolean):void
		{
			_textField.embedFonts = value;
		}
		
		/**
		 * 获取默认字体样式
		 */
		public function get defaultTextFormat():TextFormat
		{
			return _textField.defaultTextFormat;
		}
		
		/**
		 * 设置高度
		 */
		override public function set height(value:Number):void
		{
			_textField.height = value;
			//super.height = value;
		}
		
		
		
		/**
		 * 获取文本内容
		 */
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * 获取文本内容
		 */
		public function set text(value:String):void
		{
			if (value == _text)
			{
				return;
			}
			_text = value;
			_textField.text = value;
			
			rerenderTextBitmap();
		}
		
		/**
		 * 文字输入限制
		 * @return 
		 * 
		 */
		public function get restrict():String
		{
			return _textField.restrict;
		}
		
		public function set restrict(value:String):void
		{
			_textField.restrict = value;
		}
		
		/**
		 * 设置宽度
		 */
		override public function set width(value:Number):void
		{
			_textField.width = value;
			//super.width = value;
		}
		
		/**
		 * 一个布尔值，指示文本字段是否自动换行。 
		 */
		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
		}
		
		//------------------------------------------------------------------------------------------------
		// PUBLIC
		//------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 * @param	format:TextFormat — 一个包含字符和段落格式设置信息的 TextFormat 对象。
		 * @param	beginIndex:int (default = -1) — 指定所需文本范围内第一个字符的从零开始的索引位置。
		 * @param	endIndex:int (default = -1) — 指定所需文本范围内最后一个字符的从零开始的索引位置。
		 */
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void
		{
			_textField.setTextFormat(format, beginIndex, endIndex);
			_textField.defaultTextFormat = format;
			rerenderTextBitmap();
		}
		
		/**
		 * 
		 * @param	beginIndex
		 * @param	endIndex
		 * @return
		 */
		public function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat
		{
			return _textField.getTextFormat(beginIndex, endIndex);
		}
	}//end class
}