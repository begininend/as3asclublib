package org.asclub.engine
{
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import org.asclub.engine.Ticker;
	
	public final class MainTimer
	{
		public static const TIMER_DEFAULT:String = "timerDefault";
		private static var _timerMap:Dictionary;
		
		
		public function MainTimer()
		{
			throw new Error("静态方法，请勿实例化");
		}
		
		//===========================================================================================================
		//  Public method
		//===========================================================================================================
		
		
		/**
		 * 添加并启动计时器
		 * @param	id      		计时器id
		 * @param	delay   		延迟时间（以毫秒为单位）。 
		 * @param	repeatCount		运行总次数。
		 * @return  返回添加的计时器的引用
		 */
		public static function addTimer(id:String = MainTimer.TIMER_DEFAULT, delay:Number = 1000, repeatCount:int = 0):Timer
		{
			if (!(id in MainTimer._getMap()))
			{
				var timer:Ticker = new Ticker(delay,repeatCount);
				timer.start();
				MainTimer._getMap()[id] = timer;
			}
			else
			{
				if (delay != MainTimer._getMap()[id]["delay"])
				{
					MainTimer._getMap()[id]["delay"] = delay;
				}
				else if (repeatCount != MainTimer._getMap()[id]["repeatCount"])
				{
					MainTimer._getMap()[id]["repeatCount"] = repeatCount;
				}
			}
			
			return MainTimer._getMap()[id];
		}
		
		/**
		 * 获取定义的计时器
		 * @param	id
		 * @return
		 */
		public static function getTimer(id:String = MainTimer.TIMER_DEFAULT):Timer
		{
			if (!(id in MainTimer._getMap()))
			{
				return null;
			}
			return MainTimer._getMap()[id];
        }
		
		/**
		 * 返回Timer在字典表里的id名称
		 * 
		 * @param timer	Timer对象
		 * @return 
		 * 
		 */
		public static function getTimerID(timer:Timer):String
		{
			for (var key:* in MainTimer._getMap())
			{
				if (MainTimer._getMap()[key] == timer)
					return key.toString();
			}
			return null;
		}
		/**
		 * 获取 计时器事件间的延迟（以毫秒为单位）。
		 * @param	id    计时器id
		 * @return
		 */ 
		public static function getTimerDelay(id:String = MainTimer.TIMER_DEFAULT):Number
		{
			if (!(id in MainTimer._getMap()))
			{
				throw new Error("未找到ID为:" + id + "的计时器");
			}
			
			return MainTimer._getMap()[id]["delay"];
		}
		
		/**
		 * 设置 计时器事件间的延迟（以毫秒为单位）。 
		 * @param	delayValue    延迟
		 * @param	id            计时器id
		 */
		public static function setTimerDelay(delay:Number, id:String = MainTimer.TIMER_DEFAULT):void
		{
			if (!(id in MainTimer._getMap()))
			{
				throw new Error("未找到ID为:" + id + "的计时器");
			}
			MainTimer._getMap()[id]["delay"] = delay;
		}
		
		/**
		 * 获取 计时器运行总次数。
		 * @return
		 */
		public static function getTimerRepeatCount(id:String = MainTimer.TIMER_DEFAULT):int
		{
			if (!(id in MainTimer._getMap()))
			{
				throw new Error("未找到ID为:" + id + "的计时器");
			}
			
			return MainTimer._getMap()[id]["repeatCount"];
		}
		
		/**
		 * 设置 计时器运行总次数。
		 * @param	repeatCountValue   运行总次数。
		 * @param	id            	   计时器id
		 */
		public static function setTimerRepeatCount(repeatCount:int, id:String = MainTimer.TIMER_DEFAULT):void
		{
			if (!(id in MainTimer._getMap()))
			{
				throw new Error("未找到ID为:" + id + "的计时器");
			}
			
			MainTimer._getMap()[id]["repeatCount"] = repeatCount;
		}
		
		/**
		 * 移除计时器
		 * @param	id
		 * @return  如果移除成功返回true，否则返回false
		 */
		public static function removeStage(id:String = MainTimer.TIMER_DEFAULT):Boolean {
			if (!(id in MainTimer._getMap()))
				return false;
			
			MainTimer._getMap()[id] = null;
			
			return true;
		}
		
		//如果计时器正在运行，则停止计时器，并将 currentCount 属性设回为 0.
		public static function reset(id:String = MainTimer.TIMER_DEFAULT):void
		{
			if (id in MainTimer._getMap())
			{
				MainTimer._getMap()[id].reset();
			}
		}
		
		//停止计时器。
		public static function stop(id:String = MainTimer.TIMER_DEFAULT):void
		{
			if (id in MainTimer._getMap())
			{
				MainTimer._getMap()[id].stop();
			}
		}
		
		//===========================================================================================================
		//  Private method
		//===========================================================================================================
		
		
		private static function _getMap():Dictionary {
			if (MainTimer._timerMap == null)
				MainTimer._timerMap = new Dictionary();
			
			return MainTimer._timerMap;
		}
		
	}//end of class
}
