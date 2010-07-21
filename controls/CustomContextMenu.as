package org.asclub.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.getTimer;
	
	import org.asclub.data.FunctionUtil;
	import org.asclub.display.DrawUtil;
	import org.asclub.system.MyGC;


	public class RichMenu extends CustomUIComponent
	{
		public static var rowHeight:Number;
		private static var rowWidth:Number;
		private static var menuItems:Array;
		private static var intervalID:uint;
		private static var displayObjectContainer:DisplayObjectContainer;
		private static var menuContainer:Sprite;
		public function RichMenu()
		{
			
		}
		
		//初始化
		public static function init(base:DisplayObjectContainer):void
		{
			//行高
			rowHeight = 22;
			displayObjectContainer = base;
			menuItems = [];
		}
		
		/**
		 * 添加菜单项
		 * @param	itemLabel         菜单标签
		 * @param	callBackFun       回调函数
		 * @param	...alt            用于回调函数的参数集
		 */
		public static function addItem(itemLabel:String, callBackFun:Function, ...alt):void
		{
			menuItems.push({label:itemLabel,callBack:FunctionUtil.eventDelegate(callBackFun,alt)});
		}
		
		/**
		 * 添加多个菜单项
		 * @param	items
		 * @example
		 * <code>
		 * 		RichMenu.addItems([{label:"点餐",callBack:labelCallBack},{label:"付账",callBack:labelCallBack},{label:"吃霸王餐",callBack:labelCallBack2,ispare:"附带参数"}]);
		 * </code>
		 */
		public static function addItems(items:Array):void
		{
			var d1:int = getTimer();
			var numItem:int = items.length;
			var item:Object;
			var itemLabel:String;
			var callBackFun:Function;
			
			for (var i:int = 0; i < numItem; i++)
			{
				var arg:Array = [];
				item = items[i];
				itemLabel = item["label"];
				callBackFun = item["callBack"];
				//标签和回调不纳入回调函数的参数集中..  setPropertyIsEnumerable 为 设置循环操作动态属性的可用性。
				item.setPropertyIsEnumerable("label",false);
				item.setPropertyIsEnumerable("callBack",false);
				//delete item["label"];
				//delete item["callBack"];
				for (var j:String in item)
				{
					arg.push(item[j]);
				}
				trace("arg:" + arg);
				trace(getTimer() - d1);
				menuItems.push({label:itemLabel,callBack:FunctionUtil.eventDelegate(callBackFun,arg)});
			}
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
				height = textField.textHeight + 4;
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
			DrawUtil.drawRoundRect(overState.graphics,w,h,0xE0E8F3,0x96B5DA,0,0,1,0);
			DrawUtil.drawRoundRect(downState.graphics,w,h,0xE0E8F3,0x96B5DA,0,0,1,0);
			DrawUtil.drawRoundRect(hitTestState.graphics,w,h,0xE0E8F3,0x96B5DA,0,0,1,0);
			simpleButton.overState = overState;
			simpleButton.downState = downState;
			simpleButton.hitTestState = hitTestState;
			simpleButton.trackAsMenu = true;
			simpleButton.useHandCursor = false;
			return simpleButton;
		}
		
		//显示
		public static function show(x:Number = NaN,y:Number = NaN):void
		{
			if (displayObjectContainer == null) {
				trace("Alert class has not been initialised!");
				return;
			}
			
			//displayObjectContainer.stage.addEventListener(MouseEvent.CLICK, stageClickedHandler);
			
			if (!menuContainer)
			{
				var large:String = "";
				var itemLength:int = menuItems.length;
				for (var i:int = 0; i < itemLength; i++)
				{
					large = menuItems[i].label.length > large.length ? menuItems[i].label : large;
				}
				rowWidth = createTextField(large).textWidth + 40;
				
				menuContainer = new Sprite();
				var bg:Shape = new Shape();
				DrawUtil.drawRoundRect(bg.graphics, rowWidth, rowHeight * itemLength + 4, 0xFCFCFC, 0x8A867A, 0, 0, 1, 0);
				var side:Shape = new Shape();
				DrawUtil.drawGradientRoundRect(side.graphics, [0xE5E3DA, 0xF7F6F1], [100, 100], [0, 255], 22, bg.height - 2, 0, 0, 0, "linear", 180);
				side.x = 1;
				side.y = 1;
				menuContainer.addChild(bg);
				menuContainer.addChild(side);
				//逐个生成按钮并添加
				for (var j:int = 0; j < itemLength; j++)
				{
					var menuItem:Sprite = new Sprite();
					var labelButton:SimpleButton = drawSimpleButton(rowWidth - 4, rowHeight);
					labelButton.x = (bg.width - labelButton.overState.width) * 0.5 >> 0;
					//labelButton.addEventListener(MouseEvent.CLICK, menuItems[j].callBack);
					var label:TextField = createTextField(menuItems[j].label);
					label.x = 25;
					label.y = (rowHeight - label.height) * 0.5;
					menuItem.addChild(labelButton);
					menuItem.addChild(label);
					menuItem.name = j.toString();
					menuItem.y = j * rowHeight + 2;
					menuItem.addEventListener(MouseEvent.CLICK, menuItems[j].callBack);
					menuContainer.addChild(menuItem);
				}
				//此菜单的目标坐标。如果有指定，则位于指定点，如果未指定，则相应的跟随鼠标位置
				var targetPointX:int = isNaN(x) ? displayObjectContainer.mouseX : x;
				var targetPointY:int = isNaN(y) ? displayObjectContainer.mouseY : y;
				//容纳此菜单的容器的舞台边缘的X坐标，因为随着容器的不同相对应的舞台边缘坐标也不一样
				var localStageEdgeX:int = displayObjectContainer.globalToLocal(new Point(displayObjectContainer.stage.stageWidth, 0)).x;
				var localStageEdgeY:int = displayObjectContainer.globalToLocal(new Point(0, displayObjectContainer.stage.stageHeight)).y;
				menuContainer.x = targetPointX;
				menuContainer.y = targetPointY;
				if (localStageEdgeX - targetPointX < menuContainer.width)
				{
					if (! isNaN(x))
					{
						menuContainer.x = localStageEdgeX - menuContainer.width;
					}
					else
					{
						menuContainer.x = targetPointX - menuContainer.width;
					}
				}
				if (localStageEdgeY - targetPointY < menuContainer.height)
				{
					if (! isNaN(y))
					{
						menuContainer.y = localStageEdgeY - menuContainer.height;
					}
					else
					{
						menuContainer.y = targetPointY - menuContainer.height;
					}
				}
				displayObjectContainer.addChild(menuContainer);
				intervalID = setTimeout(addListenerOffset, 100);
			}
		}
		
		//延迟添加事件
		private static function addListenerOffset():void
		{
			displayObjectContainer.stage.addEventListener(MouseEvent.CLICK, stageClickedHandler);
			clearTimeout(intervalID);
		}
		
		//注销
		public static function dispose():void
		{
			if (menuContainer != null)
			{
				
				//trace("子项数目:" + menuContainer.numChildren);
				var numChildren:int = menuContainer.numChildren;
				var item:DisplayObject;
				for (var j:int = menuContainer.numChildren - 1; j > -1 ; j--)
				{
					item = menuContainer.getChildAt(j);
					if (item.hasEventListener(MouseEvent.CLICK))
					{
						item.removeEventListener(MouseEvent.CLICK, menuItems[int(item.name)].callBack);
					}
					menuContainer.removeChild(menuContainer.getChildAt(j));
				}
				//trace("removeChild后子项数目:" + menuContainer.numChildren);
				
				displayObjectContainer.removeChild(menuContainer);
				displayObjectContainer.stage.removeEventListener(MouseEvent.CLICK, stageClickedHandler);
				menuContainer = null;
				menuItems.length = 0;
				MyGC.gc();
			}
		}
		
		//舞台被点击
		private static function stageClickedHandler(evt:MouseEvent):void
		{
			dispose();
		}
	}//end of class
}
