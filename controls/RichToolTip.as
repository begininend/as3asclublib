package org.asclub.controls
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	
	public class RichToolTip extends CustomUIComponent
	{
		private static var instance:RichToolTip;
		private static var _content:DisplayObject;
		
		//构造函数
		public function RichToolTip()
		{
			
		}
		
		
		//--------------------------GETTER AND SETTER---------------------------------------------------------
		
		/**
		 * 获取当前RichToolTip所显示的内容
		 */
		public static function get content():DisplayObject
		{
			
		}
		
		
		
		//--------------------------PUBLIC FUNCTION-----------------------------------------------------------
		
		/**
		 * 使用前先调用此方法
		 */
		public static function init():void
		{
			if (instance == null) {
				instance = new RichToolTip(new PrivateClass());
			}
		}
		
		
	}//end of class
}

class PrivateClass()