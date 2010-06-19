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

	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.ScrollRectPlugin;
	
	public class ScrollVText extends Sprite
	{
		private var _tf1:TextField;
		private var _tf2:TextField;
		private var _textFormat:TextFormat;
		private var _width:Number;
		private var _msgInfo:Array;
		private var _currentMsgIndex:int;
		
		//计时器
		private var _textTimer:Timer;
		
		//缓动间隔时间
		public var _interval:Number;
		
		//缓动类型
		public var ease:Function;
		
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
			//activation is permanent in the SWF, so this line only needs to be run once.
			TweenPlugin.activate([ScrollRectPlugin]);
			
			_msgInfo = [];
			_currentMsgIndex = 0;
			_tf1 = createTextField();
			_tf2 = createTextField();
			_tf2.y = _tf1.y + _tf1.height;
			
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
		
		/**
		 * 开始滚动
		 * @param	delay    每次间隔时间(以毫秒为单位)
		 */
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
			else 
			{
				_textTimer.delay = _interval;
			}
			getPrevTextField().htmlText = _msgInfo[0];
			_tf1.y = 0;
			_tf2.y = _tf1.y + _tf1.height;
			this.scrollRect = new Rectangle(0, 0, _width, _tf1.height);
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
			
			TweenLite.to(getPrevTextField(), 1.2, {y: - getPrevTextField().height,ease:ease} );
			TweenLite.to(getNextTextField(), 1.2, { y:0, ease:ease } );
			TweenLite.to(this, 1, {scrollRect:{x:0, y:0, width:_width, height:getNextTextField().height}, ease:ease}); 
			TweenLite.delayedCall(1.3,tweenLiteFinishHandler,null);
		}
		
		//tween
		private function tweenLiteFinishHandler():void
		{
			getPrevTextField().y = getNextTextField().height;
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
			tf.autoSize = (_textFormat.align == null ? TextFormatAlign.CENTER : _textFormat.align);
			tf.defaultTextFormat = _textFormat;
			tf.selectable = false;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.text = " ";
			//tf.height = tf.textHeight + 4;
			//tf.border = true;
			return tf;
		}
		
		/**
		 * 在不需要此实例时销毁掉，由外部调用
		 */
		public function dispose():void
		{
			if(_textTimer) _textTimer.removeEventListener(TimerEvent.TIMER, textTimerHandler);
		}
		
	}//end of class
}