﻿package org.asclub.text
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

	import org.asclub.core.IDestroyable;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.ScrollRectPlugin;
	
	public class ScrollVText extends Sprite implements IDestroyable
	{
		public var _tf1:TextField;
		private var _tf2:TextField;
		private var _textFormat:TextFormat;
		private var _width:Number;
		private var _msgInfo:Array;
		private var _currentMsgIndex:int;
		
		//计时器
		private var _textTimer:Timer;
		
		//缓动间隔时间(毫秒为单位)
		private const TWEEN_DURATION:uint = 1200;
		
		//切换间隔时间(毫秒为单位)
		private var _interval:Number;
		
		//缓动类型
		public var ease:Function;
		
		/**
		 * 构造函数
		 * @param	w                宽度
		 * @param	textFormat       文本样式
		 */
		public function ScrollVText(w:Number, textFormat:TextFormat = null)
		{
			_width = w;
			_textFormat = textFormat;
			init();
		}
		
		/**
		 * 在不需要此实例时销毁掉，由外部调用
		 */
		public function destroy():void
		{
			if(_textTimer) _textTimer.removeEventListener(TimerEvent.TIMER, textTimerHandler);
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
			_interval = Math.max(delay, TWEEN_DURATION);
			if (!_textTimer)
			{
				_textTimer = new Timer(_interval);
				_textTimer.addEventListener(TimerEvent.TIMER, textTimerHandler);
			}
			else 
			{
				_textTimer.delay = _interval;
			}
			_textTimer.start();
			getPrevTextField().htmlText = _msgInfo[0];
			_tf1.y = 0;
			_tf2.y = _tf1.y + _tf1.height;
			//在外部设置遮罩会跟scrollRect起冲突
			if (this.mask == null)
			{
				this.scrollRect = new Rectangle(0, 0, _width, _tf1.height);
			}
		}
		
		/**
		 * 是否在运行
		 */
		public function get running():Boolean
		{
			return _textTimer && _textTimer.running;
		}
		
		/**
		 * 文本停止滚动
		 */
		public function stop():void
		{
			if (running)
			{
				_textTimer.reset();
			}
		}
		
		/**
		 * 添加一条滚动文本
		 * @param	item
		 */
		public function addItem(item:String):void
		{
			_msgInfo.push(item);
			if (_msgInfo.length == 1)
			{
				getPrevTextField().htmlText = _msgInfo[0];
			}
		}
		
		/**
		 * 删除一条滚动文本
		 * @param	item
		 */
		public function removeItem(item:String):void
		{
			
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
		
		//缓动结束后，将上面的文本放于下面的文本的正下方(然后依此反复)
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
			var tf:TextField = new TextField();
			//tf.border = true;
			tf.width = _width;
			tf.selectable = false;
			tf.multiline = true;
			tf.wordWrap = true;
			if (_textFormat)
			{
				_textFormat.align = _textFormat.align || TextFormatAlign.CENTER;
				tf.defaultTextFormat = _textFormat;
				tf.autoSize = _textFormat.align;
			}
			else
			{
				tf.text = " ";
				tf.height = tf.textHeight + 4;
			}
			return tf;
		}
		
		//计时器运行时，使用TweenLite将两个文本框在Y轴上提高，缓动结束后将上面的文本框放到下面的文本框的下面，随着计时器的运行如此往复。
		private function textTimerHandler(evt:TimerEvent):void
		{
			_currentMsgIndex >= _msgInfo.length - 1 ? (_currentMsgIndex = 0) : _currentMsgIndex++;
			getNextTextField().htmlText = _msgInfo[_currentMsgIndex];
			
			//将上面的文本提升到- getPrevTextField().height 的位置
			TweenLite.to(getPrevTextField(), TWEEN_DURATION * 0.001, { y: - getPrevTextField().height, ease:ease , onComplete:tweenLiteFinishHandler} );
			//将下面的文本提示到坐标0位置
			TweenLite.to(getNextTextField(), TWEEN_DURATION * 0.001, { y:0, ease:ease  } );
			//TweenLite.to(getNextTextField(), 1.2, { y:0, ease:ease} );
			//对滚动矩形区域进行缓动(因为有的文本的多行，有的是单行)
			if (this.mask == null)
			{
				TweenLite.to(this, TWEEN_DURATION * 0.001, {scrollRect:{x:0, y:0, width:_width, height:getNextTextField().height}, ease:ease}); 
			}
			//在这里时间要设为1.3，之所以要比缓动的总时间1.2长0.1秒的原因其实我也不知道，但是缓动结束回调的时间如果设为跟缓动的总时间一样长
			//的话，会出现缓动尚未完全结束，缓动结束回调函数就被调用,从而产生干扰
			//TweenLite.delayedCall(1.3,tweenLiteFinishHandler,null);
			
			//var t:TweenMax = TweenMax.to(mc, 1, {x:300,onComplete:completeHandler,onCompleteParams:["sss"]});
		}
		
	}//end of class
}