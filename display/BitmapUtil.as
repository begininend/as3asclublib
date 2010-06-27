package org.asclub.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	public final class BitmapUtil 
	{
		public function BitmapUtil()
		{
			
		}
		
		/**
		 * 从显示对象中创建bitmap
		 * @param	disObj    显示对象
		 * @return  Bitmap
		 */
		public static function createBitmapFromDisplayObject(disObj:DisplayObject) : Bitmap
        {
            var bitmapData:BitmapData;
            if (disObj is Bitmap)
            {
                return new Bitmap((disObj as Bitmap).bitmapData);
            }// end if
            bitmapData = new BitmapData(disObj.width, disObj.height, true);
            bitmapData.draw(disObj);
            return new Bitmap(bitmapData);
        }
		
		
		
	}//end of class
}