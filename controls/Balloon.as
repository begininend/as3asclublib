package org.asclub.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import org.asclub.display.DrawUtil;
	
	/**
	 * 气球提示(又叫冒泡提示)
	 */
	public final class Balloon extends Sprite
	{
		//冒泡提示文本
		private var _label:TextField;
		//冒泡提示背景
		private var _BalloonBG:DisplayObject;
		//n秒后自动消失
		private var _intervalID:int;
		//处理函数
		private var _handler:Function;
		//处理函数参数
		private var _alt:Array;
		
		//泡泡尖角的X坐标(相对于泡泡的父级)
		public var tipAngleX:Number;
		//泡泡尖角的Y坐标(相对于泡泡的父级)
		public var tipAngleY:Number;
		
		public override function get width():Number
		{
			return 6 + _label.width;
		}
		
		public override function get height():Number
		{
			return 8 + _label.height;
		}
		
		public function Balloon(name:String,w:Number,msg:String,x:Number,y:Number,delay:Number = 0,handler:Function = null,...alt)
		{
			this.name = name;
			_handler = handler;
			tipAngleX = x;
			tipAngleY = y;
			_alt = alt;
			init(w, msg);
			if (delay != 0) setTimeout(dispose, delay * 1000);
		}
		
		private function init(w:Number,msg:String):void
		{
			var defaultTextFormat:TextFormat = new TextFormat();
			defaultTextFormat.font = "宋体";
			defaultTextFormat.size = 12;
			defaultTextFormat.color = 0xffffff;
			defaultTextFormat.leading = 5;
			_label = new TextField();
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.width = w;
			_label.selectable = false;
			_label.multiline = true;
			_label.wordWrap = true;
			_label.defaultTextFormat = defaultTextFormat;
			_label.htmlText = msg;
			_label.x = 3;
			_label.y = 2;
			addChild(_label);
			//updateBG();
			
			this.addEventListener(MouseEvent.CLICK, clickedHandler);
		}
		
		//重绘制背景
		private function drawBG():void
		{
			trace("tipAngleX:" + tipAngleX + "tipAngleY" + tipAngleY);
			var tipAnglePoint:Point = this.globalToLocal(new Point(tipAngleX, tipAngleY));
			trace();
			var leftCorner:Point = new Point(tipAnglePoint.x - 4,tipAnglePoint.y - 4);
			var rightCorner:Point = new Point(tipAnglePoint.x + 4,tipAnglePoint.y - 4);
			DrawUtil.drawGradientRoundRect(this.graphics, [0xDE0201, 0xAF0000], [100, 100], [0, 255], 6 + _label.width, 4 + _label.height, 0, 0, 8, "linear", 90);
			
			DrawUtil.drawShape(this.graphics, 0xAF0000, 0xAF0000, [tipAnglePoint,leftCorner,rightCorner]);
		}
		
		//
		private function updateBG():void
		{
			if (_BalloonBG == null)
			{
				drawBG();
				return;
			}
			_BalloonBG.width = 6 + _label.width;
			_BalloonBG.height = 4 + _label.height;
		}
		
		//被鼠标点击
		private function clickedHandler(evt:MouseEvent):void
		{
			if (_handler != null) {
				_handler.apply(null, _alt);
				_handler = null;
			}
			BalloonManager.removeItem(this.name);
		}
		
		/**
		 * 提示信息
		 * @param	msg
		 */
		public function text(msg:String):void
		{
			_label.htmlText = msg;
			
		}
		
		/**
		 * 设置样式
		 * @param	name    样式名称
		 * @param	value   样式
		 */
		public function setRendererStyle(name:String, value:*):void
		{
			switch(name)
			{
				//提供组件背景的外观的类
				case "skin":
					var bgSkin:Class = value as Class;
					_BalloonBG = new bgSkin();
				break;
				//用于呈现组件标签的 TextFormat 对象
				case "textFormat":
					_label.setTextFormat(value);
					_label.defaultTextFormat = value;
				break;
			}
			updateBG();
		}
		
		/**
		 * 清理
		 */
		public function dispose():void
		{
			this.removeEventListener(MouseEvent.CLICK, clickedHandler);
			this.removeChild(_label);
			this.graphics.clear();
			this.parent.removeChild(this);
		}
	}//end of class
}