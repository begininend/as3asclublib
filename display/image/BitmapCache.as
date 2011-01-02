package util
{
    import flash.display.*;
    import flash.utils.*;

    public class BitmapCache extends Object
    {
        private static var s_fLog:Boolean = false;
        private static var s_aDisposable:Array = [];
        private static var s_dctCachesToClear:Dictionary = new Dictionary();
        private static var s_dctCaches:Dictionary = new Dictionary();

        public function BitmapCache()
        {
            return;
        }// end function

        public static function AddDisposable(param1:IDisposable) : void
        {
            s_aDisposable.push(param1);
            return;
        }// end function

        public static function Remove(param1:BitmapData) : void
        {
            var _loc_2:Object;
            var _loc_3:Dictionary;
            var _loc_4:String;
            var _loc_5:BitmapCacheEntry;
            for (_loc_2 in s_dctCaches)
            {
                
                _loc_3 = s_dctCaches[_loc_2] as Dictionary;
                for (_loc_4 in _loc_3)
                {
                    
                    _loc_5 = _loc_3[_loc_4] as BitmapCacheEntry;
                    if (_loc_5.result == param1)
                    {
                        delete _loc_3[_loc_4];
                    }
                }
            }
            return;
        }// end function

        public static function DumpCaches() : void
        {
            var _loc_1:Object;
            var _loc_2:Dictionary;
            var _loc_3:String;
            for (_loc_1 in s_dctCaches)
            {
                
                trace("=== Cache owned by " + _loc_1 + ", " + (typeof(_loc_1)) + " ===");
                _loc_2 = s_dctCaches[_loc_1];
                if (_loc_2 == null)
                {
                    trace("   null");
                    continue;
                }
                for (_loc_3 in _loc_2)
                {
                    
                    trace("   " + _loc_3 + ": " + _loc_2[_loc_3]);
                }
            }
            return;
        }// end function

        public static function Contains(param1:BitmapData) : Boolean
        {
            var _loc_2:Object;
            var _loc_3:Dictionary;
            var _loc_4:String;
            var _loc_5:BitmapCacheEntry;
            if (!param1)
            {
                return false;
            }
            for (_loc_2 in s_dctCaches)
            {
                
                _loc_3 = s_dctCaches[_loc_2] as Dictionary;
                for (_loc_4 in _loc_3)
                {
                    
                    _loc_5 = _loc_3[_loc_4] as BitmapCacheEntry;
                    if (_loc_5 && _loc_5.result == param1)
                    {
                        return true;
                    }
                }
            }
            return false;
        }// end function

        public static function MarkForDelayedClear() : void
        {
            var _loc_1:Object;
            for (_loc_1 in s_dctCaches)
            {
                
                s_dctCachesToClear[_loc_1] = s_dctCaches[_loc_1];
                delete s_dctCaches[_loc_1];
            }
            return;
        }// end function

        public static function Lookup(param1:Object, param2:String, param3:String, param4:BitmapData) : BitmapData
        {
            var _loc_5:* = LookupEntry(param1, param2, param3, param4);
            if (LookupEntry(param1, param2, param3, param4))
            {
                return _loc_5.result;
            }
            return null;
        }// end function

        public static function DelayedClear() : void
        {
            var _loc_1:Object;
            var _loc_2:Dictionary;
            var _loc_3:String;
            var _loc_4:BitmapCacheEntry;
            for (_loc_1 in s_dctCachesToClear)
            {
                
                _loc_2 = s_dctCachesToClear[_loc_1] as Dictionary;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_4 = _loc_2[_loc_3] as BitmapCacheEntry;
                    if (_loc_4)
                    {
                        _loc_4.Dispose();
                    }
                    delete _loc_2[_loc_3];
                }
                delete s_dctCachesToClear[_loc_1];
            }
            return;
        }// end function

        public static function Clear() : void
        {
            var _loc_1:Object;
            var _loc_2:Dictionary;
            var _loc_3:String;
            var _loc_4:BitmapCacheEntry;
            for (_loc_1 in s_dctCaches)
            {
                
                _loc_2 = s_dctCaches[_loc_1] as Dictionary;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_4 = _loc_2[_loc_3] as BitmapCacheEntry;
                    if (_loc_4)
                    {
                        _loc_4.Dispose();
                    }
                    delete _loc_2[_loc_3];
                }
                delete s_dctCaches[_loc_1];
            }
            while (s_aDisposable.length > 0)
            {
                
                IDisposable(s_aDisposable.pop()).Dispose();
            }
            DelayedClear();
            return;
        }// end function

        public static function Set(param1:Object, param2:String, param3:String, param4:BitmapData, param5:BitmapData, param6:Object = null) : void
        {
            var _loc_8:BitmapCacheEntry;
            var _loc_7:* = s_dctCaches[param1];
            if (s_dctCaches[param1] == null)
            {
                _loc_7 = new Dictionary();
                s_dctCaches[param1] = _loc_7;
            }
            if (param2 in _loc_7 && _loc_7[param2] != null)
            {
                _loc_8 = _loc_7[param2] as BitmapCacheEntry;
                delete _loc_7[param2];
                if (_loc_8 && !Contains(_loc_8.result) && _loc_8.result != param5)
                {
                    _loc_8.Dispose();
                }
            }
            _loc_7[param2] = new BitmapCacheEntry(param3, param4, param5, param6);
            if (s_fLog)
            {
                trace("Set cache: " + param2 + ", " + param5);
            }
            return;
        }// end function

        public static function BackupCacheEntry(param1:Object, param2:String) : void
        {
            var _loc_4:BitmapCacheEntry;
            var _loc_3:* = s_dctCaches[param1];
            if (_loc_3 == null)
            {
                _loc_3 = new Dictionary();
                s_dctCaches[param1] = _loc_3;
            }
            if (param2 in _loc_3)
            {
                _loc_4 = _loc_3[param2] as BitmapCacheEntry;
                if (_loc_4)
                {
                    Set(param1, param2 + "_backup", null, null, _loc_4.result);
                }
            }
            return;
        }// end function

        public static function ClearOne(param1:Object, param2:String) : void
        {
            var _loc_4:BitmapCacheEntry;
            var _loc_3:* = s_dctCaches[param1];
            if (_loc_3 == null)
            {
                return;
            }
            if (param2 in _loc_3 && _loc_3[param2] != null)
            {
                _loc_4 = _loc_3[param2] as BitmapCacheEntry;
                delete _loc_3[param2];
                if (_loc_4 && !Contains(_loc_4.result))
                {
                    _loc_4.Dispose();
                }
            }
            return;
        }// end function

        public static function LookupEntry(param1:Object, param2:String, param3:String, param4:BitmapData) : BitmapCacheEntry
        {
            var _loc_5:* = s_dctCaches[param1];
            if (s_dctCaches[param1] == null)
            {
                return null;
            }
            var _loc_6:BitmapCacheEntry;
            if (param2 in _loc_5)
            {
                _loc_6 = _loc_5[param2] as BitmapCacheEntry;
                if (_loc_6 && !_loc_6.matches(param3, param4))
                {
                    _loc_6 = null;
                }
            }
            return _loc_6;
        }// end function

    }
}
