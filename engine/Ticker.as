package com.riaoo.utils
{
	import com.riaoo.events.TickerEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * @eventType com.riaoo.events.TickerEvent
	 */	
	[Event(name="ticker",type="com.riaoo.events.TickerEvent")]
	
	/**
	 * @eventType com.riaoo.events.TickerEvent
	 */	
	[Event(name="tickerComplete",type="com.riaoo.events.TickerEvent")]
	
	/**
	 * Ticker 类是 Timer 类的扩展。可获知每个 TickerEvent.TICKER 事件触发所需要的<strong>实际</strong>延迟间隔（通过 TimerEvent.realDelay 属性可知）。
	 * <br />
	 * 所触发的 TickerEvent.TICKER 对应于 TimerEvent.TIMER ，而 TickerEvent.TICKER_COMPLETE 对应于 TimerEvent.TIMER_COMPLETE 。
	 * 
	 * @see com.riaoo.events.TickerEvent
	 * 
	 * @author Y.Boy
	 * 
	 */	
	public class Ticker extends Timer
	{
		private var getTimer_prev:int; // 上一次对 getTimer() 的取值
		
		public function Ticker(delay:Number, repeatCount:int = 0)
		{
			super(delay, repeatCount);
		}
		
		override public function start():void
		{
			if (!this.running)
			{
				addEventListener(TimerEvent.TIMER, onTimer);
				addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				this.getTimer_prev = getTimer();
				super.start();
			}
		}
		
		override public function stop():void
		{
			removeTimerEventListener();
			super.stop();
		}
		
		override public function reset():void
		{
			removeTimerEventListener();
			super.reset();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			var now:int = getTimer();
			var realDelay:int = now - this.getTimer_prev; // 每个 TickerEvent.TICKER 事件触发所需要的 实际 延迟间隔
			this.getTimer_prev = now;
			
			var tickerEvent:TickerEvent = new TickerEvent(TickerEvent.TICKER, realDelay);
			dispatchEvent(tickerEvent);
		}
		
		private function onTimerComplete(event:TimerEvent):void
		{
			removeTimerEventListener();
			
			var tickerEvent:TickerEvent = new TickerEvent(TickerEvent.TICKER_COMPLETE);
			dispatchEvent(tickerEvent);
		}
		
		private function removeTimerEventListener():void
		{
			removeEventListener(TimerEvent.TIMER, onTimer);
			removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
	}
}