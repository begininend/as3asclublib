package org.asclub.controls
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	
	import org.asclub.controls.events.TabBarEvent;
	import org.asclub.controls.TabBarDirection;
	import org.asclub.controls.SimpleStateButton;
	
	public class NewTabBar extends MovieClip
	{
		public var tabBarIndex:int;
		public var spaceWidth:Number = 0;   //单元之间的行间距(行空白区域)
		public var spaceHeight:Number = 0;  //单元之间的竖间距(竖空白区域)
		private var _itemArray:Array;
		private var _enabled:Boolean;
		private var _direction:String;
		private var _tabItem:Class;
		private var _textFormat:TextFormat;
		
		/**
		 * 获取tabbar的启用情况
		 */
		override public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * 设置tabbar的启用情况
		 */
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			var numItem:int = _itemArray.length;
			for (var i:int = 0; i < numItem; i++)
			{
				if (_enabled)
				{
					_itemArray[i]["instance"].mouseEnabled = true;
					_itemArray[i]["instance"].mouseChildren = true;
				}
				else
				{
					_itemArray[i]["instance"].mouseEnabled = false;
					_itemArray[i]["instance"].mouseChildren = false;
				}
			}
		}
		
		/**
		 * 获取标签页是水平排列还是垂直排列
		 */
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * 设置标签页是水平排列还是垂直排列
		 */
		public function set direction(value:String):void
		{
			_direction = value;
		}
		 
		public function NewTabBar()
		{
			_itemArray = [];
			_tabItem = getDefinitionByName("TabItem") as Class;
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.color = 0x000000;
			_textFormat = format;
			direction = TabBarDirection.HORIZONTAL;
		}
		
		//添加标签
		public function addItem(item:Object):void
		{
			if (labelToIndex(item["label"]) == -1)
			{
				_itemArray.push(item);
			}
		}
			
        public function setRendererStyle(name:String, value:*):void
		{
			switch(name)
			{
				case "TabItem":
					_tabItem = value;
				break;
				case "textFormat":
					_textFormat = value;
				break;
			}
		}
		
		//更新显示
		public function update():void
		{
			//先移除以前的标签
			for (var j:int = this.numChildren - 1; j > 0; j-- )
			{
				trace(this.getChildAt(j));
				this.getChildAt(j).removeEventListener(MouseEvent.CLICK, tabItemClickedHandler);
				this.removeChildAt(j);
			}
			trace("移除之后：" + this.numChildren);
			//
			var numItem:int = _itemArray.length;
			for (var i:int = 0; i < numItem; i++)
			{
				var tabItem:MovieClip = new _tabItem();
				_itemArray[i]["instance"] = tabItem;
				_itemArray[i]["instance"]["name"] = _itemArray[i]["label"];
				_itemArray[i]["instance"].gotoAndStop("unSelect");
				tabItem.__label_txt.width = tabItem.width;
				tabItem.__label_txt.setTextFormat(_textFormat);
				tabItem.__label_txt.defaultTextFormat = _textFormat;
				tabItem.__label_txt.text = _itemArray[i]["label"];
				tabItem.addEventListener(MouseEvent.CLICK, tabItemClickedHandler);
				if (direction == TabBarDirection.HORIZONTAL)
				{
					tabItem.x = (tabItem.width + spaceWidth) * i >> 0;
					tabItem.y = 0;
				}
				else
				{
					tabItem.x = 0;
					tabItem.y = (tabItem.height + spaceHeight) * i >> 0;
				}
				addChild(tabItem);
			}
			trace("添加之后：" + this.numChildren);
			
			selectToIndex(tabBarIndex);
		}
		
		//跳动某个标签页
		public function selectToIndex(index:int):void
		{
			if (index > _itemArray.length - 1) index = _itemArray.length - 1;
			if (_itemArray[index]["instance"] == null)
			{
				tabBarIndex = index;
				return;
			}
			_itemArray[tabBarIndex]["instance"].gotoAndStop("unSelect");
			_itemArray[index]["instance"].gotoAndStop("select");
			dispatchEvent(new TabBarEvent(TabBarEvent.ITEM_CLICK, index));
			if (index != tabBarIndex)
			{
				dispatchEvent(new TabBarEvent(TabBarEvent.CHANGE, index));
			}
			tabBarIndex = index;
		}
		
		//从标签值中获取索引
		private function labelToIndex(label:String):int
		{
			var numItem:int = _itemArray.length;
			for (var i:int = 0; i < numItem; i++)
			{
				if (label == _itemArray[i]["label"])
				{
					return i;
				}
			}
			return -1;
		}
		
		//标签被点击
		private function tabItemClickedHandler(evt:MouseEvent):void
		{
			var index:int = labelToIndex(evt.currentTarget.name);
			selectToIndex(index);
		}
		
	}//end of class
}