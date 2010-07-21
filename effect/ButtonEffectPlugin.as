package org.asclub.effect
{
	//import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	import com.greensock.TweenMax;
	
	import org.asclub.core.IDestroyable;
	import org.asclub.data.ObjectUtil;
	
	public final class ButtonEffectPlugin implements IDestroyable
	{
		//产生效果的元件.之所以用Object类型而不用InteractiveObject类型，是因为InteractiveObject是静态类,在需要帧处理时无法动态添加frame属性
		private var _instance:Object;
		
		//缓动效果器
		private var _tweenMax:TweenMax;
		
		//缓动总持续时间，以毫秒为单位
		private var _duration:Number;
		
		//当前缓动已运行到的时间点
		private var _currentTime:Number = 0;
		
		//起始时效果
		private var _fromVars:Object = {};
		
		//结束时效果
		private var _toVars:Object = {};
		
		//缓动类型
		public var ease:Function;
		
		//正向计时器
		private var _increaseTimer:Timer;
		
		//反向计时器
		private var _decreaseTimer:Timer;
		
		//计时器事件间的延迟（以毫秒为单位）。 
		private var _delay:int = 40;
		
		private var t1:int;
		
		/**
		 * 构造函数
		 * @param	instance
		 */
		public function ButtonEffectPlugin(instance:InteractiveObject)
		{
			_instance = instance;
			_instance.addEventListener(MouseEvent.ROLL_OVER, instanceRollOverHandler);
			_instance.addEventListener(MouseEvent.ROLL_OUT, instanceRollOutHandler);
		}
		
		/**
		 * 添加效果
		 * @param	duration   持续时间，以秒为单位
		 * @param	fromVars   鼠标移出后的效果
		 * @param	toVars     鼠标移入后的效果
		 */
		public function addEffect(duration:Number, fromVars:Object, toVars:Object):void
		{
			if (isNaN(_duration))
			{
				//_duration以毫秒为单位，因为在下面的计时器中会一直使用_duration，如果不以毫秒为单位，每次计时器运算_duration都要X1000,影响效率
				_duration = duration * 1000;
			}
			_fromVars = ObjectUtil.mergeObjects(fromVars,_fromVars);
			_toVars = ObjectUtil.mergeObjects(toVars,_toVars);
		}
		
		/**
		 * 删除任何事件侦听器,帮助以便及时收集垃圾。
		 */
		public function destroy():void
		{
			_fromVars = { };
			_toVars = { };
			if (_instance != null)
			{
				_instance.removeEventListener(MouseEvent.ROLL_OVER, instanceRollOverHandler);
				_instance.removeEventListener(MouseEvent.ROLL_OUT, instanceRollOutHandler);
			}
			if (_increaseTimer != null)
			{
				_increaseTimer.removeEventListener(TimerEvent.TIMER, increaseTimerHandler);
				_increaseTimer = null;
			}
			if (_decreaseTimer != null)
			{
				_decreaseTimer.removeEventListener(TimerEvent.TIMER,decreaseTimerHandler);
				_decreaseTimer = null;
			}
		}
		
		//鼠标移上元件时
		private function instanceRollOverHandler(event:MouseEvent):void
		{
			/*
			trace("鼠标移上元件时");
			trace("_targetTime:" + _targetTime);
			t1 = getTimer();
			_instance.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_tweenMax = TweenMax.to(_instance, _duration - _targetTime, _toVars);
			*/
			
			
			_increaseTimer = new Timer(_delay);
			_increaseTimer.addEventListener(TimerEvent.TIMER,increaseTimerHandler);
			_increaseTimer.start();
			if(_decreaseTimer != null)
			{
				_decreaseTimer.reset();
				_decreaseTimer = null;
			}
			trace("鼠标移上元件时:" + _currentTime * 0.001);
			_tweenMax = TweenMax.to(_instance,(_duration - _currentTime) / 1000, _toVars);
			
		}
		
		//鼠标移开元件时
		private function instanceRollOutHandler(event:MouseEvent):void
		{
			/*
			trace("鼠标移开元件时", "逗留时间:" ,(getTimer() - t1));
			
			if (TweenMax.isTweening(_instance))
			{
				//如果鼠标移开元件时缓动还在进行，说明向终点跑的缓动还没跑到终点，这是应该按原路返回，
				//向前跑花了多少时间，返回的时候也要花同样是时间
				_targetTime = _tweenMax.currentTime;
			}
			else
			{
				//如果鼠标移开元件时缓动没有在进行，则进行全时长的返回运动
				_targetTime = _duration;
			}
			trace("_targetTime:" + _targetTime);
			_tweenMax = TweenMax.to(_instance, _targetTime, _fromVars);
			_instance.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			*/
			
			_decreaseTimer = new Timer(_delay);
			_decreaseTimer.addEventListener(TimerEvent.TIMER,decreaseTimerHandler);
			_decreaseTimer.start();
			if(_increaseTimer != null)
			{
				_increaseTimer.reset();
				_increaseTimer = null;
			}
			trace(_currentTime * 0.001);
			_tweenMax = TweenMax.to(_instance, _currentTime * 0.001, _fromVars);
		}
		
		//正向计时器
		private function increaseTimerHandler(event:TimerEvent):void
		{
			_currentTime += _delay;
			if(_currentTime >= _duration)
			{
				_increaseTimer.reset();
				_increaseTimer = null;
				_currentTime = _duration;
			}
			//trace(_currentTime);
		}

		//反向计时器
		private function decreaseTimerHandler(event:TimerEvent):void
		{
			_currentTime -= _delay;
			if(_currentTime <= 0)
			{
				_decreaseTimer.reset();
				_decreaseTimer = null;
				_currentTime = 0;
			}
			//trace(_currentTime);
		}
		
	}//end of class
}