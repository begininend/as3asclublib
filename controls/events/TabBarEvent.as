package org.asclub.controls.events
{
	import flash.events.Event;
	public class TabBarEvent extends Event
	{
		private var _index:int;
		public static const CHANGE:String = "change";
		public static const ITEM_CLICK:String = "itemClick";
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		
		public function TabBarEvent(type:String,index:int)
		{
			_index = index;
			super(type);
		}
		
		/**
		 * 获取标签页索引
		 */
		public function get tabBarIndex():int
		{
			return _index;
		}
	}//end of class
}