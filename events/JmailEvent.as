package org.asclub.events
{
	import flash.events.Event;
	
	public class JmailEvent extends Event
	{
		public static const LOADCOMPLETE:String = "complete";
		
		public function JmailEvent(type:String)
		{
			super(type);
		}
		
	}//end of class
}

