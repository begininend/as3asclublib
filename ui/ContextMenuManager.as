package org.asclub.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.DisplayObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getQualifiedClassName;
	import flash.events.ContextMenuEvent;
	public class ContextMenuManager
	{
		public function ContextMenuManager()
		{
			
		}
		
		/**
		 * 隐藏默认菜单
		 * @param	displayObject   显示对象
		 * @param	hide            是否隐藏
		 */
		public static function hideBuiltInItems(displayObject:InteractiveObject,hide:Boolean = true):void
		{
			if (displayObject.contextMenu != null)
			{
				if (hide)
				{
					displayObject.contextMenu.hideBuiltInItems();
				}
				return;
			}
			var RightKeyMenu:ContextMenu = new ContextMenu();
			RightKeyMenu.hideBuiltInItems();
			displayObject.contextMenu = RightKeyMenu;
		}
		
		/**
		 * 添加单个菜单
		 * @param	displayObject        显示对象
		 * @param	menuCaption          指定上下文菜单中显示的菜单项标题（文本）
		 * @param	callBackFun          回调函数
		 * @param	separatorBefore      指示指定的菜单项上方是否显示分隔条
		 * @param	menuEnabled          指示指定的菜单项处于启用状态还是禁用状态
		 * @param	menuVisible          指示在显示 Flash Player 上下文菜单时指定菜单项是否可见
		 * @param	...alt               回调参数
		 */
		public static function addMenu(displayObject:InteractiveObject,menuCaption:String,callBackFun:Function = null,separatorBefore:Boolean = false,menuEnabled:Boolean = true,menuVisible:Boolean = true,...alt):void
		{
			var RightKeyMenu:ContextMenu = new ContextMenu();
			var menuItem:ContextMenuItem = new ContextMenuItem(menuCaption,separatorBefore,menuEnabled,menuVisible);
			if (callBackFun != null)
			{
				menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getFun(callBackFun,alt)); 
			}
			if (displayObject.contextMenu != null)
			{
				displayObject.contextMenu.customItems.push(menuItem);
				return;
			}
			
			if (getQualifiedClassName(displayObject) != "flash.display::Stage")
			{
				RightKeyMenu.customItems.push(menuItem);
				displayObject.contextMenu = RightKeyMenu;
			}
			
		}
		
		/**
		 * 添加一个菜单到某个索引处
		 * @param	displayObject          显示对象
		 * @param	Index                  索引处
		 * @param	menuCaption            指定上下文菜单中显示的菜单项标题（文本）
		 * @param	callBackFun            回调函数
		 * @param	separatorBefore        指示指定的菜单项上方是否显示分隔条
		 * @param	menuEnabled            指示指定的菜单项处于启用状态还是禁用状态
		 * @param	menuVisible            指示在显示 Flash Player 上下文菜单时指定菜单项是否可见
		 * @param	...alt                 回调参数
		 * @return  Boolean                添加是否成功（true为成功）
		 */
		public static function addMenuAt(displayObject:InteractiveObject,Index:int,menuCaption:String,callBackFun:Function = null,separatorBefore:Boolean = false,menuEnabled:Boolean = true,menuVisible:Boolean = true,...alt):Boolean
		{
			var RightKeyMenu:ContextMenu = new ContextMenu();
			var menuItem:ContextMenuItem = new ContextMenuItem(menuCaption,separatorBefore,menuEnabled,menuVisible);
			if (callBackFun != null)
			{
				menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getFun(callBackFun,alt)); 
			}
			if (Index > displayObject.contextMenu.customItems.length || Index < 0)
			{
				return false;
			}
			if (displayObject.contextMenu != null)
			{
				displayObject.contextMenu.customItems.splice(Index,0,menuItem);
				return true;
			}
			if (getQualifiedClassName(displayObject) != "flash.display::Stage")
			{
				RightKeyMenu.customItems.push(menuItem);
				displayObject.contextMenu = RightKeyMenu;
				return true;
			}
			return false;
		}
		
		//添加多个菜单
		public static function addMenus(displayObject:InteractiveObject):void
		{
			
		}
		
		/**
		 * 编辑某个菜单
		 * @param	displayObject          显示对象
		 * @param	oldCaption             旧 菜单项标题（文本）
		 * @param	newCaption             新 菜单项标题（文本）
		 * @param	callBackFun            回调函数
		 * @param	separatorBefore        指示指定的菜单项上方是否显示分隔条
		 * @param	menuEnabled            指示指定的菜单项处于启用状态还是禁用状态
		 * @param	menuVisible            指示在显示 Flash Player 上下文菜单时指定菜单项是否可见
		 * @param	...alt                 回调参数
		 * @return  Boolean                编辑是否成功（true为成功）
		 */
		public static function editMenu(displayObject:InteractiveObject,oldCaption:String,newCaption:String,callBackFun:Function = null,separatorBefore:Boolean = false,menuEnabled:Boolean = true,menuVisible:Boolean = true,...alt):Boolean
		{
			if (displayObject.contextMenu == null)
			{
				return false;
			}
			var menuIndex:int = getIndexByCaption(displayObject, oldCaption);
			if (menuIndex == -1)
			{
				return false;
			}
			if (removeMenu(displayObject, oldCaption))
			{
				var RightKeyMenu:ContextMenu = new ContextMenu();
				var menuItem:ContextMenuItem = new ContextMenuItem(newCaption,separatorBefore,menuEnabled,menuVisible);
				if (callBackFun != null)
				{
					menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getFun(callBackFun,alt)); 
				}
				if (displayObject.contextMenu != null)
				{
					displayObject.contextMenu.customItems.splice(menuIndex,0,menuItem);
					return true;
				}
				if (getQualifiedClassName(displayObject) != "flash.display::Stage")
				{
					RightKeyMenu.customItems.push(menuItem);
					displayObject.contextMenu = RightKeyMenu;
					return true;
				}
				return false;
			}
			return false;
		}
		
		/**
		 * 删除单个菜单
		 * @param	displayObject          显示对象
		 * @param	caption                指定上下文菜单中显示的菜单项标题（文本）
		 * @return  Boolean                删除是否成功（true为成功）
		 */
		public static function removeMenu(displayObject:InteractiveObject,caption:String):Boolean
		{
			if (displayObject.contextMenu == null)
			{
				return false;
			}
			var menuIndex:int = getIndexByCaption(displayObject, caption);
			if (menuIndex == -1)
			{
				return false;
			}
			displayObject.contextMenu.customItems.splice(menuIndex, 1);
			return true;
		}
		
		/**
		 * 删除某个索引处的菜单
		 * @param	displayObject          显示对象
		 * @param	Index                  索引处
		 * @return  Boolean                删除是否成功（true为成功）
		 */
		public static function removeMenuAt(displayObject:InteractiveObject,Index:int):Boolean
		{
			if (displayObject.contextMenu == null)
			{
				return false;
			}
			if (Index >= displayObject.contextMenu.customItems.length || Index < 0)
			{
				return false;
			}
			displayObject.contextMenu.customItems.splice(Index, 1);
			return true;
		}
		
		/**
		 * 删除全部菜单
		 * @param	displayObject          显示对象
		 */
		public static function removeAll(displayObject:InteractiveObject):void
		{
			displayObject.contextMenu = null;
		}
		
		/**
		 * 获取某个显示对象中某个菜单项的索引位置
		 * @param	displayObject          显示对象
		 * @param	caption                指定上下文菜单中显示的菜单项标题（文本）
		 * @return  int                    返回某个显示对象中某个菜单项的索引位置
		 */
		public static function getIndexByCaption(displayObject:InteractiveObject,caption:String):int
		{
			for(var i:int = 0;i < displayObject.contextMenu.customItems.length;i++)
			{
				if(caption == displayObject.contextMenu.customItems[i].caption)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 获取某个显示对象的菜单项
		 * @param	displayObject          显示对象
		 * @return  Array                  返回某个显示对象的菜单项
		 */
		public function getMenuItems(displayObject:InteractiveObject):Array
		{
			if (displayObject.contextMenu == null)
			{
				return null;
			}
			return displayObject.contextMenu.customItems;
		}
		
		//代理函数
		private static function getFun(_function:Function,alt:Array):Function
		{
			var _fun:Function = function (e:*):void 
			{
				var _alt:Array = new Array()
				_function.apply(null,_alt.concat(e,alt));
			}
			return _fun;
		}
	}//end of class
}