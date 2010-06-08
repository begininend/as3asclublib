package org.asclub.text
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import org.asclub.display.DrawUtil;
	
	public class ScrollVText extends Sprite
	{
		private var _tf1:TextField;
		private var _tf2:TextField;
		private var _mask:Sprite;
		private var _textFormat:TextFormat;
		private var _width:Number;
		private var _msgInfo:Array;
		private var _textTimer:Timer;
		public var _interval:Number;
		
		public function ScrollVText(w:Number,textFormat:TextFormat = null)
		{
			_width = w;
			_textFormat = textFormat;
			_tf1 = createTextField();
			_tf1.htmlText = "设置遮罩";
			addChild(_tf1);
		}
		
		private function init():void
		{
			_msgInfo = [];
		}
		
		public function set text(value:String):void
		{
			
		}
		
		public function start(delay:Number):void
		{
			if (_msgInfo.length < 2) return;
			_interval = delay;
		}
		
		public function stop():void
		{
			
		}
		
		public function addItem(item:Object):void
		{
			_msgInfo.push(item);
		}
		
		//创建文本框
		private function createTextField():TextField
		{
			if (_textFormat == null)
			{
				_textFormat = new TextFormat();
				_textFormat.align = TextFormatAlign.CENTER;
			}
			var tf:TextField = new TextField();
			tf.width = _width;
			tf.autoSize = (_textFormat.align == null ? TextFormatAlign.CENTER : _textFormat.align);
			tf.defaultTextFormat = _textFormat;
			tf.selectable = false;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.text = " ";
			trace(tf.height);
			tf.border = true;
			return tf;
		}
		
		//设置遮罩
		private function setMask():void 
		{
			_mask = new Sprite();
			DrawUtil.drawRect(_mask.graphics, 0xffffff, 0xffffff, _tf1.width, _tf1.height);
			addChild(_mask);
			this.mask = _mask;
		}
		
		/**
		 * 在不需要此实例时销毁掉，由外部调用
		 */
		public function dispose():void
		{
			//_targetTF.removeEventListener(MouseEvent.ROLL_OVER, targetTFRollOverHandler);
			//_targetTF.removeEventListener(MouseEvent.ROLL_OUT, targetTFRollOutHandler);
			//if(_textTimer) _textTimer.removeEventListener(TimerEvent.TIMER, textTimerHandler);
		}
		
	}//end of class
}