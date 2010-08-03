package org.asclub.controls.events
{
	import flash.events.Event;
	public class TabBarEvent extends Event
	{
		public var index:int;
		public var item:Object;
		public static const CHANGE:String = "change";
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		
		public function TabBarEvent(type:String,index:int,item:Object)
		{
			this.index = index;
			this.item = item;
			super(type);
		}
		
		override public function clone():TabBarEvent
		{
			return new TabBarEvent(this.type, this.index, this.item);
		}
		
	}//end of class
}