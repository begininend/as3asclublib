package org.asclub.controls
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	
	import org.asclub.controls.events.TabBarEvent;
	import org.asclub.controls.TabBarDirection;
	import org.asclub.controls.SimpleStateButton;
	import org.asclub.data.DataProvider;
	
	public class NewTabBar extends CustomUIComponent
	{
		//正常状态的位图数据对象
		private var _stateNormal:BitmapData;
		//悬停状态的位图数据对象
		private var _stateHover:BitmapData;
		//按下状态的位图数据对象
		private var _stateDown:BitmapData;
		//经用状态的位图数据对象
		private var _stateDisabled:BitmapData;
		
		//存放数据的数据集合
		private var _dataProvider:DataProvider;
		//存放实体按钮的数组
		private var _buttons:Array;
		//字体样式
		private var _textFormat:TextFormat;
		//修改标签的函数
		private var _labelFunction:Function = null;
		//标签字段名
		private var _labelField:String = "label";
		
		//tabbar的可用性
		private var _enabled:Boolean = true;
		
		//排列方式(横向、纵向、交错三种方式)
		private var _direction:String;
		//单元之间的行间距(行空白区域)
		public var spaceWidth:Number = 0;
		//单元之间的竖间距(竖空白区域)
		public var spaceHeight:Number = 0;
		//水平方向上的个数
		private var _numHorizontal:int = 0;
		
		//默认索引
		private var _defaultIndex:int = 0;
		//当前选中项的索引
		private var _selectedIndex:int = -1;
		
		/**
		 * 获取 dataProvider 对象中的字段名称，该字段名称将显示为 标签。
		 */
		public function get labelField():String
		{
			return this._labelField;
		}
		
		/**
         * 设置 dataProvider 对象中的字段名称，该字段名称将显示为 标签。
		 */
		public function set labelField(value:String):void
		{
			if(this._labelField != value)
			{
				this._labelField = value;
			}
		}
		
		/**
		 * 获取tabbar的启用情况
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * 设置tabbar的启用与否
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			var numItem:int = _buttons.length;
			for (var i:int = 0; i < numItem; i++)
			{
				if (_enabled)
				{
					_buttons[i].enabled = true;
				}
				else
				{
					_buttons[i].enabled = false;
				}
			}
		}
		
		/**
         * 获取tabBar默认选定项目的索引。
		 */
		public function get defaultIndex():int
		{
			return _defaultIndex;
		}
		
		/**
         * 设置tabBar默认选定项目的索引。
		 */
		public function set defaultIndex(value:int):void
		{
			if (value >= 0 && value < this._dataProvider.length)
			{
				_defaultIndex = value;
			}
		}
		
		/**
		 * 获取tabBar选定项目的索引。
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}
		
		/**
         * 设置tabBar选定项目的索引。
		 */
		public function set selectedIndex(value:int):void
		{
			if(value < 0 || value >= this._buttons.length)
			{
				return;
			}
			var item:Object = this._dataProvider.getItemAt(value);
			dispatchEvent(new TabBarEvent(TabBarEvent.ITEM_CLICK, value, item));
			if(this._selectedIndex != value)
			{
				if (_selectedIndex != -1)
				{
					_buttons[_selectedIndex].selected = false;
				}
				_buttons[value].selected = true;
				this._selectedIndex = value;
				this._defaultIndex = value;
				dispatchEvent(new TabBarEvent(TabBarEvent.CHANGE, value, item));
			}
		}
		
		/**
		 * 获取设置选中的项目
		 */
		public function get selectedItem():Object
		{
			if(this.selectedIndex >= 0)
			{
				return this._dataProvider.getItemAt(this.selectedIndex);
			}
			return null;
		}
		
		/**
         * 设置选中的项目
		 */
		public function set selectedItem(value:Object):void
		{
			var index:int = this._dataProvider.getItemIndex(value);
			this.selectedIndex = index;
		}
		
		public function NewTabBar(normal:BitmapData, down:BitmapData, hover:BitmapData = null, disabled:BitmapData = null)
		{
			_stateNormal = normal.clone();
			_stateHover = hover;
			_stateDown = down;
			_stateDisabled = disabled;
			init();
		}
		
		//初始化设置
		private function init():void
		{
			//默认排列方式
			_direction = TabBarDirection.HORIZONTAL;
			
			//
			_dataProvider = new DataProvider();
			_buttons = [];
		}
		
		/**
		 * 设置排列方式
		 * @param	direction
		 * @param	num
		 */
		public function setDirection(direction:String,num:int = 0):void
		{
			_direction = direction;
			if (direction == TabBarDirection.ALTERNATE)
			{
				if (num >= 1)
				{
					_numHorizontal = num;
				}
				else
				{
					_direction = TabBarDirection.HORIZONTAL;
				}
			}
		}
		
		/**
		 * 添加项
		 * 请在调用此方法之后调用update 方法进行更新
		 * @param	item
		 * @example
		 * <code>
		 * 		newTabBar.addItem({label:"私聊"});
		 * </code>
		 */
		public function addItem(item:Object):void
		{
			_dataProvider.addItem(item);
		}
		
		/**
		 * 添加项到某个索引位
		 * 请在调用此方法之后调用update 方法进行更新
		 * @param	item    要添加的项
		 * @param	index   索引位
		 * @example
		 * <code>
		 * 		newTabBar.addItemAt({label:"楼麽"},2);
		 * </code>
		 */
		public function addItemAt(item:Object, index:int):void
		{
			_dataProvider.addItemAt(item, index);
			if (index <= _selectedIndex)
			{
				selectedIndex = _selectedIndex + 1;
			}
		}
		
		/**
		 * 添加多个项
		 * 请在调用此方法之后调用update 方法进行更新
		 * @param	items
		 * @example
		 * <code>
		 * 		newTabBar.addItems([{label:"登机牌"},{label:"JPEG"}]);
		 * </code>
		 */
		public function addItems(items:Object):void
		{
			_dataProvider.addItems(items);
		}
		
		/**
		 * 添加若干项到指定索引处
		 * 请在调用此方法之后调用update 方法进行更新
		 * @param	items
		 * @param	index
		 * @example
		 * <code>
		 * 		newTabBar.addItemsAt([{label:"addItemsAt3"},{label:"addItemsAt4"}],3);
		 * </code>
		 */
		public function addItemsAt(items:Object, index:uint):void
		{
			_dataProvider.addItemsAt(items, index);
			if (index <= _selectedIndex)
			{
				selectedIndex = _selectedIndex + (items as Array).length;
			}
		}
		
		/**
		 * 删除全部项
		 * 请在调用此方法之后调用update 方法进行更新
		 */
		public function removeAll():void
		{
			_dataProvider.removeAll();
		}
		
		/**
		 * 删除指定索引处的项
		 * 请在调用此方法之后调用update 方法进行更新
		 * @param	index  索引位置
		 * @return
		 */
		public function removeItemAt(index:uint):void
		{
			_dataProvider.removeItemAt(index);
			//selectedIndex = _selectedIndex >= _dataProvider.length ? _dataProvider.length - 1 : _selectedIndex;
			//_defaultIndex = _selectedIndex = (_selectedIndex >= _dataProvider.length ? _dataProvider.length - 1 : _selectedIndex);
			if (_selectedIndex >= _dataProvider.length)
			{
				selectedIndex = _dataProvider.length - 1;
			}
			else if (index <= _selectedIndex)
			{
				selectedIndex = _selectedIndex - 1;
			}
			else
			{
				_defaultIndex = _selectedIndex;
			}
		}
		
		/**
		 * 替换指定索引处的项目
		 * @param	newItem
		 * @param	index
		 * @return
		 */
		public function replaceItemAt(newItem:Object, index:uint):void
		{
			_dataProvider.replaceItemAt(newItem, index);
		}
		
		/**
		 * 设置tabBar 外观样式
		 * @param	name     样式名称
		 * @param	value    样式值
		 */
        override public function setStyle(name:String, value:Object):void
		{
			switch(name)
			{
				case "textFormat":
				{
					_textFormat = value as TextFormat;
					updateSkin("textFormat",_textFormat);
					break;
				}
				case "upSkin":
				{
					_stateNormal = getSkinBitmapData(value);
					updateSkin("upSkin", _stateNormal);
					realign();
					break;
				}
				case "overSkin":
				{
					_stateHover = getSkinBitmapData(value);
					updateSkin("overSkin",_stateHover);
					realign();
					break;
				}
				case "downSkin":
				{
					_stateDown = getSkinBitmapData(value);
					updateSkin("downSkin",_stateDown);
					realign();
					break;
				}
				case "disabledSkin":
				{
					_stateDisabled = getSkinBitmapData(value);
					updateSkin("disabledSkin",_stateDisabled);
					realign();
					break;
				}
			}
		}
		
		//更新显示
		public function update():void
		{
			//先移除以前的标签按钮
			var numButtons:int = _buttons.length;
			trace("numButtons:" + numButtons);
			for (var i:int = numButtons - 1; i > -1; i--)
			{
				_buttons[i].removeEventListener(MouseEvent.CLICK, tabItemClickedHandler);
				this.removeChildAt(i);
				_buttons[i] = null;
			}
			_buttons.length = 0;
			trace("移除之后：" + this.numChildren);
			//
			var numItem:int = _dataProvider.length;
			for (var j:int = 0; j < numItem; j++)
			{
				var tabItem:SimpleStateButton = new SimpleStateButton(_stateNormal, _stateHover, _stateDown, _stateDisabled);
				var item:Object = _dataProvider.getItemAt(j);
				if (item.hasOwnProperty(this.labelField))
				{
					tabItem.label = itemToLabel(item);
				}
				tabItem.selected = (j == _selectedIndex);
				tabItem.enabled = this._enabled;
				tabItem.buttonMode = this.buttonMode;
				tabItem.useHandCursor = this.useHandCursor;
				if (_textFormat)
				{
					tabItem.setStyle("textFormat", _textFormat);
				}
				tabItem.addEventListener(MouseEvent.CLICK, tabItemClickedHandler);
				
				_buttons.push(tabItem);
				addChild(tabItem);
			}
			trace("添加之后：" + this.numChildren);
			realign();
			selectedIndex = this._defaultIndex;
		}
		
		//重新排列
		private function realign():void
		{
			var numItem:int = _buttons.length;
			var tabItem:SimpleStateButton;
			for (var i:int = 0; i < numItem; i++)
			{
				tabItem = _buttons[i];
				//水平排列
				if (_direction == TabBarDirection.HORIZONTAL)
				{
					tabItem.x = (tabItem.width + spaceWidth) * i >> 0;
					tabItem.y = 0;
				}
				//垂直排列
				else if (_direction == TabBarDirection.VERTICAL)
				{
					tabItem.x = 0;
					tabItem.y = (tabItem.height + spaceHeight) * i >> 0;
				}
				//交错排列
				else if (_direction == TabBarDirection.ALTERNATE)
				{
					tabItem.x = ((tabItem.width + spaceWidth) * (i % _numHorizontal)) >> 0;
					tabItem.y = ((tabItem.height + spaceHeight) * Math.floor(i / _numHorizontal)) >> 0;
				}
			}
		}
		
		/**
		 * 获取某个数据项的索引
		 * @param	item
		 * @return
		 */
		private function itemToIndex(item:Object):int
		{
			return this._dataProvider.getItemIndex(item);
		}
		
		/**
		 * 获取某个数据项的标签
		 * @param	item
		 * @return 
		 */
		private function itemToLabel(item:Object):String
		{
			if(this._labelFunction != null)
			{
				this._labelFunction(item, this.itemToIndex(item));
			}
			else if(this.labelField && item.hasOwnProperty(this.labelField))
			{
				return item[this.labelField];
			}
			return "";
		}
		
		//更新皮肤
		private function updateSkin(name:String, skin:Object):void
		{
			var numItem:int = _buttons.length;
			for (var i:int = 0; i < numItem; i++)
			{
				_buttons[i].setStyle(name,skin);
			}
		}
		
		//标签被点击
		private function tabItemClickedHandler(event:MouseEvent):void
		{
			var changedButton:SimpleStateButton = event.target as SimpleStateButton;
			var index:int = this._buttons.indexOf(changedButton);
			this.selectedIndex = index;
		}
		
	}//end of class
}