package org.asclub.data
{
	import flash.events.EventDispatcher;
	
	import org.asclub.events.DataChangeEvent;
	
	public class DataProvider extends EventDispatcher
	{
		protected var data:Array;
		
		public function DataProvider(value:Object = null)
		{
			if (value == null)
            {
                data = [];
            }
            else
            {
                data = getDataFromObject(value);
            }
		}
		
		//---------------------------PRIVATE FUNCTION------------------------------
		
		//从一个Object中获取对应数据
		private function getDataFromObject(param1:Object):Array
		{
			var _loc_2:Array;
            var _loc_3:Array;
            var _loc_4:uint;
            var _loc_5:Object;
            var _loc_6:XML;
            var _loc_7:XMLList;
            var _loc_8:XML;
            var _loc_9:XMLList;
            var _loc_10:XML;
            var _loc_11:XMLList;
            var _loc_12:XML;
            if (param1 is Array)
            {
                _loc_3 = param1 as Array;
                if (_loc_3.length > 0)
                {
                    if (_loc_3[0] is String || _loc_3[0] is Number)
                    {
                        _loc_2 = [];
                        _loc_4 = 0;
                        while (_loc_4++ < _loc_3.length)
                        {
                            // label
                            _loc_5 = {label:String(_loc_3[_loc_4]), data:_loc_3[_loc_4]};
                            _loc_2.push(_loc_5);
                        }// end while
                        return _loc_2;
                    }// end if
                }// end if
                return param1.concat();
            }
            else
            {
                if (param1 is DataProvider)
                {
                    return param1.toArray();
                }// end if
                if (param1 is XML)
                {
                    _loc_6 = param1 as XML;
                    _loc_2 = [];
                    _loc_7 = _loc_6.*;
                    for each (_loc_8 in _loc_7)
                    {
                        // label
                        param1 = {};
                        _loc_9 = _loc_8.attributes();
                        for each (_loc_10 in _loc_9)
                        {
                            // label
                            param1[_loc_10.localName()] = _loc_10.toString();
                        }// end of for each ... in
                        _loc_11 = _loc_8.*;
                        for each (_loc_12 in _loc_11)
                        {
                            // label
                            if (_loc_12.hasSimpleContent())
                            {
                                param1[_loc_12.localName()] = _loc_12.toString();
                            }// end if
                        }// end of for each ... in
                        _loc_2.push(param1);
                    }// end of for each ... in
                    return _loc_2;
                }// end if
            }// end else if
            throw new TypeError("Error: Type Coercion failed: cannot convert " + param1 + " to Array or DataProvider.");
		}
		
		//检查索引位置
		private function checkIndex(startIndex:int, endIndex:int):void
        {
            if (startIndex > endIndex || startIndex < 0)
            {
                throw new RangeError("DataProvider index (" + startIndex + ") is not in acceptable range (0 - " + endIndex + ")");
            }
        }
		
		//在更改数据之前调度
		protected function dispatchPreChangeEvent(changeType:String, items:Array, startIndex:int, endIndex:int):void
        {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE, changeType, items, startIndex, endIndex));
        }
		
		//在更改数据之后调度。
		protected function dispatchChangeEvent(changeType:String, items:Array, startIndex:int, endIndex:int):void
        {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, changeType, items, startIndex, endIndex));
        }
		
		//---------------------------GETTER AND SETTER-----------------------------
		
		public function get length():uint
        {
            return data.length;
        }
		
		//---------------------------PUBLIC FUNCTION-------------------------------
		
		/**
		 * 将项目追加到数据提供者的结尾。
		 * @param	item:Object — 要追加到当前数据提供者的结尾的项目。
		 */
		public function addItem(item:Object):void
		{
			
			var l:int = data.length;
			dispatchPreChangeEvent(DataChangeEvent.ADD, [item], l--, l--);
            data.push(item);
            dispatchChangeEvent(DataChangeEvent.ADD, [item], l--, l--);
		}
		
		/**
		 * 将新项目添加到数据提供者的指定索引处。 如果指定的索引超过数据提供者的长度，则忽略该索引。
		 * @param	item:Object — 包含要添加的项目数据的对象。
		 * @param	index:uint — 要在其位置添加项目的索引。
		 */
		public function addItemAt(item:Object, index:uint):void
		{
			checkIndex(index, data.length);
            dispatchPreChangeEvent(DataChangeEvent.ADD, [item], index, index);
            data.splice(index, 0, item);
            dispatchChangeEvent(DataChangeEvent.ADD, [item], index, index);
		}
		
		/**
		 * 向 DataProvider 的末尾追加多个项目，并调度 DataChangeType.ADD 事件。 按照指定项目的顺序添加项目。
		 * @param	items:Object — 要追加到数据提供者的项目。 
		 */
		public function addItems(items:Object):void
		{
			addItemsAt(items, data.length);
		}
		
		/**
		 * 向数据提供者的指定索引处添加若干项目，并调度 DataChangeType.ADD 事件。
		 * @param	items:Object — 要添加到数据提供者的项目。
		 * @param	index:uint — 要在其位置插入项目的索引。
		 */
		public function addItemsAt(items:Object, index:uint):void
		{
			checkIndex(index, data.length);
            var item:Array = getDataFromObject(items);
			var endIndex:int = index + item.length;
			trace("endIndex:" + endIndex);
            dispatchPreChangeEvent(DataChangeEvent.ADD, item, index, endIndex--);
            data.splice.apply(data, [index, 0].concat(item));
			var endIndex2:int = index + item.length;
            dispatchChangeEvent(DataChangeEvent.ADD, item, index, endIndex2--);
		}
		
		/**
		 * 创建当前 DataProvider 对象的副本。
		 * @return DataProvider — 该 DataProvider 对象的新实例
		 */
		public function clone():DataProvider
		{
			return new DataProvider(data);
		}
		
		/**
		 * 将指定项目连接到当前数据提供者的结尾。 此方法调度 DataChangeType.ADD 事件。
		 * @param	items:Object — 要添加到数据提供者的项目。
		 */
		public function concat(items:Object):void
		{
			addItems(items);
		}
		
		/**
		 * 返回指定索引处的项目。
		 * @param	index  要返回的项目的位置。
		 * @return  Object — 指定索引处的项目。 
		 */
		public function getItemAt(index:uint):Object
		{
			var l:int = data.length;
			checkIndex(index, l--);
            return data[index];
		}
		
		/**
		 * 返回指定项目的索引。 
		 * @param	item:Object — 要查找的项目。 
		 * @return  int — 指定项目的索引；如果没有找到指定项目，则为 -1。
		 */
		public function getItemIndex(item:Object):int
		{
			return data.indexOf(item);
		}
		
		/**
		 * 使 DataProvider 包含的所有数据项失效，并调度 DataChangeEvent.INVALIDATE_ALL 事件。 项目在更改以后会失效；DataProvider 会自动重绘失效的项目。
		 */
		public function invalidate():void
		{
			dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeEvent.INVALIDATE_ALL, data.concat(), 0, data.length));
		}
		
		/**
		 * 使指定的项目失效。 项目在更改以后会失效；DataProvider 会自动重绘失效的项目。
		 * @param	item:Object — 要使之失效的项目。
		 */
		public function invalidateItem(item:Object):void
		{
			var index:int = getItemIndex(item);
            if (index == -1)
            {
                return;
            }
            invalidateItemAt(index);
		}
		
		/**
		 * 使指定索引处的项目失效。 项目在更改以后会失效；DataProvider 会自动重绘失效的项目。
		 * @param	index   要使之失效的项目的索引。
		 */
		public function invalidateItemAt(index:int):void
        {
			var l:int = data.length;
            checkIndex(index, l--);
            dispatchChangeEvent(DataChangeEvent.INVALIDATE, [data[index]], index, index);
        }
		
		/**
		 * 将指定数据追加到数据提供者包含的数据，并删除任何重复的项目。 此方法调度 DataChangeType.ADD 事件。
		 * @param	newData:Object — 要合并到数据提供者的数据。
		 */
		public function merge(newData:Object):void
		{
			var l:int = this.data.length;
			var _loc_6:Object;
            var _loc_2:Array = getDataFromObject(newData);
            var _loc_3:uint = _loc_2.length;
            var _loc_4:uint = data.length;
            dispatchPreChangeEvent(DataChangeEvent.ADD, data.slice(_loc_4, data.length), _loc_4, l--);
            var _loc_5:uint;
            while (_loc_5++ < _loc_3)
            {
                // label
                _loc_6 = _loc_2[_loc_5];
                if (getItemIndex(_loc_6) == -1)
                {
                    data.push(_loc_6);
                }// end if
            }// end while
            if (data.length > _loc_4)
            {
                dispatchChangeEvent(DataChangeEvent.ADD, data.slice(_loc_4, data.length), _loc_4, l--);
            }
            else
            {
                dispatchChangeEvent(DataChangeEvent.ADD, [], -1, -1);
            }
		}
		
		/**
		 * 从数据提供者中删除所有项目，并调度 DataChangeType.REMOVE_ALL 事件。 
		 */
		public function removeAll():void
		{
			var items:Array = data.concat();
            dispatchPreChangeEvent(DataChangeEvent.REMOVE_ALL, items, 0, items.length);
            data = [];
            dispatchChangeEvent(DataChangeEvent.REMOVE_ALL, items, 0, items.length);
		}
		
		/**
		 * 从数据提供者中删除指定项目，并调度 DataChangeType.REMOVE 事件。 
		 * @param	item:Object — 要删除的项目。 
		 * @return  Object — 被删除的项目
		 */
		public function removeItem(item:Object):Object
		{
			var index:int = getItemIndex(item);
            if (index != -1)
            {
                return removeItemAt(index);
            }
			return null;
		}
		
		/**
		 * 删除指定索引处的项目，并调度 DataChangeType.REMOVE 事件。 
		 * @param	index:uint — 要删除的项目的索引。 
		 * @return  Object — 被删除的项目。 
		 */
		public function removeItemAt(index:uint):Object
		{
			var l:int = data.length;
			checkIndex(index, l--);
            dispatchPreChangeEvent(DataChangeEvent.REMOVE, data.slice(index, index + 1), index, index);
            var deleteArray:Array = data.splice(index, 1);
            dispatchChangeEvent(DataChangeEvent.REMOVE, deleteArray, index, index);
            return deleteArray[0];
		}
		
		/**
		 * 用新项目替换现有项目，并调度 DataChangeType.REPLACE 事件。 
		 * @param	newItem:Object — 要替换的项目。
		 * @param	oldItem:Object — 替换项目。
		 * @return  Object — 被替换的项目。 
		 */
		public function replaceItem(newItem:Object, oldItem:Object):Object
		{
			var index:int = getItemIndex(oldItem);
            if (index != -1)
            {
                return replaceItemAt(newItem, index);
            }
			return null;
		}
		
		/**
		 * 替换指定索引处的项目，并调度 DataChangeType.REPLACE 事件
		 * @param	newItem:Object — 替换项目。 
		 * @param	index:uint — 要替换的项目的索引。
		 * @return  Object — 被替换的项目。 
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */
		public function replaceItemAt(newItem:Object, index:uint):Object
		{
			var l:int = data.length;
			checkIndex(index, l--);
            var item:Array;
            dispatchPreChangeEvent(DataChangeEvent.REPLACE, item, index, index);
            data[index] = newItem;
            dispatchChangeEvent(DataChangeEvent.REPLACE, item, index, index);
            return item[0];
		}
		
		/**
		 * 对数据提供者包含的项目进行排序，并调度 DataChangeType.SORT 事件。
		 * @param	... sortArgs — 用于排序的参数。 
		 * @return   * — 返回值取决于方法是否接收任何参数。 有关详细信息，请参阅 Array.sort() 方法。 当 sortOption 属性设置为 Array.UNIQUESORT 时，该方法返回 0。
		 */
		public function sort(...args):*
		{
			var l:int = data.length;
			dispatchPreChangeEvent(DataChangeEvent.SORT, data.concat(), 0, l--);
            var _loc_2:* = data.sort.apply(data, args);
            dispatchChangeEvent(DataChangeEvent.SORT, data.concat(), 0, l--);
            return _loc_2;
		}
		
		/**
		 * 按指定字段对数据提供者包含的项目进行排序，并调度 DataChangeType.SORT 事件。 指定字段可以是字符串或字符串值数组，这些字符串值指定要按优先顺序对其进行排序的多个字段。
		 * @param	fieldName:Object — 要按其进行排序的项目字段。 该值可以是字符串或字符串值数组。
		 * @param	options:Object (default = null) — 用于排序的选项。 
		 * @return  * — 返回值取决于方法是否接收任何参数。 有关详细信息，请参阅“Array.sortOn()方法”。 如果 sortOption 属性设置为 Array.UNIQUESORT，则该方法返回 0。
		 */
		public function sortOn(fieldName:Object, options:Object = null):*
		{
			var l:int = data.length;
			dispatchPreChangeEvent(DataChangeEvent.SORT, data.concat(), 0, l--);
            var _loc_3:* = data.sortOn(fieldName, options);
            dispatchChangeEvent(DataChangeEvent.SORT, data.concat(), 0, l--);
            return _loc_3;
		}
		
		/**
		 * 数据提供者包含的数据的 Array 对象表示形式。
		 * @return  Array  数据提供者包含的数据的 Array 对象表示形式
		 */
		public function toArray():Array
        {
            return data.concat();
        }
		
		/**
		 * 创建数据提供者包含的数据的字符串表示形式。
		 * @return  String — 数据提供者包含的数据的字符串表示形式。
		 */
		override public function toString():String
        {
            return "DataProvider [" + data.join(" , ") + "]";
        }
		
	}//end of class
}