package org.asclub.string
{
    import flash.utils.ByteArray;

    public class URLEncode
    {

        public function URLEncode()
        {
            return;
        }// end function

        public static function urlEncodeUtf8String(param1:String) : String
        {
            if (!param1)
            {
                return "";
            }
            var _loc_2:* = new ByteArray();
            var _loc_3:Number;
            _loc_2.writeUTFBytes(param1);
            _loc_2.position = 0;
            var _loc_4:String = "";
            var _loc_5:int;
            while (_loc_5 < _loc_2.length)
            {
                
                _loc_3 = _loc_2[_loc_5];
                if (_loc_3 < 128)
                {
                    _loc_4 += String.fromCharCode(_loc_3);
                }
                else if (_loc_3 > 127 && _loc_3 < 2048)
                {
                    _loc_4 += String.fromCharCode(_loc_3 >> 6 | 192);
                    _loc_4 += String.fromCharCode(_loc_3 & 63 | 128);
                }
                else
                {
                    _loc_4 += String.fromCharCode(_loc_3 >> 12 | 224);
                    _loc_4 += String.fromCharCode(_loc_3 >> 6 & 63 | 128);
                    _loc_4 += String.fromCharCode(_loc_3 & 63 | 128);
                }
                _loc_5++;
            }
            return urlEncode(_loc_4);
        }// end function

        public static function urlEncodeSpecial(param1:String) : String
        {
            if (!param1)
            {
                return "";
            }
            var _loc_2:Number;
            var _loc_3:String = "";
            var _loc_4:int;
            while (_loc_4 < param1.length)
            {
                
                _loc_2 = param1.charCodeAt(_loc_4);
                if (_loc_2 < 128)
                {
                    _loc_3 = _loc_3 + String.fromCharCode(_loc_2);
                }
                else if (_loc_2 > 127 && _loc_2 < 2048)
                {
                    _loc_3 = _loc_3 + String.fromCharCode(_loc_2 >> 6 | 192);
                    _loc_3 = _loc_3 + String.fromCharCode(_loc_2 & 63 | 128);
                }
                else
                {
                    _loc_3 = _loc_3 + String.fromCharCode(_loc_2 >> 12 | 224);
                    _loc_3 = _loc_3 + String.fromCharCode(_loc_2 >> 6 & 63 | 128);
                    _loc_3 = _loc_3 + String.fromCharCode(_loc_2 & 63 | 128);
                }
                _loc_4++;
            }
            return urlEncode(_loc_3);
        }// end function

        public static function urlEncode(param1:String) : String
        {
            if (!param1)
            {
                return "";
            }
            var _loc_2:String = "";
            var _loc_3:Number;
            var _loc_4:int;
			var numChat:int = param1.length;
            while (_loc_4 < numChat)
            {
                
                _loc_3 = param1.charCodeAt(_loc_4);
                if (_loc_3 >= 48 && _loc_3 <= 57 || _loc_3 >= 65 && _loc_3 <= 90 || _loc_3 >= 97 && _loc_3 <= 122 || _loc_3 == 45 || _loc_3 == 95 || _loc_3 == 46 || _loc_3 == 126)
                {
                    _loc_2 += String.fromCharCode(_loc_3);
                }
                else
                {
                    _loc_2 = _loc_2 + ("%" + _loc_3.toString(16).toUpperCase());
                }
                _loc_4++;
            }
            return _loc_2;
        }// end function

    }
}
