package org.asclub.controls
{
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;
	import org.asclub.controls.tips.TipsType;
	
	/**
	 * ...
	 * @author linhan
	 */
	public class Tips extends Sprite
	{
		private static var myTips:Sprite;
		private static var base:DisplayObject;
		private static var Tl:TweenLite;
		private static var _background_mc:Sprite;
		private static var _close_btn:SimpleButton;
		private static var _icons_mc:MovieClip;
		private static var _message_txt:TextField;
		private static var maskSprite:Sprite;
		private static var _tipsType:String;
		private static var _delayIntervalID:int;
		private static var _overTime:int = 15; //超时时间/秒(超时则关闭tips)
		private static var _overTimeIntervalID:int;

		public function Tips()
		{
			
		}
		
		//初始化
		public static function init(stageReference:DisplayObject):void
		{
			base = stageReference;
			base.stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		//创建元件
		private static function createTips():void
		{
			myTips = new tips_mc();
			
			//白色背景遮罩
			maskSprite = new Sprite();
			maskSprite.graphics.beginFill(0xffffff,0.3);
			maskSprite.graphics.drawRect(0, 0, base.stage.stageWidth, base.stage.stageHeight);
			myTips.addChildAt(maskSprite,0);
			
			//背景
			_background_mc = myTips["__background_mc"];
			
			//关闭按钮
			_close_btn = myTips["__close_btn"];
			_close_btn.addEventListener(MouseEvent.CLICK, closeBtnClickedHandler);
			
			//icon
			_icons_mc = myTips["__icons_mc"];
			_icons_mc.stop();
			
			//信息文本框
			var format:TextFormat = new TextFormat();
			format.color = 0x0066CC;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			_message_txt = myTips["__message_txt"];
			_message_txt.selectable = false;
			_message_txt.mouseEnabled = false;
			_message_txt.multiline = true;
			_message_txt.wordWrap = true;
			_message_txt.defaultTextFormat = format;
			_message_txt.setTextFormat(format);
		}
		
		//舞台大小重置
		private static function stageResizeHandler(Evt:Event):void
		{
			if (myTips != null)
			{
				_updateView();
			}
		}
		
		//赋予信息
		private static function _setMessage(messages:String):void
		{
			_message_txt.htmlText = messages;
			_updateView();
		}
		
		//更新显示
		private static function _updateView():void
		{
			// 将舞台的零点转换为自己的零点
			var zeroPoint:Point = new Point();
			zeroPoint = myTips.globalToLocal(new Point(0, 0));
			maskSprite.width = base.stage.stageWidth;
			maskSprite.height = base.stage.stageHeight;
			maskSprite.x = zeroPoint.x;
			maskSprite.y = zeroPoint.y;
			
			_background_mc.x = zeroPoint.x + ((base.stage.stageWidth - _background_mc.width) / 2 >> 0);
			_background_mc.y = zeroPoint.y + ((base.stage.stageHeight - _background_mc.height) / 2 >> 0);
			
			_icons_mc.x = _background_mc.x + 6;
			_icons_mc.y = _background_mc.y + 27;
			
			_close_btn.x = _background_mc.x + _background_mc.width - 45;
			_close_btn.y = _background_mc.y + 5;
			
			_message_txt.x = _background_mc.x + 57;
			_message_txt.y = _background_mc.y + 30;
		}
		
		/**
		 * 显示提示
		 * @param	tipType  提示类型:成功、错误、警告、进行中
		 * @param	messages 提示信息
		 */
		public static function show(tipType:String,messages:String,fun:Function = null):void 
		{
			if (base == null) {
				trace("Alert class has not been initialised!");
				return;
			}
			
			_tipsType = tipType;
			if (myTips == null)
			{
				createTips();
				base.stage.addChild(myTips);
				_showTween();
			}
			else
			{   //结束loading，延迟xx毫秒以显示成功、错误、警告信息
				if (tipType != TipsType.PROGRESS)
				{
					_delayIntervalID = setTimeout(delayHandler, 500,"close");
				}
			}
			//如果是PROGRESS而且没有进度函数，而进行超时计数
			if (tipType == TipsType.PROGRESS && fun == null)
			{
				_overTimeIntervalID = setTimeout(delayHandler, _overTime * 1000,"warn");
			}
			_updateView();
			_setMessage(messages);
			changeIcon(tipType);
			progressFunction = fun;
		}
		
		private static var progressFunction:Function;
		/*
		private static function progressFunction():void
		{
			trace("progressFunction");
		}*/
		
		//改变图标类型
		private static function changeIcon(tipType:String):void
		{
			switch(tipType)
			{
				case TipsType.COMPLETE:
					_icons_mc.gotoAndStop(TipsType.COMPLETE);
				break;
				case TipsType.ERROR:
					_icons_mc.gotoAndStop(TipsType.ERROR);
				break;
				case TipsType.PROGRESS:
					_icons_mc.gotoAndStop(TipsType.PROGRESS);
				break;
				case TipsType.WARN:
					_icons_mc.gotoAndStop(TipsType.WARN);
				break;
			}
		}
		
		//缓动效果(开)
		private static function _showTween():void
		{
			myTips.alpha = 0;
			Tl = new TweenLite(myTips, 0.3, { alpha:1 } );
			TweenLite.delayedCall(Tl.duration, tweenOverHandler, ["open"]);
		}
		
		//缓动效果(关)
		private static function _closeTween():void
		{
			_message_txt.visible = false;
			Tl = new TweenLite(myTips, 0.4, {alpha:0});
			TweenLite.delayedCall(Tl.duration,tweenOverHandler,["close"]);
		}

		
		//缓动结束
		private static function tweenOverHandler(arg:String):void
		{
			if (_tipsType != TipsType.PROGRESS)
			{
				if (arg == "open")
				{
					//没经过loading过程直接显示结果，需延迟xx毫秒来显示
					_delayIntervalID = setTimeout(delayHandler, 500,"close");
					return;
				}
				_close();
			}
		}
		
		//延迟执行
		private static function delayHandler(opType:String):void
		{
			if (opType == "close")
			{
				_closeTween();
			}
			else if (opType == "warn")
			{
				show(TipsType.ERROR, "超时错误");
			}
		}
		
		//关闭按钮被点击
		private static function closeBtnClickedHandler(evt:MouseEvent):void
		{
			_tipsType = TipsType.ERROR;
			_closeTween();
		}
		
		//关闭
		private static function _close():void
		{
			if (myTips != null)
			{
				base.stage.removeChild(myTips);
				base.stage.removeEventListener(Event.RESIZE, stageResizeHandler);
				_close_btn.removeEventListener(MouseEvent.CLICK, closeBtnClickedHandler);
				clearTimeout(_overTimeIntervalID);
				clearTimeout(_delayIntervalID);
				myTips = null;
			}
		}
	}//end of class
}