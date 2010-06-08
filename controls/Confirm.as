package org.asclub.controls
{
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;

	public class Confirm extends Sprite
	{
		
		private static var myConfirm:Sprite;
		private static var stages:Stage;
		private static var __handler:Function;
		private static var _alt:Array;
		private static var _top_mc:Sprite;
		private static var _box_mc:Sprite;
		private static var _bottom_mc:Sprite;
		private static var _close_btn:SimpleButton;
		private static var _ok_btn:SimpleButton;
		private static var _cancel_btn:SimpleButton;
		private static var _title_txt:TextField;
		private static var _message_txt:TextField;
		private static var Tl:TweenLite;
		private static var __selected:Boolean;
		private static var maskSprite:Sprite;
		private static var states:String;
		
		public function Confirm()
		{
			
		}
		
		//初始化
		public static function Init(stageReference:Stage):void
		{
			stages = stageReference;
			stages.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		//创建元件
		private static function createAlert():void
		{
			myConfirm = new confirm_mc();
			
			//白色背景遮罩
			maskSprite = new Sprite();
			maskSprite.graphics.beginFill(0xffffff,0.3);
			maskSprite.graphics.drawRect(0, 0, stages.stageWidth, stages.stageHeight);
			myConfirm.addChildAt(maskSprite,0);
			
			//
			_top_mc = myConfirm["__top_mc"];
			
			//标题
			_title_txt = myConfirm["__top_mc"]["__title_txt"];
			
			//
			_box_mc = myConfirm["__box_mc"];
			
			//
			_bottom_mc = myConfirm["__bottom_mc"];
			
			
			//确认按钮
			_ok_btn = myConfirm["__ok_btn"];
			_ok_btn.addEventListener(MouseEvent.CLICK, okBtnClickedHandler);
			
			//取消按钮
			_cancel_btn = myConfirm["__cancel_btn"];
			_cancel_btn.addEventListener(MouseEvent.CLICK, cancelBtnClickedHandler);
			
			//关闭按钮
			_close_btn = myConfirm["__close_btn"];
			_close_btn.addEventListener(MouseEvent.CLICK,closeBtnClickedHandler);
			
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
			myConfirm.addChild(_message_txt);
		}
		
		//舞台大小重置
		private static function stageResizeHandler(Evt:Event):void
		{
			if (myConfirm != null)
			{
				_updateView();
			}
		}
		
		//赋予信息
		private static function _setMessage(title:String, messages:String):void 
		{
			_title_txt.text = title;
			_message_txt.text = messages;
			_updateView();
		}
		
		//回调
		private static function _setHandler(handler:Function = null):void {
			__handler = handler;
		}
		
		//更新显示
		private static function _updateView():void
		{
			// 将舞台的零点转换为自己的零点
			var zeroPoint:Point = new Point();
			zeroPoint = myConfirm.globalToLocal(new Point(0, 0));
			maskSprite.width = stages.stageWidth;
			maskSprite.height = stages.stageHeight;
			maskSprite.x = zeroPoint.x;
			maskSprite.y = zeroPoint.y;
			
			_top_mc.x = zeroPoint.x + (stages.stageWidth - _top_mc.width) * 0.5 >> 0;
			_top_mc.y = zeroPoint.y + (stages.stageHeight - _top_mc.height - _message_txt.textHeight - _bottom_mc.height - 15) * 0.5 >> 0;
			
			_box_mc.x = _top_mc.x;
			_box_mc.y = _top_mc.y + _top_mc.height;
			_box_mc.height = _message_txt.textHeight + 15;
			
			_bottom_mc.x = _top_mc.x;
			_bottom_mc.y = _box_mc.y + _box_mc.height;
			
			_ok_btn.x = _box_mc.x + (_box_mc.width - _ok_btn.width - _cancel_btn.width - 20) * 0.5 >> 0;
			_ok_btn.y = _bottom_mc.y - 15;
			
			_cancel_btn.x = _ok_btn.x + _ok_btn.width + 20;
			_cancel_btn.y = _bottom_mc.y - 15;
			
			_close_btn.x = _top_mc.x + _top_mc.width - 20;
			_close_btn.y = _top_mc.y + 10;
			
			_message_txt.x = _box_mc.x + (_box_mc.width - _message_txt.width) / 2;
			_message_txt.y = _top_mc.y + 33;
		}
		
		//关闭
		private static function _close():void
		{
			if (__handler != null) 
			{
				var argArray:Array = new Array();
				__handler.apply(null,argArray.concat(__selected,_alt));
				__handler = null;
			}
			stages.removeChild(myConfirm);
			myConfirm = null;
		}
		
		//确定按钮被点击
		private static function okBtnClickedHandler(Evt:MouseEvent):void {
			__selected = true;
			_closeTween();
		}
		
		//取消按钮被点击
		private static function cancelBtnClickedHandler(Evt:MouseEvent):void 
		{
			__selected = false;
			_closeTween();
		}
		
		//关闭按钮被点击
		private static function closeBtnClickedHandler(Evt:MouseEvent):void {
			__selected = false;
			_closeTween();
		}
		
		private static function _showTween():void
		{
			states = "show";
			myConfirm.alpha = 0;
			Tl = new TweenLite(myConfirm, 0.3, {alpha:1});
			TweenLite.delayedCall(Tl.duration,_tweenHandler,null);
		}
		
		private static function _closeTween():void
		{		
			states = "close";
			_ok_btn.mouseEnabled = _close_btn.mouseEnabled = _cancel_btn.mouseEnabled = false;
			_message_txt.visible = false;
			Tl = new TweenLite(myConfirm, 0.3, {alpha:0});
			TweenLite.delayedCall(Tl.duration,_tweenHandler,null);
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
			
			if (myConfirm == null)
			{
				createAlert();
				stages.addChild(myConfirm);
				_updateView();
				_showTween();
				_setMessage(title,messages);
				_setHandler(handler);
				_alt = alt;
			}
		}
		
		private static function close():void 
		{
			if (myConfirm != null)
			{
				_close();
			}
		}
		
	}//end of class
}