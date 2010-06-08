package org.asclub.data
{
	public class NumberUtils
	{
		public function NumberUtils()
		{
			
		}
		
		/**
		 * 比较两个数字是否相等
		 * @param	val1          数字1
		 * @param	val2          数字2
		 * @param	precision     误差
		 * @return  Boolean
		 * @example
		 * 			<code>
		 * 					trace(NumberUtils.isEqual(3.042, 3, 0)); // Traces false
		 * 					trace(NumberUtils.isEqual(3.042, 3, 0.5)); // Traces true
		 * 			</code>
		 */
		public static function isEqual(val1:Number, val2:Number, precision:Number = 0):Boolean {
			return Math.abs(val1 - val2) <= Math.abs(precision);
		}
		
		/**
		 * 进制转换
		 * @param	txt        数字的字符串形式
		 * @param	radix      现有进制
		 * @param	target     目标进制
		 * @return
		 */
		public static function systemChange(txt:String,radix:uint,target:uint):String
		{
		  var num:Number = parseInt(txt,radix); //把2~32进制转换为10进制
		  return num.toString(target); //把10进制转换为2~32进制
		}
		
		/**
		 * 取得一定范围内的随机值(浮点)
		 * @param	min      起始值
		 * @param	max      结束值
		 * @return  Number   随机值(浮点)
		 */
		public static function randomWithinRange(min:Number, max:Number):Number {
			return min + (Math.random() * (max - min));
		}
		
		/**
		 * 取得一定范围内的随机整数
		 * @param	min   起始值
		 * @param	max   结束值
		 * @return  int   随机值(整数)
		 */
		public static function randomIntegerWithinRange(min:int, max:int):int {
			return Math.round(NumberUtils.randomWithinRange(min, max));
		}
		
		/**
		 * 是否是偶数
		 * @param	value
		 * @return
		 */
		public static function isEven(value:Number):Boolean {
			return (value & 1) == 0;
		}
		
		/**
		 * 是否是奇数
		 * @param	value
		 * @return
		 */
		public static function isOdd(value:Number):Boolean {
			return !NumberUtils.isEven(value);
		}
		
		/**
		 * 是否是整数
		 * @param	value
		 * @return
		 */
		public static function isInteger(value:Number):Boolean {
			return (value % 1) == 0;
		}
		
		/**
		 * 取得包含小数点后几位 的 数字
		 * @param	value
		 * @param	place  小数点后优秀位数
		 * @return
		 */
		public static function roundDecimalToPlace(value:Number, place:uint):Number {
			var p:Number = Math.pow(10, place);
			
			return Math.round(value * p) / p;
		}
		
		/**
		 * 创建某个范围内的步进点
		 * @param	begin       起始值
		 * @param	end         结束值
		 * @param	steps       步进点个数
		 * @return  Array       某个范围内的步进点
		 * @example 
		 * 		<code>
		 * 			trace(NumberUtils.createStepsBetween(0, 5, 4)); // Traces 1,2,3,4
		 * 			trace(NumberUtils.createStepsBetween(1, 3, 3)); // Traces 1.5,2,2.5
		 * 		</code>
		 */
		public static function createStepsBetween(begin:Number, end:Number, steps:Number):Array {
			steps++;
			
			var i:uint = 0;
			var stepsBetween:Array = [];
			var increment:Number = (end - begin) / steps;
			
			while (++i < steps)
				stepsBetween.push((i * increment) + begin);
			
			return stepsBetween;
		}
		
		/**
		 * 对数字进行格式化
		 * @param	value            要进行格式化的数字
		 * @param	minLength        最小长度
		 * @param	thouDelim        分隔符
		 * @param	fillChar         不足位数的填充符
		 * @return  String
		 * @example
		 * 		<code>
		 * 			trace(NumberUtils.format(1234567, 8, ",")); // Traces 01,234,567
		 * 		</code>
		 */
		public static function format(value:Number, minLength:uint, thouDelim:String = null, fillChar:String = null):String {
			var num:String = value.toString();
			var len:uint   = num.length;
			
			if (thouDelim != null) {
				var numSplit:Array = num.split('');
				var counter:uint = 3;
				var i:uint       = numSplit.length;
				
				while (--i > 0) {
					counter--;
					if (counter == 0) {
						counter = 3;
						numSplit.splice(i, 0, thouDelim);
					}
				}
				
				num = numSplit.join('');
			}
			
			if (minLength != 0) {
				if (len < minLength) {
					minLength -= len;
					
					var addChar:String = (fillChar == null) ? '0' : fillChar;
					
					while (minLength--)
						num = addChar + num;
				}
			}
			
			return num;
		}
		
		/**
		 * 小于10的数左侧补零
		 * @param	value
		 * @return
		 */
		public static function addLeadingZero(value:Number):String {
			return (value < 10) ? '0' + value : value.toString();
		}
		
	}//end of class
}