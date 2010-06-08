package org.asclub.view
{
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * 此类用于冒泡提示的管理
	 */
	public final class BalloonManager
	{
		private static var _Balloons:Array = [];
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
			_Balloons.push(balloon);
		}
		
		public static function editItem():void
		{
			
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
				_Balloons[index].dispose();
				_Balloons[index] = null;
				_Balloons.splice(index, 1);
			}
		}
		
		/**
		 * 移除所有的泡泡
		 */
		public static function removeAll():void
		{
			for (var i in _Balloons)
			{
				_Balloons[i].dispose();
				_Balloons[i] = null;
			}
			_Balloons.length = 0;
		}
		
		//通过泡泡名称获取泡泡在数组中的索引
		private static function getIndexByName(name:String):int
		{
			for (var i in _Balloons)
			{
				if (_Balloons[i]["name"] == name)
				{
					return i;
				}
			}
			return -1;
		}
		
	}//end of class
}


class PrivateClass{}