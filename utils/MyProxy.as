package org.asclub.utils
{
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
   
    use namespace flash_proxy;
   
    public dynamic class MyProxy extends Proxy
    {
        private var _properties:Object = {};
       
        flash_proxy override function callProperty(name:*, ... rest):*
        {
            if(_properties[name] == undefined)
            {
                _properties[name] = traces;
            }
            rest.unshift(name);
            traces(rest);
            return _properties[name];
        }
        flash_proxy override function getProperty(name:*):*
        {
            return _properties[name];
        }
        private var _pnames:Array;
        flash_proxy override function nextNameIndex(index:int):int
        {
            trace("nextNameIndex", index);
            if(index == 0)
            {
                _pnames = [];
                for(var pname:String in _properties)
                {
                    _pnames.push(pname);
                }
            }
            return (index<_pnames.length) ? index+1 : 0;
        }
        flash_proxy override function nextName(index:int):String
        {
            //trace("nextName", index);
            return _pnames[index-1];
        }
        flash_proxy override function nextValue(index:int):*
        {
            //trace("nextValue", index);
            return _properties[_pnames[index-1]];
        }
        private function traces(...args):void
        {
            trace(args);
        }
    }
}