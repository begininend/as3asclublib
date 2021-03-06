﻿package org.asclub.controls
{
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * 此类用于冒泡提示的管理
	 */
	public final class BalloonManager
	{
		private static var _balloons:Array = [];
		public function BalloonManager(privateClass:PrivateClass)
		{
			//请不要实例化此类
		}
		
		/**
		 * 添加一个新泡泡
		 * @param	base
		 * @param	balloonWidth
		 * @param	msg
		 * @param	x
		 * @param	y
		 * @param	delay                  延迟多少秒后自动消失，当值为0时不自动消失
		 * @param	balloonName            泡泡名称
		 * @param	handler
		 * @param	...alt
		 */
		public static function addItem(base:DisplayObjectContainer,balloonWidth:Number,msg:String,x:Number,y:Number,delay:Number = 0,balloonName:String = null,handler:Function = null,...alt):void
		{
			balloonName = (balloonName == null ? String(Math.random()) : balloonName);
			if (getIndexByName(balloonName) != -1)
			{
				throw new Error("此名称的泡泡已经存在，请使用其他名称");
			}
			var balloon:Balloon = new Balloon(balloonName, balloonWidth, msg, x, y);
			trace("balloon.height:" + balloon.height);
			trace("balloon.width:" + balloon.width);
			balloon.x = x;
			balloon.y = y;
			
			if(x < balloon.width)
			{
				balloon.x = 0;
				if(y < balloon.height)
				{
					balloon.y = y - balloon.height;
				}
			}
			else
			{
				balloon.x = x - 20;
				if((base.stage.stageHeight - y) > balloon.height)
				{
					balloon.y = y;
				}
			}
			
			
			base.addChild(balloon);
			_balloons.push(balloon);
		}
		
		/**
		 * 编辑指定的泡泡。
		 * @param	balloonName        泡泡名称
		 * @param	key                属性名称
		 * @param	value              值
		 */
		public static function editItem(balloonName:String, key:String, value:*):void
		{
			var index:int = getIndexByName(balloonName);
			if (index != -1)
			{
				var balloon:Balloon = _balloons[index];
				switch (key) 
				{
					//泡泡提示内容
					case "labelName":
					
					break;
					//提供组件背景的外观的类
					case "skin":
						balloon.setRendererStyle("skin", value);
					break;
					//用于呈现组件标签的 TextFormat 对象
					case "textFormat":
						balloon.setRendererStyle("textFormat", value);
					break;
				}
			}
		}
		
		/**
		 * 从列表中删除指定的泡泡。
		 * @param	balloonName     泡泡名称
		 */
		public static function removeItem(balloonName:String):void
		{
			var index:int = getIndexByName(balloonName);
			if (index != -1)
			{
				_balloons[index].dispose();
				_balloons[index] = null;
				_balloons.splice(index, 1);
			}
		}
		
		/**
		 * 移除所有的泡泡
		 */
		public static function removeAll():void
		{
			for (var i in _balloons)
			{
				_balloons[i].dispose();
				_balloons[i] = null;
			}
			_balloons.length = 0;
		}
		
		//通过泡泡名称获取泡泡在数组中的索引
		private static function getIndexByName(name:String):int
		{
			for (var i in _balloons)
			{
				if (_balloons[i]["name"] == name)
				{
					return i;
				}
			}
			return -1;
		}
		
	}//end of class
}


class PrivateClass{}