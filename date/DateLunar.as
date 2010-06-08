/*
 * DateLunar.as
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
	import org.asclub.error.ErrorUtil;
	import org.asclub.date.DateUtil;

	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 * <code>DateLunar</code> 类是一个农历日期类,表示农历日期信息.
	 * 
	 * 该类类似于 <code>Date</code> 类,可以用于农历日期与公历日期的相互转换,计算节气和
	 * 天干地支,但仅限于计算日期,无法计算相应的具体时间.
	 * 
	 * <p>该类可以计算农历的日期是从 1900年1月31日 0时0分0秒0毫秒 到 2101年1月28日 
	 * 23时59分59秒999毫秒,即 1900 年初一至 2100 年除夕.</p>
	 *
	 * @author CYJB
	 * @versions 1.0
	 * @since 2009-1-29
	 */
	public final class DateLunar {
		/**
		 * @private
		 * 该类的版本.
		 */
		public static const version:String = "1.0";
		/**
		 * 农历数据支持的最小农历年份.
		 * 
		 * 该年份是 1900 年.
		 * 
		 * @see #MAX_SUPPORTED_YEAR
		 * @see #MIN_SUPPORTED_DATE
		 */
		public static const MIN_SUPPORTED_YEAR:uint = 1900;
		/**
		 * 农历数据支持的最小公历日期.
		 * 
		 * 该日期是 1900年1月31日 0时0分0秒0毫秒.
		 * 
		 * @see #MAX_SUPPORTED_DATE
		 * @see #MIN_SUPPORTED_YEAR
		 */
		public static const MIN_SUPPORTED_DATE:Date = new Date(1900, 0, 31, 0, 
				0, 0, 0);
		/**
		 * 农历数据支持的最大农历年份.
		 * 
		 * 该年份是 2100 年.
		 * 
		 * @see #MIN_SUPPORTED_YEAR
		 * @see #MAX_SUPPORTED_DATE
		 */
		public static const MAX_SUPPORTED_YEAR:uint = 2100;
		/**
		 * 农历数据支持的最大公历日期.
		 * 
		 * 该日期是 2101年1月28日 23时59分59秒999毫秒.
		 * 
		 * @see #MAX_SUPPORTED_YEAR
		 * @see #MIN_SUPPORTED_DATE
		 */
		public static const MAX_SUPPORTED_DATE:Date = new Date(2101, 0, 28, 
				23, 59, 59, 999);
		/**
		 * 设置是否从节气开始分割干支记年与记月.
		 * 
		 * <p>对于从何时分割干支记年与记月,有两种说法.一种是从每月的初一分割,从初一后才算下一个
		 * 干支年/月;另一种是按照节气来分割,就是每年第一个节气之后才算下一个干支年,每两个节气
		 * 之后才算下一个干支月.</p>
		 * 
		 * <p>如果该属性为 <code>true</code> ,则从节气开始分割干支记年与记月;否则从每年或
		 * 每月的 1 日开始.</p>
		 */
		public static var sliceFromSolarTerm:Boolean = true;
		/**
		 * 农历的日期数据.
		 * 
		 * 1900 年 - 2100 年.
		 * 
		 * @internal 0xABBBC 格式说明
		 * A:该年的闰月是大月还是小月.大月是 1,小月是 0.
		 * BBB:这三位 16 进制数对应的 12 位 2 进制指定了 1 月到 12 月是大月还是小月.
		 * C:该年的闰月,1 - C 指示闰那个月,没有闰月是 0.
		 */
		private static const LUNAR_INFO:Array = [
0x04BD8, 0x04AE0, 0x0A570, 0x054D5, 0x0D260, 0x0D950, 0x16554, 0x056A0, 0x09AD0, 0x055D2,
0x04AE0, 0x0A5B6, 0x0A4D0, 0x0D250, 0x1D255, 0x0B540, 0x0D6A0, 0x0ADA2, 0x095B0, 0x14977,
0x04970, 0x0A4B0, 0x0B4B5, 0x06A50, 0x06D40, 0x1AB54, 0x02B60, 0x09570, 0x052F2, 0x04970,
0x06566, 0x0D4A0, 0x0EA50, 0x06E95, 0x05AD0, 0x02B60, 0x186E3, 0x092E0, 0x1C8D7, 0x0C950,
0x0D4A0, 0x1D8A6, 0x0B550, 0x056A0, 0x1A5B4, 0x025D0, 0x092D0, 0x0D2B2, 0x0A950, 0x0B557,
0x06CA0, 0x0B550, 0x15355, 0x04DA0, 0x0A5B0, 0x14573, 0x052B0, 0x0A9A8, 0x0E950, 0x06AA0,
0x0AEA6, 0x0AB50, 0x04B60, 0x0AAE4, 0x0A570, 0x05260, 0x0F263, 0x0D950, 0x05B57, 0x056A0,
0x096D0, 0x04DD5, 0x04AD0, 0x0A4D0, 0x0D4D4, 0x0D250, 0x0D558, 0x0B540, 0x0B6A0, 0x195A6,
0x095B0, 0x049B0, 0x0A974, 0x0A4B0, 0x0B27A, 0x06A50, 0x06D40, 0x0AF46, 0x0AB60, 0x09570,
0x04AF5, 0x04970, 0x064B0, 0x074A3, 0x0EA50, 0x06B58, 0x055C0, 0x0AB60, 0x096D5, 0x092E0,
0x0C960, 0x0D954, 0x0D4A0, 0x0DA50, 0x07552, 0x056A0, 0x0ABB7, 0x025D0, 0x092D0, 0x0CAB5,
0x0A950, 0x0B4A0, 0x0BAA4, 0x0AD50, 0x055D9, 0x04BA0, 0x0A5B0, 0x15176, 0x052B0, 0x0A930,
0x07954, 0x06AA0, 0x0AD50, 0x05B52, 0x04B60, 0x0A6E6, 0x0A4E0, 0x0D260, 0x0EA65, 0x0D530,
0x05AA0, 0x076A3, 0x096D0, 0x04BD7, 0x04AD0, 0x0A4D0, 0x1D0B6, 0x0D250, 0x0D520, 0x0DD45,
0x0B5A0, 0x056D0, 0x055B2, 0x049B0, 0x0A577, 0x0A4B0, 0x0AA50, 0x1B255, 0x06D20, 0x0ADA0,
0x14B63, 0x09370, 0x049F8, 0x04970, 0x064B0, 0x168A6, 0x0EA50, 0x06B20, 0x1A6C4, 0x0AAE0, 
0x092E0, 0x0D2E3, 0x0C960, 0x0D557, 0x0D4A0, 0x0DA50, 0x05D55, 0x056A0, 0x0A6D0, 0x055D4, 
0x052D0, 0x0A9B8, 0x0A950, 0x0B4A0, 0x0B6A6, 0x0AD50, 0x055A0, 0x0ABA4, 0x0A5B0, 0x052B0, 
0x0B273, 0x06930, 0x07337, 0x06AA0, 0x0AD50, 0x14B55, 0x04B60, 0x0A570, 0x054E4, 0x0D260, 
0x0E968, 0x0D520, 0x0DAA0, 0x16AA6, 0x056D0, 0x04AE0, 0x0A9D4, 0x0A4D0, 0x0D150, 0x0F252, 
0x0D520];
		/**
		 * 在计算中存储数据的数组,可以用来优化计算.
		 * 
		 * 该数组中存储索引年之前到最小支持年之间的天数.
		 */
		private static var YEAR_DATE:Array = [0];
		/**
		 * 对应的公历日期.
		 */
		private var _dateSolar:Date;
		/**
		 * 农历年份.
		 * 
		 * MIN_SUPPORTED_YEAR - MAX_SUPPORTED_YEAR
		 */
		private var _year:uint;
		/**
		 * 农历月份.
		 * 
		 * 0 - 11
		 */
		private var _month:uint;
		/**
		 * 农历日期.
		 * 
		 * 1 - 30
		 */
		private var _date:uint;
		/**
		 * 是否是闰月.
		 * 
		 * true/false
		 */
		private var _isLeap:Boolean;
		/**
		 * 构造一个新的 <code>DateLunar</code> 对象,该对象将保存指定的日期.
		 * 
		 * <ul>
		 * <li>如果未传递参数,则赋予 <code>DateLunar</code> 对象当前的日期.</li>
		 * <li>如果传递一个 <code>Date</code> 对象,则赋予 <code>DateLunar</code> 对
		 * 象与 <code>Date</code> 对象相同的公历日期.</li>
		 * <li>如果传递一个 Number 数据类型的参数,则基于自农历 1900 年正月初一以来的天数赋予 
		 * <code>DateLunar</code> 对象一个时间值.</li>
		 * <li>如果传递两个或更多个参数,则会认为传入的参数分别表示农历的年份,月份,日期和是
		 * 否是闰月.</li>
		 * </ul>
		 *
		 * @param yearOrTimevalue 如果指定了其它参数,则此数字表示农历年份;否则,表示时间值.
		 * @param month <code>0</code>(一月)到 <code>11</code>(十二月)之间的一个整数.
		 * @param date <code>1</code>(初一) 到 <code>30</code>(三十) 之间的一个整数.
		 * @param isLeap <code>true</code> 表示当月指的是闰月;否则当月不是闰月.
		 * 
		 * @throws ArgumentError 当日期不在可支持的范围内时引发.
		 * 
		 * @see #dateSolar
		 * @see #year
		 * @see #month
		 * @see #date
		 * @see #isLeap
		 * 
		 * @includeExample examples/DateLunar.DateLunar.1.as -noswf
		 */
		public function DateLunar(yearOrTimevalue:Object = null, month:uint = 0, 
				date:uint = 1, isLeap:Boolean = false):void {
			if(yearOrTimevalue is Date) {
				//指定的是日期
				_dateSolar = yearOrTimevalue as Date;
				checkDate(_dateSolar);
				calculateDate();
			} else if(arguments.length) {
				if(arguments.length == 1) {
					//指定的是日期偏移
					calculateDate(uint(yearOrTimevalue));
				} else {
					//指定的是年,月,日
					_year = uint(yearOrTimevalue);
					_month = month;
					_date = date;
					_isLeap = isLeap;
					calculateLunar();
				}
			} else {
				//未指定日期
				_dateSolar = new Date();
				checkDate(_dateSolar);
				calculateDate();
			}
		}
		/**
		 * 设置或获取对应的公历日期.
		 * 
		 * @throws ArgumentError 当日期不在可支持的范围内时引发.
		 */
		public function get dateSolar():Date {
			return _dateSolar;
		}
		public function set dateSolar(value:Date):void {
			checkDate(value);
			_dateSolar = value;
		}
		/**
		 * <code>DateLunar</code> 对象中自农历 1900 年正月初一以来的天数.
		 * 
		 * @throws ArgumentError 当时间不在可支持的范围内时引发.
		 */
		public function get time():uint {
			return DateUtil.elapsedTimes(_dateSolar, MIN_SUPPORTED_DATE, DateUtil.DAY);;
		}
		public function set time(value:uint):void {
			calculateDate(value);
		}
		/**
		 * 获取或设置农历年份.
		 * 
		 * <p>该年份总是与相应的公历年份对应,并应当处于 1900 至 2100 范围之内
		 * (含 1900 和 2100).</p>
		 * 
		 * @see #yearCyclical
		 * 
		 * @throws ArgumentError 当年份不在可支持的范围内时引发.
		 */
		public function get year():uint {
			return _year;
		}
		public function set year(value:uint):void {
			_year = value;
			calculateLunar();
		}
		/**
		 * 获取或设置农历月份.
		 * 
		 * 月份有效值为 0 至 11,代表正月到十二月.
		 * 
		 * @see #isLeap
		 * @see #monthCyclical
		 * 
		 * @throws ArgumentError 当日期不在可支持的范围内时引发.
		 */
		public function get month():uint {
			return _month;
		}
		public function set month(value:uint):void {
			_month = value;
			calculateLunar();
		}
		/**
		 * 获取或设置农历日期.
		 * 
		 * 日期有效值为 1 至 30
		 * 
		 * @see #dateCyclical
		 * 
		 * @throws ArgumentError 当日期不在可支持的范围内时引发.
		 */
		public function get date():uint {
			return _date;
		}
		public function set date(value:uint):void {
			_date = value;
			calculateLunar();
		}
		/**
		 * 获取或设置当前月是否是闰月.
		 * 
		 * 若当前月不能是闰月,则不会更改 <code>isLeap</code> 属性.
		 * 
		 * @see #month
		 */
		public function get isLeap():Boolean {
			return _isLeap;
		}
		public function set isLeap(value:Boolean):void {
			if(_isLeap == value) {
				return;
			}
			var m:uint = getLeapMonth(_year);
			if(m == _month + 1) {
				_isLeap = value;
				calculateLunar();
			}
		}
		/**
		 * 获取年份的干支序号.
		 * 
		 * 干支序号的可能范围是 <code>0 - 59</code>, 0 是甲子, 59 是癸亥.
		 * 
		 * @see #year
		 * @see #getYearCyclical()
		 */
		public function get yearCyclical():uint {
			var index:uint;
			if(sliceFromSolarTerm) {
				//以节气为分界
				index = getYearCyclical(_dateSolar.fullYear);
				//立春日期之前算上一年的干支.
				if((_dateSolar.month < 1) || ((_dateSolar.month == 1) && 
						(_dateSolar.date < calculateTerm(_dateSolar.fullYear, 2)))) {
					if(index == 0)
						index = 59;
					else
						index --;
				}
			} else {
				index = getYearCyclical(_year);
			}
			return index;
		}
		/**
		 * 获取月份干支序号.
		 * 
		 * 干支序号的可能范围是 <code>0 - 59</code>, 0 是甲子, 59 是癸亥.
		 * 
		 * @see #month
		 * @see #getMonthCyclical()
		 */
		public function get monthCyclical():uint {
			if(sliceFromSolarTerm) {
				//1900 年 1 月小寒以前为 丙子月(12)
				var firstTerm:uint = calculateTerm(_dateSolar.fullYear, _dateSolar.month * 2);
				var index:uint;
				index = (_dateSolar.fullYear - 1900) * 12 + _dateSolar.month + 12;
				if(_dateSolar.date >= firstTerm) {
					index ++;
				}
				return index % 60;
			} else {
				return getMonthCyclical(_year, _month);
			}
			return 0;
		}
		/**
		 * 获取日期干支序号.
		 * 
		 * 干支序号的可能范围是 <code>0 - 59</code>, 0 是甲子, 59 是癸亥.
		 * 
		 * @see #date
		 */
		public function get dateCyclical():uint {
			//1900.1.1 日为甲戌日(60进制10)
			var num:Number = DateUtil.elapsedTimes(_dateSolar, 
				new Date(1900, 0, 1), DateUtil.DAY);
			return (num + 10) % 60;
		}
		/**
		 * 获取时间干支序号.
		 * 
		 * 干支序号的可能范围是 <code>0 - 59</code>, 0 是甲子, 59 是癸亥.
		 */
		public function get hourCyclical():uint {
			//1900.1.1 日 从 1:00 开始为乙丑时(60进制1)
			var num:Number = DateUtil.elapsedTimes(_dateSolar, 
				new Date(1900, 0, 1, 1), DateUtil.HOUR) / 2 + 1;
			return num % 60;
		}
		/**
		 * 获取属相的索引.
		 * 
		 * 属相的索引的可能范围是 <code>0 - 11</code>, 0 是子鼠, 11 是亥猪. 
		 * 
		 * @see #getAnimal()
		 */
		public function get animal():uint {
			if(sliceFromSolarTerm) {
				//以节气为分界
				return yearCyclical % 12;
			} else {
				return getAnimal(_year);
			}
		}
		/**
		 * 获取当前日期的节气.
		 * 
		 * 如果当前日期是某个节气,则返回该节气的索引(0 - 23);否则返回 <code>-1</code>.
		 * 
		 * <p>节气的顺序为:</p>
		 * <p>小寒, 大寒, 立春, 雨水, 惊蛰, 春分, 清明, 谷雨, 立夏, 小满, 芒种, 夏至, 
		 * 小暑, 大署, 立秋, 处暑, 白露, 秋分, 寒露, 霜降, 立冬, 小雪, 大雪, 冬至</p>
		 * 
		 * @see #getSolarTerm()
		 */
		public function get solarTerm():int {
			var year:uint = _dateSolar.fullYear;
			var index:uint = _dateSolar.month * 2;
			var day:uint = calculateTerm(year, index);
			if(day == _dateSolar.date) {
				return index;
			}
			index++;
			day = calculateTerm(year, index);
			if(day == _dateSolar.date) {
				return index;
			}
			return -1;
		}
		/**
		 * 返回农历指定年的闰月.
		 * 
		 * <code>1 - 12</code> 指示闰那个月,没有闰月是 <code>0</code>.
		 * 
		 * @param year 要检查的年份.
		 * 
		 * @return 指定年的闰月.
		 * 
		 * @throws ArgumentError 当年份不在可支持的范围内时引发.
		 */
		public static function getLeapMonth(year:uint):uint {
			checkYear(year);
			return leapMonth(year - MIN_SUPPORTED_YEAR);
		}
		/**
		 * 返回农历指定年闰月的天数.
		 * 
		 * @param year 要检查的年份.
		 * 
		 * @return 指定年闰月的天数,没有闰月是 <code>0</code>.
		 * 
		 * @throws ArgumentError 当年份不在可支持的范围内时引发.
		 */
		public static function getLeapDays(year:uint):uint {
			checkYear(year);
			return leapDays(year - MIN_SUPPORTED_YEAR);
		}
		/**
		 * 返回农历指定年份指定月份的总天数.
		 * 
		 * @param year 要检查的年份.
		 * @param month 要检查的月份,月份是从 <code>0</code> 到 <code>11</code>.
		 * 
		 * @return 指定年指定月份的天数.
		 * 
		 * @throws ArgumentError 当年份不在可支持的范围内时引发.
		 * @throws ArgumentError 当月份不在可支持的范围内时引发.
		 */
		public static function getMonthDays(year:uint, month:uint):uint {
			checkYear(year);
			checkMonth(month);
			return monthDays(year - MIN_SUPPORTED_YEAR, month);
		}
		/**
		 * 返回农历指定年份的总天数.
		 * 
		 * @param year 要检查的年份.
		 * 
		 * @return 指定年份的总天数.
		 * 
		 * @throws ArgumentError 当年份不在可支持的范围内时引发.
		 */
		public static function getYearDays(year:uint):uint {
			checkYear(year);
			return yearDays(year - MIN_SUPPORTED_YEAR);
		}
		/**
		 * 返回农历指定年份的干支序号.
		 * 
		 * 干支序号的可能范围是 <code>0 - 59</code>, 0 是甲子, 59 是癸亥.
		 * 
		 * @param year 要检查的年份.
		 * 
		 * @return 指定年份的干支序号.
		 */
		public static function getYearCyclical(year:uint):uint {
			//农历 0 年为庚申年(60进制56)
			return (year + 56) % 60;
		}
		/**
		 * 返回农历指定年份属相的索引.
		 * 
		 * 属相的索引的可能范围是 <code>0 - 11</code>, 0 是子鼠, 11 是亥猪.
		 * 
		 * @param year 要检查的年份.
		 * 
		 * @return 指定年份属相的索引.
		 */
		public static function getAnimal(year:uint):uint {
			return (year + 56) % 12;
		}
		/**
		 * 返回农历指定年份指定月份的干支序号.
		 * 
		 * 干支序号的可能范围是 <code>0 - 59</code>, 0 是甲子, 59 是癸亥.
		 * 
		 * <p>平月和闰月的干支序号相同.</p>
		 * 
		 * @param year 要检查的年份.
		 * @param month 要检查的月份(0 - 11).
		 * 
		 * @return 指定年份的指定月份的干支序号.
		 * 
		 * @throws ArgumentError 当月份不在可支持的范围内时引发.
		 */
		public static function getMonthCyclical(year:uint, month:uint):uint {
			checkMonth(month);
			//农历 0 年正月为戊寅月(60进制14)
			return (year * 12 + month + 14) % 60;
		}
		/**
		 * 返回指定年份指定节气的时间.
		 * 
		 * 节气是一个索引,有效值从 0 - 23,分别指每年的 24 个节气.
		 * 
		 * <p>节气的顺序为:</p>
		 * <p>小寒, 大寒, 立春, 雨水, 惊蛰, 春分, 清明, 谷雨, 立夏, 小满, 芒种, 夏至, 
		 * 小暑, 大署, 立秋, 处暑, 白露, 秋分, 寒露, 霜降, 立冬, 小雪, 大雪, 冬至</p>
		 * 
		 * <p>该方法只能返回节气的近似时间,与实际的时间肯定是不同的,以真实时间为准.</p>
		 * 
		 * @param year 要检查的年份.
		 * @param index 要检查的节气的索引.
		 * 
		 * @return 该节气的公历日期.
		 * 
		 * @throws ArgumentError 当节气索引不在可支持的范围内时引发.
		 * 
		 * @internal 原始算法:
		 * //标准天数(Standard Days)(y年1月0日距该历制的1年1月0日的天数)。
		 * function SD(y:Number):Number {
		 * 	return (y-1)*365+floor((y-1)/4)-floor((y-1)/100)+floor((y-1)/400);
		 * }
		 * //返回y年第n个节气（如小寒为1）的D0（日差天数）值
		 * function S(y:Number, n:Number):Number {
		 * 	var juD = y*(365.2423112-(6.4e-14)*(y-100)*(y-100)-(3.047e-8)*(y-100))+
		 * 		15.218427*n+1721050.71301;
		 * 	//儒略日
		 * 	var tht = (3e-4)*y-0.372781384-0.2617913325*n;
		 * 	//角度
		 * 	var yrD = (1.945*sin(tht)-0.01206*sin(2*tht))*(1.048994-(2.583e-5)*y);
		 * 	//年差实均数
		 * 	var shuoD = (-18e-4)*sin(2.313908653*y-0.439822951-3.0443*n);
		 * 	//朔差实均数
		 * 	var vs = juD+yrD+shuoD-SD(y, 1, 0)-1721425;
		 * 	return vs;
		 * }
		 */
		public static function getSolarTerm(year:uint, index:uint):Date {
			if(index >= 24) {
				ErrorUtil.throwError(ArgumentError, 1508, "index");
			}
			//经过修改的算法
			var re:Number = (.2423112-(6.4e-14)*(year-100)*(year-100)-
				(3.047e-8)*(year-100))*year;
			re += 15.218427*index+5.931437-int((year-1)/4)+int((year-1)/100)-
				int((year-1)/400);
			var tht:Number = (3e-4)*year-0.6345727165-0.2617913325*index;
			re += (1.945*Math.sin(tht)-0.01206*Math.sin(2*tht))*(1.048994-(2.583e-5)*year);
			re += (-18e-4)*Math.sin(2.313908653*year-3.484122951-3.0443*index);
			var date:Date = new Date(year, 0, re);
			re = (re % 1) * 24;
			date.hours = int(re);
			re = (re % 1) * 60;
			date.minutes = int(re);
			re = (re % 1) * 60;
			date.seconds = int(re);
			re = (re % 1) * 1000;
			date.milliseconds = int(re);
			return date;
		}
		/**
		 * 返回农历年,月和日期值的字符串表示形式.
		 * 
		 * 输出的日期格式为:
		 * <p>农历 YYYY 年 Mon 月 Day 日</p>
		 * 
		 * @return <code>DateLunar</code> 对象的字符串表示形式.
		 */
		public function toString():String {
			return (_year + " 年" + (isLeap?"闰 ":" ") + (month + 1) + " 月 "
					 + date + " 日");
		}
		/**
		 * 根据公历日期计算农历日期.
		 */
		private function calculateDate(time:uint = 0):void {
			//当前日期与最小支持日期间隔的天数
			var offset:int;
			if(arguments.length) {
				offset = time;
				_dateSolar = new Date(MIN_SUPPORTED_DATE.time + offset * DateUtil.DAY);
			} else {
				offset = DateUtil.elapsedTimes(_dateSolar, MIN_SUPPORTED_DATE, 
					DateUtil.DAY);
			}
			var i:uint, y:uint, nYear:uint, temp:uint = 0, leap:uint = 0;
			//计算年份
			//缓存以前的年份计算结果,极大的提高了计算效率
			//年份的索引
			nYear = _dateSolar.fullYear - MIN_SUPPORTED_YEAR;
			//以前计算过的最大年份的索引
			y = YEAR_DATE.length - 1;
			if(y < nYear) {
				//只需计算从 y 开始至今的年份
				temp = YEAR_DATE[y];
				do {
					YEAR_DATE.push(temp = (yearDays(y) + temp));
					y++;
				} while (y < nYear);
			} else {
				//以前计算过,无需计算
				temp = YEAR_DATE[y = nYear];
			}
			//若是多计算了一年,则减去一年
			if(offset < temp) {
				y--;
				offset -= YEAR_DATE[y];
			} else {
				offset -= temp;
			}
			//offset 月份的总天数
			//计算月份
			leap = leapMonth(y);
			_isLeap = false;
			//至多有 13 个月(包括一个闰月)
			//月份从 0 - 11, 闰月从 1 - 12
			for(i = 0;i < 13 && offset > 0;i++) {
				//遇到闰月时,先计算平月,再计算闰月
				if(leap && i == leap && !_isLeap) {
					//有闰月,且当前月是闰月的后一个月,且未标记闰月
					//意味着当前月指的是闰月,上一次循环计算的是对应平月的天数
					i--;
					_isLeap = true;
					temp = leapDays(y);
				} else {
					//当前月不是闰月
					temp = monthDays(y, i);
				}
				//已经标记了闰月,且当前月是闰月的后一个月
				//证明在上一次循环时计算了闰月
				if(_isLeap && i == leap) {
					_isLeap = false;
				}
				offset -= temp;
			}
			//剩余天数恰好为 0,有闰月且正好计算到了闰月(最后一次循环 i 会多加 1)
			if(offset == 0 && leap && i == leap) {
				if(_isLeap) {
					//最后一次循环时计算了闰月的时间,即闰月恰好过完,应当到达下个月的第一天
					_isLeap = false;
				} else {
					//最后一次循环时计算了闰月的时间,即平月恰好过完,应当到达闰月的第一天
					_isLeap = true;
					i--;
				}
			}
			//多计算了一个月,减去一个月的时间
			if(offset < 0) {
				offset += temp;
				i--;
			}
			//年份 = 年份索引 + 起始年份
			_year = y + MIN_SUPPORTED_YEAR;
			_month = i;
			_date = offset + 1;
		}
		/**
		 * 根据农历日期计算公历日期.
		 */
		private function calculateLunar():void {
			//sum :从 1900 年正月初一至今的天数
			var i:uint, sum:uint = 0, leap:uint = 0;
			//若是月份超出范围,则将多余的月份累加到下一年
			if(_month > 12) {
				_year += Math.floor(_month / 12);
				_month %= 12;
			}
			//检查年份是否超出范围,只要年份和日期没有超出范围,计算出来的公历日期一定在支持的
			//范围之内
			checkYear(_year);
			//计算年份
			//缓存以前的年份计算结果,极大的提高了计算效率
			//年份的索引
			var y:uint = _year - MIN_SUPPORTED_YEAR;
			//以前计算过的最大年份的索引
			i = YEAR_DATE.length - 1;
			if(i < y) {
				//只需计算从 y 开始至今的年份
				sum = YEAR_DATE[i];
				for(;i < y;i++) {
					YEAR_DATE.push(sum = (yearDays(i) + sum));
				}
			} else {
				//以前计算过,无需计算
				sum = YEAR_DATE[y];
			}
			//计算月份
			leap = leapMonth(y);
			for(i = 0;i< _month;i++) {
				sum += monthDays(y, i);
			}
			//若已经过了闰月,则加上闰月天数
			if(leap && _month >= leap) {
				sum += leapDays(y);
			}
			//是否需要重新计算农历的标志
			//如果为 true ,则意味着 date 参数超出了范围,只能使用公历日期重新推断农历日期
			var setDate:Boolean = false;
			if(_isLeap && leap == _month + 1) {
				//当前月是闰月,则先加上对应平月的天数
				sum += monthDays(y, _month);
				//如果日期超出了范围,则需要重新计算农历日期
				if(_date > leapDays(y)) {
					setDate = true;
				}
			} else {
				//对平月来说, _isLeap 标志必须为 false
				_isLeap = false;
				//如果日期超出了范围,则需要重新计算农历日期
				if(_date > monthDays(y, _month)) {
					setDate = true;
				}
			}
			//加上日期的天数
			sum += _date - 1;
			//获取对应天数的日期
			_dateSolar = new Date(MIN_SUPPORTED_DATE.time + sum * DateUtil.DAY);
			if(setDate) {
				//使用公历日期重新推断农历日期
				dateSolar = _dateSolar;
			}
		}
		/**
		 * 返回指定年份指定节气的日期.
		 * 
		 * 节气是一个索引,有效值从 0 - 23,分别指每年的 24 个节气.
		 * 
		 * <p>节气的顺序为:</p>
		 * <p>小寒, 大寒, 立春, 雨水, 惊蛰, 春分, 清明, 谷雨, 立夏, 小满, 芒种, 夏至, 
		 * 小暑, 大署, 立秋, 处暑, 白露, 秋分, 寒露, 霜降, 立冬, 小雪, 大雪, 冬至</p>
		 * 
		 * @param year 要检查的年份.
		 * @param index 要检查的节气的索引.
		 * 
		 * @return 该节气的公历日期.
		 * 
		 * @throws ArgumentError 当节气索引不在可支持的范围内时引发.
		 */
		private static function calculateTerm(year:uint, index:uint):uint {
			return getSolarTerm(year, index).date;
		}
		/**
		 * 检查年份是否在可支持的范围内.
		 * 
		 * MIN_SUPPORTED_YEAR - MAX_SUPPORTED_YEAR
		 * 
		 * @throws ArgumentError 当年份不在可支持的范围内时引发.
		 */
		private static function checkYear(year:uint):void {
			if((year < MIN_SUPPORTED_YEAR) || (year > MAX_SUPPORTED_YEAR)) {
				ErrorUtil.throwError(ArgumentError, 1508, "year");
			}
		}
		/**
		 * 检查月份是否在可支持的范围内.
		 * 
		 * 0 - 11
		 * 
		 * @throws ArgumentError 当月份不在可支持的范围内时引发.
		 */
		private static function checkMonth(month:uint):void {
			if((month < 0) || (month > 11)) {
				ErrorUtil.throwError(ArgumentError, 1508, "month");
			}
		}
		/**
		 * 检查日期是否在可支持的范围内.
		 * 
		 * MIN_SUPPORTED_DATE - MAX_SUPPORTED_DATE
		 * 
		 * @throws ArgumentError 当日期不在可支持的范围内时引发.
		 */
		private static function checkDate(date:Date):void {
			var min:Number = MIN_SUPPORTED_DATE.getTime();
			var max:Number = MAX_SUPPORTED_DATE.getTime();
			var time:Number = date.getTime();
			if((time < min) || (time > max)) {
				ErrorUtil.throwError(ArgumentError, 1508, "date");
			}
		}
		/**
		 * 返回指定年份索引的闰月.
		 * 
		 * 1 - 12, 没有闰月返回 0.
		 * 
		 * @param index 要检查的年份的索引.
		 * 
		 * @return 指定年的闰月.
		 */
		private static function leapMonth(index:uint):uint {
			//获取农历信息最后一位的数值
			return (LUNAR_INFO[index] & 0xF);
		}
		/**
		 * 返回指定年份索引闰月的天数.
		 * 
		 * @param index 要检查的年份索引.
		 * 
		 * @return 指定年闰月的天数,没有闰月是 <code>0</code>.
		 */
		private static function leapDays(index:uint):uint {
			if(leapMonth(index)) {
				//获取农历信息第一位的数值
				return ((LUNAR_INFO[index] & 0x10000)? 30:29);
			} else {
				return 0;
			}
		}
		/**
		 * 返回指定年份索引指定月份的天数.
		 * 
		 * @param index 要检查的年份索引.
		 * @param month 要检查的月份,月份是从 <code>0</code> 到 <code>11</code>.
		 * 
		 * @return 指定年指定月份的天数.
		 */
		private static function monthDays(index:uint, month:uint):uint {
			//获取农历信息中月份信息
			//0x8000 = 1000 0000 0000 0000
			//最后四位是闰月月份,仅前 12 位是有效的
			return ((LUNAR_INFO[index] & (0x8000 >> month))? 30:29);
		}
		/**
		 * 返回指定年份索引的总天数.
		 * 
		 * @param year 要检查的年份索引.
		 * 
		 * @return 指定年份的总天数.
		 */
		private static function yearDays(index:uint):uint {
			//每月都是 29 天的话,总天数是 348.
			var i:uint, sum:uint = 348;
			var date:uint = LUNAR_INFO[index];
			for(i = 0x8000;i > 0x8; i >>= 1) {
				sum += (date & i)? 1:0;
			}
			return (sum + leapDays(index));
		}
	}
}
