/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.asclub.data
{
	import org.asclub.data.NumberUtil;
	
	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Arrays.
	* 
	*	Note that all APIs assume that they are working with well formed arrays.
	*	i.e. they will only manipulate indexed values.  
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/		
	public class ArrayUtil
	{
		
		/**
			Modifies original Array by adding all the elements from another Array at a specified position.
			向数组添加多个项
			@param tarArray: Array to add elements to.被添加的数组
			@param items: Array of elements to add.要添加的项的数组
			@param index: Position where the elements should be added.要添加的索引
			@return Returns <code>true</code> if the Array was changed as a result of the call; otherwise <code>false</code>.
			@example
				<code>
					var alphabet:Array = new Array("a", "d", "e");
					var parts:Array    = new Array("b", "c");
					
					ArrayUtil.addItemsAt(alphabet, parts, 1);
					
					trace(alphabet); // Traces a,b,c,d,e
				</code>
		*/
		public static function addItemsAt(tarArray:Array, items:Array, index:int = 0x7FFFFFFF):Boolean {
			if (items.length == 0)
				return false;
			
			var args:Array = items.concat();
			args.splice(0, 0, index, 0);
			
			tarArray.splice.apply(null, args);
			
			return true;
		}
				
		/**
		*	Determines whether the specified array contains the specified value.	
		* 	数组中是否包含某项
		* 	@param arr The array that will be checked for the specified value.
		*
		*	@param value The object which will be searched for within the array
		* 
		* 	@return True if the array contains the value, False if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function arrayContainsValue(arr:Array, value:Object):Boolean
		{
			return (arr.indexOf(value) != -1);
		}
		
		/**
			Finds out how many instances of <code>item</code> Array contains.
			数组中含有多少此项
			@param inArray: Array to search for <code>item</code> in.
			@param item: Object to find.
			@return The amount of <code>item</code>'s found; if none were found returns <code>0</code>.
			@example
				<code>
					var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);
					trace("numberArray contains " + ArrayUtil.contains(numberArray, 7) + " 7's."); // Traces 3
				</code>
		*/
		public static function contains(inArray:Array, item:*):uint {
			var i:int  = inArray.indexOf(item, 0);
			var t:uint = 0;
			
			while (i != -1) {
				i = inArray.indexOf(item, i + 1);
				t++;
			}
			
			return t;
		}
		
		/**
			Determines if Array contains all items.
			某些项是否全部在数组中
			@param inArray: Array to search for <code>items</code> in.
			@param items: Array of elements to search for.
			@return Returns <code>true</code> if <code>inArray</code> contains all elements of <code>items</code>; otherwise <code>false</code>.
			@example
				<code>
					var numberArray:Array = new Array(1, 2, 3, 4, 5);
					trace(ArrayUtil.containsAll(numberArray, new Array(1, 3, 5))); // Traces true
				</code>
		*/
		public static function containsAll(inArray:Array, items:Array):Boolean {
			var l:uint = items.length;
			
			while (l--)
				if (inArray.indexOf(items[l]) == -1)
					return false;
			
			return true;
		}
		
		/**
			Determines if Array <code>inArray</code> contains any element of Array <code>items</code>.
			两个数组是否有交集
			@param inArray: Array to search for <code>items</code> in.
			@param items: Array of elements to search for.
			@return Returns <code>true</code> if <code>inArray</code> contains any element of <code>items</code>; otherwise <code>false</code>.
			@example
				<code>
					var numberArray:Array = new Array(1, 2, 3, 4, 5);
					trace(ArrayUtil.containsAny(numberArray, new Array(9, 3, 6))); // Traces true
				</code>
		*/
		public static function containsAny(inArray:Array, items:Array):Boolean {
			var l:uint = items.length;
			
			while (l--)
				if (inArray.indexOf(items[l]) > -1)
					return true;
			
			return false;
		}
		
		/**
			Compares two Arrays and finds the first index where they differ.
			返回两个数组中不同的项的索引
			@param first: First Array to compare to the <code>second</code>.
			@param second: Second Array to compare to the <code>first</code>.
			@param fromIndex: The location in the Arrays from which to start searching for a difference.
			@return The first position/index where the Arrays differ; if Arrays are identical returns <code>-1</code>.返回第一个查找到的项的索引，如果未查找的则返回-1
			@example
				<code>
					var color:Array     = new Array("Red", "Blue", "Green", "Indigo", "Violet");
					var colorsAlt:Array = new Array("Red", "Blue", "Green", "Violet");
					
					trace(ArrayUtil.getIndexOfDifference(color, colorsAlt)); // Traces 3
				</code>
		*/
		public static function getIndexOfDifference(first:Array, second:Array, fromIndex:uint = 0):int {
			var i:int = fromIndex - 1;
			
			while (++i < first.length)
				if (first[i] != second[i])
					return i;
			
			return -1;
		}
		
		/**
			Returns the first item that match the key values of all properties of the object <code>keyValues</code>.
			如果数组中包含object 值对，可通过key来查找
			@param inArray: Array to search for an element with every key value in the object <code>keyValues</code>.
			@param keyValues: An object with key value pairs.
			@return Returns the first matched item; otherwise <code>null</code>.返回找到的第一个
			@example
				<code>
					var people:Array  = new Array({name: "Aaron", sex: "Male", hair: "Brown"}, {name: "Linda", sex: "Female", hair: "Blonde"}, {name: "Katie", sex: "Female", hair: "Brown"}, {name: "Nikki", sex: "Female", hair: "Blonde"});
					var person:Object = ArrayUtil.getItemByKeys(people, {sex: "Female", hair: "Brown"});
					
					trace(person.name); // Traces "Katie"
				</code>
		*/
		public static function getItemByKeys(inArray:Array, keyValues:Object):* {
			var i:int = -1;
			var item:*;
			var hasKeys:Boolean;
			
			while (++i < inArray.length) {
				item    = inArray[i];
				hasKeys = true;
				
				for (var j:String in keyValues)
					if (!item.hasOwnProperty(j) || item[j] != keyValues[j])
						hasKeys = false;
				
				if (hasKeys)
					return item;
			}
			
			return null;
		}
		
		/**
			Returns all items that match the key values of all properties of the object <code>keyValues</code>.
			如果数组中包含object 值对，可通过key来查找
			@param inArray: Array to search for elements with every key value in the object <code>keyValues</code>.
			@param keyValues: An object with key value pairs.
			@return Returns all the matched items.返回所有符合的
			@example
				<code>
					var people:Array        = new Array({name: "Aaron", sex: "Male", hair: "Brown"}, {name: "Linda", sex: "Female", hair: "Blonde"}, {name: "Katie", sex: "Female", hair: "Brown"}, {name: "Nikki", sex: "Female", hair: "Blonde"});
					var blondeFemales:Array = ArrayUtil.getItemsByKeys(people, {sex: "Female", hair: "Blonde"});
					
					for each (var p:Object in blondeFemales) {
						trace(p.name);
					}
				</code>
		*/
		public static function getItemsByKeys(inArray:Array, keyValues:Object):Array {
			var t:Array = new Array();
			var i:int   = -1;
			var item:*;
			var hasKeys:Boolean;
			
			while (++i < inArray.length) {
				item    = inArray[i];
				hasKeys = true;
				
				for (var j:String in keyValues)
					if (!item.hasOwnProperty(j) || item[j] != keyValues[j])
						hasKeys = false;
				
				if (hasKeys)
					t.push(item);
			}
			
			return t;
		}
		
		/**
			Returns the first item that match a key value of any property of the object <code>keyValues</code>.
			
			@param inArray: Array to search for an element with any key value in the object <code>keyValues</code>.
			@param keyValues: An object with key value pairs.
			@return Returns the first matched item; otherwise <code>null</code>.
			@example
				<code>
					var people:Array  = new Array({name: "Aaron", sex: "Male", hair: "Brown"}, {name: "Linda", sex: "Female", hair: "Blonde"}, {name: "Katie", sex: "Female", hair: "Brown"}, {name: "Nikki", sex: "Female", hair: "Blonde"});
					var person:Object = ArrayUtil.getItemByAnyKey(people, {sex: "Female", hair: "Brown"});
					
					trace(person.name); // Traces "Aaron"
				</code>
		*/
		public static function getItemByAnyKey(inArray:Array, keyValues:Object):* {
			var i:int = -1;
			var item:*;
			
			while (++i < inArray.length) {
				item = inArray[i];
				
				for (var j:String in keyValues)
					if (item.hasOwnProperty(j) && item[j] == keyValues[j])
						return item;
			}
			
			return null;
		}
		
		/**
			Returns all items that match a key value of any property of the object <code>keyValues</code>.
			
			@param inArray: Array to search for elements with any key value in the object <code>keyValues</code>.
			@param keyValues: An object with key value pairs.
			@return Returns all the matched items.
			@example
				<code>
					var people:Array         = new Array({name: "Aaron", sex: "Male", hair: "Brown"}, {name: "Linda", sex: "Female", hair: "Blonde"}, {name: "Katie", sex: "Female", hair: "Brown"}, {name: "Nikki", sex: "Female", hair: "Blonde"});
					var brownOrFemales:Array = ArrayUtil.getItemsByAnyKey(people, {sex: "Female", hair: "Brown"});
					
					for each (var p:Object in brownOrFemales) {
						trace(p.name);
					}
				</code>
		*/
		public static function getItemsByAnyKey(inArray:Array, keyValues:Object):Array {
			var t:Array = new Array();
			var i:int   = -1;
			var item:*;
			var hasKeys:Boolean;
			
			while (++i < inArray.length) {
				item    = inArray[i];
				hasKeys = true;
				
				for (var j:String in keyValues) {
					if (item.hasOwnProperty(j) && item[j] == keyValues[j]) {
						t.push(item);
						
						break;
					}
				}
			}
			
			return t;
		}
		
		/**
			Returns the first element that is compatible with a specific data type, class, or interface.
			获取某一类型的项
			@param inArray: Array to search for an element of a specific type.
			@param type: The type to compare the elements to.
			@return Returns all the matched elements.返回找到的第一个
		*/
		public static function getItemByType(inArray:Array, type:Class):* {
			for each (var item:* in inArray)
				if (item is type)
					return item;
			
			return null;
		}
		
		/**
			Returns every element that is compatible with a specific data type, class, or interface.
			获取某一类型的项
			@param inArray: Array to search for elements of a specific type.
			@param type: The type to compare the elements to.
			@return Returns all the matched elements.返回所有符合的
		*/
		public static function getItemsByType(inArray:Array, type:Class):Array {
			var t:Array = new Array();
			
			for each (var item:* in inArray)
				if (item is type)
					t.push(item);
			
			return t;
		}
		
		/**
			Returns the value of the specified property for every element where the key is present.
			在数组中查找与key相对于的value
			@param inArray: Array to get the values from.
			@param key: Name of the property to retrieve the value of.
			@return Returns all the present key values.
		*/
		public static function getValuesByKey(inArray:Array, key:String):Array {
			var k:Array = [];
			
			for each (var item:* in inArray)
				if (item.hasOwnProperty(key))
					k.push(item[key]);
			
			return k;
		}
		
		/**
		*	Remove all instances of the specified value from the array,
		* 
		* 	@param arr The array from which the value will be removed
		*
		*	@param value The object that will be removed from the array.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function removeValueFromArray(arr:Array, value:Object):void
		{
			var len:uint = arr.length;
			
			for(var i:Number = len; i > -1; i--)
			{
				if(arr[i] === value)
				{
					arr.splice(i, 1);
				}
			}					
		}
		
		/**
			Removes only the specified items in an Array.
			从数组中移除多个项
			@param tarArray: Array to remove specified items from.
			@param items: Array of elements to remove.
			@return Returns <code>true</code> if the Array was changed as a result of the call; otherwise <code>false</code>.
			@example
				<code>
					var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);
					ArrayUtil.removeItems(numberArray, new Array(1, 3, 7, 5));
					trace(numberArray); // Traces 2,4
				</code>
		*/
		public static function removeItems(tarArray:Array, items:Array):Boolean {
			var removed:Boolean = false;
			var l:uint          = tarArray.length;
			
			while (l--) {
				if (items.indexOf(tarArray[l]) > -1) {
					tarArray.splice(l, 1);
					removed = true;
				}
			}
			
			return removed;
		}
		
		/**
			Retains only the specified items in an Array.
			
			@param tarArray: Array to remove non specified items from.
			@param items: Array of elements to keep.
			@return Returns <code>true</code> if the Array was changed as a result of the call; otherwise <code>false</code>.
			@example
				<code>
					var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);
					ArrayUtil.retainItems(numberArray, new Array(2, 4));
					trace(numberArray); // Traces 2,4
				</code>
		*/
		public static function retainItems(tarArray:Array, items:Array):Boolean {
			var removed:Boolean = false;
			var l:uint          = tarArray.length;
			
			while (l--) {
				if (items.indexOf(tarArray[l]) == -1) {
					tarArray.splice(l, 1);
					removed = true;
				}
			}
			
			return removed;
		}

		/**
		*	Create a new array that only contains unique instances of objects
		*	in the specified array.
		*
		*	Basically, this can be used to remove duplication object instances
		*	from an array
		* 
		* 	@param arr The array which contains the values that will be used to
		*	create the new array that contains no duplicate values.
		*
		*	@return A new array which only contains unique items from the specified
		*	array.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function createUniqueCopy(a:Array):Array
		{
			var newArray:Array = new Array();
			
			var len:Number = a.length;
			var item:Object;
			
			for (var i:uint = 0; i < len; ++i)
			{
				item = a[i];
				
				if(ArrayUtil.arrayContainsValue(newArray, item))
				{
					continue;
				}
				
				newArray.push(item);
			}
			
			return newArray;
		}
		
		/**
		*	Creates a copy of the specified array.
		*
		*	Note that the array returned is a new array but the items within the
		*	array are not copies of the items in the original array (but rather 
		*	references to the same items)
		* 
		* 	@param arr The array that will be copies
		*
		*	@return A new array which contains the same items as the array passed
		*	in.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function copyArray(arr:Array):Array
		{	
			return arr.slice();
		}
		
		/**
		*	Compares two arrays and returns a boolean indicating whether the arrays
		*	contain the same values at the same indexes.
		*   两个数组是否相同
		* 	@param arr1 The first array that will be compared to the second.
		*
		* 	@param arr2 The second array that will be compared to the first.
		*
		*	@return True if the arrays contains the same values at the same indexes.
			False if they do not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length)
			{
				return false;
			}
			
			var len:Number = arr1.length;
			
			for(var i:Number = 0; i < len; i++)
			{
				if(arr1[i] !== arr2[i])
				{
					return false;
				}
			}
			
			return true;
		}
		
		/**
		 * 互换数组中两个元素的位置
		 * @param	arr        数组
		 * @param	index1     索引1
		 * @param	index2     索引2
		 * @return
		 */
		public static function swap(arr:Array, index1:int, index2:int) : Boolean
        {
            var temp:Object;
            if (arr == null || index1 < 0 || index1 >= arr.length || index2 < 0 || index2 >= arr.length)
            {
                return false;
            }
            temp = arr[index1];
            arr[index1] = arr[index2];
            arr[index2] = temp;
            return true;
        }
		
		/**
		 * 去除数组中的重复项
		 * @param	arr
		 * @return
		 */
		public static function trimSameness(arr:Array):Array
		{
			var newArray:Array = [];
			var len:int = arr.length;
			var item:Object;
			for (var i:int = 0; i < len; i++)
			{
				item = arr[i];
				if(!arrayContainsValue(newArray,item))
				{
					newArray.push(item);
				}
			}
			return newArray;
		}
		
		/**
		 * 获取某个数之内的随机不重复数组，比如8 =》 7,6,3,0,2,5,1,4
		 * @param	value   某个数 
		 * @return
		 */
		public static function getRandomArray(value:int) : Array
        {
            var arr:Array = [];
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            while (_loc_6 < value)
            {
                arr.push(_loc_6);
                _loc_6++;
            }
            _loc_6 = 0;
            while (_loc_6 < value)
            {
                _loc_3 = NumberUtil.randomIntegerWithinRange(0,value);
                _loc_4 = NumberUtil.randomIntegerWithinRange(0,value);
                if (_loc_3 != _loc_4)
                {
                    swap(arr, _loc_3, _loc_4);
                }
                _loc_6++;
            }
            return arr;
        }
		
		/**
		 * 将数组随机排序
		 * @param	arr
		 * @return
		 */
		public static function sortRandom(arr:Array):Array
		{
			return arr.sort(sort);
		}
		
		private static function sort(a:Object, b:Object):Number
		{
			return (Math.random() < 0.5) ? -1 : 1;
		}
		
		/**
			Adds all items in <code>inArray</code> and returns the value.
			数组中所有项的总和
			@param inArray: Array composed only of numbers.(数组中的全部项均为数组型)
			@return The total of all numbers in <code>inArray</code> added.数组中所有项的总和
			@example
				<code>
					var numberArray:Array = new Array(2, 3);
					trace("Total is: " + ArrayUtil.sum(numberArray)); // Traces 5
				</code>
		*/
		public static function sum(inArray:Array):Number
		{
			var t:Number = 0;
			var l:uint   = inArray.length;
			
			while (l--)
				t += inArray[l];
			
			return t;
		}
		
		/**
			Averages the values in <code>inArray</code>.
			数组中所有项的平均值
			@param inArray: Array composed only of numbers.(数组中的全部项均为数组型)
			@return The average of all numbers in the <code>inArray</code>.
			@example
				<code>
					var numberArray:Array = new Array(2, 3, 8, 3);
					trace("Average is: " + ArrayUtil.average(numberArray)); // Traces 4
				</code>
		*/
		public static function average(inArray:Array):Number 
		{
			if (inArray.length == 0)
				return 0;
			
			return ArrayUtil.sum(inArray) / inArray.length;
		}
		
		/**
			Finds the lowest value in <code>inArray</code>.
			数组中最小的一项
			@param inArray: Array composed only of numbers.
			@return The lowest value in <code>inArray</code>.
			@example
				<code>
					var numberArray:Array = new Array(2, 1, 5, 4, 3);
					trace("The lowest value is: " + ArrayUtil.getLowestValue(numberArray)); // Traces 1
				</code>
		*/
		public static function getLowestValue(inArray:Array):Number {
			return inArray[inArray.sort(16|8)[0]];
		}
		
		/**
			Finds the highest value in <code>inArray</code>.
			数组中最大的一项
			@param inArray: Array composed only of numbers.
			@return The highest value in <code>inArray</code>.
			@example
				<code>
					var numberArray:Array = new Array(2, 1, 5, 4, 3);
					trace("The highest value is: " + ArrayUtil.getHighestValue(numberArray)); // Traces 5
				</code>
		*/
		public static function getHighestValue(inArray:Array):Number {
			return inArray[inArray.sort(16|8)[inArray.length - 1]];
		}
		
		
	}//end of class
}
