package crypt
{

    public class RC4 extends Object
    {
        private static var sbox:Array = new Array(255);
        private static var mykey:Array = new Array(255);

        public function RC4()
        {
            return;
        }// end function

        public static function encrypt(param1:String, param2:String) : String
        {
            var _loc_3:* = strToChars(param1);
            var _loc_4:* = strToChars(param2);
            var _loc_5:* = calculate(_loc_3, _loc_4);
            return charsToHex(_loc_5);
        }// end function

        public static function decrypt(param1:String, param2:String) : String
        {
            var _loc_3:* = hexToChars(param1);
            var _loc_4:* = strToChars(param2);
            var _loc_5:* = calculate(_loc_3, _loc_4);
            return charsToStr(_loc_5);
        }// end function

        private static function initialize(param1:Array)
        {
            var _loc_3:Number;
            var _loc_2:Number;
            var _loc_4:* = param1.length;
            var _loc_5:Number;
            while (_loc_5++ <= 255)
            {
                
                mykey[_loc_5] = param1[_loc_5 % _loc_4];
                sbox[_loc_5] = _loc_5;
            }
            _loc_5 = 0;
            while (_loc_5++ <= 255)
            {
                
                _loc_2 = (_loc_2 + sbox[_loc_5] + mykey[_loc_5]) % 256;
                _loc_3 = sbox[_loc_5];
                sbox[_loc_5] = sbox[_loc_2];
                sbox[_loc_2] = _loc_3;
            }
            return;
        }// end function

        private static function calculate(param1:Array, param2:Array) : Array
        {
            var _loc_6:Number;
            var _loc_7:Number;
            var _loc_8:Number;
            var _loc_10:Number;
            initialize(param2);
            var _loc_3:Number;
            var _loc_4:Number;
            var _loc_5:* = new Array();
            var _loc_9:Number;
            while (_loc_9++ < param1.length)
            {
                
                _loc_3 = (_loc_3 + 1) % 256;
                _loc_4 = (_loc_4 + sbox[_loc_3]) % 256;
                _loc_7 = sbox[_loc_3];
                sbox[_loc_3] = sbox[_loc_4];
                sbox[_loc_4] = _loc_7;
                _loc_10 = (sbox[_loc_3] + sbox[_loc_4]) % 256;
                _loc_6 = sbox[_loc_10];
                _loc_8 = param1[_loc_9] ^ _loc_6;
                _loc_5.push(_loc_8);
            }
            return _loc_5;
        }// end function

        private static function charsToHex(param1:Array) : String
        {
            var _loc_2:* = new String("");
            var _loc_3:* = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f");
            var _loc_4:Number;
            while (_loc_4++ < param1.length)
            {
                
                _loc_2 = _loc_2 + (_loc_3[param1[_loc_4] >> 4] + _loc_3[param1[_loc_4] & 15]);
            }
            return _loc_2;
        }// end function

        private static function hexToChars(param1:String) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:* = param1.substr(0, 2) == "0x" ? (2) : (0);
            while (_loc_3 < param1.length)
            {
                
                _loc_2.push(parseInt(param1.substr(_loc_3, 2), 16));
                _loc_3 = _loc_3 + 2;
            }
            return _loc_2;
        }// end function

        private static function charsToStr(param1:Array) : String
        {
            var _loc_2:* = new String("");
            var _loc_3:Number;
            while (_loc_3++ < param1.length)
            {
                
                _loc_2 = _loc_2 + String.fromCharCode(param1[_loc_3]);
            }
            return _loc_2;
        }// end function

        private static function strToChars(param1:String) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:Number;
            while (_loc_3++ < param1.length)
            {
                
                _loc_2.push(param1.charCodeAt(_loc_3));
            }
            return _loc_2;
        }// end function

    }
}
