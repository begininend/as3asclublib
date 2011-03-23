package util
{
    import flash.geom.*;

    public class RectUtil extends Object
    {
        public static const LEFT:Number = 2;
        public static const BELOW:Number = 1;
        public static const RIGHT:Number = 3;
        public static const ABOVE:Number = 0;

        public function RectUtil()
        {
            return;
        }// end function

        public static function ApplyPadding(param1:Rectangle, param2:Object, param3:Boolean = true) : Rectangle
        {
            var _loc_4:* = param1.clone();
            if (param2 != null)
            {
                if (RectUtil.ABOVE in param2)
                {
                    _loc_4.y = _loc_4.y - param2[RectUtil.ABOVE];
                    _loc_4.height = _loc_4.height + param2[RectUtil.ABOVE];
                }
                if (RectUtil.BELOW in param2)
                {
                    _loc_4.height = _loc_4.height + param2[RectUtil.BELOW];
                }
                if (RectUtil.LEFT in param2)
                {
                    _loc_4.x = _loc_4.x - param2[RectUtil.LEFT];
                    _loc_4.width = _loc_4.width + param2[RectUtil.LEFT];
                }
                if (RectUtil.RIGHT in param2)
                {
                    _loc_4.width = _loc_4.width + param2[RectUtil.RIGHT];
                }
            }
            return _loc_4;
        }// end function

        static function ApplyRules(param1:Rectangle, param2:Array, param3:Point, param4:Number) : Object
        {
            var obRet:Object;
            var obConst:Object;
            var rc:Rectangle;
            var rcOutside:Rectangle;
            var aobRet:Array;
            var nDir:Number;
            var rc2:Rectangle;
            var fnCommon:Function;
            var rcIn:* = param1;
            var aobConstraints:* = param2;
            var ptSize:* = param3;
            var i:* = param4;
            obRet;
            obConst = aobConstraints[i];
            if ("rcInside" in obConst)
            {
                rc = obConst["rcInside"];
                rc = rcIn.intersection(rc);
                if (rc.width + 0.5 < ptSize.x || rc.height + 0.5 < ptSize.y)
                {
                    return null;
                }
                if (aobConstraints.length > i + 1)
                {
                    obRet = ApplyRules(rc, aobConstraints, ptSize, i + 1);
                }
                if (!obRet)
                {
                    obRet;
                    obRet.pt = new Point(rc.x + (rc.width - ptSize.x) / 2, rc.y + (rc.height - ptSize.y) / 2);
                    obRet.depth = i;
                }
                return obRet;
            }
            else
            {
                rcOutside = obConst.rcOutside ? (obConst.rcOutside) : (obConst.rcPointAt);
                aobRet;
                fnCommon = function () : void
            {
                var _loc_1:Rectangle;
                var _loc_2:Rectangle;
                obRet = null;
                if (aobConstraints.length > i + 1)
                {
                    obRet = ApplyRules(rc2, aobConstraints, ptSize, i + 1);
                }
                if (obRet == null)
                {
                    obRet = {};
                    switch(nDir)
                    {
                        case ABOVE:
                        {
                            break;
                        }
                        case BELOW:
                        {
                            break;
                        }
                        case LEFT:
                        {
                            break;
                        }
                        case RIGHT:
                        {
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    obRet.depth = i;
                }
                if ("prefer" in obConst && obConst["prefer"] == nDir)
                {
                    obRet.depth = obRet.depth + 0.5;
                }
                aobRet.push({pt:obRet.pt, depth:obRet.depth});
                return;
            }// end function
            ;
                if (rcOutside.top - rcIn.top >= ptSize.y - 0.5)
                {
                    nDir = ABOVE;
                    rc2 = rcIn.clone();
                    rc2.bottom = Math.min(rc2.bottom, rcOutside.top);
                    this.fnCommon();
                }
                if (rcIn.bottom - rcOutside.bottom >= ptSize.y - 0.5)
                {
                    nDir = BELOW;
                    rc2 = rcIn.clone();
                    rc2.top = Math.max(rc2.top, rcOutside.bottom);
                    this.fnCommon();
                }
                if (rcOutside.left - rcIn.left >= ptSize.x - 0.5)
                {
                    nDir = LEFT;
                    rc2 = rcIn.clone();
                    rc2.right = Math.min(rc2.right, rcOutside.left);
                    this.fnCommon();
                }
                if (rcIn.right - rcOutside.right >= ptSize.x - 0.5)
                {
                    nDir = RIGHT;
                    rc2 = rcIn.clone();
                    rc2.left = Math.max(rc2.left, rcOutside.right);
                    this.fnCommon();
                }
            }
            aobRet.sortOn("depth", Array.NUMERIC | Array.DESCENDING);
            if (aobRet.length == 0)
            {
                return null;
            }
            return aobRet[0];
            ;
            return null;
        }// end function

        public static function PlaceRect(param1:Array, param2:Point) : Point
        {
            var _loc_3:Rectangle;
            if (param1 == null || param1.length == 0)
            {
                return new Point(0, 0);
            }
            var _loc_4:Number;
            if ("rcInside" in param1[0])
            {
                _loc_3 = param1[0].rcInside;
            }
            else
            {
                _loc_3 = new Rectangle(0, 0, Number.MAX_VALUE, Number.MAX_VALUE);
            }
            param2.x = Math.min(param2.x, _loc_3.width);
            param2.y = Math.min(param2.y, _loc_3.height);
            var _loc_5:* = ApplyRules(_loc_3, param1, param2, _loc_4++);
            if (ApplyRules(_loc_3, param1, param2, _loc_4++) == null)
            {
                return new Point(0, 0);
            }
            return _loc_5.pt;
        }// end function

        public static function Integerize(param1:Rectangle) : Rectangle
        {
            return new Rectangle(int(param1.x), int(param1.y), Math.ceil(param1.right) - int(param1.left), Math.ceil(param1.bottom) - int(param1.top));
        }// end function

    }
}
