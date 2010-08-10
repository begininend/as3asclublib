package org.asclub.game
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	public final class DefaultConfig
	{
		public function DefaultConfig()
		{
			
		}
		
		/**
		 * 舞台配置
		 * @param	stageReference  舞台
		 */
		public static function stageSetting(stageReference:Stage):void
		{
			stageReference.showDefaultContextMenu = false;
			stageReference.scaleMode = StageScaleMode.NO_SCALE;
			stageReference.align = StageAlign.TOP_LEFT;
			//stageReference.frameRate = 12;
		}
		
		/**
		 * 启用交互性
		 * @param	actObj
		 */
		public static function interactiveEnabled(actObj:InteractiveObject):void
		{
			actObj.mouseEnabled = true;
			actObj.tabEnabled = true;
			if (actObj is DisplayObjectContainer)
			{
				(actObj as DisplayObjectContainer).mouseChildren = true;
				(actObj as DisplayObjectContainer).tabChildren = true;
			}
		}
		
		/**
		 * 禁用交互性
		 * @param	actObj
		 */
		public static function interactiveDisabled(actObj:InteractiveObject):void
		{
			actObj.mouseEnabled = false;
			actObj.tabEnabled = false;
			if (actObj is DisplayObjectContainer)
			{
				(actObj as DisplayObjectContainer).mouseChildren = false;
				(actObj as DisplayObjectContainer).tabChildren = false;
			}
		}
		
	}//end of class
}