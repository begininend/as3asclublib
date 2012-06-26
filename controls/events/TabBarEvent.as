package org.asclub.controls.events
{
	import flash.events.Event;
	public class TabBarEvent extends Event
	{
		//进行更改之前的从零开始的索引。
		public var oldIndex:int;
		
		//进行更改之后的从零开始的索引。
		public var index:int;
		
		public var item:Object;
		public static const CHANGE:String = "change";
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		
		public function TabBarEvent(type:String,oldIndex:int,index:int,item:Object)
		{
			this.oldIndex = oldIndex;
			this.index = index;
			this.item = item;
			super(type);
		}
		
		override public function clone():Event
		{
			return new TabBarEvent(this.type, this.oldIndex, this.index, this.item);
		}
		
	}//end of class
}