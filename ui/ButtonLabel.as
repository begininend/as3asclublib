package org.asclub.ui
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * 此类用于fla文档的按钮设置标签,按钮中第一层为图片，第二层为文本框（必须为动态文本框、输入文本框，实例名可不设置）
	 * 可以动态设置按钮标签，从而实现一个按钮多次使用，减少库中按钮数量，而且在做多国语言版时可将按钮标签文字放在外部配置文件中，从而方便修改
	 * 但是必须遵守一定的约定：文本框放于最上层，且文本框要单独一层.
	 */
	public class ButtonLabel
	{
		public function ButtonLabel()
		{
			
		}
		
		/**
		 * 设置按钮标签(如果经过状态和按下状态的文本未指明，则跟弹起状态的文本相同)
		 * @param	button        按钮
		 * @param	upLabel       弹起状态的文本
		 * @param	overLabel     经过状态的文本
		 * @param	downLabel	  按下状态的文本
		 */
		public static function setLabel(button:SimpleButton,upLabel:String,overLabel:String = null,downLabel:String = null):void
		{
			if(button.upState is Sprite) searchAndSet(button.upState as Sprite, upLabel);
			if(button.overState is Sprite) searchAndSet(button.overState as Sprite, overLabel == null ? upLabel : overLabel);
			if(button.downState is Sprite) searchAndSet(button.downState as Sprite, downLabel == null ? upLabel : downLabel);
		}
		
		//搜索到文本框之后进行附加文本
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