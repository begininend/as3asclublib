package org.asclub.net
{
	/**
	 * 
	 * 以秒为单位
	 * 
	 * 
	 * cookies[{key:String,values:*,createTime:Number,expires:Number}]
	 */
	
	
	
	import flash.net.SharedObject;	
	
	public class FlashCookie
	{
		private static var _so:SharedObject;
		public static var Name:String;
		
		public function FlashCookie()
		{
		}
		
		public static function init(CookieName:String):void
		{
			Name = CookieName;
			_so = SharedObject.getLocal(Name, "/");
		}
		
		//是否过期  true为过期
		public static function testTimeOut(key:String):Boolean
		{
			var obj:* = _so.data.cookie;
			
			if(!IsContains(key))
			{
				return true;
			}
			
			if (_so.data.cookie["key_" + key].expires == 0)
			{
				return false;
			}
			
			var today:Date = new Date();
			return today.getTime() - _so.data.cookie["key_" + key].createTime  > _so.data.cookie["key_" + key].expires * 1000;
			return false;
		}
		
		//Cookie值是否存在;
		private static function IsContains(key:String):Boolean
		{
			key = "key_" + key;	
			if (_so.data.cookie == undefined)
			{
				_so.data.cookie = {};
			}
			return ((_so.data.cookie[key] != undefined && _so.data.cookie[key] != null) && _so.data.cookie != undefined);
		}
		
		//添加Cookie值
		public static function put(key:String,value:*,expires:Number = 0):void
		{
			var today:Date = new Date();
			key = "key_" + key;
			var obj:Object = {};
			if (_so.data.cookie == undefined)
			{
				_so.data.cookie = {};
			}
			if(_so.data.cookie[key] == undefined || _so.data.cookie[key] == null)
			{
				obj.values = value;
				obj.createTime = today.getTime();
				obj.expires = expires;
				_so.data.cookie[key] = obj;
			}
			else
			{
				_so.data.cookie[key].values = value;
				_so.data.cookie[key].expires = expires;
				_so.data.cookie[key].createTime = today.getTime();
			}
			_so.flush();
		}
		
		//获取Cookie值;
		public static function GetValue(key:String):Object
		{		
			return IsContains(key)?_so.data.cookie["key_"+key]:null;
		}
		
		//删除Cookie值;
		public static function remove(key:String):void
		{
			if(IsContains(key)){
				delete _so.data.cookie["key_" + key];
				_so.flush();
			}
		}
		
		//清除Cookie所有值;
		public static function removeAll():void
		{
			_so.clear();
		}
	}//end of class
}