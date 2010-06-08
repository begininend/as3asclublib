package org.asclub.text
{
	import flash.display.Sprite;
	import flash.text.TextField;
	public class ScrollVText extends Sprite
	{
		private var tf1:TextField;
		private var tf2:TextField;
		public function ScrollVText()
		{
			
		}
		
		public function set text(value:String):void
		{
			
		}
		
		//创建文本框
		private function createTextField():TextField
		{
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.height = tf.textHeight;
			return tf;
		}
	}//end of class
}