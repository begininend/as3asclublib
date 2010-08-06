package com.riaoo.events
{
	import flash.events.Event;
	
	/**
	 * 只要 Ticker 对象达到 Ticker.delay 属性指定的间隔，Flash ® Player 就调度 TickerEvent 对象。
	 * 
	 * @see com.riaoo.utils.Ticker
	 * 
	 * @author Y.Boy
	 * 
	 */	
	public class TickerEvent extends Event
	{
		/**
		 * 定义 ticker 事件对象的 type 属性。
		 */		
		public static const TICKER:String = "ticker";
		
		/**
		 * 定义 tickerComplete 事件对象的 type 属性。
		 */		
		public static const TICKER_COMPLETE:String = "tickerComplete";
		
		
		
		/**
		 * 每个 TickerEvent.TICKER 事件触发所需要的<strong>实际</strong>延迟间隔。
		 */		
		public var realDelay:int;
		
		/**
		 * 构造函数。
		 * @param type 事件类型。
		 * @param offset 每个 TickerEvent.TICKER 事件触发所需要的时间与 Ticker.delay 的差。
		 * 
		 */		
		public function TickerEvent(type:String, realDelay:int = 0)
		{
			super(type, bubbles, cancelable);
			this.realDelay = realDelay;
		}
		
		/**
		 * 创建 TickerEvent 对象的副本，并设置每个属性的值以匹配原始属性值。
		 * @return 
		 * 
		 */		
		override public function clone():Event
		{
			return new TickerEvent(TickerEvent.TICKER, this.realDelay);
		}
		
	}
}