package org.asclub.net
{
    /**
    *Author: ATHER Shu 2008.9.26
    * NetUtil类: 一些直接调用浏览器简单js的实用类
    * 功能：
    * 1.显示swf所在页面也就是浏览器地址栏地址 getPageUrl
    * 2.显示swf所在地址(未实现，求高手指点) getSwfUrl
    * 3.直接弹出浏览器提示 explorerAlert
    * 4.获取swf所在页面的编码方式 getpageEncoding
    * 5.获取浏览器类型 getBrowserType
    * 6.直接运行js代码 eval
    * http://www.asarea.cn
    * ATHER Shu(AS)
    */
    import flash.external.ExternalInterface;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
    public class NetUtil
    {
        /**
         * 获取当前页面url
         * @return
         */
        public static function getPageUrl():String
        {
            //在ie中如果没有用object classid或者没有赋id属性，而直接用embed，该方法会失效！
            var pageurl:String = ExternalInterface.call("eval", "window.location.href");
            if(pageurl == null)
                pageurl = "none";//"not in a page or js called fail";
            return pageurl;
        }
		
        /**
         * 通过js弹出浏览器提示alert
         * @param	msg
         */
        public static function explorerAlert(msg:String):void
        {
            navigateToURL(new URLRequest("javascript:alert('"+msg+"')"), "_self");
        }
		
        /**
         * 获取swf所在页面编码方式
         * @return
         */
        public static function getpageEncoding():String
        {
            //IE下用:document.charset
            //Firefox下用:document.characterSet
            var pageencoding:String = ExternalInterface.call("eval", "document.charset");
            if(pageencoding == null)
                pageencoding = ExternalInterface.call("eval", "document.characterSet");
            //
            if(pageencoding == null)
                pageencoding = "NONE";//can't get the page encoding
            return pageencoding.toUpperCase();
        }
		
        /**
         * 获取浏览器类型
         * @return
         */
        public static function getBrowserType():String
        {
            //var browsertype:String = ExternalInterface.call("eval", "navigator.appName");
            var browsertype:String = ExternalInterface.call("eval", "navigator.userAgent");
            return (browsertype ? browsertype:"NONE");
        }
		
        /**
         * 直接运行js语句，eval
         * @param	code
         * @return
         */
        public static function eval(code:String):Object
        {
            var rtn:Object = ExternalInterface.call("eval", code);
            return rtn;
        }
		
		/**
		 * 去除URL尾部参数
		 * @param	char
		 * @return
		 */
		public static function trimParam(char:String,separator:String = "?"):String
		{
			if(char == null){
				return "";
			}
			return char.split(separator)[0];
		}
		
		/**
		* 密码强度检测(cryptographic strength check),返回0~95之间的数字..数字超大强度越高,不支持中文字符,如密码文本中包含中文~该中文字符将作为字符打分
		* 
		* @param  passString  待检测的密码文本
		* @return  返回0~95之间的数字..数字超大强度越高
		*/
		static public function csCheck(passString:String):uint
		{
			if(!passString)return 0;
			var count:uint = 0;
			count += passString.length<=4?5:(passString.length>=8?25:10);
			count += !passString.match(/[a-z]/i)?0:(passString.match(/[a-z]/) && passString.match(/[A-Z]/)?20:10);
			count += !passString.match(/[0-9]/)?0:(passString.match(/[0-9]/g).length >= 3?20:10);
			count += !passString.match(/\W/)?0:(passString.match(/\W/g).length > 1?25:10);
			count += !passString.match(/[0-9]/)||!passString.match(/[a-z]/i)?0:(!passString.match(/\W/)?2:(!passString.match(/[a-z]/) || !passString.match(/[A-Z]/)?3:5));
			return count
		}
		
		 /**
		 *  Returns an object from a String. The String contains <code>name=value</code> pairs, which become dynamic properties
		 *  of the returned object. These property pairs are separated by the specified <code>separator</code>.
		 *  This method converts Numbers and Booleans, Arrays (defined by "[]"), 
		 *  and sub-objects (defined by "{}"). By default, URL patterns of the format <code>%XX</code> are converted
		 *  to the appropriate String character.
		 *
		 *  <p>For example:
		 *  <pre>
		 *  var s:String = "name=Alex;age=21";
		 *  var o:Object = URLUtil.stringToObject(s, ";", true);
		 *  </pre>
		 *  
		 *  Returns the object: <code>{ name: "Alex", age: 21 }</code>.
		 *  </p>
		 *  
		 *  @param string The String to convert to an object.
		 *  @param separator The character that separates <code>name=value</code> pairs in the String.
		 *  @param decodeURL Whether or not to decode URL-encoded characters in the String.
		 * 
		 *  @return The object containing properties and values extracted from the String passed to this method.
		 */
		public static function stringToObject(string:String, separator:String = ";",
									decodeURL:Boolean = true):Object
		{
			var o:Object = {};

			var arr:Array = string.split(separator);

			// if someone has a name or value that contains the separator 
			// this will not work correctly, nor will it work well if there are 
			// '=' or '.' in the name or value

			var n:int = arr.length;
			for (var i:int = 0; i < n; i++)
			{
				var pieces:Array = arr[i].split('=');
				var name:String = pieces[0];
				if (decodeURL)
					name = decodeURIComponent(name);

				var value:Object = pieces[1];
				if (decodeURL)
					value = decodeURIComponent(value as String);

				if (value == "true")
					value = true;
				else if (value == "false")
					value = false;
				else 
				{
					var temp:Object = int(value);
					if (temp.toString() == value)
						value = temp;
					else
					{
						temp = Number(value)
						if (temp.toString() == value)
							value = temp;
					}
				}

				var obj:Object = o;

				pieces = name.split('.');
				var m:int = pieces.length;
				for (var j:int = 0; j < m - 1; j++)
				{
					var prop:String = pieces[j];
					if (obj[prop] == null && j < m - 1)
					{
						var subProp:String = pieces[j + 1];
						var idx:Object = int(subProp);
						if (idx.toString() == subProp)
							obj[prop] = [];
						else
							obj[prop] = {};
					}
					obj = obj[prop];
				}
				obj[pieces[j]] = value;
			}

			return o;
		}
		
		/**
		 *  Enumerates an object's dynamic properties (by using a <code>for..in</code> loop)
		 *  and returns a String. You typically use this method to convert an ActionScript object to a String that you then append to the end of a URL.
		 *  By default, invalid URL characters are URL-encoded (converted to the <code>%XX</code> format).
		 *
		 *  <p>For example:
		 *  <pre>
		 *  var o:Object = { name: "Alex", age: 21 };
		 *  var s:String = URLUtil.objectToString(o,";",true);
		 *  trace(s);
		 *  </pre>
		 *  Prints "name=Alex;age=21" to the trace log.
		 *  </p>
		 *  
		 *  @param object The object to convert to a String.
		 *  @param separator The character that separates each of the object's <code>property:value</code> pair in the String.
		 *  @param encodeURL Whether or not to URL-encode the String.
		 *  
		 *  @return The object that was passed to the method.
		 */
		public static function objectToString(object:Object, separator:String=';',
									encodeURL:Boolean = true):String
		{
			var s:String = internalObjectToString(object, separator, null, encodeURL);
			return s;
		}

		private static function internalObjectToString(object:Object, separator:String, prefix:String, encodeURL:Boolean):String
		{
			var s:String = "";
			var first:Boolean = true;

			for (var p:String in object)
			{
				if (first)
				{
					first = false;
				}
				else
					s += separator;

				var value:Object = object[p];
				var name:String = prefix ? prefix + "." + p : p;
				if (encodeURL)
					name = encodeURIComponent(name);

				if (value is String)
				{
					s += name + '=' + (encodeURL ? encodeURIComponent(value as String) : value);
				}
				else if (value is Number)
				{
					value = value.toString();
					if (encodeURL)
						value = encodeURIComponent(value as String);

					s += name + '=' + value;
				}
				else if (value is Boolean)
				{
					s += name + '=' + (value ? "true" : "false");
				}
				else
				{
					if (value is Array)
					{
						s += internalArrayToString(value as Array, separator, name, encodeURL);
					}
					else // object
					{
						s += internalObjectToString(value, separator, name, encodeURL);
					}
				}
			}
			return s;
		}
		
		private static function internalArrayToString(array:Array, separator:String, prefix:String, encodeURL:Boolean):String
		{
			var s:String = "";
			var first:Boolean = true;

			var n:int = array.length;
			for (var i:int = 0; i < n; i++)
			{
				if (first)
				{
					first = false;
				}
				else
					s += separator;

				var value:Object = array[i];
				var name:String = prefix + "." + i;
				if (encodeURL)
					name = encodeURIComponent(name);

				if (value is String)
				{
					s += name + '=' + (encodeURL ? encodeURIComponent(value as String) : value);
				}
				else if (value is Number)
				{
					value = value.toString();
					if (encodeURL)
						value = encodeURIComponent(value as String);

					s += name + '=' + value;
				}
				else if (value is Boolean)
				{
					s += name + '=' + (value ? "true" : "false");
				}
				else
				{
					if (value is Array)
					{
						s += internalArrayToString(value as Array, separator, name, encodeURL);
					}
					else // object
					{
						s += internalObjectToString(value, separator, name, encodeURL);
					}
				}
			}
			return s;
		}
		
    }//end of class
}