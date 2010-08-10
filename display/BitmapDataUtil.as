package org.asclub.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapDataUtil
	{
		public function BitmapDataUtil()
		{
		}
		
		/**
		 * 获取图像的最小边界区域（Minimum Bounding Rectangle，简称 MBR）。
		 * @param sourceBitmapData 要除去最外边透明部分的位图图像。
		 * @return 源图像的 MBR 。
		 * 
		 */		
		public static function getMinBoundingRect(sourceBitmapData:BitmapData):Rectangle
		{
			var rect:Rectangle = sourceBitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			return rect;
		}
		
		/**
		 * 获取图像的最小边界区域（Minimum Bounding Rectangle，简称 MBR）的位图数据。
		 * @param sourceBitmapData 要除去最外边透明部分的位图图像。
		 * @return 源图像的 MBR 。
		 * 
		 */		
		public static function getMinBoundingBitmapData(sourceBitmapData:BitmapData):BitmapData
		{
			var rect:Rectangle = sourceBitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			var bmd:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
			bmd.copyPixels(sourceBitmapData, rect, new Point(), null, null, true);
			return bmd;
		}
		
		/**
		 * 切分位图为一组较小的位图
		 * 
		 * @param source
		 * @param width
		 * @param height
		 * @param toBitmap	转换为Bitmap（而非BitmapData）
		 * @return 
		 * 
		 */
		public static function separateBitmapData(source:BitmapData,width:int,height:int,toBitmap:Boolean = false):Array
		{
			var result:Array = [];
			for (var j:int = 0;j < Math.ceil(source.height / height);j++)
			{
				for (var i:int = 0;i < Math.ceil(source.width / width);i++)
				{
					var bitmap:BitmapData = new BitmapData(width,height,true,0);
					bitmap.copyPixels(source,new Rectangle(i*width,j*height,width,height),new Point());
					if (toBitmap)
					{
						var bp:Bitmap = new Bitmap(bitmap);
						bp.x = i * width;
						bp.y = j * height;
						result.push(bp);
					}
					else
						result.push(bitmap)
				}	
			}
			return result;
		}
		
	}//end of class
}