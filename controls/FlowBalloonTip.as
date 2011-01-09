package org.asclub.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	import org.asclub.display.DrawUtil;
	
	/**
	 * 浮动的气球提示（通常在舞台中央漂浮而上,而后消失）
	 */
	public class FlowBalloonTip extends Sprite
	{
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		private var _textTopMargin:int = 5;
		private var _textBottomMargin:int = 5;
		private var _bgSkin:DisplayObject;
		
		public function FlowBalloonTip()
		{
			_textFormat = new TextFormat("宋体", 12, 0xffffff, true);
			_textFormat.leftMargin = 10;
			_textFormat.rightMargin = 10;
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.multiline = false;
			_textField.wordWrap = false;
			_textField.defaultTextFormat = _textFormat;
			_textField.text = "气球提示";
			_textField.y = _textTopMargin;
			_textField.width = 6 + _textField.textWidth;
			_textField.height = 6 + _textField.textHeight;
			addChild(_textField);
			updateView();
		}
		
		/**
		 * 文本与边框的上边距
		 */
		public function set textBottomMargin(value:int):void
		{
			if (_textBottomMargin != value)
			{
				_textBottomMargin = value;
				updateView();
			}
		}
		
		/**
		 * 设置背景皮肤
		 */
		public function set bgSkin(value:DisplayObject):void
		{
			_bgSkin = value;
			updateView();
		}
		
		/**
		 * 设置默认气泡文字样式
		 */
		public function set defaultTextFormat(value:TextFormat):void
		{
			_textFormat = value;
			updateView();
		}
		
		/**
		 * 设置气泡文字样式
		 * @param	format
		 */
		public function setTextFormat(format:TextFormat):void
		{
			_textField.setTextFormat(format);
			updateView();
		}
		
		/**
		 * 设置此气泡的文本
		 */
		public function set text(value:String):void
		{
			_textField.htmlText = value;
			_textField.width = 6 + _textField.textWidth;
			_textField.height = 6 + _textField.textHeight;
			updateView();
		}
		
		/**
		 * 文本与边框的上边距
		 */
		public function set textTopMargin(value:int):void
		{
			if (_textTopMargin != value)
			{
				_textTopMargin = value;
				_textField.y = _textTopMargin;
				updateView();
			}
		}
		
		//更新气泡显示
		private function updateView():void
		{
			var w:int = _textField.width;
			var h:int = _textTopMargin + _textField.height + _textBottomMargin;
			if (_bgSkin)
			{
				this.graphics.clear();
				_bgSkin.width = w;
				_bgSkin.height = h;
				return;
			}
			drawBGSkin(w, h);
		}
		
		//绘制背景
		private function drawBGSkin(w:int,h:int):void
		{
			this.graphics.clear();
			//绘制阴影
			DrawUtil.drawRoundRect(this.graphics, w, h, 0x333333, -1, 2, 2, 0.3,9);
			DrawUtil.drawGradientRoundRect(this.graphics, [0xDE0201, 0xAF0000], [100, 100], [0, 255], w, h, 0, 0, 9, "linear", 90);
		}
	}//end class
}