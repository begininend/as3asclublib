package org.asclub.net
{
	/**
	 * flash cookie类用来保存记录(比如游戏积分、设置等)
	 * 记录文件在 %appdata%\Macromedia\Flash Player\#SharedObjects
	 * cookies[{key:String,values:*,createTime:Number,expires:Number}]
	 * key          属性名 
	 * values       属性值
	 * createTime   创建时间
	 * expires      有效期(以秒为单位)
	 */
	
	import flash.net.SharedObject;	
	
	public class FlashCookie
	{
		private static var _so:SharedObject;
		public static var Name:String;
		
		public function FlashCookie()
		{
		}
		
		/**
		 * 初始化
		 * @param	cookieName       cookie名称
		 */
		public static function init(cookieName:String):void
		{
			Name = cookieName;
			_so = SharedObject.getLocal(Name, "/");
		}
		
		/**
		 * cookie中是否存在相应的属性
		 * @param	key       属性
		 * @return  Boolean   如果存在则返回true
		 */
		public static function contains(key:String):Boolean
		{
			key = "key_" + key;	
			if (_so.data.cookie == undefined)
			{
				_so.data.cookie = {};
				return false;
			}
			return ((_so.data.cookie[key] != undefined && _so.data.cookie[key] != null) && _so.data.cookie != undefined);
		}
		
		/**
		 * 添加Cookie值
		 * @param	key          属性名
		 * @param	value        属性值
		 * @param	expires      有效期
		 */
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
		
		 /**
		  * 获取Cookie值
		  * @param	 key    属性名
		  * @return  *      属性值
		  */
		public static function GetValue(key:String):*
		{		
			return contains(key) ? _so.data.cookie["key_"+key] : null;
		}
		
		//删除Cookie值;
		public static function remove(key:String):void
		{
			if (contains(key))
			{
				delete _so.data.cookie["key_" + key];
				_so.flush();
			}
		}
		
		//是否过期  true为过期
		public static function testTimeOut(key:String):Boolean
		{
			var obj:* = _so.data.cookie;
			
			if(!contains(key))
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
		
		//清除Cookie所有值;
		public static function removeAll():void
		{
			_so.clear();
		}
	}//end of class
}