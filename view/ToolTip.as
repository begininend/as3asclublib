package org.asclub.view
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.Stage;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
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
		private static var _label:TextField;
		private static var _delayTime:int;
		private var IntervarID:int;
		private static var tipAlign:String;
		
		public function ToolTip()
		{
			_label = new TextField();
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.selectable = false;
			_label.multiline = false;
			_label.wordWrap = false;
			_label.defaultTextFormat = new TextFormat("宋体", 12, 0xffffff);
			_label.text = "提示信息";
			_label.x = 5;
			_label.y = 2;
			addChild(_label);
			redraw();
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
			var w:Number = 6 + _label.width;
			var h:Number = 4 + _label.height;			
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.3);
			this.graphics.drawRoundRect(2, 2, w, h, 7, 7);				
			//this.graphics.moveTo(10, 2 + h);  //画尖角
			//this.graphics.lineTo(16, 2 + h);
			//this.graphics.lineTo(13, 7 + h);
			//this.graphics.lineTo(10, 2 + h);
			this.graphics.endFill();
			
			var fillType:String = GradientType.LINEAR;   //GradientType.LINEAR  指定线性渐变填充    GradientType.RADIAL  指定放射状渐变填充
  			var colors:Array = [0xDE0201, 0xAF0000];
  			var alphas:Array = [100, 100];
  			var ratios:Array = [0, 255];
  			var matrix:Matrix = new Matrix();
  			var boxWidth:Number = w;  //渐变框宽度
  			var boxHeight:Number = h; //渐变框高度
  			var boxRotation:Number = Math.PI/2;   //Math.PI 为180°
  			var tx:Number = 0; //渐变框中心点x位置
  			var ty:Number = 0; //渐变框中心点y位置
  			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
  			var spreadMethod:String = SpreadMethod.PAD;
  			this.graphics.beginGradientFill(fillType, colors, alphas, ratios,matrix, spreadMethod);  
 			this.graphics.drawRoundRect(0, 0, w, h, 7, 7);
  			//this.graphics.moveTo(7, h);  //画尖角
			//this.graphics.lineTo(13, h);
			//this.graphics.lineTo(10, 5 + h);
			//this.graphics.lineTo(7, h);
			this.graphics.endFill();
		}
		
		//初始化
		public static function init():void {
			if (instance == null) {
				instance = new ToolTip();
				instance.name = "toolTip";
			}
		}
		
		//设置字体样式
		public static function setTextFormat(tf:TextFormat):void
		{
			_label.defaultTextFormat = tf;
		}
		
		//注册
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
		
		//反注册
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
			_label.text = area.accessibilityProperties.description;
			if(_label.width > area.stage.stageWidth)
			{
				var scaleWidth:int = Math.ceil(_label.width / area.width);
				var msg:String = _label.text;
				var breakPoint:int = msg.length / 2 >> 0;
				_label.text = msg.substr(0,breakPoint) + "\n" + msg.substr(breakPoint,msg.length - breakPoint);
				/*
				for(var i:int = 0;i < scaleWidth * 2 - 1;i++)
				{
					_label.appendText();
				}*/
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
						this.y = lp.y - _label.height - 8;
					break;
					case "TOP_LEFT":
						this.x = lp.x + 15;
						this.y = lp.y + 22;
					break;
					case "BOTTOM_RIGHT":
						this.x = lp.x - _label.width - 15;
						this.y = lp.y - _label.height - 8;
					break;
					case "TOP_RIGHT":
						this.x = lp.x - _label.width - 15;
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