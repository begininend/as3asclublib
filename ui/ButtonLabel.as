package org.asclub.ui
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ButtonLabel
	{
		public function ButtonLabel()
		{
			
		}
		
		
		public static function setLabel(button:SimpleButton,upLabel:String,overLabel:String = null,downLabel:String = null):void
		{
			searchAndSet(button.upState as Sprite, upLabel);
			searchAndSet(button.overState as Sprite, overLabel == null ? upLabel : overLabel);
			searchAndSet(button.downState as Sprite, downLabel == null ? upLabel : downLabel);
		}
		
		private static function searchAndSet(sp:Sprite,label:String):void
		{
			var num:int = sp.numChildren;
			//因为文本框通常位于最上层，所以从最上层开始找，就可以用最少的次数
			for (var i:int = num - 1; i > -1; i--)
			{
				if (sp.getChildAt(i) is TextField)
				{
					(sp.getChildAt(i) as TextField).htmlText = label;
					return;
				}
			}
		}
		
	}//end of class
}