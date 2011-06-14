package org.asclub.display.image
{
	import flash.utils.ByteArray;
	
	import org.asclub.net.FileTypeCheck;
	
	public final class ImagePreParser
	{
		
		/*HexTag 数据标记，每串标记作为标记数组里的一个元素
		leapLength 跳过的字节数
		fileType 文件类型
		parseComplete 解析完成标记
		contentHeight,contentWidth 目标高度和宽度
		isAPPnExist 标记JPG图片的APPn数据段是否存在,默认为无
		*/
		private static const JPGHexTag:Array=[[0xFF,0xC0,0x00,0x11,0x08]];
		private static  const PNGHexTag:Array=[[0x49,0x48,0x44,0x52]];
		private static  const GIFHexTag:Array = [[0x21, 0xF9, 0x04], [0x00, 0x2C]];
		
		
		private static var fileType:String;
			
		private static var hexTag:Array;
		
		private static var APPnTag:Array;
		
		private static var leapLength:int;
		
		private static var address:uint;
		
		private static var byte:uint;
		private static var index:uint = 0;
		
		private static var match:Boolean=false;
		private static var isAPPnExist:Boolean=false;
		
		private static var fileData:ByteArray;
		
		
		public static var contentWidth:uint;
		public static var contentHeight:uint;
		
		
		/**
		 * 解析
		 * @param	byteArray
		 */
		public static function parse(byteArray:ByteArray):void
		{
			fileData = byteArray;
			fileData.position = 0;
			if (FileTypeCheck.isPNG(byteArray))
			{
				fileType = "png";
				hexTag = PNGHexTag;
				matchHexTag();
			}
			else if (FileTypeCheck.isJPEG(byteArray))
			{
				fileType = "jpg";
				hexTag = JPGHexTag;
				APPnTag = [];
				JPGAPPnMatch();
			}
			else if (FileTypeCheck.isGIF(byteArray))
			{
				fileType = "gif";
				hexTag = GIFHexTag;
				leapLength = 4;
				matchHexTag();
			}
		}
		
		//比较SOF0数据标签,其中包含width和height信息
		private static function matchHexTag() {
			var len:uint = hexTag.length;
			while (fileData.bytesAvailable > hexTag[0].length) {
				match=false;
				byte = fileData.readUnsignedByte();
				address++;
				if (byte == hexTag[0][index]) {
					//trace(byte.toString(16).toUpperCase());
					match=true;
					if (index >= hexTag[0].length - 1 && len == 1) {
						getWidthAndHeight();
						break;
					} else if (index >= hexTag[0].length - 1 && len > 1) {
						hexTag.shift();
						index=0;
						matchHexTag();
						break;
					}
				}
				if (match) {
					index++;
				} else {
					index=0;
				}
			}
		}
		
		//因为JPG图像比较复杂，有的有缩略图APPn标签里(缩略图同样有SOF0标签)，所有先查找APPn标签
		private static function JPGAPPnMatch() {
			while (fileData.bytesAvailable > leapLength) {
				match=false;
				byte = fileData.readUnsignedByte();
				address++;
				if (byte == 0xFF) {
					byte = fileData.readUnsignedByte();
					address++;
					/*如果byte在0xE1与0xEF之间，即找到一个APPn标签
					APPn标签为(0xFF 0xE1到0xFF 0xEF)
					*/
					if (byte >= 225 && byte <= 239) {
						isAPPnExist=true;
						//trace(byte.toString(16).toUpperCase());
						leapLength = fileData.readUnsignedShort() - 2;
						leapBytes(leapLength);
						JPGAPPnMatch();
					}
				}
				//APPn标签搜索完毕后即可开始比较SOF0标签
				if (byte != 0xFF && leapLength != 0) {
					matchHexTag();
					break;
				}
				/*如果超过一定数据还未找到APPn,则认为此JPG无APPn,直接开始开始比较SOF0标签。
				这里我取巧选了一个100作为判断,故并不能保证100%有效,但如重新解析的话效率并不好。
				如果谁有更有效的解决办法请告诉我，谢谢。
				*/
				if (address > 100 && isAPPnExist == false) {
					matchHexTag();
					break;
				}
			}
		}
		//跳过count个字节数
		private static function leapBytes(count:uint):void {
			for (var i:uint=0; i < count; i++) {
				fileData.readByte();
			}
			address+= count;
		}
		//获取加载对象的width和height
		private static function getWidthAndHeight() {
			if (fileType == "gif") {
				leapBytes(leapLength);
			}
			switch (fileType) {
				case "png" :
					contentWidth = fileData.readUnsignedInt();
					contentHeight = fileData.readUnsignedInt();
					break;
				case "gif" :
					contentWidth = fileData.readUnsignedShort();
					contentHeight = fileData.readUnsignedShort();
					break;
				case "jpg" :
					contentHeight = fileData.readUnsignedShort();
					contentWidth = fileData.readUnsignedShort();
					break;
			}
		}
		
	}//end class
}