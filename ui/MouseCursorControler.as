package org.asclub.ui
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class MouseCursorControler
	{
		private static var _cursor:DisplayObject;
		private static var _base:Stage;
		
		public function MouseCursorControler()
		{
			
		}
		
		//------------------------------------------------------------------------------------------------
		// PUBLIC METHOD
		//------------------------------------------------------------------------------------------------
		
		/**
		 * 初始化
		 * @param	base
		 */
		public static function init(base:Stage):void
		{
			_base = base;
			base.addEventListener(MouseEvent.MOUSE_MOVE, baseMouseMoveHandler);
			base.addEventListener(MouseEvent.MOUSE_DOWN, baseMouseDownHandler);
		}
		
		/**
		 * 设置当前的鼠标手型
		 */
		public static function set cursor(value:Object):void
		{
			if (value == null)
			{
				_cursor = null;
				Mouse.show();
			}
			else if (value is String)
			{
				_cursor = null;
				switch(String(value))
				{
					case "auto":
					{
						Mouse.show();
					}
				}
			}
			else if (value is DisplayObject)
			{
				Mouse.hide();
				_cursor = value as DisplayObject;
				//如果为添加到显示列表中
				if (! _cursor.stage)
				{
					_base.addChild(_cursor);
				}
			}
		}
		
		/**
		 * 更新手型的坐标点
		 * @param	globalPoint  全局坐标点
		 */
		public static function updatePoint(globalPoint:Point):void
		{
			var localPoint:Point = _cursor.parent.globalToLocal(globalPoint);
			_cursor.x = localPoint.x;
			_cursor.y = localPoint.y;
		}
		
		//------------------------------------------------------------------------------------------------
		// EVENT HANDLER
		//------------------------------------------------------------------------------------------------
		//鼠标在舞台上移动
		private static function baseMouseMoveHandler(event:MouseEvent):void
		{
			if (_cursor)
			{
				updatePoint(new Point(event.stageX, event.stageY));
				event.updateAfterEvent();
			}
		}
		
		//鼠标在舞台上按下
		private static function baseMouseDownHandler(event:MouseEvent):void
		{
			if (_cursor)
			{
				Mouse.hide();
			}
		}
		
	}//end class
}