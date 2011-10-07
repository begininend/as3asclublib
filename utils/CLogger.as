package org.asclub.utils
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.asclub.display.DrawUtil;
	import org.asclub.display.StageReference;
	import org.asclub.events.KeyComboEvent;
	import org.asclub.ui.Key;
	import org.asclub.ui.KeyCombo;
	import org.asclub.ui.KeyCode;
	import org.asclub.ui.IconDataManager;
	
	public final class CLogger extends Sprite
	{
		private static var _instance:CLogger;
		
		private var _titleBar:Sprite;
		
		private var _logTxt:TextField;
		
		private var _closeBtn:SimpleButton;
		
		private var _resizeBtn:SimpleButton;
		
		private var _clearBtn:SimpleButton;
		
		private var _stage:Stage;
		
		private var _ctrlShiftAltDCombo:KeyCombo;
		
		//默认字体样式
		private var _defaultTextFormat:TextFormat;
		
		//最小高度
		private var _minHeight:int;
		
		//最小宽度
		private var _minWidth:int = 100;
		
		//是否显示
		private var _show:Boolean;
		
		public function CLogger(privateClass:PrivateClass)
		{
			//舞台设定
			_stage = StageReference.getStage();
			
			_defaultTextFormat = new TextFormat();
			_defaultTextFormat.font = "宋体";
			_defaultTextFormat.size = 12;
			_defaultTextFormat.leading = 6;
			
			//快捷键
			var key:Key = Key.getInstance();
			key.addEventListener(KeyComboEvent.DOWN, comboDownHandler);
			_ctrlShiftAltDCombo = new KeyCombo([KeyCode.CONTROL, KeyCode.SHIFT, KeyCode.ALT, KeyCode.D]);
			key.addKeyCombo(_ctrlShiftAltDCombo);
			
			_titleBar = new Sprite();
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, titleBarMouseDownHandler);
			addChild(_titleBar);
			redraw(1, 1);
			
			_closeBtn = getSimpleButton("关闭");
			_closeBtn.addEventListener(MouseEvent.CLICK, closeBtnClickedHandler);
			_closeBtn.y = _titleBar.height - _closeBtn.height >> 1;
			addChild(_closeBtn);
			
			_clearBtn = getSimpleButton("清除");
			_clearBtn.addEventListener(MouseEvent.CLICK, clearBtnClickedHandler);
			_clearBtn.y = _titleBar.height - _clearBtn.height >> 1;
			addChild(_clearBtn);
			
			_logTxt = new TextField();
			_logTxt.y = _titleBar.height;
			_logTxt.border = true;
			_logTxt.wordWrap = true;
			_logTxt.multiline = true;
			_logTxt.defaultTextFormat = _defaultTextFormat;
			addChild(_logTxt);
			
			var resizeBtnUpstate:DisplayObject = IconDataManager.getIcon(IconDataManager.RESIZE);
			_resizeBtn = new SimpleButton(resizeBtnUpstate, resizeBtnUpstate, resizeBtnUpstate, resizeBtnUpstate);
			_resizeBtn.addEventListener(MouseEvent.MOUSE_DOWN, resizeBtnClickedHandler);
			addChild(_resizeBtn);
			
			_minHeight = _titleBar.height + _resizeBtn.height;
			
			width = 200;
		}
		
		/**
		 * 获取单例
		 * @return
		 */
		public static function getInstance():CLogger
		{
			if ( ! _instance) 
			{
				_instance = new CLogger(new PrivateClass());
			}
            return _instance;
		}
		
		/**
		 * 设置调试器的高度
		 */
		override public function set height(value:Number):void 
		{
			_logTxt.height = value - _titleBar.height;
			resize(this.width, value);
		}
		
		/**
		 * 设置调试器的宽度
		 */
		override public function set width(value:Number):void 
		{
			_logTxt.width = value;
			resize(value, this.height);
		}
		
		/**
		 * 控制调试器的显隐
		 * @param	value
		 */
		public function set show(value:Boolean):void
		{
			if (value)
			{
				if (_stage && !_stage.contains(this))
				{
					_stage.addChild(this);
					_show = true;
				}
			}
			else
			{
				if (this.parent && this.parent.contains(this))
				{
					this.parent.removeChild(this);
					_show = false;
				}
			}
		}
		
		/**
		 * 输出调试信息
		 * @param	...rest
		 */
		public function trace(...rest):void
		{
			if (! _show)
			{
				return;
			}
			_logTxt.appendText(parse(rest) + "\n");
		}
		
		public static function trace(...rest):void
		{
			CLogger.getInstance().trace(rest);
		}
		
		private static function parse(data:Array):String
		{
			var args:Array;
			//args = data;
			if (data.length == 1 && data[0] is Array)
			{
				args = data[0] as Array;
			}
			else
			{
				args = data;
			}
			
			
			var items:Array = [];
			var item:*;
			var info:String = "";
			for (var i:int = 0; i < args.length; i++)
			{
				item = args[i];
				if (item)
				{
					info = item.toString();
					if (item == "[object Object]")
					{
						info += "=>";
						var objCount:int;
						for (var key:String in item)
						{
							info += ((objCount > 0 ? "," : "") + key + ":" + item[key]);
							objCount ++;
						}
					}
					items.push(info);
				}
				else
				{
					info = String(item);
					items.push(info);
				}
			}
			return items.join(" ");
		}
		
		//重绘
		private function redraw(w:int, h:int):void
		{
			_titleBar.graphics.clear();
			DrawUtil.drawRoundRect(_titleBar.graphics, w, 20, 0xeae7d6, 0xaca899, 0, 0, 1, 5);
			
			this.graphics.clear();
			DrawUtil.drawRoundRect(this.graphics, w, h, 0xffffff, -1);
		}
		
		//重置大小
		private function resize(w:int, h:int):void
		{
			_closeBtn.x = w - _closeBtn.width >> 0;
			_clearBtn.x = _closeBtn.x - _clearBtn.width - 10;
			
			_resizeBtn.x = w - _resizeBtn.width >> 0;
			_resizeBtn.y = h - _resizeBtn.height >> 0;
			
			
			redraw(w, h);
		}
		
		//获取文本框
		private function getTextField():TextField
		{
			var textField:TextField = new TextField();
			textField.defaultTextFormat = new TextFormat("宋体", 12);
			return textField;
		}
		
		//获取清除按钮
		private function getSimpleButton(label:String):SimpleButton
		{
			var textFieldUpstate:TextField = getTextField();
			textFieldUpstate.text = label;
			textFieldUpstate.width = textFieldUpstate.textWidth + 4;
			textFieldUpstate.height = textFieldUpstate.textHeight + 4;
			
			var textFieldOverstate:TextField = getTextField();
			textFieldOverstate.text = label;
			textFieldOverstate.width = textFieldOverstate.textWidth + 4;
			textFieldOverstate.height = textFieldOverstate.textHeight + 4;
			
			var clearBtnUpstate:Sprite = new Sprite();
			clearBtnUpstate.addChild(textFieldUpstate);
			
			var clearBtnOverstate:Sprite = new Sprite();
			clearBtnOverstate.addChild(textFieldOverstate);
			DrawUtil.drawRoundRect(clearBtnOverstate.graphics, clearBtnOverstate.width, clearBtnOverstate.height, 0xffffff, 0x7a98af, 0, 0 , 1, 3);
			
			var simpleButton:SimpleButton = new SimpleButton(clearBtnUpstate, clearBtnOverstate, clearBtnOverstate, clearBtnUpstate);
			return simpleButton;
		}
		
		//组合键按下时
		private function comboDownHandler(event:KeyComboEvent):void 
		{
			if (_ctrlShiftAltDCombo.equals(event.keyCombo))
			{
				show = ! _show;
			}
		}
		
		//鼠标在标题栏按下
		private function titleBarMouseDownHandler(event:MouseEvent):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpForTitlebarHandler);
			this.startDrag(false);
		}
		
		//鼠标在舞台上弹起
		private function stageMouseUpForTitlebarHandler(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpForTitlebarHandler);
			this.stopDrag();
		}
		
		//关闭按钮点击
		private function closeBtnClickedHandler(event:MouseEvent):void
		{
			show = false;
		}
		
		//清除按钮点击
		private function clearBtnClickedHandler(event:MouseEvent):void
		{
			_logTxt.text = "";
		}
		
		//鼠标在resizeBtn上按下
		private function resizeBtnClickedHandler(event:MouseEvent):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpForResizeBtnHandler);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveForResizeBtnHandler);
		}
		
		private function stageMouseUpForResizeBtnHandler(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpForResizeBtnHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveForResizeBtnHandler);
		}
		
		private function stageMouseMoveForResizeBtnHandler(event:MouseEvent):void
		{
			var clickPoint:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
			var w:int = clickPoint.x > _minWidth ? clickPoint.x : _minWidth;
			var h:int = clickPoint.y > _minHeight ? clickPoint.y : _minHeight;
			width = w;
			height = h;
		}
		
	}//end class
}

class PrivateClass
{
	
}