package org.asclub.controls
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flash.utils.Dictionary;
	
	import com.greensock.TweenLite;
	
	public class RichToolTip extends CustomUIComponent
	{
		private static var _instance:RichToolTip;
		private var _content:DisplayObject;
		private var _areaMap:Dictionary;
		
		//鼠标在舞台的方位
		private var _tipAlign:String;
		
		//构造函数(单例模式(全局仅此一鼠标提示实例存在)，privateClass是为了防止在外部被实例化)
		public function RichToolTip(privateClass:PrivateClass)
		{
			
		}
		
		
		//--------------------------GETTER AND SETTER---------------------------------------------------------
		
		/**
		 * 获取当前RichToolTip所显示的内容
		 */
		public static function get content():DisplayObject
		{
			return _instance._content;
		}
		
		
		
		//--------------------------PUBLIC FUNCTION-----------------------------------------------------------
		
		/**
		 * 初始化。使用前先调用此方法。
		 */
		public static function init():void
		{
			if (_instance == null) {
				_instance = new RichToolTip(new PrivateClass());
				_instance._areaMap = new Dictionary();
				_instance.name = "richToolTip";
				_instance.mouseEnabled = false;
				_instance.mouseChildren = false;
			}
		}
		
		/**
		 * 注册
		 * @param	area       响应对象
		 * @param	content    显示内容
		 */
		public static function register(area:InteractiveObject, content:DisplayObject):void
		{
			if (_instance == null)
			{
				throw new Error("请先执行RichToolTip.init()，再进行热区域注册");
			}
			//如果area未曾注册过热区提示，则进行鼠标监听，如果已经注册过，则不再进行鼠标监听。
			//在此如果通过 area.hasEventListener(MouseEvent.*) 进行判断是不准确的，因为area可能在外部就已经注册了鼠标监听
			if (!(area in _instance._areaMap))
			{
				area.addEventListener(MouseEvent.ROLL_OVER, _instance.mouseEventHandler);
			}
			_instance._areaMap[area] = content;
		}
		
		/**
		 * 反注册
		 * @param	area       响应对象
		 */
		public static function unregister(area:DisplayObject):void
		{
			if (!(area in _instance._areaMap))
			{
				return;
			}
			area.removeEventListener(MouseEvent.ROLL_OVER, _instance.mouseEventHandler);
			_instance._areaMap[area] = null;
		}
		
		//--------------------------PRIVATE FUNCTION------------------------------------------------------------
		
		//鼠标事件处理
		private function mouseEventHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.ROLL_OVER:
				{
					stageMouseOverHandler(event);
					show(event.currentTarget as DisplayObject, new Point(event.stageX, event.stageY));
					break;
				}
				case MouseEvent.ROLL_OUT:
				{
					hide(event.currentTarget as DisplayObject);
					//虽然会及时呈现结果，但是会耗更多的cpu(根据实际情况使用)
					//event.updateAfterEvent();   
					break;
				}
				case MouseEvent.MOUSE_MOVE:
				{
					move(event.currentTarget as DisplayObject,new Point(event.stageX, event.stageY));
					break;
				}
			}
		}
		
		//显示提示内容
		private function show(area:DisplayObject, point:Point):void
		{
			area.stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseOverHandler);
			area.addEventListener(MouseEvent.ROLL_OUT,mouseEventHandler);
			area.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			
			_content = _areaMap[area];
			_instance.addChild(_content);
			if (area.stage.getChildByName("richToolTip") == null)
			{
				area.stage.addChild(_instance);
			}
			move(area,point);
		}
		
		//隐藏提示内容
		private function hide(area:DisplayObject):void
		{
			_instance.removeChild(_content);
			if (area.stage.getChildByName("richToolTip") != null)
			{
				area.stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMouseOverHandler);
				area.stage.removeChild(_instance);
				area.removeEventListener(MouseEvent.ROLL_OUT,mouseEventHandler);
				area.removeEventListener(MouseEvent.MOUSE_MOVE,mouseEventHandler);
			}
		}
		
		//移动提示内容
		private function move(area:DisplayObject,point:Point):void
		{
			var lp:Point = this.parent.globalToLocal(point);
			switch (_tipAlign)
			{
				case "BOTTOM_LEFT":
				{
					
					this.x = lp.x + 15;
					this.y = lp.y - _content.height - 8;
					break;
				}
				case "TOP_LEFT":
				{
					
					this.x = lp.x + 15;
					this.y = lp.y + 22;
					break;
				}
				case "BOTTOM_RIGHT":
				{
					
					this.x = lp.x - _content.width - 15;
					this.y = lp.y - _content.height - 8;
					break;
				}
				case "TOP_RIGHT":
				{
					
					this.x = lp.x - _content.width - 15;
					this.y = lp.y + 22;
					break;
				}
			}
		}
		
		
		//鼠标在舞台上移动时
		//将舞台(限定区域)四切片，划分为 TOP_LEFT  TOP_RIGHT  BOTTOM_LEFT  BOTTOM_RIGHT 四个子区域
		//鼠标与显示内容对角相邻，如果鼠标在TOP_LEFT，则显示内容在鼠标的BOTTOM_RIGHT（右下角）
		//       -------------------------------
		//       |TOP_LEFT     |     TOP_RIGHT |
		//       |             |			   |
		//       |             |			   |
		//       -------------------------------
		//       |             |			   |
		//       |             |			   |
		//       |BOTTOM_LEFT  |  BOTTOM_RIGHT |
		//       -------------------------------
		private function stageMouseOverHandler(event:MouseEvent):void
		{
			if(event.stageX < event.currentTarget.stage.stageWidth * 0.5)
			{
				_tipAlign = "BOTTOM_LEFT";
				if(event.stageY < event.currentTarget.stage.stageHeight * 0.5)
				{
					_tipAlign = "TOP_LEFT";
				}
			}
			else
			{
				_tipAlign = "BOTTOM_RIGHT";
				if(event.stageY < event.currentTarget.stage.stageHeight * 0.5)
				{
					_tipAlign = "TOP_RIGHT";
				}
			}
		}
		
		
	}//end of class
}

class PrivateClass{}