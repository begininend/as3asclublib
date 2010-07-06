package org.asclub.controls
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.Stage;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import org.asclub.display.DrawUtil;
	/**
	 * @link kinglong@gmail.com
	 * @author Kinglong
	 * @version 0.1
	 * @since 20090608
	 * @playerversion fp9+
	 * 热区提示
	 */	
	public class ToolTip extends Sprite	
	{
		private static var instance:ToolTip = null;
		private static var label:TextField;
		private static var _delayTime:int;
		private var IntervarID:int;
		private static var tipAlign:String;
		//文本样式
		private static var _textFormat:TextFormat;
		//文本宽度
		public static var textWidth:Number = NaN;
		
		
		public function ToolTip(privateClass:PrivateClass)
		{
			label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
			label.multiline = true;
			label.defaultTextFormat = new TextFormat("宋体", 12, 0xffffff);
			label.text = "提示信息";
			label.x = 3;
			label.y = 2;
			addChild(label);
			mouseEnabled = mouseChildren = false;
		}
		
		
		/**
		*
		*绘制提示框
		*
		*方位:TOP_LEFT  TOP_RIGHT  BOTTOM_LEFT  BOTTOM_RIGHT
		*
		*/
		private function redraw():void {
			var w:Number = 6 + label.width;
			var h:Number = 4 + label.height;
			
			this.graphics.clear();
			DrawUtil.drawRoundRect(this.graphics, w, h, 0x333333, -1, 2, 2, 0.3,9);
			DrawUtil.drawGradientRoundRect(this.graphics, [0xDE0201, 0xAF0000], [100, 100], [0, 255], w, h, 0, 0, 9, "linear", 90);
		}
		
		//初始化
		public static function init():void {
			if (instance == null) {
				instance = new ToolTip(new PrivateClass());
				instance.name = "toolTip";
			}
		}
		
		/**
		 * 设置字体样式
		 * @param	tf    字体样式
		 */
		public static function setTextFormat(tf:TextFormat):void
		{
			label.defaultTextFormat = tf;
			_textFormat = tf;
		}
		
		/**
		 * 设置文本描述
		 * @param	area
		 * @param	msg
		 */
		public static function setDescription(area:DisplayObject,msg:String):void
		{
			if (area.accessibilityProperties != null)
			{
				area.accessibilityProperties.description = msg;
				label.htmlText = msg;
			}
		}
		
		/**
		 * 注册
		 * @param	area
		 * @param	msg
		 * @param	delayTime
		 */
		public static function register(area:DisplayObject,msg:String,delayTime:int = 0):void 
		{
			if(instance != null)
			{
				var prop:AccessibilityProperties = new AccessibilityProperties();
				prop.description = msg;
				prop.shortcut = String(delayTime);
				_delayTime = delayTime;
				area.accessibilityProperties = prop;
				area.addEventListener(MouseEvent.ROLL_OVER,instance.handler);
			}
		}
		
		/**
		 * 反注册
		 * @param	area
		 */
		public static function unregister(area:DisplayObject):void
		{
			if (instance != null)
			{
				area.removeEventListener(MouseEvent.MOUSE_OVER, instance.handler);
				instance.hide(area);
			}
		}
		
		//显示提示框
		private function show(area:DisplayObject,point:Point):void
		{
			area.stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseOverHandler);
			area.addEventListener(MouseEvent.ROLL_OUT,handler);
			area.addEventListener(MouseEvent.MOUSE_MOVE,handler);
			var targetTextFormat:TextFormat = new TextFormat();
			targetTextFormat.leading = 0;
			label.defaultTextFormat = targetTextFormat;
			label.text = area.accessibilityProperties.description;
			label.wordWrap = false;
			if (! isNaN(textWidth) && label.textWidth > textWidth) 
			{
				var leading:int = 3;
				if (_textFormat != null && _textFormat.leading != null) leading = ((int(_textFormat.leading) > 3 ? int(_textFormat.leading) : 3));
				label.wordWrap = true;
				label.width = textWidth;
				targetTextFormat.leading = leading;
				label.setTextFormat(targetTextFormat);
			}
			
			redraw();
			move(area,point);
			if (area.stage.getChildByName("toolTip") == null)
			{
				area.stage.addChild(instance);
				instance.visible = false;
			}
		}

		//隐藏提示框
		private function hide(area:DisplayObject):void
		{
			if (area.stage.getChildByName("toolTip") != null)
			{
				area.stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseOverHandler);
				area.stage.removeChild(instance);
				area.removeEventListener(MouseEvent.ROLL_OUT,handler);
				area.removeEventListener(MouseEvent.MOUSE_MOVE,handler);
			}
		}
		
		//移动
		private function move(area:DisplayObject,point:Point):void
		{
			if (this.parent != null)
			{
				instance.visible = true;
				var lp:Point = this.parent.globalToLocal(point);
				switch(tipAlign)
				{
					case "BOTTOM_LEFT":
						this.x = lp.x + 15;
						this.y = lp.y - label.height - 8;
					break;
					case "TOP_LEFT":
						this.x = lp.x + 15;
						this.y = lp.y + 22;
					break;
					case "BOTTOM_RIGHT":
						this.x = lp.x - label.width - 15;
						this.y = lp.y - label.height - 8;
					break;
					case "TOP_RIGHT":
						this.x = lp.x - label.width - 15;
						this.y = lp.y + 22;
					break;
				}
			}
		}
		
		//事件处理
		private function handler(event:MouseEvent):void	{
			switch(event.type) 
			{
				case MouseEvent.ROLL_OUT:
					clearTimeout(IntervarID);
					this.hide(event.currentTarget as DisplayObject);
					break;
				case MouseEvent.MOUSE_MOVE:
					this.move(event.currentTarget as DisplayObject,new Point(event.stageX, event.stageY));
					//event.updateAfterEvent();   //虽然会及时呈现结果，但是会耗更多的cpu(更好的用户体验，更大的代价)
					break;
				case MouseEvent.ROLL_OVER:
					var targetObject:DisplayObject = event.currentTarget as DisplayObject;
					var newPoint:Point = new Point(event.stageX, event.stageY);
					var times:int = int(targetObject.accessibilityProperties.shortcut);
					IntervarID = setTimeout(show,times,targetObject,newPoint);
					//trace(targetObject.accessibilityProperties.shortcut);
					//trace("targetObject.x:" + targetObject.localToGlobal(new Point(targetObject.x,targetObject.y)));
					break;
			}
		}
		
		//鼠标在舞台上移动时
		private static function stageMouseOverHandler(evt:MouseEvent):void
		{
			if(evt.stageX < evt.currentTarget.stageWidth * 0.5)
			{
				tipAlign = "BOTTOM_LEFT";
				if(evt.stageY < evt.currentTarget.stageHeight * 0.5)
				{
					tipAlign = "TOP_LEFT";
				}
			}
			else
			{
				tipAlign = "BOTTOM_RIGHT";
				if(evt.stageY < evt.currentTarget.stageHeight * 0.5)
				{
					tipAlign = "TOP_RIGHT";
				}
			}
		}
		
	}//end of class
}

class PrivateClass{}