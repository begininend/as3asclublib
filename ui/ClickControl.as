//Copyright ? 2008. Http://L4cd.Net All Rights Reserved.
package org.asclub.ui 
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.Dictionary;
	
	
	
	/**
	 * 自定义双击事件类
	 *
	 * @author L4cd.Net
	 * @playerversion Flash player 9
	 * @langversion 3.0
	 * @version 2008-10-22 22:53
	 */
	public class ClickControl
	{
		static public var list:Dictionary;
		public function ClickControl()
		{
			
		}
		
		/**
		 * 取消自定义双击事件.
		 * 
		 * @param	target 目标
		 */
		static public function disable(target:DisplayObject):void
		{
			if (!list) return;
			if (!list[target]) return;
			delete list[target];
			target.removeEventListener(MouseEvent.CLICK, l4cd_click);
		}
		
		/**
		 * 启动自定义事件
		 * 
		 * @param	target 目标
		 * @param	delay 判断为双击事件的延时,默认值为200毫秒
		 */
		static public function enable(target:DisplayObject,delay:uint = 200):void
		{
			if (!list) list = new Dictionary();
			target.addEventListener(MouseEvent.CLICK, l4cd_click, false, 10, true);
			var obj:Object = {}
			obj.l4cd_last_click = 0;
			obj.l4cd_delay = delay;
			obj.l4cd_timer = 0;
			list[target] = obj;
		}
		
		static private function l4cd_click(e:MouseEvent):void
		{
			var target:Object = list[e.currentTarget];
			if(target.l4cd_timer == -1){
				target.l4cd_timer = 0
				return;
			}
			if (getTimer() - target.l4cd_last_click < target.l4cd_delay)
			{
				clearTimeout(target.l4cd_timer);
				target.l4cd_timer = 0;
				target.l4cd_last_click = 0;
				e.currentTarget.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK,e.bubbles,e.cancelable,e.localX,e.localY,e.relatedObject,e.ctrlKey,e.altKey,e.shiftKey,e.buttonDown,e.delta))
			}else
			{
				clearTimeout(target.l4cd_timer);
				target.l4cd_timer = setTimeout(l4cd_click_event, target.l4cd_delay + 5, e.currentTarget as DisplayObject, e);
				target.l4cd_last_click = getTimer();
			}
			e.stopImmediatePropagation();
		}
		
		static private function l4cd_click_event(currentTarget:DisplayObject, event:Event):void
		{
			var target:Object = list[currentTarget];
			target.l4cd_timer = -1;
			currentTarget.dispatchEvent(event);
		}
	}//end of class
}