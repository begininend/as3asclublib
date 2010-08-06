package com.riaoo.events
{
	import flash.events.Event;

	public class AnimationEvent extends Event
	{
		/**
		 * Animation 类的 enterFrame 事件。
		 */
		public static const ANIMATION_ENTER_FRAME:String = "animationEnterFrame";

		/**
		 * Animation 类播放到最后一帧时的 end 事件。
		 */
		public static const ANIMATION_END:String = "animationEnd";

		/**
		 * 构造函数。
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 *
		 */
		public function AnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}