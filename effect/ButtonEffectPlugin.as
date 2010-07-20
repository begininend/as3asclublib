package org.asclub.effect
{
	//import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import com.greensock.TweenMax;
	
	import org.asclub.core.IDestroyable;
	import org.asclub.data.ObjectUtil;
	
	public final class ButtonEffectPlugin implements IDestroyable
	{
		//产生效果的元件.之所以用Object类型而不用InteractiveObject类型，是因为InteractiveObject是静态类,在需要帧处理时无法动态添加frame属性
		private var _instance:Object;
		
		//缓动效果器
		private var _tweenMax:TweenMax;
		
		//缓动总持续时间
		private var _duration:Number;
		
		//当前缓动已运行到的时间点
		private var _targetTime:Number;
		
		//起始时效果
		private var _fromVars:Object;
		
		//结束时效果
		private var _toVars:Object;
		
		//缓动类型
		public var ease:Function;
		
		private var t1:int;
		
		/**
		 * 构造函数
		 * @param	instance
		 */
		public function ButtonEffectPlugin(instance:InteractiveObject)
		{
			_instance = instance;
			_fromVars = { };
			_toVars = { };
			_targetTime = 0;
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
				_duration = duration;
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
		}
		
		//鼠标移上元件时
		private function instanceRollOverHandler(event:MouseEvent):void
		{
			trace("鼠标移上元件时");
			trace("_targetTime:" + _targetTime);
			t1 = getTimer();
			_instance.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_tweenMax = TweenMax.to(_instance, _duration - _targetTime, _toVars);
		}
		
		//鼠标移开元件时
		private function instanceRollOutHandler(event:MouseEvent):void
		{
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
		}
		
		//帧频计时器
		private function enterFrameHandler(event:Event):void
		{
			if (_tweenMax.currentProgress == 1)
			{
				_instance.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			_targetTime = _duration - _tweenMax.currentTime;
			
		}
		
	}//end of class
}