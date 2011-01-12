package org.asclub.controls
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.setInterval;
	
	import com.greensock.TweenLite;
	
	public final class FlowBalloonTipsManager
	{
		//气泡紧急程度(特急,紧急,急,正常)
		//特急(如果当前有气泡冒泡中，则进行停止插播)
		public static const EXTRA_URGENT:String = "extraUrgent";
		//急(加到信息列表第一个，如果当前有气泡冒泡，不进行中断)
		public static const URGENT:String = "urgent";
		//正常(加到信息列表尾部)
		public static const normal:String = "normal";
		
		
		//显示容器
		private static var _container:DisplayObjectContainer;
		
		//气泡列表
		private static var _balloonList:Array = [];
		
		//延迟ID
		private static var _delayIntervalID:int;
		
		//气泡广播是否处于允许中
		private static var _running:Boolean;
		
		public function FlowBalloonTipsManager()
		{
			
		}
		
		//------------------------------------------------------------------------------------------------
		// PUBLIC METHOD
		//------------------------------------------------------------------------------------------------
		
		/**
		 * 初始化
		 * @param	base   气泡的显示容器
		 */
		public static function init(base:DisplayObjectContainer):void
		{
			_container = base;
		}
		
		//添加一个气泡
		public static function add(msg:String, delay:Number = 1, level:String = "normal"):void
		{
			var balloonTip:FlowBalloonTip = createBalloonTip(msg);
			_balloonList.push( { balloonTip:balloonTip, delay : delay, level:level } );
			if (!_running)
			{
				_running = true;
				addBalloonTipToStage(balloonTip, delay);
			}
		}
		
		
		//------------------------------------------------------------------------------------------------
		// PRIVATE METHOD
		//------------------------------------------------------------------------------------------------
		
		//创建一个气泡
		private static function createBalloonTip(msg:String):FlowBalloonTip
		{
			var flowBalloonTip:FlowBalloonTip = new FlowBalloonTip();
			flowBalloonTip.text = msg;
			return flowBalloonTip;
		}
		
		//添加一个气泡到舞台进行冒泡
		private static function addBalloonTipToStage(balloonTip:FlowBalloonTip, delay:Number = 1):void
		{
			var containerWidth:int = _container is Stage ? (_container as Stage).stageWidth : _container.width;
			var containerHeight:int = _container is Stage ? (_container as Stage).stageHeight : _container.height;
			balloonTip.x = containerWidth - balloonTip.width >> 1;
			balloonTip.y = containerHeight - balloonTip.height >> 1;
			_container.addChild(balloonTip);
			_delayIntervalID = setTimeout(delayHandler, delay * 1000, balloonTip);
		}
		
		//延时操作
		private static function delayHandler(balloonTip:FlowBalloonTip):void
		{
			clearTimeout(_delayIntervalID);
			TweenLite.to(balloonTip, 1.2, { alpha:0, y:balloonTip.y - 50, onComplete:tweenCompleteHandler, onCompleteParams:[balloonTip] } );
		}
		
		//缓动结束
		private static function tweenCompleteHandler(balloonTip:FlowBalloonTip):void
		{
			_container.removeChild(balloonTip);
			balloonTip = null;
			_balloonList.shift();
			//如果列表还有气泡则继续冒泡广播
			if (_balloonList.length > 0)
			{
				addBalloonTipToStage(_balloonList[0].balloonTip, _balloonList[0].delay);
			}
			else
			{
				_running = false;
			}
		}
		
	}//end class
}