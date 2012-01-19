package org.asclub.geom
{
	import flash.geom.Point;
	
	public final class PointUtil
	{
		public function GetCrossPoint(param1:Point, param2:Number, param3:Point, param4:Number) : Point
        {
            var _loc_5:Number;
            var _loc_6:Number;
            var _loc_7:Number;
            var _loc_8:Number;
            var _loc_9:* = param2 % 180 == 0 ? (1) : (param2 % 90 == 0 ? (-1) : (0));
            var _loc_10:* = param4 % 180 == 0 ? (1) : (param4 % 90 == 0 ? (-1) : (0));
            if (_loc_9 == 0)
            {
                var _loc_12:* = Math.tan(param2 * Math.PI / 180);
                _loc_5 = Math.tan(param2 * Math.PI / 180);
            }
            if (_loc_10 == 0)
            {
                var _loc_12:* = Math.tan(param4 * Math.PI / 180);
                _loc_6 = Math.tan(param4 * Math.PI / 180);
            }
            var _loc_11:* = Math.abs(param2) + Math.abs(param4);
            if (Math.abs(param2) + Math.abs(param4) == 180 && param2 * param4 < 0 || int(param2) == int(param4))
            {
                return null;
            }
            if (_loc_9 == 0 && _loc_10 == 0)
            {
                _loc_7 = (_loc_5 * param1.x - param1.y - (_loc_6 * param3.x - param3.y)) / (_loc_5 - _loc_6);
                _loc_8 = (_loc_5 * param3.y - param3.x * _loc_5 * _loc_6 - (_loc_6 * param1.y - param1.x * _loc_5 * _loc_6)) / (_loc_5 - _loc_6);
            }
            else if (_loc_9 == 0 && _loc_10 == 1)
            {
                _loc_8 = param3.y;
                _loc_7 = (_loc_8 - param1.y) / _loc_5 + param1.x;
            }
            else if (_loc_9 == 0 && _loc_10 == -1)
            {
                _loc_7 = param3.x;
                _loc_8 = (_loc_7 - param1.x) * _loc_5 + param1.y;
            }
            else if (_loc_9 == 1 && _loc_10 == 0)
            {
                _loc_8 = param1.y;
                _loc_7 = (_loc_8 - param3.y) / _loc_6 + param3.x;
            }
            else if (_loc_9 == 1 && _loc_10 == -1)
            {
                _loc_8 = param1.y;
                _loc_7 = param3.x;
            }
            else if (_loc_9 == -1 && _loc_10 == 0)
            {
                _loc_7 = param1.x;
                _loc_8 = (_loc_7 - param3.x) * _loc_6 + param3.y;
            }
            else if (_loc_9 == -1 && _loc_10 == 1)
            {
                _loc_7 = param1.x;
                _loc_8 = param3.y;
            }
            else
            {
                return null;
            }
            return new Point(int(_loc_7 * 1000) / 1000, int(_loc_8 * 1000) / 1000);
        }// end function

		/**
		 * 获取两点所构成的角度
		 * @param	param1
		 * @param	param2
		 * @return
		 */
        public static function angle(point1:Point, point2:Point) : Number
        {
            if (!point1 || !point2)
            {
                return 0;
            }
            var _loc_3:Number = point2.x - point1.x;
            var _loc_4:Number = point2.y - point1.y;
            return Math.atan2(_loc_4, _loc_3) * 180 / Math.PI;
        }// end function

		/**
		 * 获取两点间的距离
		 * @param	param1
		 * @param	param2
		 * @return
		 */
        public static function distance(param1:Point, param2:Point) : Number
        {
            if (!param1 || !param2)
            {
                return 0;
            }
            return Point.distance(param1, param2);
        }
		
		
	}//end class
}