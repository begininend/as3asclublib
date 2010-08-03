package org.asclub.game
{
	
	import flash.utils.getTimer;
	/**
	 * 服务器时间
	 * @example
	 * <code>
	 * 		
	 * </code>
	 */
	public class ServiceDate
	{
		//服务端时间，以毫秒为单位
		private static var _serverTime:Number;
		//接到服务器时间时，Flash Player 已经初始化后并运行的时间
		private static var _runTime:Number;
		
		/**
		 * 设置服务器时间(以毫秒为单位)
		 * @param	serviceTime
		 */
		public static function setServiceTime(serviceTime:Number):void
		{
			_runTime = getTimer();
			_serverTime = serviceTime;
		}
		
		/**
		 * 获取服务器当前日期时间
		 * @return  Date
		 */
		public static function getDate():Date
		{
			return new Date(getTime());
		}
		
		/**
		 * 返回服务器的当前时间(以毫秒为单位)
		 * 之所以使用getTimer 而不使用 Date,是因为Date是获取玩家操作系统的时间，而玩家又可以自行更改操作系统时间
		 * @return
		 */
		public static function getTime():Number
		{
			return _serverTime + getTimer() - _runTime;
		}
	}//end of class
}