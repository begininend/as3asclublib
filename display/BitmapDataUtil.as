package org.asclub.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.asclub.data.ArrayUtil;
	import org.asclub.data.MathUtil;

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
		
		/**
		 * 横向拼合位图
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public static function concatBitmapDataH(source:Array):BitmapData
		{
			
			var width:Number = MathUtil.sum(ArrayUtil.getValuesByKey(source,"width"));
			var height:Number = MathUtil.max(ArrayUtil.getValuesByKey(source,"height"));
			var result:BitmapData = new BitmapData(width,height,true,0);
			
			var x:int = 0;
			for (var i:int = 0;i < source.length; i++)
			{
				var bitmap:BitmapData = source[i];
				result.copyPixels(bitmap,new Rectangle(0,0,bitmap.width,bitmap.height),new Point(x,0));
				
				x += bitmap.width;
			}	
			return result;
		}
		
		/**
		 * 纵向向拼合位图
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public static function concatBitmapDataV(source:Array):BitmapData
		{
			
			var width:Number = MathUtil.max(ArrayUtil.getValuesByKey(source,"width"));
			var height:Number = MathUtil.sum(ArrayUtil.getValuesByKey(source,"height"));
			var result:BitmapData = new BitmapData(width,height,true,0);
			
			var y:int = 0;
			for (var i:int = 0;i < source.length; i++)
			{
				var bitmap:BitmapData = source[i];
				result.copyPixels(bitmap,new Rectangle(0,0,bitmap.width,bitmap.height),new Point(0,y));
				
				y += bitmap.height;
			}	
			return result;
		}
		
		/**
		 * 在一个限定的宽度内拼合位图
		 * 
		 * @param source	位图数据源
		 * @param maxWidth	最大宽度
		 * @param resultRect	结果矩形区域数据
		 * @return 
		 * 
		 */
		public static function concatBitmapDataLimitWidth(source:Array,maxWidth:int,resultRects:Array = null):BitmapData
		{
			if (!resultRects)
				resultRects = [];
			
			var x:int = 0;
			var y:int = 0;
			var mh:int = 0;
			for (var i:int = 0;i < source.length;i++)
			{
				var bitmap:BitmapData = source[i];
				if (x + bitmap.width <= maxWidth)
				{
					if (bitmap.height > mh)
						mh = bitmap.height;
				}
				else
				{
					x = 0;
					y += mh;
					mh = 0;
				}
				resultRects.push(new Rectangle(x,y,bitmap.width,bitmap.height))
				x += bitmap.width;
			}
			
			var result:BitmapData = new BitmapData(maxWidth,y + mh,true,0);
			
			for (i = 0;i < resultRects.length;i++)
			{
				bitmap = source[i];
				result.copyPixels(bitmap,bitmap.rect,(resultRects[i] as Rectangle).topLeft);
			}
			
			return result;
		}
		
		
		/**
		* Converts a BitmapData instance into a 32-bit
		* BMP image.
		* bitmapdata.getpixel 方法是ActionScript 3.0中的一个新方法，可以把矩形内的像素读取成bytearray，但是这种bytearray
		* 又不能直接用loader.loadbytes来读，一读就会出现IOERROR。为了达到可以直接用loader.loadbytes读取的目的,便有如下方法
		* @param bitmapData A BitmapData instance of the image
		* desired to have converted into a Bitmap (BMP).
		* @return A ByteArray containing the binary Bitmap (BMP)
		* representation of the BitmapData instance passed.
		*/
		public static function BMPEncode(bitmapData:BitmapData):ByteArray 
		{
			// image/file properties
			var bmpWidth:int = bitmapData.width;
			var bmpHeight:int = bitmapData.height;
			var imageBytes:ByteArray = bitmapData.getPixels(bitmapData.rect);
			var imageSize:int = imageBytes.length;
			var imageDataOffset:int = 0x36;
			var fileSize:int = imageSize + imageDataOffset;
			// binary BMP data
			var bmpBytes:ByteArray = new ByteArray();
			bmpBytes.endian = Endian.LITTLE_ENDIAN; // byte order
			// header information
			bmpBytes.length = fileSize;
			bmpBytes.writeByte(0x42); // B
			bmpBytes.writeByte(0x4D); // M (BMP identifier)
			bmpBytes.writeInt(fileSize); // file size
			bmpBytes.position = 0x0A; // offset to image data
			bmpBytes.writeInt(imageDataOffset);
			bmpBytes.writeInt(0x28); // header size
			bmpBytes.position = 0x12; // width, height
			bmpBytes.writeInt(bmpWidth);
			bmpBytes.writeInt(bmpHeight);
			bmpBytes.writeShort(1); // planes (1)
			bmpBytes.writeShort(32); // color depth (32 bit)
			bmpBytes.writeInt(0); // compression type
			bmpBytes.writeInt(imageSize); // image data size
			bmpBytes.position = imageDataOffset; // start of image data...
			// write pixel bytes in upside-down order
			// (as per BMP format)
			var col:int = bmpWidth;
			var row:int = bmpHeight;
			var rowLength:int = col * 4; // 4 bytes per pixel (32 bit)
			try 
			{
				// make sure we're starting at the
				// beginning of the image data
				imageBytes.position = 0;
				// bottom row up
				while (row--) 
				{
					// from end of file up to imageDataOffset
					bmpBytes.position = imageDataOffset + row*rowLength;
					// read through each column writing
					// those bits to the image in normal
					// left to rightorder
					col = bmpWidth;
					while (col--) {
						bmpBytes.writeInt(imageBytes.readInt());
					}
				}
			}catch(error:Error){
				// end of file
			}
				// return BMP file
			return bmpBytes;
		}
		
		 /**
		* 获取透明背景纹理
		*/
		public static function getAlphaTextureBitmapData() : BitmapData 
		{
			var shape : Shape = new Shape();
			shape.graphics.beginFill(0xDFDFDF);
			shape.graphics.drawRect(8, 0, 8, 8);
			shape.graphics.drawRect(0, 8, 8, 8);
			shape.graphics.endFill();
			var data : BitmapData = new BitmapData(16, 16, false, 0xFFFFFF);
			data.draw(shape);
			return data;
		}
		
	}//end of class
}