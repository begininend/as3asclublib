package org.asclub.effect
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import org.asclub.core.IDestroyable;
	
	
	public class ButtonEffect implements IDestroyable
	{
		private var _instance:Object;
		private var _currentPropValue:Object;
		private var _increaseTimer:Timer;
		private var _decreaseTimer:Timer;
		
		public function ButtonEffect()
		{
			_currentPropValue = { };
		}
		
		/**
		 * 注册元件
		 * @param	instance
		 */
		public function register(instance:DisplayObject):void
		{
			_instance = instance;
			_instance.addEventListener(MouseEvent.ROLL_OVER, instanceRollOverHandler);
			_instance.addEventListener(MouseEvent.ROLL_OUT, instanceRollOutHandler);
		}
		
		/**
		 * 添加效果
		 * @param	propType     属性名称
		 * @param	beginNum     起始值
		 * @param	finishNum    结束值
		 * @param	durationNum  持续时间
		 * 
		 * _currentPropValue 为注册元件属性集合   _currentPropValue:{ 
		 * 											                   x:{ begin:Number          起始值
		 * 																   finish:Number         结束值
		 * 																   duration:Number       持续时间
		 * 																   currentValue:Number   当前值  
		 * 																 }
		 * 															   ....
		 * 											                 }
		 */
		public function addEffect(propType:String, beginNum:Number, finishNum:Number, durationNum:Number):void
		{
			var prop:Object = {begin:beginNum, finish:finishNum ,duration:durationNum ,currentValue:beginNum};
			_currentPropValue[propType] = prop;
			_instance[propType] = beginNum;
		}
		
		/**
		 * 删除任何事件侦听器,帮助以便及时收集垃圾。
		 */
		public function destroy():void
		{
			if (_instance != null)
			{
				_instance.removeEventListener(MouseEvent.ROLL_OVER, instanceRollOverHandler);
				_instance.removeEventListener(MouseEvent.ROLL_OUT, instanceRollOutHandler);
			}
		}
		
		//鼠标移上元件时
		private function instanceRollOverHandler(evt:MouseEvent):void
		{
			for (var propType:String in _currentPropValue)
			{
				_currentPropValue[propType]["currentValue"] = (propType == "frame" && _instance is MovieClip) ? _instance["currentFrame"] : _instance[propType];
			}
			_increaseTimer = new Timer(40);
			_increaseTimer.addEventListener(TimerEvent.TIMER,increaseTimerHandler);
			_increaseTimer.start();
			if(_decreaseTimer != null)
			{
				_decreaseTimer.reset();
				_decreaseTimer = null;
			}
		}
		
		//鼠标移开元件时
		private function instanceRollOutHandler(evt:MouseEvent):void
		{
			for (var propType:String in _currentPropValue)
			{
				_currentPropValue[propType]["currentValue"] = (propType == "frame" && _instance is MovieClip) ? _instance["currentFrame"] : _instance[propType];
			}
			_decreaseTimer = new Timer(40);
			_decreaseTimer.addEventListener(TimerEvent.TIMER,decreaseTimerHandler);
			_decreaseTimer.start();
			if(_increaseTimer != null)
			{
				_increaseTimer.reset();
				_increaseTimer = null;
			}
		}
		
		//increaseTimer
		private function increaseTimerHandler(evt:TimerEvent):void
		{
			for (var propType:String in _currentPropValue)
			{
				var speed:Number = (_currentPropValue[propType]["finish"] - _currentPropValue[propType]["begin"]) / _currentPropValue[propType]["duration"] * evt.currentTarget.delay;
				if(evt.currentTarget.currentCount * evt.currentTarget.delay > ((_currentPropValue[propType]["finish"] - _currentPropValue[propType]["currentValue"]) / speed  * evt.currentTarget.delay))
				{
					_increaseTimer.reset();
					_increaseTimer = null;
					for (var type:String in _currentPropValue)
					{
						if (type == "frame" && _instance is MovieClip) _instance.gotoAndStop(_instance.totalFrames);
						else _instance[type] = _currentPropValue[type]["finish"];
					}
					return;
				}
				if (propType == "frame" && _instance is MovieClip)  _instance.gotoAndStop(Math.round(_instance.currentFrame + speed));
				else _instance[propType] += (_currentPropValue[propType]["finish"] - _currentPropValue[propType]["begin"]) / _currentPropValue[propType]["duration"] * evt.currentTarget.delay;
				
			}
		}

		//decreaseTimer
		private function decreaseTimerHandler(evt:TimerEvent):void
		{
			for (var propType:String in _currentPropValue)
			{
				var speed:Number = (_currentPropValue[propType]["begin"] - _currentPropValue[propType]["finish"]) / _currentPropValue[propType]["duration"] * evt.currentTarget.delay;
				if(evt.currentTarget.currentCount * evt.currentTarget.delay > ((_currentPropValue[propType]["begin"] - _currentPropValue[propType]["currentValue"]) / speed  * evt.currentTarget.delay))
				{
					_decreaseTimer.reset();
					_decreaseTimer = null;
					if (propType == "frame" && _instance is MovieClip) _instance.gotoAndStop(1);
					else _instance[propType] = _currentPropValue[propType]["begin"];
					return;
				}
				if (propType == "frame" && _instance is MovieClip) _instance.gotoAndStop(Math.round(_instance.currentFrame + speed));
				else _instance[propType] += speed;
				
			}
		}
		
		
	}//end of class
}