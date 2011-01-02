package org.asclub.utils
{

    public class MatrixUtils extends Object
    {
        private static const DELTA_INDEX:Array = [0, 0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1, 0.11, 0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.2, 0.21, 0.22, 0.24, 0.25, 0.27, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38, 0.4, 0.42, 0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 0.71, 0.74, 0.77, 0.8, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98, 1, 1.06, 1.12, 1.18, 1.24, 1.3, 1.36, 1.42, 1.48, 1.54, 1.6, 1.66, 1.72, 1.78, 1.84, 1.9, 1.96, 2, 2.12, 2.25, 2.37, 2.5, 2.62, 2.75, 2.87, 3, 3.2, 3.4, 3.6, 3.8, 4, 4.3, 4.7, 4.9, 5, 5.5, 6, 6.5, 6.8, 7, 7.3, 7.5, 7.8, 8, 8.4, 8.7, 9, 9.4, 9.6, 9.8, 10];

        public function MatrixUtils()
        {
            return;
        }// end function

        public static function getDefaultMatrix() : Array
        {
            return [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
        }// end function

        public static function getGrayMatrix() : Array
        {
            return [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0];
        }// end function

        public static function getSobelXMatrix() : Array
        {
            return [1, 2, 1, 0, 0, 0, -1, -2, -1];
        }// end function

        public static function getSobelYMatrix() : Array
        {
            return [-1, 0, 1, -2, 0, 2, -1, 0, 1];
        }// end function

        public static function getGrayMatrixBySimple() : Array
        {
            return [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
        }// end function

        public static function getMixMatrix(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : Array
        {
            var _loc_5:* = getDefaultMatrix();
            if (param1 != 0)
            {
                _loc_5 = multiplyMatrix(_loc_5, getBrightnessMatrix(param1));
            }
            if (param2 != 0)
            {
                _loc_5 = multiplyMatrix(_loc_5, getContrastMatrix(param2));
            }
            if (param3 != 0)
            {
                _loc_5 = multiplyMatrix(_loc_5, getSaturationMatrix(param3));
            }
            if (param4 != 0)
            {
                _loc_5 = multiplyMatrix(_loc_5, getHueMatrix(param4));
            }
            return _loc_5;
        }// end function

        public static function getBrightnessMatrix(param1:Number = 0) : Array
        {
            param1 = param1 > 100 ? (100) : (param1 < -100 ? (-100) : (param1));
            return [1, 0, 0, 0, param1, 0, 1, 0, 0, param1, 0, 0, 1, 0, param1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
        }// end function

        public static function getHueMatrix(param1:Number) : Array
        {
            param1 = param1 > 180 ? (180) : (param1 < -180 ? (-180) : (param1));
            if (param1 == 0 || isNaN(param1))
            {
                return getDefaultMatrix();
            }
            var _loc_2:* = param1 / 180 * Math.PI;
            var _loc_3:* = Math.cos(_loc_2);
            var _loc_4:* = Math.sin(_loc_2);
            var _loc_5:Number;
            var _loc_6:Number;
            var _loc_7:Number;
            return [_loc_5 + _loc_3 * (1 - _loc_5) + _loc_4 * (-_loc_5), _loc_6 + _loc_3 * (-_loc_6) + _loc_4 * (-_loc_6), _loc_7 + _loc_3 * (-_loc_7) + _loc_4 * (1 - _loc_7), 0, 0, _loc_5 + _loc_3 * (-_loc_5) + _loc_4 * 0.143, _loc_6 + _loc_3 * (1 - _loc_6) + _loc_4 * 0.14, _loc_7 + _loc_3 * (-_loc_7) + _loc_4 * -0.283, 0, 0, _loc_5 + _loc_3 * (-_loc_5) + _loc_4 * (-(1 - _loc_5)), _loc_6 + _loc_3 * (-_loc_6) + _loc_4 * _loc_6, _loc_7 + _loc_3 * (1 - _loc_7) + _loc_4 * _loc_7, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
        }// end function

        public static function getAutocontrastMatrix(param1:Number) : Array
        {
            return [param1, 0, 0, 0, 0, 0, param1, 0, 0, 0, 0, 0, param1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
        }// end function

        public static function getContrastMatrix(param1:Number) : Array
        {
            var _loc_2:Number;
            param1 = param1 > 100 ? (100) : (param1 < -100 ? (-100) : (param1));
            if (param1 == 0 || isNaN(param1))
            {
                return getDefaultMatrix();
            }
            if (param1 < 0)
            {
                _loc_2 = 127 + param1 / 100 * 127;
            }
            else
            {
                _loc_2 = param1 % 1;
                if (_loc_2 == 0)
                {
                    _loc_2 = DELTA_INDEX[param1];
                }
                else
                {
                    _loc_2 = DELTA_INDEX[param1 << 0] * (1 - _loc_2) + DELTA_INDEX[(param1 << 0) + 1] * _loc_2;
                }
                _loc_2 = _loc_2 * 127 + 127;
            }
            return [_loc_2 / 127, 0, 0, 0, 0.5 * (127 - _loc_2), 0, _loc_2 / 127, 0, 0, 0.5 * (127 - _loc_2), 0, 0, _loc_2 / 127, 0, 0.5 * (127 - _loc_2), 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
        }// end function

        public static function getSaturationMatrix(param1:Number = 0) : Array
        {
            param1 = param1 > 100 ? (100) : (param1 < -100 ? (-100) : (param1));
            if (param1 == 0 || isNaN(param1))
            {
                return getDefaultMatrix();
            }
            var _loc_2:* = 1 + (param1 > 0 ? (3 * param1 / 100) : (param1 / 100));
            var _loc_3:Number;
            var _loc_4:Number;
            var _loc_5:Number;
            return [_loc_3 * (1 - _loc_2) + _loc_2, _loc_4 * (1 - _loc_2), _loc_5 * (1 - _loc_2), 0, 0, _loc_3 * (1 - _loc_2), _loc_4 * (1 - _loc_2) + _loc_2, _loc_5 * (1 - _loc_2), 0, 0, _loc_3 * (1 - _loc_2), _loc_4 * (1 - _loc_2), _loc_5 * (1 - _loc_2) + _loc_2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
        }// end function

        public static function getInvertMatrix() : Array
        {
            return [-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0];
        }// end function

        public static function getSharpenMatrix(param1:Number = 0) : Array
        {
            param1 = param1 > 100 ? (100) : (param1 < 0 ? (0) : (param1));
            return [0, -1, 0, -1, 6 - param1 / 100, -1, 0, -1, 0];
        }// end function

        public static function getSharpenMatrix2(param1:Number = 0) : Array
        {
            var _loc_2:* = param1 / -100;
            var _loc_3:* = _loc_2 * -8 + 1;
            return [_loc_2, _loc_2, _loc_2, _loc_2, _loc_3, _loc_2, _loc_2, _loc_2, _loc_2];
        }// end function

        public static function getHighPassMatrix() : Array
        {
            return [-1, -1, -1, -1, 8.5, -1, -1, -1, -1];
        }// end function

        public static function getEmbossMatrix(param1:Number) : Array
        {
            return [-param1, -1, 0, -1, 1, 1, 0, 1, param1];
        }// end function

        public static function multiplyMatrix(param1:Array, param2:Array) : Array
        {
            var _loc_3:Array;
            var _loc_4:Array;
            var _loc_5:uint;
            var _loc_6:uint;
            var _loc_7:Number;
            var _loc_8:Number;
            if (param1 == null && param2 == null)
            {
                return null;
            }
            if (param1 == null)
            {
                return cloneMatrix(param2);
            }
            if (param2 == null)
            {
                return cloneMatrix(param1);
            }
            _loc_3 = cloneMatrix(param1);
            _loc_4 = [];
            _loc_5 = 0;
            while (_loc_5++ < 5)
            {
                
                _loc_6 = 0;
                while (_loc_6++ < 5)
                {
                    
                    _loc_4[_loc_6] = _loc_3[_loc_6 + _loc_5 * 5];
                }
                _loc_6 = 0;
                while (_loc_6++ < 5)
                {
                    
                    _loc_7 = 0;
                    _loc_8 = 0;
                    while (_loc_8++ < 5)
                    {
                        
                        _loc_7 = _loc_7 + param2[_loc_6 + _loc_8 * 5] * _loc_4[_loc_8];
                    }
                    _loc_3[_loc_6 + _loc_5 * 5] = _loc_7;
                }
            }
            return _loc_3;
        }// end function

        public static function cloneMatrix(param1:Array) : Array
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = param1.length;
            var _loc_3:* = new Array(_loc_2);
            var _loc_4:uint;
            while (_loc_4++ < _loc_2)
            {
                
                _loc_3[_loc_4] = param1[_loc_4];
            }
            return _loc_3;
        }// end function

        public static function getGammaMatrix(param1:Number) : Array
        {
            var _loc_2:* = new Array(3);
            var _loc_3:* = new Array(256);
            var _loc_4:* = new Array(256);
            var _loc_5:* = new Array(256);
            var _loc_6:* = 1 / param1;
            var _loc_7:uint;
            while (_loc_7++ < 256)
            {
                
                _loc_5[_loc_7] = Math.round(Math.pow(_loc_7 / 255, _loc_6) * 255 + 0.5);
                _loc_5[_loc_7] = _loc_5[_loc_7] > 255 ? (255) : (_loc_5[_loc_7]);
                _loc_4[_loc_7] = _loc_5[_loc_7] << 8;
                _loc_3[_loc_7] = _loc_5[_loc_7] << 16;
            }
            _loc_2[0] = _loc_3;
            _loc_2[1] = _loc_4;
            _loc_2[2] = _loc_5;
            return _loc_2;
        }// end function

        public static function getGammaMatrix2(param1:uint, param2:uint, param3:uint) : Array
        {
            var _loc_4:* = new Array(3);
            var _loc_5:* = Math.log((param2 - param1) / (param3 - param1)) / Math.log(0.5);
            var _loc_6:Array;
            var _loc_7:Array;
            var _loc_8:Array;
            var _loc_9:int;
            while (_loc_9 < 256)
            {
                
                _loc_8[_loc_9] = _loc_9 < param1 ? (0) : (_loc_9 > param3 ? (255) : (255 * Math.pow((_loc_9 - param1) / (param3 - param1), 1 / _loc_5)));
                _loc_7[_loc_9] = _loc_8[_loc_9] << 8;
                _loc_6[_loc_9] = _loc_8[_loc_9] << 16;
                _loc_9++;
            }
            _loc_4[0] = _loc_8;
            _loc_4[1] = _loc_7;
            _loc_4[2] = _loc_6;
            return _loc_4;
        }// end function

    }
}
