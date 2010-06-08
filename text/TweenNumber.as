package org.asclub.text
{
	import fl.motion.ITween;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.asclub.data.NumberUtils;
	
	public final class TweenNumber
	{
		private var _textTimer:Timer;
		private var _targetTF:TextField;
		private var _currentValue:Number;
		private var _tweenNumberArray:Array;
		
		public function TweenNumber(targetTF:TextField)
		{
			_targetTF = targetTF;
			_targetTF.selectable = false;
			
			_tweenNumberArray = [];
			_currentValue = 0;
		}
		
		public function to(duration:Number,endValue:Number,trunc:Boolean = true,startValue:Number = 0,intervalTime:Number = 80):void
		{
			if (startValue != 0) _currentValue = startValue;
			var times:int = duration / intervalTime;
			_tweenNumberArray = NumberUtils.createStepsBetween(_currentValue, endValue, times - 1);
			_tweenNumberArray.push(endValue);
			if (trunc)
			{
				_tweenNumberArray.forEach(function(element:*, index:int, _tweenNumberArray:Array):void
					{
						_tweenNumberArray[index] = int(element);
					}
				);
			}
			trace("_tweenNumberArray:" + _tweenNumberArray);
			_targetTF.text = String(_currentValue);
			if (!_textTimer)
			{
				_textTimer = new Timer(intervalTime,times);
				_textTimer.addEventListener(TimerEvent.TIMER,textTimerHandler);
				_textTimer.start();
			}
			else
			{
				_textTimer.reset();
				_textTimer.delay = intervalTime;
				_textTimer.repeatCount = times;
				_textTimer.start();
			}
		}
		
		//计时器
		private function textTimerHandler(evt:TimerEvent):void
		{
			trace(evt.currentTarget.currentCount);
			_currentValue = _tweenNumberArray[evt.currentTarget.currentCount - 1];
			_targetTF.text = String(_currentValue);
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