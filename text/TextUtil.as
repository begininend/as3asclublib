package org.asclub.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	public class TextUtil
	{
		public function TextUtil()
		{
			
		}
		
		/**
		 * 文本是否溢出文本框
		 * @param	field
		 * @return
		 */
		public static function hasOverFlow(field:TextField):Boolean 
		{
			return field.maxScrollV > 1 || field.maxScrollH > 1;
		}
		
		/**
		 * 当目标文本框不足于在可视行中显示所有文字则用省略代替
		 * @param	textField   目标文本框
		 * @param	str         目标文本
		 * @return  String      包含省略的文本
		 */
		public static function getTextFieldAbbrAsString(textField:TextField,str:String, separator:String = " ...."):String
		{
			textField.text = str;
			var shorteningStr:String = str;
			var numTextLines:int = textField.bottomScrollV;
			if(textField.multiline && textField.wordWrap)
			{
				if(textField.textHeight > textField.height)
				{
					shorteningStr = "";
					for(var i:int = 0;i < numTextLines - 1;i++)
					{
						shorteningStr += textField.getLineText(i);
					}
					var lastLineStr:String = textField.getLineText(numTextLines - 1);
					shorteningStr += lastLineStr.substr(0,lastLineStr.length - separator.length) + separator;
				}
			}
			else
			{
				if(textField.textWidth > textField.width)
				{
					shorteningStr = shorteningStr.substring(0,textField.getCharIndexAtPoint(textField.width - 5,5) - separator.length) + separator;
				}
			}
			
			textField.text = shorteningStr;
			return shorteningStr;
		}
		
		/**
		 * 获取一个空白所占的宽度
		 * @return
		 */
		public static function getSingleWhitespaceWidth(textFormat:TextFormat):Number
		{
			var targetTextFormat:TextFormat = new TextFormat();
			targetTextFormat.size = textFormat.size;
			targetTextFormat.font = textFormat.font;
			var textField:TextField = new TextField();
			textField.defaultTextFormat = targetTextFormat;
			textField.setTextFormat(targetTextFormat);
			textField.text = " ";
			return textField.textWidth;
		}
		
		/**
		 * 去除html标签
		 * @param	param1
		 * @return
		 */
		public static function htmlToText(str:String) : String
        {
            var tf:TextField = new TextField();
            tf.htmlText = str;
            return tf.text;
        }
        
        /**
		 * 根据TextFormat附加HTML文本
		 * @param v
		 * @param format
		 * 
		 */
		public static function applyTextFormat(v:String,format:TextFormat):String
		{
			var t:TextField = new TextField();
			t.defaultTextFormat = format;
			t.text = v;
			return t.htmlText;
		}
		
		
	}//end of class
}