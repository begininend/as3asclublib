package org.asclub.display
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class StageResize
	{
		
		private static var targetMap:Dictionary = new Dictionary();
		
		private static var _inited:Boolean;
		
		private static var _stage:Stage;
		
		public static function init(stage:Stage):void
		{
			if (! _inited)
			{
				_stage = stage;
				_stage.addEventListener(Event.RESIZE, stageResizeHandler);
				_inited = true;
			}
			
		}
		
		/**
		 * 添加到重置列表
		 * @param	target      目标对象
		 * @param	resizeFun   重置函数
		 */
		public static function addToList(target:Object, resizeFun:Function,...args):void
		{
			if (! target || resizeFun == null)
			{
				return;
			}
			if (! targetMap[target])
			{
				targetMap[target] = [];
			}
			var functionList:Array = targetMap[target];
			var numFunction:int = functionList.length;
			for (var i:int = 0; i < numFunction; i++)
			{
				if (functionList[i]["fun"] == resizeFun)
				{
					functionList[i] = resizeFun;
					return;
				}
			}
			functionList.push({"fun":resizeFun,"args":args});
		}
		
		
		public static function removeFromList(target:Object, resizeFun:Function):void
		{
			if (! target || ! targetMap[target] || resizeFun == null)
			{
				return;
			}
			
			
			var functionList:Array = targetMap[target];
			var numFunction:int = functionList.length;
			for (var i:int = 0; i < numFunction; i++)
			{
				if (functionList[i]["fun"] == resizeFun)
				{
					functionList.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * 移除对象上的所有重置函数
		 * @param	target  要移除的对象
		 */
		public static function removeAll(target:Object):void
		{
			if (! target || ! targetMap[target])
			{
				return;
			}
			targetMap[target].length = 0;
			targetMap[target] = null;
			delete targetMap[target];
		}
		
		public static function dispose():void
		{
			for (var i:* in targetMap)
			{
				targetMap[i] = null;
				delete targetMap[i];
			}
			targetMap = null;
			_stage.removeEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		
		private static function stageResizeHandler(event:Event):void
		{
			resize();
		}
		
		
		private static function resize():void
		{
			var functionList:Array;
			var numFunction:int;
			for (var i:* in targetMap)
			{
				functionList = targetMap[i] as Array;
				numFunction = functionList.length;
				for (var j:int = 0; j < numFunction; j++)
				{
					functionList[j]["fun"].apply(null,functionList[j]["args"].length > 0 ? functionList[j]["args"] : null);
				}
			}
		}
		
	}//end class
}