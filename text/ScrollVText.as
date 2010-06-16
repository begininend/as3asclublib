package org.asclub.text
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.StyleSheet;
	import flash.utils.Timer;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.None;
	import fl.transitions.TweenEvent;

	
	import com.greensock.TweenLite;
	
	public class ScrollVText extends Sprite
	{
		private var _tf1:TextField;
		private var _tf2:TextField;
		private var _textFormat:TextFormat;
		private var Tl:TweenLite;
		private var T2:TweenLite;
		private var _tween:Tween;
		private var _prevPointY:Number;
		private var _nextPointY:Number;
		private var _width:Number;
		private var _msgInfo:Array;
		private var _currentMsgIndex:int;
		private var _textTimer:Timer;
		public var _interval:Number;
		
		/**
		 * 构造函数
		 * @param	w                宽度
		 * @param	textFormat       文本样式
		 */
		public function ScrollVText(w:Number,textFormat:TextFormat = null)
		{
			_width = w;
			_textFormat = textFormat;
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init():void
		{
			_msgInfo = [];
			_currentMsgIndex = 0;
			_tf1 = createTextField();
			_tf1.name = "_tf1";
			_tf1.htmlText = "设置遮罩";
			_tf2 = createTextField();
			_tf2.name = "_tf2";
			_tf2.y = _tf1.y + _tf1.height;
			this.scrollRect = new Rectangle(0, 0, _width, _tf1.height);
			_prevPointY = - _tf1.height;
			_nextPointY = _tf1.height;
			addChild(_tf1);
			addChild(_tf2);
		}
		
		/**
		 * 设置文本css样式
		 */
		public function set styleSheet(css:StyleSheet):void
		{
			_tf1.styleSheet = css;
			_tf2.styleSheet = css;
		}
		
		public function start(delay:Number):void
		{
			if (_msgInfo.length < 2) 
			{
				throw new Error("滚动信息不能少于2条");
				return;
			}
			_interval = delay;
			if (!_textTimer)
			{
				_textTimer = new Timer(_interval);
				_textTimer.addEventListener(TimerEvent.TIMER,textTimerHandler);
				_textTimer.start();
			}
			
			getPrevTextField().alpha = 0.2;
			getPrevTextField().htmlText = _msgInfo[0];
		}
		
		public function stop():void
		{
			
		}
		
		/**
		 * 添加一条滚动文本
		 * @param	item
		 */
		public function addItem(item:String):void
		{
			_msgInfo.push(item);
		}
		
		/**
		 * 删除一条滚动文本
		 * @param	item
		 */
		public function removeItem(item:String):void
		{
			
		}
		
		//计时器
		private function textTimerHandler(evt:TimerEvent):void
		{
			_currentMsgIndex >= _msgInfo.length - 1 ? (_currentMsgIndex = 0) : _currentMsgIndex++;
			getNextTextField().htmlText = _msgInfo[_currentMsgIndex];
			//TweenLite.to(getPrevTextField(), 1.2, {y: _prevPointY} );
			//TweenLite.to(getNextTextField(), 1.2, {y:0} );
			//TweenLite.delayedCall(1.2,tweenLiteFinishHandler,null);
			
			_tween = null;
			_tween = new Tween(getPrevTextField(), "y", None.easeInOut, 0, _prevPointY, 1.2, true);
			_tween = new Tween(getNextTextField(), "y", None.easeInOut, _nextPointY, 0, 1.2, true);
			_tween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
		}
		
		//tween
		private function tweenFinishHandler(evt:TweenEvent):void
		{
			_tween.removeEventListener(TweenEvent.MOTION_FINISH, tweenFinishHandler);
			getPrevTextField().y = _nextPointY;
		}
		
		//tween
		private function tweenLiteFinishHandler():void
		{
			trace("tweenFinishHandler");
			trace(getPrevTextField().name);
			//trace("_nextPointY:" + _nextPointY);
			getPrevTextField().alpha += 0.1;
			getPrevTextField().y += 36;
		}
		
		//获取排在上面的文本
		private function getPrevTextField():TextField
		{
			if (_tf1.y < _tf2.y)
			{
				return _tf1;
			}
			return _tf2;
		}
		
		//获取排在下面的文本
		private function getNextTextField():TextField
		{
			if (_tf1.y > _tf2.y)
			{
				return _tf1;
			}
			return _tf2;
		}
		
		//创建文本框
		private function createTextField():TextField
		{
			if (_textFormat == null)
			{
				_textFormat = new TextFormat();
				_textFormat.align = TextFormatAlign.CENTER;
			}
			if (_textFormat.align == null) 
			{
				_textFormat.align = TextFormatAlign.CENTER;
			}
			var tf:TextField = new TextField();
			tf.width = _width;
			//tf.autoSize = (_textFormat.align == null ? TextFormatAlign.CENTER : _textFormat.align);
			tf.defaultTextFormat = _textFormat;
			tf.selectable = false;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.text = " ";
			tf.height = tf.textHeight + 4;
			//tf.border = true;
			return tf;
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