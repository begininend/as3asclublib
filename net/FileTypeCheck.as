package org.asclub.net
{
	import flash.utils.ByteArray;
	/**
	 * 文件类型检查
	 */
	public final class FileTypeCheck
	{
		
		private static var _fileData:ByteArray;
		
		
		/**
		 * 是否是bmp格式
		 * @param	fileData
		 * @return
		 */
		public static function isBMP(fileData:ByteArray):Boolean
		{
			fileData.position = 0;
			if (fileData.bytesAvailable < 2)
			{
				return false;
			}
			return fileData.readUTFBytes(2).toLocaleUpperCase() == "BM";
		}
		
		/**
		 * 是否是flv格式
		 * @param	fileData
		 * @return
		 */
		public static function isFLV(fileData:ByteArray):Boolean
		{
			fileData.position = 0;
			if (fileData.bytesAvailable < 3)
			{
				return false;
			}
			return fileData.readUTFBytes(3).toLocaleUpperCase() == "FLV";
		}
		
		/**
		 * 是否是png格式
		 * @param	fileData
		 * @return
		 */
		public static function isPNG(fileData:ByteArray):Boolean
		{
			_fileData = fileData;
			_fileData.position = 0;
			if (_fileData.bytesAvailable < 8)
			{
				return false;
			}
			//png   文件头标识 (8 bytes)   89 50 4E 47 0D 0A 1A 0A
			var regular:Array = [137,80,78,71,13,10,26,10];
			return regular.every(everyCallBack);
		}
		
		/**
		 * 是否是gif格式
		 * @param	fileData
		 * @return
		 */
		public static function isGIF(fileData:ByteArray):Boolean
		{
			_fileData = fileData;
			_fileData.position = 0;
			if (_fileData.bytesAvailable < 6)
			{
				return false;
			}
			// gif  - 文件头标识 (6 bytes)   47 49 46 38 39(37) 61
			var regular1:Array = [71, 73, 70, 56, 57, 97];
			var regular2:Array = [71, 73, 70, 56, 55, 97];
			var res1:Boolean = regular1.every(everyCallBack);
			var res2:Boolean = regular2.every(everyCallBack);
			return (res1 || res2);
		}
		
		/**
		 * 是否是jpeg格式
		 * @param	fileData
		 * @return
		 */
		public static function isJPEG(fileData:ByteArray):Boolean
		{
			_fileData = fileData;
			_fileData.position = 0;
			if (_fileData.bytesAvailable < 2)
			{
				return false;
			}
			//- 文件头标识 (2 bytes): $ff, $d8 (SOI) (JPEG 文件标识)
			//- 文件结束标识 (2 bytes): $ff, $d9 (EOI)
			var regular:Array = [255,216];
			return regular.every(everyCallBack);
		}
		
		/**
		 * 是否是tga格式
		 * @param	fileData
		 * @return
		 */
		public static function isTGA(fileData:ByteArray):Boolean
		{
			_fileData = fileData;
			_fileData.position = 0;
			if (_fileData.bytesAvailable < 5)
			{
				return false;
			}
			//- 未压缩的前5字节   00 00 02 00 00
			//- RLE压缩的前5字节   00 00 10 00 00
			var uncompressedRegular:Array = [0, 0, 2, 0, 0];
			var compressedRegular:Array = [0, 0, 16, 0, 0];
			var res1:Boolean = uncompressedRegular.every(everyCallBack);
			var res2:Boolean = compressedRegular.every(everyCallBack);
			return (res1 || res2);
		}
		
		/**
		 * 
		 * @param	fileData
		 * @return
		 * - 文件头标识 (1 bytes)   0A
		 */
		public static function isPCX(fileData:ByteArray):Boolean
		{
			
		}
		
		/**
		 * 
		 * @param	fileData
		 * @return
		 * - 文件头标识 (2 bytes)   4D 4D 或 49 49
		 */
		public static function isTIFF(fileData:ByteArray):Boolean
		{
			
		}
		
		/**
		 * 
		 * @param	fileData
		 * @return
		 * - 文件头标识 (8 bytes)   00 00 01 00 01 00 20 20
		 */
		public static function isICO(fileData:ByteArray):Boolean
		{
			
		}
		
		/**
		 * 
		 * @param	fileData
		 * @return
		 * - 文件头标识 (8 bytes)   00 00 02 00 01 00 20 20
		 */
		public static function isCUR(fileData:ByteArray):Boolean
		{
			
		}
		
		/**
		 * 
		 * @param	fileData
		 * @return
		 * - 文件头标识 (4 bytes)   46 4F 52 4D
		 */
		public static function isIFF(fileData:ByteArray):Boolean
		{
			
		}
		
		/**
		 * 
		 * @param	fileData
		 * @return
		 * - 文件头标识 (4 bytes)   52 49 46 46
		 */
		public static function isANI(fileData:ByteArray):Boolean
		{
			
		}
		
		//检查是否复合文件头标识
		private static function everyCallBack(element:int, index:int, arr:Array):Boolean
		{
			return _fileData[index] == element;
		}
		
	}//end class
}