package org.asclub.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.asclub.system.MyGC;


	public class DRichMenu extends Sprite
	{
		public var rowHeight:Number;
		private var rowWidth:Number;
		private var items:Array;
		private var intervalID:uint;
		private var displayObjectContainer:Stage;
		private var menuContainer:Sprite;
		public function DRichMenu()
		{
			
		}
		
		//初始化
		public function init(base:Stage):void
		{
			//行高
			rowHeight = 22;
			displayObjectContainer = base;
			items = [];
		}
		
		
		public function addItems(items:Array):void
		{
			
		}
		
		public function addItem(itemLabel:String, callBackFun:Function, ...alt):void
		{
			items.push({label:itemLabel,callBack:getFun(callBackFun,alt)});
		}


		/**
		 * 绘制一个矩形
		 * @param	BGcolor
		 * @param	lineColor
		 * @param	w
		 * @param	h
		 * @param	thickness
		 * @return
		 */
		private function drawRectShape(BGcolor:uint,lineColor:uint,w:int,h:int,thickness:Number = 1):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(BGcolor);
			shape.graphics.lineStyle(thickness,lineColor);
			shape.graphics.drawRect(0,0,w,h);
			shape.graphics.endFill();
			return shape;
		}
		
		//绘制渐变矩形
		private function drawGradientShape(w:int,h:int):Shape
		{
			var shape:Shape = new Shape();
			var fillType:String = GradientType.LINEAR;   //GradientType.LINEAR  指定线性渐变填充    GradientType.RADIAL  指定放射状渐变填充
  			var colors:Array = [0xE5E3DA,0xF7F6F1];
  			var alphas:Array = [100, 100];
  			var ratios:Array = [0, 255];
  			var matrix:Matrix = new Matrix();
  			var boxWidth:Number = w;  //渐变框宽度
  			var boxHeight:Number = h; //渐变框高度
  			var boxRotation:Number = Math.PI;   //Math.PI 为180°
  			var tx:Number = 0; //渐变框中心点x位置
  			var ty:Number = 0; //渐变框中心点y位置
  			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
  			var spreadMethod:String = SpreadMethod.PAD;
  			shape.graphics.beginGradientFill(fillType, colors, alphas, ratios,matrix, spreadMethod);  
 			shape.graphics.drawRect(0, 0, w, h);
			shape.graphics.endFill();
			return shape;
		}
		
		/**
		 * 绘制一文本
		 * @param	labelField  文本内容
		 * @return
		 */
		private function createTextField(labelField:String):TextField
		{
			var textField:TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.multiline = false;
			textField.wordWrap = false;
			textField.mouseEnabled = false;
			textField.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
			textField.text = labelField;
			textField.height = textField.textHeight;
			return textField;
		}
		
		/**
		 * 绘制按钮
		 * @param	w 宽
		 * @param	h 高
		 * @return
		 */
		private function drawSimpleButton(w:int,h:int):SimpleButton
		{
			var simpleButton:SimpleButton = new SimpleButton();
			simpleButton.overState = drawRectShape(0xE0E8F3, 0x96B5DA, w, h);
			simpleButton.downState = drawRectShape(0xE0E8F3, 0x96B5DA, w, h);
			simpleButton.hitTestState = drawRectShape(0xE0E8F3, 0x96B5DA, w, h);
			simpleButton.useHandCursor = false;
			return simpleButton;
		}
		
		//显示
		public function show():void
		{
			if (displayObjectContainer == null) {
				trace("Alert class has not been initialised!");
				return;
			}
			
			if (!menuContainer)
			{
				var large:String = "";
				var itemLength:int = items.length;
				for (var i:int = 0; i < itemLength; i++)
				{
					large = items[i].label.length > large.length ? items[i].label : large;
				}
				rowWidth = createTextField(large).textWidth + 40;
				
				menuContainer = new Sprite();
				var bg:Shape = drawRectShape(0xFCFCFC, 0x8A867A, rowWidth, rowHeight * itemLength);
				var side:Shape = drawGradientShape(22, rowHeight * itemLength - 2);
				side.x = 1;
				side.y = 1;
				menuContainer.addChild(bg);
				menuContainer.addChild(side);
				for (var j:int = 0; j < itemLength; j++)
				{
					var menuItem:Sprite = new Sprite;
					var labelButton:SimpleButton = drawSimpleButton(rowWidth, rowHeight);
					labelButton.addEventListener(MouseEvent.CLICK, items[j].callBack);
					var label:TextField = createTextField(items[j].label);
					label.x = 25;
					label.y = (rowHeight - label.height) * 0.5;
					menuItem.addChild(labelButton);
					menuItem.addChild(label);
					menuItem.y = j * rowHeight;
					menuContainer.addChild(menuItem);
				}
				menuContainer.x = displayObjectContainer.mouseX;
				menuContainer.y = displayObjectContainer.mouseY;
				if (displayObjectContainer.stageWidth - displayObjectContainer.mouseX < menuContainer.width)
				{
					menuContainer.x = displayObjectContainer.mouseX - menuContainer.width;
				}
				if (displayObjectContainer.stageHeight - displayObjectContainer.mouseY < menuContainer.height)
				{
					menuContainer.y = displayObjectContainer.mouseY - menuContainer.height;
				}
				displayObjectContainer.addChild(menuContainer);
				intervalID = setTimeout(addListenerOffset, 100);
			}
		}
		
		//延迟添加事件
		private function addListenerOffset():void
		{
			displayObjectContainer.addEventListener(MouseEvent.CLICK, stageClickedHandler);
			clearTimeout(intervalID);
		}
		
		//注销
		public function dispose():void
		{
			if (menuContainer != null)
			{
				//for (var i:int = 0; i < items.length; i ++)
				//{
					//delete items[i];
				//}
				items = [];
				
				trace("子项数目:" + menuContainer.numChildren);
				var numChildren:int = menuContainer.numChildren;
				for (var j:int = menuContainer.numChildren - 1; j > -1 ; j--)
				{
						trace(menuContainer.getChildAt(j));
						menuContainer.removeChild(menuContainer.getChildAt(j));
				}
				trace("removeChild后子项数目:" + menuContainer.numChildren);
				
				displayObjectContainer.removeChild(menuContainer);
				displayObjectContainer.removeEventListener(MouseEvent.CLICK, stageClickedHandler);
				menuContainer = null;
				MyGC.gc();
			}
		}
		
		//舞台被点击
		private function stageClickedHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		/**
		 * 代理函数
		 * @param	_function   函数
		 * @param	alt         参数集
		 * @return
		 */
		private function getFun(_function:Function,alt:Array):Function
		{
			var _fun:Function = function (e:*):void
			{
				var _alt:Array = new Array()
				_function.apply(null,_alt.concat(e,alt));
			}
			return _fun;
		}
	}
}
