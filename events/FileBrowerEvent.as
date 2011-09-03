package org.asclub.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author $(DefaultUser)
	 */
	public class FileBrowerEvent extends Event 
	{
		
		//保存完成
		public static const SAVE_COMPLETE:String = "saveComplete";
		
		//图像加载完成
		public static const IMAGE_COMPLETE:String = "imageComplete";
		
		//异常操作
		public static const ILLEGAL_OPERATION:String = "illegalOperation";
		
		public var fileName:String;
		
		
		public function FileBrowerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new FileBrowerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FileBrowerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}