package org.asclub.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import org.asclub.display.DrawUtil;
	import org.asclub.display.AlignUtil;
	
	public final class PopUpManager
	{
		public static var bgAlpha:Number = 0.2;
		
		
		private static var _mask:Sprite;
		
		public static function addPopUp(window:DisplayObject, parent:DisplayObjectContainer, modal:Boolean = false, childList:String = null):void
		{
			if (! _mask)
			{
				_mask = new Sprite();
				DrawUtil.drawRoundRect(_mask.graphics, 1, 1, 0x000000, -1, 0, 0, bgAlpha, 0);
			}
			var stage:Stage = window.stage || parent.stage;
			if (stage)
			{
				_mask.width = stage.stageWidth;
				_mask.height = stage.stageHeight;
				if (modal)
				{
					stage.addChild(_mask);
				}
				stage.addChild(window);
			}
		}
		
		public static function centerPopUp(popUp:DisplayObject):void
		{
			if (popUp.parent)
			{
				//AlignUtil.alignMiddle(popUp, popUp.getBounds(popUp.parent));
			}
		}
		
		public static function removePopUp(popUp:DisplayObject, parent:DisplayObjectContainer):void
		{
			var stage:Stage = popUp.stage || parent.stage;
			if (stage)
			{
				if (stage.contains(_mask))
				{
					stage.removeChild(_mask);
				}
				if (stage.contains(popUp))
				{
					stage.removeChild(popUp);
				}
			}
		}
		
		
	}//end class
}
