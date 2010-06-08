package org.asclub.engine
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class MainTimer extends EventDispatcher
	{
		private static var _instance:MainTimer = null;
		private static var _mainTimer:Timer;
		
		//获取 计时器从 0 开始后触发的总次数。 如果已重置了计时器，则只会计入重置后的触发次数。
		public static function get currentCount():int
		{
			return _mainTimer.currentCount;
		}
		
		//获取 计时器的当前状态；如果计时器正在运行，则为 true，否则为 false。
		public static function get running():Boolean
		{
			return _mainTimer.running;
		}
		
		//获取 计时器事件间的延迟（以毫秒为单位）。 
		public static function get delay():Number
		{
			return _mainTimer.delay;
		}
		
		//设置 计时器事件间的延迟（以毫秒为单位）。 
		public static function set delay(value:Number):void
		{
			_mainTimer.delay = value;
		}
		
		//获取 计时器运行总次数。
		public static function get repeatCount():int
		{
			return _mainTimer.repeatCount;
		}
		
		//设置 计时器运行总次数。
		public static function set repeatCount(value:int):void
		{
			_mainTimer.repeatCount = value;
		}
		
		public function MainTimer(privateClass:PrivateClass)
		{
			
		}
		
		//获取单例
		public static function getInstance():MainTimer
		{
			if ( _instance == null ) _instance = new MainTimer(new PrivateClass());
            return _instance;
		}
		
		//如果计时器尚未运行，则启动计时器。
		public static function start(delay:Number, repeatCount:int = 0):void
		{
			if (_instance == null) _instance = new MainTimer(new PrivateClass());
			if (_mainTimer != null) return;
			_mainTimer = new Timer(delay, repeatCount);
			_mainTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_mainTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
            _mainTimer.start();
        }
		
		//如果计时器正在运行，则停止计时器，并将 currentCount 属性设回为 0.
		public static function reset():void
		{
			_mainTimer.reset();
		}
		
		//停止计时器。
		public static function stop():void
		{
			_mainTimer.stop();
		}

		//timerHandler
        private static function timerHandler(evt:TimerEvent):void 
		{
			_instance.dispatchEvent(evt);
        }
		
		//timer 完成
		private static function timerCompleteHandler(evt:TimerEvent):void
		{
			_instance.dispatchEvent(evt);
		}
		
	}//end of class
}

class PrivateClass{}