package org.asclub.controls
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import com.greensock.TweenLite;
	
	import org.asclub.display.DrawUtil;
	
	public final class Prompt extends Sprite
	{
		private static var _instance:Prompt;
		private static var _myPrompt:Sprite;
		private static var _base:DisplayObjectContainer;
		private static var _handler:Function;
		private static var _alt:Array;
		private static var _top_mc:Sprite;
		private static var _box_mc:Sprite;
		private static var _bottom_mc:Sprite;
		private static var _textInputBG_mc:Sprite;
		private static var _close_btn:SimpleButton;
		private static var _cancel_btn:SimpleButton;
		private static var _ok_btn:SimpleButton;
		private static var Tl:TweenLite;
		private static var _title_txt:TextField;
		private static var _message_txt:TextField;
		private static var _textInput_txt:TextField;
		private static var _maskSprite:Sprite;
		private static var states:String;
		
		
		public function Prompt(privateClass:PrivateClass)
		{
			
		}
		
		//初始化
		public static function init(base:DisplayObjectContainer,prompt:Sprite):void 
		{
			if (_instance == null) {
				_instance = new Prompt(new PrivateClass());
				_base = base;
				_base.stage.addEventListener(Event.RESIZE, stageResizeHandler);
				
				_myPrompt = prompt;
				
				//标题
				_title_txt = _myPrompt["__top_mc"]["__title_txt"];
				
				//对话框顶部
				_top_mc = _myPrompt["__top_mc"];
				
				//对话框中间部分
				_box_mc = _myPrompt["__box_mc"];
				
				//对话框底部
				_bottom_mc = _myPrompt["__bottom_mc"];
				
				//文本输入框背景
				_textInputBG_mc = _myPrompt["__textInputBG_mc"];
				
				//文本输入框
				
				
				//确认按钮
				_ok_btn = _myPrompt["__ok_btn"];
				_ok_btn.addEventListener(MouseEvent.CLICK,okBtnClickedHandler);
				
				//关闭按钮
				_close_btn = _myPrompt["__close_btn"];
				_close_btn.addEventListener(MouseEvent.CLICK, closeBtnClickedHandler);
				
				//取消按钮
				_cancel_btn = _myPrompt["__cancel_btn"];
				_cancel_btn.addEventListener(MouseEvent.CLICK, closeBtnClickedHandler);
				
				//信息文本框
				var format:TextFormat = new TextFormat();
				format.align = TextFormatAlign.LEFT;
				_message_txt = new TextField();
				//_message_txt.border = true;
				_message_txt.width = 223;
				_message_txt.selectable = false;
				_message_txt.mouseEnabled = false;
				_message_txt.multiline = true;
				_message_txt.wordWrap = true;
				_message_txt.defaultTextFormat = format;
				_message_txt.setTextFormat(format);
				_myPrompt.addChildAt(_message_txt, _myPrompt.getChildIndex(_close_btn));
				
				//白色背景遮罩
				_maskSprite = new Sprite();
				DrawUtil.drawRoundRect(_maskSprite.graphics, _base.stage.stageWidth, _base.stage.stageWidth, 0xffffff, -1, 0, 0, 0.3, 0);
				_myPrompt.addChildAt(_maskSprite, 0);
			
			}
		}
		
		public static function show(title:String,messages:String, handler:Function = null,...alt):void 
		{
			if (_base == null) {
				trace("Alert class has not been initialised!");
				return;
			}
			
			if (_myPrompt != null)
			{
				_base.stage.addChild(_myPrompt);
				_title_txt.htmlText = title;
				_message_txt.htmlText = messages;
				_message_txt.height = _message_txt.textHeight + 4;
				_alt = alt;
				_handler = handler;
				//showTween();
				updateView();
			}
		}
		
		/**
		 * 对此组件实例设置样式属性。
		 * @param	style:String — 样式属性的名称。
		 * @param	value:Object — 样式的值。
		 */
		public static function setStyle(style:String, value:Object):void
		{
			
		}
		
		
		
		/////////------------------------------------PRIVATE FUNCTION(私有方法)----------------------------------------------------
		
		//舞台大小重置
		private static function stageResizeHandler(Evt:Event):void
		{
			if (_myPrompt != null)
			{
				updateView();
			}
		}
		
		//元件重定位
		private static function updateView():void
		{
			// 将舞台的零点转换为自己的零点
			var zeroPoint:Point = new Point();
			zeroPoint = _myPrompt.globalToLocal(new Point(0, 0));
			_maskSprite.width = _base.stage.stageWidth;
			_maskSprite.height = _base.stage.stageHeight;
			_maskSprite.x = zeroPoint.x;
			_maskSprite.y = zeroPoint.y;
			
			_top_mc.x = zeroPoint.x + (_base.stage.stageWidth - _top_mc.width) / 2;
			_top_mc.y = zeroPoint.y + (_base.stage.stageHeight - _top_mc.height - _message_txt.textHeight - _bottom_mc.height - 15) / 2;
			
			_message_txt.x = (_top_mc.x + (_top_mc.width - _message_txt.width) * 0.5) >> 0;
			_message_txt.y = _top_mc.y + 33;
			
			_textInputBG_mc.x = (_top_mc.x + (_top_mc.width - _textInputBG_mc.width) * 0.5) >> 0;
			_textInputBG_mc.y = (_message_txt.y + _message_txt.height) >> 0;
			
			_ok_btn.x = _top_mc.x + (_top_mc.width - _ok_btn.width - _cancel_btn.width - 20) * 0.5 >> 0;
			_ok_btn.y = _textInputBG_mc.y + _textInputBG_mc.height + 5;
			
			_cancel_btn.x = _ok_btn.x + _ok_btn.width + 20;
			_cancel_btn.y = _textInputBG_mc.y + _textInputBG_mc.height + 5;
			
			_box_mc.x = _top_mc.x;
			_box_mc.y = _top_mc.y + _top_mc.height;
			_box_mc.height = _textInputBG_mc.y + _textInputBG_mc.height - _message_txt.y + 10;
			
			_bottom_mc.x = _top_mc.x;
			_bottom_mc.y = _box_mc.y + _box_mc.height;
			
			_close_btn.x = _top_mc.x + _top_mc.width - 20;
			_close_btn.y = _top_mc.y + 10;
			
		}
		
		//ok按钮被点击
		private static function okBtnClickedHandler(evt:MouseEvent):void
		{
			
		}
		
		//close按钮被点击
		private static function closeBtnClickedHandler(evt:MouseEvent):void
		{
			
		}
		
		
	}//end of class
}

class PrivateClass{}