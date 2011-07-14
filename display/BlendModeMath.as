package org.asclub.display
{
    public class BlendModeMath extends Object
    {
        public static const kaobFuncs:Array = [{label:"Normal", fn:Normal}, {label:"Lighten", fn:Lighten}, {label:"Darken", fn:Darken}, {label:"Multiply", fn:Multiply}, {label:"Average", fn:Average}, {label:"Add", fn:Add}, {label:"Subtract", fn:Subtract}, {label:"Difference", fn:Difference}, {label:"Negation", fn:Negation}, {label:"Screen", fn:Screen}, {label:"Exclusion", fn:Exclusion}, {label:"Overlay", fn:Overlay}, {label:"SoftLight", fn:SoftLight}, {label:"HardLight", fn:HardLight}, {label:"ColorDodge", fn:ColorDodge}, {label:"ColorBurn", fn:ColorBurn}, {label:"LinearDodge", fn:LinearDodge}, {label:"LinearBurn", fn:LinearBurn}, {label:"LinearLight", fn:LinearLight}, {label:"VividLight", fn:VividLight}, {label:"PinLight", fn:PinLight}, {label:"HardMix", fn:HardMix}, {label:"Reflect", fn:Reflect}, {label:"Glow", fn:Glow}, {label:"Phoenix", fn:Phoenix}];

        public function BlendModeMath()
        {
            return;
        }// end function

        public static function Add(param1:Number, param2:Number) : Number
        {
            return Math.min(255, param1 + param2);
        }// end function

        public static function GetColorMaps(param1:Function, param2:Number) : Array
        {
            var _loc_3:Array;
            if (param1 == null || isNaN(param2))
            {
                _loc_3 = [null, null, null];
            }
            else
            {
                _loc_3.push(BlendModeMath.GetPaletteMapForColor(param1, param2, 16));
                _loc_3.push(BlendModeMath.GetPaletteMapForColor(param1, param2, 8));
                _loc_3.push(BlendModeMath.GetPaletteMapForColor(param1, param2, 0));
            }
            return _loc_3;
        }// end function

        public static function Negation(param1:Number, param2:Number) : Number
        {
            return 255 - Math.abs(255 - param1 - param2);
        }// end function

        public static function Normal(param1:Number, param2:Number) : Number
        {
            return param1;
        }// end function

        public static function Multiply(param1:Number, param2:Number) : Number
        {
            return param1 * param2 / 255;
        }// end function

        public static function LinearLight(param1:Number, param2:Number) : Number
        {
            return param2 < 128 ? (LinearBurn(param1, 2 * param2)) : (LinearDodge(param1, 2 * (param2 - 128)));
        }// end function

        public static function LinearDodge(param1:Number, param2:Number) : Number
        {
            return Add(param1, param2);
        }// end function

        public static function Screen(param1:Number, param2:Number) : Number
        {
            return 255 - ((255 - param1) * (255 - param2) >> 8);
        }// end function

        public static function ColorDodge(param1:Number, param2:Number) : Number
        {
            return param2 == 255 ? (param2) : (Math.min(255, (param1 << 8) / (255 - param2)));
        }// end function

        public static function VividLight(param1:Number, param2:Number) : Number
        {
            return param2 < 128 ? (ColorBurn(param1, 2 * param2)) : (ColorDodge(param1, 2 * (param2 - 128)));
        }// end function

        public static function HardLight(param1:Number, param2:Number) : Number
        {
            return Overlay(param2, param1);
        }// end function

        public static function Difference(param1:Number, param2:Number) : Number
        {
            return Math.abs(param1 - param2);
        }// end function

        public static function Lighten(param1:Number, param2:Number) : Number
        {
            return param2 > param1 ? (param2) : (param1);
        }// end function

        public static function HardMix(param1:Number, param2:Number) : Number
        {
            return VividLight(param1, param2) < 128 ? (0) : (255);
        }// end function

        public static function PinLight(param1:Number, param2:Number) : Number
        {
            return param2 < 128 ? (Darken(param1, 2 * param2)) : (Lighten(param1, 2 * (param2 - 128)));
        }// end function

        public static function Reflect(param1:Number, param2:Number) : Number
        {
            return param2 == 255 ? (param2) : (Math.min(255, param1 * param1 / (255 - param2)));
        }// end function

        public static function SoftLight(param1:Number, param2:Number) : Number
        {
            return param2 < 128 ? (2 * ((param1 >> 1) + 64) * (param2 / 255)) : (255 - 2 * (255 - ((param1 >> 1) + 64)) * (255 - param2) / 255);
        }// end function

        public static function Glow(param1:Number, param2:Number) : Number
        {
            return Reflect(param2, param1);
        }// end function

        public static function Exclusion(param1:Number, param2:Number) : Number
        {
            return param1 + param2 - 2 * param1 * param2 / 255;
        }// end function

        public static function Phoenix(param1:Number, param2:Number) : Number
        {
            return Math.min(param1, param2) - Math.max(param1, param2) + 255;
        }// end function

        public static function Overlay(param1:Number, param2:Number) : Number
        {
            return param2 < 128 ? (2 * param1 * param2 / 255) : (255 - 2 * (255 - param1) * (255 - param2) / 255);
        }// end function

        public static function GetPaletteMapForColor(param1:Function, param2:Number, param3:Number) : Array
        {
            var _loc_4:* = param2 >> param3 & 255;
            return GetPaletteMap(param1, _loc_4, param3);
        }// end function

        public static function ColorBurn(param1:Number, param2:Number) : Number
        {
            return param2 == 0 ? (param2) : (Math.max(0, 255 - (255 - param1 << 8) / param2));
        }// end function

        public static function Subtract(param1:Number, param2:Number) : Number
        {
            return param1 + param2 < 255 ? (0) : (param1 + param2 - 255);
        }// end function

        public static function GetPaletteMap(param1:Function, param2:Number, param3:Number) : Array
        {
            var _loc_4:Array;
            var _loc_5:Number;
            while (_loc_5++ <= 255)
            {
                
                _loc_4.push(Math.min(Math.max(Math.round(this.param1(param2, _loc_5)), 0), 255) << param3);
            }
            return _loc_4;
        }// end function

        public static function LinearBurn(param1:Number, param2:Number) : Number
        {
            return Subtract(param1, param2);
        }// end function

        public static function Average(param1:Number, param2:Number) : Number
        {
            return (param1 + param2) / 2;
        }// end function

        public static function Darken(param1:Number, param2:Number) : Number
        {
            return param2 > param1 ? (param1) : (param2);
        }// end function

    }
}
