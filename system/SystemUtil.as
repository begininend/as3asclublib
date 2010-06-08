package org.asclub.system
{
	import flash.display.DisplayObject;
	import flash.system.Capabilities;

    public class SystemUtil
    {

        public function SystemUtil()
        {
        }

		/**
		 * 是否是windows操作系统
		 */
        public static function get isWindows() : Boolean
        {
            return Capabilities.os.indexOf("Windows") != -1;
        }

		/**
		 * 是否是Linux操作系统
		 */
        public static function get isLinux() : Boolean
        {
            return Capabilities.os.indexOf("Linux") != -1;
        }

		/**
		 * 是否是Mac操作系统
		 */
        public static function get isMac() : Boolean
        {
            return Capabilities.os.indexOf("Mac OS") != -1;
        }
		
		/**
		 * swf文件是否运行于浏览器插件
		 * @return  Returns <code>true</code> if SWF is running in the Flash Player browser plug-in; otherwise <code>false</code>.
		 */
		public static function isPlugin():Boolean {
			return Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX";
		}
		
		/**
		 * swf文件是否运行于flash IDE
		 * @return  Returns <code>true</code> if SWF is running in the Flash Player version used by the external player or test movie mode; otherwise <code>false</code>.
		 */
		public static function isIde():Boolean {
			return Capabilities.playerType == "External";
		}
		
		/**
		 * swf文件是否运行于独立播放器
		 * @return  Returns <code>true</code> if SWF is running in the Flash StandAlone Player; otherwise <code>false</code>.
		 */
		public static function isStandAlone():Boolean {
			return Capabilities.playerType == "StandAlone";
		}
		
		/**
		 * swf文件是否运行于AIR播放器
		 * @return
		 */
		public static function isAirApplication():Boolean {
			return Capabilities.playerType == "Desktop";
		}
		
		/**
		 * 是否位于web上
		 * @param	 location: DisplayObject to get location of.
		 * @return   Returns <code>true</code> if SWF is being served on the internet; otherwise <code>false</code>.
		 * @example  trace(LocationUtil.isWeb(this.stage));
		 */
		public static function isWeb(location:DisplayObject):Boolean {
			return location.loaderInfo.url.substr(0, 4) == "http";
		}
		
		/**
		 * 是否位于某个网站
		 * @param	location: DisplayObject to get location of.
		 * @param	domain: Web domain.
		 * @return  Returns <code>true</code> if file's embed location matched passed domain; otherwise <code>false</code>.
		 */
		public static function isDomain(location:DisplayObject, domain:String):Boolean {
			return LocationUtil.getDomain(location).slice(-domain.length) == domain;
		}
		
		/**
		 * 获取加载此显示对象所属的文件的网站
		 * @param	location: DisplayObject to get location of.
		 * @return  Returns full domain (including sub-domains) of MovieClip's location.
		 * @example <code>
		 * 				trace(LocationUtil.getDomain(this.stage));
		 * 			</code>
		 */
		public static function getDomain(location:DisplayObject):String {
			var baseUrl:String = location.loaderInfo.url.split("://")[1].split("/")[0];
			return (baseUrl.substr(0, 4) == "www.") ? baseUrl.substr(4) : baseUrl;
		}

    }//end of class
}