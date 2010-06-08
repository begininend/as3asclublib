package org.asclub.events
{
	import flash.events.Event;
	public class DataChangeEvent extends Event
	{
		protected var _items:Array;
        protected var _changeType:String;
        protected var _startIndex:int;
        protected var _endIndex:int;
		public static const ADD:String = "add";
		public static const CHANGE:String = "change";
		public static const PRE_DATA_CHANGE:String = "preDataChange";
        public static const DATA_CHANGE:String = "dataChange";
		public static const REMOVE:String = "remove";
		public static const REMOVE_ALL:String = "removeAll";
        public static const INVALIDATE:String = "invalidate";
        public static const INVALIDATE_ALL:String = "invalidateAll";
		public static const REPLACE:String = "replace";
		public static const SORT:String = "sort";
		public function DataChangeEvent(eventType:String, changeType:String, items:Array, startIndex:int = -1, endIndex:int = -1)
		{
			super(eventType);
            _changeType = changeType;
            _startIndex = startIndex;
            _items = items;
            _endIndex = (endIndex == -1 ? (_startIndex) : (endIndex));
		}
		
		public function get items() : Array
        {
            return _items;
        }

        public function get changeType() : String
        {
            return _changeType;
        }

        public function get startIndex() : int
        {
            return _startIndex;
        }

        public function get endIndex() : int
        {
            return _endIndex;
        }

        override public function clone() : Event
        {
            return new DataChangeEvent(type, _changeType, _items, _startIndex, _endIndex);
        }
	}//end of class
}