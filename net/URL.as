package org.asclub.net
{
	import flash.net.URLVariables;

	/**
	 * URL解析
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class URL
	{
		
		/**
		 * 使用的正则
		 */
		public static const regex:RegExp = /^((\w+):\/{2,3})?((\w+):?(\w+)?@)?([^\/\?:]+):?(\d+)?(\/?[^\?#]+)?\??([^#]+)?#?(\w*)/;
 		
 		/**
		 * 协议名（诸如http）
		 */
		public var protocol:String;
    	
    	/**
		 * 主机名（诸如www.google.com）或者文件系统中的盘符
		 */
		public var host:String;
    	
    	/**
		 * 端口号 
		 */
		public var port:int;
		
		/**
		 * 除去主机名后的路径
		 */
		public var pathname:FilePath;
		
		/**
		 * URL中的用户名
		 */
		public var username:String;
		
		/**
		 * URL中的密码
		 */
		public var password:String;
		
		/**
		 * 参数列表
		 */
		public var queryString:URLVariables;
		
		/**
		 * 锚点
		 */
		public var fragment:String;
    	
		/**
		 * 
		 * @param v
		 * @param hasPath	是否拥有路径名
		 * 
		 */
    	public function URL(v:String,hasPath:Boolean = true)
		{
			if (!v)
				v = "";
			
			var data:Array = regex.exec(v);
			protocol = data[2];
			username = data[4];
			password = data[5];
			host = data[6];
			port = data[7];
			pathname = data[8] ? new FilePath(data[8]) : null;
			queryString = data[9] ? new URLVariables(data[9]) : null;
			fragment = data[10];
			
			if (hasPath && !pathname && host)//只有文件名的时候将会产生混淆，取host的值
			{
				pathname = new FilePath(host);
				host = null;
			}
		}
		
		/**
		 * 返回指定对象的字符串表示形式。
		 * @return
		 */
		public function toString():String
		{
			var result:String = "";
			if (protocol)
			{
				result += protocol + "://";
				if (protocol == "file")
					result += "/";
			}
			if (username && password)
				result += username + ":" + password + "@";	
			
			if (host)
			{
				result += host;
				if (protocol == "file")
					result += ":";
			}
			
			if (port)
				result += ":" + port.toString();
			
			if (pathname)
				result += "/" + pathname.toString();
			
			if (queryString)
				result += "?" + queryString.toString();
			
			if (fragment)
				result += "#" + fragment;
			
			return result;
		}
		
		/**
		 * 是否是http协议
		 * @param	v
		 * @return
		 */
		public static function isHTTP(v:String):Boolean
		{
			return v.substr(0,7).toLowerCase() == "http://";
		}
		
		/**
		 * url解析
		 * @param	url      url地址
		 * @param 	hasPath	 是否拥有路径名
		 * @return  Object   解析后的对象()
		 */
		public static function URLParse(url:String,hasPath:Boolean = true):Object
		{
			if (url == null || url == "")
			{
				return null;
			}
			
			var data:Array = regex.exec(url);
			//协议名（诸如http）
			var protocol:String = data[2];
			//URL中的用户名
			var username:String = data[4];
			//URL中的密码
			var password:String = data[5];
			//主机名（诸如www.google.com）或者文件系统中的盘符
			var host:String = data[6];
			//端口号
			var port:int = data[7];
			//除去主机名后的路径
			var pathname:String = data[8] ? new FilePath(data[8]).toString() : null;
			//参数列表
			var queryString:URLVariables = data[9] ? new URLVariables(data[9]) : null;
			//锚点
			var fragment:String = data[10];
			
			if (hasPath && !pathname && host)//只有文件名的时候将会产生混淆，取host的值
			{
				pathname = new FilePath(host).toString();
				host = null;
			}
			
			var parseData:Object = {"protocol":protocol,"host":host,"port":port,"pathname":pathname,"queryString":queryString,"fragment":fragment,"username":username,"password":password};
			return parseData;
		}
		
	}//end of class
}