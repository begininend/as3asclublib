/*
 * DateUtil.as
 * Copyright (c) 2009  CYJB
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.asclub.date {
	
	import org.asclub.data.ConversionUtil;

	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 * <code>DateUtil</code> 类包含了与 <code>Date</code> 有关的工具类.
	 * 
	 * <p>该工具类包括以下函数或属性:</p>
	 * <ul>
	 * <li><code>DAYS_IN_MONTH</code> :每个月的天数(二月为 28 天).</li>
	 * <li><code>SECOND</code> :一秒相当于的毫秒数.</li>
	 * <li><code>MINUTE</code> :一分钟相当于的毫秒数.</li>
	 * <li><code>HOUR</code> :一小时相当于的毫秒数.</li>
	 * <li><code>DAY</code> :一天相当于的毫秒数.</li>
	 * <li><code>isLeapYear()</code> :获取指定年份是否是闰年.</li>
	 * <li><code>getDays()</code> :获取指定月份的天数.</li>
	 * <li><code>isEqual()</code> :判断两个 <code>Date</code> 对象的日期或时间是否相同.</li>
	 * <li><code>elapsedTimes()</code> :得到两个 <code>Date</code> 对象相差的时间</li>
	 * </ul>
	 *
	 * @author CYJB
	 * @versions 1.0
	 * @since 2009-1-29
	 */
	public final class DateUtil{
		/**
		 * @private
		 * 该类的版本.
		 */
		public static const version:String = "1.0";
		/**
		 * 每个月的天数(二月为 28 天).
		 * 
		 * 月份是从 <code>0</code> 到 <code>11</code>,分别代表一月到十二月.
		 */
		public static const DAYS_IN_MONTH:Array = [31, 28, 31, 30, 31, 30, 31, 
				31, 30, 31, 30, 31];
		/**
		 * 一秒相当于的毫秒数.
		 */
		public static const SECOND:uint = 1000;
		/**
		 * 一分钟相当于的毫秒数.
		 */
		public static const MINUTE:uint = SECOND * 60;
		/**
		 * 一小时相当于的毫秒数.
		 */
		public static const HOUR:uint = MINUTE * 60;
		/**
		 * 一天相当于的毫秒数.
		 */
		public static const DAY:uint = HOUR * 24;
		/**
		 * 获取指定年份是否是闰年.
		 * 
		 * @param year 要判断的年份.
		 * 
		 * @return 如果是闰年,则返回 <code>true</code>;否则返回 <code>false</code>.
		 * 
		 * @internal 能整除 4 但不能整除 100 的是闰年,能整除 400 的也是闰年.
		 * 不存在公元 0 年,如果 year 传入 0,返回 false.
		 */
		public static function isLeapYear(year:uint):Boolean {
			if(year == 0)
				return false;
			return ((year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0)));
		}
		/**
		 * 获取指定月份的天数.
		 * 
		 * 如果指定了年份,会将闰年计算在内.
		 * 
		 * @param month 月份.
		 * @param year 年份.
		 * 
		 * @return 该月的天数.
		 */
		public static function getDays(month:uint, year:uint = 0):uint {
			var m:uint = month % 12;
			var re:uint = DAYS_IN_MONTH[m];
			if((m == 1) && year && isLeapYear(year + month / 12)){
				//2 月闰年 29 天
				re ++;
			}
			return re;
		}
		
		/**
		 * 老外写的 获取指定月份的天数（很淫荡）.
		 * @param	year     年份.
		 * @param	month    月份.
		 * @return  uint     该月的天数.
		 */
		public static function getDaysInMonth(year:Number, month:Number):uint {
			return (new Date(year, ++month, 0)).getDate();
		}
		
		/**
		 * 判断两个 <code>Date</code> 对象的日期或时间是否相同.
		 * 
		 * 可以分别比较日期和时间.
		 * 
		 * @param date1 要比较的 <code>Date</code> 对象.
		 * @param date2 要比较的 <code>Date</code> 对象.
		 * @param date 是否比较日期.
		 * @param time 是否比较时间(精确到秒).
		 * @param milliseconds 是否比较毫秒.
		 * 
		 * @return 如果两个日期相同,则返回 <code>true</code>;否则返回 <code>false</code>.
		 * 
		 * @includeExample examples/DateUtil.isEqual.1.as -noswf
		 */
		public static function isEqual(date1:Date, date2:Date, 
				date:Boolean = true, time:Boolean = true, 
				milliseconds:Boolean = false):Boolean {
			if(!date1 || !date2) {
				return false;
			}
			if(date) {
				//比较年,月,日
				if(date1.date != date2.date || date1.month != date2.month || 
						date1.fullYear != date2.fullYear)
					return false;
			}
			if(time) {
				//比较时,分,秒
				if(date1.hours != date2.hours || date1.minutes != date2.minutes ||
						date1.seconds != date2.seconds)
					return false;
			}
			//比较毫秒
			if(milliseconds && (date1.milliseconds != date2.milliseconds)) {
				return false;
			}
			return true;
		}
		/**
		 * 得到两个 <code>Date</code> 对象相差的时间.
		 * 
		 * 默认的到的相差的毫秒数,通过更改 <code>divisor</code> 参数,可以得到其他单位的数值.
		 * 
		 * @param date1 第一个 <code>Date</code> 对象.
		 * @param date2 第二个 <code>Date</code> 对象.
		 * @param divisor 时间的除数,用于更改单位.
		 * 
		 * @return 两个对象相差时间.
		 * 
		 * @includeExample examples/DateUtil.elapsedTimes.1.as -noswf
		 */
		public static function elapsedTimes(date1:Date, date2:Date, 
				divisor:uint = 1):Number {
			if(!date1 || !date2) {
				return 0;
			}
			return (date1.time - date2.time) / divisor;
		}
		
		/**
		* 从毫秒数中返回时间 ,例如 20225454  =>  01:25:07
		* @param millisecond 毫秒数.
		* @return 时:分:秒.
		*/
		public static function getTimeByMilliseconds(millisecond:Number):String
		{
			millisecond = millisecond / 1000;
			var hours:String = (Math.floor(millisecond / 3600) > 9 ? Math.floor(millisecond / 3600).toString() : ("0" + Math.floor(millisecond / 3600)));
			var minutes:String = (Math.floor(millisecond / 60 % 60) > 9 ? Math.floor(millisecond / 60 % 60).toString() : ("0" + Math.floor(millisecond / 60 % 60)));
			var seconds:String = (Math.floor(millisecond % 60) >9 ? Math.floor(millisecond % 60).toString() : ("0" + Math.floor(millisecond % 60)));
			return hours + ":" + minutes + ":" + seconds;
		}
		
		/**
			Gets the current day out of the total days in the year (starting from 0).
			获取某个日期以来在一年中的第几天(从0开始)
			@param d: Date object to find the current day of the year from.
			@return Returns the current day of the year (0-364 or 0-365 on a leap year).
		*/
		public static function getDayOfTheYear(d:Date):uint {
			var firstDay:Date = new Date(d.getFullYear(), 0, 1);
			return (d.getTime() - firstDay.getTime()) / 86400000;
		}
		
		/**
			Determines the week number of year, weeks start on Mondays.
			获取某个日期在一年的第几个周(一周从星期一开始)
			@param d: Date object to find the current week number of.
			@return Returns the the week of the year the date falls in.
		*/
		public static function getWeekOfTheYear(d:Date):uint 
		{
			var firstDay:Date    = new Date(d.getFullYear(), 0, 1);
			var dayOffset:uint   = 9 - firstDay.getDay();
			var firstMonday:Date = new Date(d.getFullYear(), 0, (dayOffset > 7) ? dayOffset - 7 : dayOffset);
			var currentDay:Date  = new Date(d.getFullYear(), d.getMonth(), d.getDate());
			var weekNumber:uint  = (ConversionUtil.millisecondsToDays(currentDay.getTime() - firstMonday.getTime()) / 7) + 1;
			
			return (weekNumber == 0) ? DateUtil.getWeekOfTheYear(new Date(d.getFullYear() - 1, 11, 31)) : weekNumber;
		}
		
		/**
		* Returns a date string formatted according to W3CDTF.
		*
		* @param d
		* @param includeMilliseconds Determines whether to include the
		* milliseconds value (if any) in the formatted string.
		*
		* @returns
		*
		* @langversion ActionScript 3.0
		* @playerversion Flash 9.0
		* @tiptext
		*
		* @see http://www.w3.org/TR/NOTE-datetime
		*/	
		public static function toW3CDTF(d:Date,includeMilliseconds:Boolean=false):String
		{
			var date:Number = d.getUTCDate();
			var month:Number = d.getUTCMonth();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var milliseconds:Number = d.getUTCMilliseconds();
			var sb:String = new String();
			
			sb += d.getUTCFullYear();
			sb += "-";
			
			//thanks to "dom" who sent in a fix for the line below
			if (month + 1 < 10)
			{
				sb += "0";
			}
			sb += month + 1;
			sb += "-";
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += "T";
			if (hours < 10)
			{
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{
				sb += "0";
			}
			sb += seconds;
			if (includeMilliseconds && milliseconds > 0)
			{
				sb += ".";
				sb += milliseconds;
			}
			sb += "-00:00";
			return sb;
		}
		
		/**
		*	Returns a short hour (0 - 12) represented by the specified date.
		*
		*	If the hour is less than 12 (0 - 11 AM) then the hour will be returned.
		*
		*	If the hour is greater than 12 (12 - 23 PM) then the hour minus 12
		*	will be returned.
		* 
		* 	@param d1 The Date from which to generate the short hour
		* 
		* 	@return An int between 0 and 13 ( 1 - 12 ) representing the short hour.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function getShortHour(d:Date):int
		{
			var h:int = d.hours;
			
			if(h == 0 || h == 12)
			{
				return 12;
			}
			else if(h > 12)
			{
				return h - 12;
			}
			else
			{
				return h;
			}
		}
		
		/**
		*	Returns a two digit representation of the year represented by the 
		*	specified date.
		* 
		* 	@param d The Date instance whose year will be used to generate a two
		*	digit string representation of the year.
		* 
		* 	@return A string that contains a 2 digit representation of the year.
		*	Single digits will be padded with 0.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function getShortYear(d:Date):String
		{
			var dStr:String = String(d.getFullYear());
			
			if(dStr.length < 3)
			{
				return dStr;
			}

			return (dStr.substr(dStr.length - 2));
		}
		
	}//end of class
}
