package org.asclub.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	public class SingleSwf extends EventDispatcher
	{
		private var _Sender_lc:LocalConnection;
		private var _receiver_lc:LocalConnection;
		public function SingleSwf()
		{
			_Sender_lc = new LocalConnection();
			_receiver_lc = new LocalConnection();
			_Sender_lc.addEventListener(StatusEvent.STATUS, senderLCStatusHandler);
			_Sender_lc.send("singleswf", "being");
		}
		
		//在 LocalConnection 对象报告其状态时调度
		private function senderLCStatusHandler(evt:StatusEvent):void
		{
			trace(evt.level);
			switch(evt.level)
			{
				case "status":
					dispatchEvent(new Event("onError"));
				break;
				case "error":
					_receiver_lc.connect("singleswf");
					_receiver_lc.client = { };
					_receiver_lc.client.being = being;
				break;
			}
		}
		
		private function being():void
		{
			dispatchEvent(new Event("onError"));
		}
	}//end of class
}