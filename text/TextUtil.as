package org.asclub.text
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	
	
	public class TextUtil
	{
		
		private static var _textFieldMaps:Dictionary = new Dictionary();
		
		
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
			//return field.maxScrollV > 1 || field.maxScrollH > 0;
			return field.textHeight > field.height || field.textWidth > field.width || field.maxScrollV > 1 || field.maxScrollH > 0;
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
		 * 根据文本框大小自动缩小字体
		 * @param textField
		 * 
		 */
		public static function autoFontSize(textField:TextField,adjustY:Boolean = false):void
		{
			var text:String = textField.text;
			var f:TextFormat = textField.getTextFormat();
			var old_size:int = int(f.size);
			
			if (text == null || text.length == 0)
				return;
			trace("文本溢出:" + hasOverFlow(textField));
			//如果文本溢出则缩小字号以适应文本框
			if (hasOverFlow(textField))
			{
				while (hasOverFlow(textField))
				{
					f = textField.getTextFormat();
					f.size = int(f.size) - 1;
					if (f.size == 0)
						return;
					
					//textField.setTextFormat(f,0,text.length);
					textField.setTextFormat(f);
				}
			}
			//如果文本未溢出则放大字号以适应文本框
			else
			{
				trace(hasOverFlow(textField));
				while ( ! hasOverFlow(textField))
				{
					f = textField.getTextFormat();
					f.size = int(f.size) + 1;
					trace(f.size);
					if (f.size > 126)
					{	
						return;
					}
					
					//textField.setTextFormat(f,0,text.length);
					textField.setTextFormat(f);
				}
				
				trace("文本溢出:" + hasOverFlow(textField));
				f = textField.getTextFormat();
				f.size = int(f.size) - 1;
				textField.setTextFormat(f);
				//textField.setTextFormat(f,0,text.length);
				trace("文本溢出:" + hasOverFlow(textField));
			}
			
			if (adjustY)
				textField.y += (old_size - int(f.size)) / 2;
		}
		
		/**
		 * 复制文本框 
		 * @param v
		 * @param replace 是否替换到父对象中
		 * @return 
		 * 
		 */
		public static function clone(v:TextField,replace:Boolean = false):TextField
		{
			var c:TextField = new TextField();
			c.name = v.name;
			c.type = v.type;
			c.autoSize = v.autoSize;
			c.embedFonts = v.embedFonts;
			c.defaultTextFormat = v.defaultTextFormat;
			c.text = v.text;
			for (var i:int = 0;i < v.text.length;i++)
			{
				c.setTextFormat(v.getTextFormat(i,i + 1),i,i + 1);
			}
			c.x = v.x;
			c.y = v.y;
			c.scaleX = v.scaleX;
			c.scaleY = v.scaleY;
			c.width = v.width;
			c.height = v.height;
			c.rotation = v.rotation;
			c.multiline = v.multiline;
			c.selectable = v.selectable;
			c.wordWrap = v.wordWrap;
			c.transform.colorTransform = v.transform.colorTransform;
			c.filters = v.filters;
			c.mouseEnabled = v.mouseEnabled;
			c.mouseWheelEnabled = v.mouseWheelEnabled;
			
			if (replace && v.parent)
			{
				var p:DisplayObjectContainer = v.parent;
				var index:int = p.getChildIndex(v);
				p.removeChild(v);
				p.addChildAt(c,index);
			}
			return c;
		}
		
		/**
		 * 获取字符所占的宽度
		 * @return
		 */
		public static function getTextWidth(str:String,textFormat:TextFormat):Number
		{
			var targetTextFormat:TextFormat = new TextFormat();
			targetTextFormat.size = textFormat.size;
			targetTextFormat.font = textFormat.font;
			var textField:TextField = new TextField();
			textField.defaultTextFormat = targetTextFormat;
			textField.setTextFormat(targetTextFormat);
			textField.text = str;
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
		
		/**
		 * 文本框最多可输入中文数
		 * @param	textField    文本框
		 * @param	value        限制数
		 */
		public static function maxChineseChars(textField:TextField,value:int):void
		{
			if (! _textFieldMaps[textField])
			{
				
			}
			
		}
		
		
	}//end of class
}