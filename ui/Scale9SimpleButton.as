package org.asclub.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	
	import org.asclub.display.DisplayObjectUtil;
	import org.asclub.display.ScaleBitmap;
	
	/**
	 * 此类用于对fla中simplebutton进行九宫格缩放,提高美术素材资源的重用率，从而减少客户端文件总体积
	 */
	public class Scale9SimpleButton
	{
		public function Scale9SimpleButton()
		{
			
		}
		
		/**
		 * 对按钮进行九宫格缩放
		 * 当按钮只有一个图层时，不管那一层上有多少元素，那么第一帧的button.upState为Shape。如果有两个图层，如果第二个图层上无元素，button.upState依然为Shape，否则为Sprite;
		 * 要进行九宫格缩放的按钮中可能包含文本框，也可能不包含文本框，这两种情况均要处理
		 * @param	button
		 * @param	scale9Grid
		 * @param	width
		 * @param	height
		 */
		public static function scale9(button:SimpleButton,scale9Grid:Rectangle,width:int,height:int):void
		{
			if(button.upState) searchAndSet(button,"up",button.upState,scale9Grid,width,height);
			if(button.overState) searchAndSet(button, "over", button.overState, scale9Grid, width, height);
			if(button.downState) searchAndSet(button, "down", button.downState, scale9Grid, width, height);
			if (button.hitTestState)
			{
				button.hitTestState.width = width;
				button.hitTestState.height = height;
			}
		}
		
		private static function searchAndSet(button:SimpleButton,state:String,btnState:DisplayObject,scale9Grid:Rectangle,width:int,height:int):void
		{
			if (btnState is Shape)
			{
				switch (state)
				{
					case "up":
					{
						button.upState = getScale9Bitmap(button.upState, scale9Grid, width, height);
						break;
					}
					case "over":
					{
						button.overState = getScale9Bitmap(button.overState, scale9Grid, width, height);
						break;
					}
					case "down":
					{
						button.downState = getScale9Bitmap(button.downState, scale9Grid, width, height);
						break;
					}
				}
			}
			else if (btnState is Sprite)
			{
				var sp:Sprite = btnState as Sprite;
				var tempSP:Sprite = new Sprite();
				var tempSP2:Sprite = new Sprite();
				var textField:TextField;
				var num:int = sp.numChildren;
				
				for (var i:int = num - 1; i > -1; i--)
				{
					if (sp.getChildAt(i) is TextField)
					{
						textField = sp.getChildAt(i) as TextField;
						textField.x = 0;
						textField.y = (height - textField.height) * 0.5;
						textField.width = width;
						continue;
					}
					//tempSP存放除文本框之外其他元素
					tempSP.addChild(sp.getChildAt(i));
				}
				tempSP2.addChild(getScale9Bitmap(tempSP, scale9Grid, width, height));
				if (textField != null)
				{
					tempSP2.addChild(textField);
				}
				
				switch (state)
				{
					case "up":
					{
						button.upState = tempSP2;
						break;
					}
					case "over":
					{
						button.overState = tempSP2;
						break;
					}
					case "down":
					{
						button.downState = tempSP2;
						break;
					}
				}
				
			}
		}
		
		private static function getScale9Bitmap(btnState:DisplayObject,scale9Grid:Rectangle,width:int,height:int):Bitmap
		{
			var scaleBitmapData:BitmapData = new BitmapData(btnState.width, btnState.height);
			scaleBitmapData.draw(btnState);
			var myScaleBitmap:ScaleBitmap = new ScaleBitmap(scaleBitmapData);
			myScaleBitmap.scale9Grid = scale9Grid;
			myScaleBitmap.setSize(width, height);
			return myScaleBitmap;
		}
		
	}//end of class
}
