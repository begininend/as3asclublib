package org.asclub.controls
{
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;
	
	public class Alert extends Sprite
	{
		private static var myAlert:Sprite;
		private static var stages:Stage;
		private static var __handler:Function;
		private static var _alt:Array;
		private static var _top_mc:Sprite;
		private static var _box_mc:Sprite;
		private static var _bottom_mc:Sprite;
		private static var _close_btn:SimpleButton;
		private static var _ok_btn:SimpleButton;
		private static var Tl:TweenLite;
		private static var _title_txt:TextField;
		private static var _message_txt:TextField;
		private static var maskSprite:Sprite;
		private static var states:String;
	
		public function Alert()
		{				
			
		}
		
		//初始化
		public static function init(stageReference:Stage):void
		{
			stages = stageReference;
			stages.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		//创建元件
		private static function createAlert():void
		{
			myAlert = new alert_mc();
			
			//白色背景遮罩
			maskSprite = new Sprite();
			maskSprite.graphics.beginFill(0xffffff,0.3);
			maskSprite.graphics.drawRect(0, 0, stages.stageWidth, stages.stageHeight);
			myAlert.addChildAt(maskSprite, 0);
			
			//标题
			_title_txt = myAlert["__top_mc"]["__title_txt"];
			
			//
			_top_mc = myAlert["__top_mc"];
			
			//
			_box_mc = myAlert["__box_mc"];
			
			//
			_bottom_mc = myAlert["__bottom_mc"];
			
			
			//确认按钮
			_ok_btn = myAlert["__ok_btn"];
			_ok_btn.addEventListener(MouseEvent.CLICK,_closeHandler);
			
			//关闭按钮
			_close_btn = myAlert["__close_btn"];
			_close_btn.addEventListener(MouseEvent.CLICK,_closeHandler);
			
			//信息文本框
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			_message_txt = new TextField();
			_message_txt.width = 223;
			_message_txt.selectable = false;
			_message_txt.mouseEnabled = false;
			_message_txt.multiline = true;
			_message_txt.wordWrap = true;
			_message_txt.defaultTextFormat = format;
			_message_txt.setTextFormat(format);
			myAlert.addChildAt(_message_txt,myAlert.getChildIndex(_close_btn));
		}
		
		//舞台大小重置
		private static function stageResizeHandler(Evt:Event):void
		{
			if (myAlert != null)
			{
				_updateView();
			}
		}
		
		//赋予信息
		private static function _setMessage(title:String,messages:String):void
		{
			_title_txt.text = title;
			_message_txt.htmlText = messages;
			_message_txt.height = _message_txt.textHeight + 4;
			_updateView();
		}
		
		//回调
		private static function _setHandler(handler:Function = null):void
		{
			__handler = handler;
		}
		
		//更新显示
		private static function _updateView():void
		{
			// 将舞台的零点转换为自己的零点
			var zeroPoint:Point = new Point();
			zeroPoint = myAlert.globalToLocal(new Point(0, 0));
			maskSprite.width = stages.stageWidth;
			maskSprite.height = stages.stageHeight;
			maskSprite.x = zeroPoint.x;
			maskSprite.y = zeroPoint.y;
			
			_top_mc.x = zeroPoint.x + (stages.stageWidth - _top_mc.width) / 2;
			_top_mc.y = zeroPoint.y + (stages.stageHeight - _top_mc.height - _message_txt.textHeight - _bottom_mc.height - 15) / 2;
			
			_box_mc.x = _top_mc.x;
			_box_mc.y = _top_mc.y + _top_mc.height;
			_box_mc.height = _message_txt.textHeight + 15;	
			
			_bottom_mc.x = _top_mc.x;
			_bottom_mc.y = _box_mc.y + _box_mc.height;
			
			_ok_btn.x = (_box_mc.x + (_box_mc.width - _ok_btn.width) * 0.5 ) >> 0;
			_ok_btn.y = (_bottom_mc.y + _bottom_mc.height -_ok_btn.height - 14) >> 0;
			
			_close_btn.x = _top_mc.x + _top_mc.width - 20;
			_close_btn.y = _top_mc.y + 10;
			
			_message_txt.x = (_box_mc.x + (_box_mc.width - _message_txt.width)* 0.5) >> 0;
			_message_txt.y = _top_mc.y + 33;
		}
		
		//关闭对话框
		private static function _close():void
		{		
			if (__handler != null) {
				__handler.apply(null, _alt);
				__handler = null;
			}
			stages.removeChild(myAlert);
			myAlert = null;
		}
		
		//关闭操作
		private static function _closeHandler(Evt:MouseEvent):void
		{
			_closeTween();
		}
		
		private static function _showTween():void
		{
			states = "show";
			myAlert.alpha = 0;
			Tl = new TweenLite(myAlert, 0.3, {alpha:1});
			TweenLite.delayedCall(Tl.duration,_tweenHandler,null);
		}
		
		private static function _closeTween():void 
		{
			states = "close";
			_ok_btn.mouseEnabled = _close_btn.mouseEnabled = false;
			_message_txt.visible = false;
			Tl = new TweenLite(myAlert, 0.3, {alpha:0});
			TweenLite.delayedCall(Tl.duration, _tweenHandler, null);
		}
		
		private static function _tweenHandler():void
		{
			switch(states)
			{
				case "close":				
					_close();
					break;
				case "show":
					break;
			}
		}
		
		
		public static function show(title:String,messages:String, handler:Function = null,...alt):void 
		{
			if (stages == null) {
				trace("Alert class has not been initialised!");
				return;
			}
			
			if (myAlert == null)
			{
				createAlert();
				stages.addChild(myAlert);
				_updateView();
				_showTween();
				_setMessage(title,messages);
				_setHandler(handler);
				_alt = alt;
			}
		}
		
		private static function close():void {
			if (myAlert != null) {
				_close();
			}
		}
	
	}//end of class
}