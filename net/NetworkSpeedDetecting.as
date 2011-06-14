package src
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	import src.events.NetworkEvent;
	
	public final class NetworkSpeedDetecting extends EventDispatcher
	{
		//采样次数
		public var numSampling:int = 10;
		
		private var _target:IEventDispatcher;
		
		private var _timer:Timer;
		
		//总字节数
		private var _bytesTotal:int
		
		//上次时间
		private var _lastTime:int;
		//上次已加载字节
		private var _lastBytesLoaded:int = 0;
		
		//上次时间
		private var _lastTimeForTimer:int;
		//上次已加载字节
		private var _lastBytesLoadedForTimer:int = 0;
		
		private var _wrongTimes:int;
		
		private var _lowerLimitSpeed:int = 2 * 1024;
		
		
		public function NetworkSpeedDetecting(target:IEventDispatcher)
		{
			_target = target;
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		public function start():void
		{
			_timer.start();
			_wrongTimes = 0;
			_lastTimeForTimer = _lastTime = getTimer();
			_target.addEventListener(ProgressEvent.PROGRESS, progessHandler);
			_target.addEventListener(Event.COMPLETE, completeHandler);
			_target.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
		}
		
		public function stop():void
		{
			_target.removeEventListener(ProgressEvent.PROGRESS, progessHandler);
			_target.removeEventListener(Event.COMPLETE, completeHandler);
			_target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		private function progessHandler(event:ProgressEvent):void
		{
			_bytesTotal = event.bytesTotal;
			
			var time:int = getTimer() - _lastTime;
			var bytesLoaded:int = event.bytesLoaded - _lastBytesLoaded;
			var speed:int = (bytesLoaded / time) * 1000;
			
			
			if (time > 0)
			{
				_lastTime = getTimer();
				_lastBytesLoaded = event.bytesLoaded;
				
				//trace("time:",time);
				//trace("bytesLoaded:",bytesLoaded);
				//trace("_speed:",_speed);
				//trace("\n");
				
				/*var evt:NetworkEvent = new NetworkEvent(NetworkEvent.SPEED);
				evt.speed = speed;
				this.dispatchEvent(evt);*/
			}
		}
		
		//上传下载完成
		private function completeHandler(event:Event):void
		{
			//当断开网线时也会调度completeHandler
			if (_lastBytesLoaded >= _bytesTotal)
			{
				trace("completeHandler");
				stop();
				dispatchEvent(event);
				//_timer = null;
			}
		}
		
		//IOError错误
		private function IOErrorHandler(event:IOErrorEvent):void
		{
			stop();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			var time:int = getTimer() - _lastTimeForTimer;
			var bytesLoaded:int = _lastBytesLoaded - _lastBytesLoadedForTimer;
			var speed:int = (bytesLoaded / time) * 1000;
			_lastTimeForTimer = getTimer();
			_lastBytesLoadedForTimer = _lastBytesLoaded;
			trace("bytesLoaded:",bytesLoaded);
			
			if (speed < _lowerLimitSpeed)
			{
				//如果网速慢于最低限制，则进行记录
				_wrongTimes ++;
			}
			else
			{
				//如果网速突然快起来，以前的慢速记录重置
				_wrongTimes = 0;
			}
			
			var evt:NetworkEvent = new NetworkEvent(NetworkEvent.SPEED);
			evt.speed = speed;
			this.dispatchEvent(evt);
			
			if (_wrongTimes >= numSampling)
			{
				//stop();
				_wrongTimes = 0;
				this.dispatchEvent(new NetworkEvent(NetworkEvent.SLOWNESS));
			}
		}
	}//end class
}