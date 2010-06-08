package org.asclub.events
{
	import flash.events.Event;
	public class DatePickerEvent extends Event
	{
		public static const CHANGE:String = "change";
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		public static const ITEM_CLICK:String = "itemClick";
		public static const SCROLL:String = "scroll";
		private var _date:Date;
		public function DatePickerEvent(type:String, date:Date = null)
		{
			_date = date;
			super(type);
		}
		
		/**
		 * 获取日期
		 */
		public function get date():Date
		{
			return _date;
		}
		
	}//end of class
}