package com.riaoo.valueObject
{
	/**
	 * Padding 类就像 CSS 里的 padding 属性一样，指示上、右、下、左的内边距。
	 * @author Y.Boy
	 * 
	 */	
	public class Padding
	{
		/**
		 * 顶部的内边距。
		 */		
		public var top:Number;
		
		/**
		 * 右部的内边距。
		 */		
		public var right:Number;
		
		/**
		 * 底部的内边距。
		 */		
		public var bottom:Number;
		
		/**
		 * 左部的内边距。
		 */		
		public var left:Number;
		
		/**
		 * 构造函数。
		 * 
		 */		
		public function Padding(top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0)
		{
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
		}
		
		public function toString():String
		{
			return "[top: " + this.top + ", right: " + this.right + ", bottom: " + this.bottom + ", left: " + this.left + "]";
		}
	}
}