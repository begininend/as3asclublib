package org.asclub.text
{
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.utils.Timer;
	
	import org.asclub.text.TextUtil;
	
	public class AutoScrollHText
	{
		private var _textTimer:Timer;
		private var _content:String;
		private var _speed:int;
		private var _targetTF:TextField;
		
		public function set styleSheet(css:StyleSheet):void
		{
			_targetTF.styleSheet = css;
		}
		
		public function AutoScrollHText(targetTF:TextField)
		{
			_targetTF = targetTF;
			_targetTF.selectable = false;
			_targetTF.addEventListener(MouseEvent.ROLL_OVER, targetTFRollOverHandler);
			_targetTF.addEventListener(MouseEvent.ROLL_OUT, targetTFRollOutHandler);
		}
		
		//获取与文本框等宽的空白字符
		private function getWhitespaceChar():String
		{
			var whitespaceChar:String = "";
			var whitespaceCharLength:int = _targetTF.width / TextUtil.getSingleWhitespaceWidth(_targetTF.getTextFormat());
			for (var i:int = 0; i < whitespaceCharLength; i++)
			{
				whitespaceChar += " ";
			}
			return whitespaceChar;
		}
		
		//插入空白字符
		private function insertWhitespace(char:String):String
		{
			var WhitespaceChar:String = getWhitespaceChar();
			char = WhitespaceChar + char;
			char += WhitespaceChar;
			return char;
		}
		
		/**
		 * 更新滚动文本
		 * @param	char      要滚动的文本
		 * @param	speed     滚动速度(以像素为单位)
		 */
		public function updateScroll(char:String,speed:int = 1):void
		{
			_targetTF.scrollH = 0;
			_targetTF.htmlText = char;
			_speed = speed;
			if (_targetTF.textWidth < _targetTF.width)
			{
				if(_textTimer != null)
				{
					_textTimer.reset();
					_textTimer.removeEventListener(TimerEvent.TIMER, textTimerHandler);
					_textTimer = null;
				}
				return;
			}
			_targetTF.htmlText = insertWhitespace(char);
			if (!_textTimer)
			{
				_textTimer = new Timer(50);
				_textTimer.addEventListener(TimerEvent.TIMER,textTimerHandler);
				_textTimer.start();
			}
		}
		
		//鼠标移上文本时
		private function targetTFRollOverHandler(evt:MouseEvent):void
		{
			if (_textTimer) _textTimer.stop();
		}
		
		//鼠标移开文本时
		private function targetTFRollOutHandler(evt:MouseEvent):void
		{
			if (_textTimer) _textTimer.start();
		}
		
		//计时器
		private function textTimerHandler(Evt:TimerEvent):void
		{
			if (_targetTF.scrollH == _targetTF.maxScrollH)
			{
				_targetTF.scrollH = 0;
			}
			_targetTF.scrollH += _speed;
		}
		
		/**
		 * 在不需要此实例时销毁掉，由外部调用
		 */
		public function dispose():void
		{
			_targetTF.removeEventListener(MouseEvent.ROLL_OVER, targetTFRollOverHandler);
			_targetTF.removeEventListener(MouseEvent.ROLL_OUT, targetTFRollOutHandler);
			if(_textTimer) _textTimer.removeEventListener(TimerEvent.TIMER, textTimerHandler);
		}
	}//end of class
}