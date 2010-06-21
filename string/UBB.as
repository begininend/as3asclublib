package org.asclub.string
{
	/**
	 * @author flashyiyi
	 * BBCode是Bulletin Board Code的缩写，有译为「BB代码」者，属于轻量标记语言（）的一种，如字面上所显示的，它
	 * 主要是使用在BBS、论坛、Blog等网路应用上。 BBCode最初由Ultimate Bulletin Board讨论区系统发展出来，因此常见UBB代码的称呼。
	 * BBCode的语法通常为[标记]这种形式，即语法左右用两个中括号包围，以作为与正常文字间的区别。系统解译时遇上中括弧便知道该处是BBcode，
	 * 会在解译结果输出到用户端时转换成最为通用的HTML语法。
	 */
	public class UBB
	{
		/**
		 * UBB解码
		 * @param	v
		 * @return
		 * @example
		 * [url=http://bangzhuzhongxin.blogbus.com/logs/11205960.html][/url]  =>
		 * <a href='http://bangzhuzhongxin.blogbus.com/logs/11205960.html'/></a>
		 */
		public static function decode(v:String):String
		{
			v = v.replace(/\[(b|i|u|p|br)\]/ig,"<$1>");
			v = v.replace(/\[\/(b|i|u|p)\]/ig,"</$1>");
			
			v = v.replace(/\[(color|size|face|align)=(.*?)]/ig,replFN);
			v = v.replace(/\[\/(color|size|face|align)\]/ig,"</font>");
			
			v = v.replace(/\[img\](.*?)\[\/img\]/ig,"<img src='$1'/>");
			v = v.replace(/\[url\](.*?)\[\/url\]/ig,"<a href='$1'/>$1</a>");
			v = v.replace(/\[url=(.*?)\](.*)?\[\/url\]/ig,"<a href='$1'/>$2</a>");
			v = v.replace(/\[email\](.*?)\[\/email\]/ig,"<a href='mailto:$1'>$1</a>");
			v = v.replace(/\[email=(.*?)\](.*)?\[\/email\]/ig,"<a href='mailto:$1'>$2</a>");
			
			return v;
		}
		
		private static const COLORS:Array = ["red","blue","green","yellow","fuchsia","aqua","black","white","gray"];
		private static const COLOR_REPS:Array = ["#FF0000","#0000FF","#00FF00","#FFFF00","#FF00FF","#00FFFF","#000000","#FFFFFF","#808080"];
		
		private static function replFN():String
		{
			var s:String = arguments[2];
			var f:String = s.charAt(0);
			var e:String = s.charAt(s.length - 1);
			if (e == f && (e == "'" || e=="\""))
				s = s.slice(1,s.length - 1);
			
			if (arguments[1].toLowerCase() == "color")
			{
				var index:int = COLORS.indexOf(s.toLowerCase());
				if (index != -1)
					s = COLOR_REPS[index];
			}
			
			return "<font "+arguments[1]+"=\""+s+"\">"
		}
	}
}