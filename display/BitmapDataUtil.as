package com.riaoo.utils
{
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
		
	}
}