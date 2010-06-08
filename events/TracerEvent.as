﻿package org.asclub.events
{
    import flash.events.Event;

    public class TracerEvent extends Event
    {
        private var _data:String;
        public static const DATA:String = "data";

        public function TracerEvent(param1:String, param2:String, param3:Boolean = false, param4:Boolean = false)
        {
            _data = param2;
            super(param1, param3, param4);
            return;
        }// end function

        public function get data():String
        {
            return _data;
        }// end function

    }
}