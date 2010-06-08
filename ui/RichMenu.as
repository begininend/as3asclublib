package org.asclub.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
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
	import org.asclub.display.DrawUtil;


	public class RichMenu extends Sprite
	{
		public static var rowHeight:Number;
		private static var rowWidth:Number;
		private static var items:Array;
		private static var intervalID:uint;
		private static var displayObjectContainer:Stage;
		private static var menuContainer:Sprite;
		public function RichMenu()
		{
			
		}
		
		//初始化
		public static function init(base:Stage):void
		{
			//行高
			rowHeight = 22;
			displayObjectContainer = base;
			items = [];
		}
		
		
		public static function addItems(items:Array):void
		{
			
		}
		
		public static function addItem(itemLabel:String, callBackFun:Function, ...alt):void
		{
			items.push({label:itemLabel,callBack:getFun(callBackFun,alt)});
		}
		
		/**
		 * 绘制一文本
		 * @param	labelField  文本内容
		 * @return
		 */
		private static function createTextField(labelField:String):TextField
		{
			var textField:TextField = new TextField();
			with (textField)
			{
				autoSize = TextFieldAutoSize.LEFT;
				selectable = false;
				multiline = false;
				wordWrap = false;
				mouseEnabled = false;
				defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
				text = labelField;
				height = textField.textHeight;
			}
			return textField;
		}
		
		/**
		 * 绘制按钮
		 * @param	w 宽
		 * @param	h 高
		 * @return
		 */
		private static function drawSimpleButton(w:int,h:int):SimpleButton
		{
			var simpleButton:SimpleButton = new SimpleButton();
			var overState:Shape = new Shape();
			var downState:Shape = new Shape();
			var hitTestState:Shape = new Shape();
			DrawUtil.drawRect(overState.graphics,0xE0E8F3,0x96B5DA,w,h);
			DrawUtil.drawRect(downState.graphics,0xE0E8F3,0x96B5DA,w,h);
			DrawUtil.drawRect(hitTestState.graphics,0xE0E8F3,0x96B5DA,w,h);
			simpleButton.overState = overState;
			simpleButton.downState = downState;
			simpleButton.hitTestState = hitTestState;
			simpleButton.useHandCursor = false;
			return simpleButton;
		}
		
		//显示
		public static function show():void
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
				var bg:Shape = new Shape();
				DrawUtil.drawRect(bg.graphics, 0xFCFCFC, 0x8A867A, rowWidth, rowHeight * itemLength);
				var side:Shape = new Shape();
				DrawUtil.drawGradientRect(side.graphics, [0xE5E3DA, 0xF7F6F1], [100, 100], [0, 255], 22, rowHeight * itemLength - 2,"linear",180);
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
		private static function addListenerOffset():void
		{
			displayObjectContainer.addEventListener(MouseEvent.CLICK, stageClickedHandler);
			clearTimeout(intervalID);
		}
		
		//注销
		public static function dispose():void
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
		private static function stageClickedHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		/**
		 * 代理函数
		 * @param	_function   函数
		 * @param	alt         参数集
		 * @return
		 */
		private static function getFun(_function:Function,alt:Array):Function
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
