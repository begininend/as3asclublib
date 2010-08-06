package com.riaoo.display
{
	import flash.display.BitmapData;

	/**
	 * 帧队列。
	 *
	 * @see com.smartgf.display.Animation
	 *
	 * @author Y.Boy
	 *
	 */
	public class FrameSequence implements IFrameSequence
	{
		/**
		 * 存放帧位图数据的向量。
		 */
		protected var frameArray:Vector.<BitmapData>;

		/**
		 * 构造函数。
		 * @param length 长度。
		 * @param fixed 指示帧队列的长度是否固定。
		 *
		 */
		public function FrameSequence(length:uint = 0, fixed:Boolean = false)
		{
			this.frameArray = new Vector.<BitmapData>(length, fixed);
		}

		public function get length():uint
		{
			return this.frameArray.length;
		}

		public function set length(value:uint):void
		{
			this.frameArray.length = value;
		}

		public function get fixed():Boolean
		{
			return this.frameArray.fixed;
		}

		public function set fixed(value:Boolean):void
		{
			this.frameArray.fixed = value;
		}

		public function setFrameAt(index:uint, bitmapData:BitmapData):Boolean
		{
			try
			{
				this.frameArray[index] = bitmapData;
				return true;
			}
			catch (e:Error)
			{
			}

			return false;
		}

		public function getFrameAt(index:uint):BitmapData
		{
			var bmd:BitmapData;
			try
			{
				bmd = this.frameArray[index];
			}
			catch (e:Error)
			{
				bmd = null;
			}

			return bmd;
		}

		public function push(...params):uint
		{
			for each (var bmd:BitmapData in params)
			{
				this.frameArray.push(bmd);
			}

			return this.frameArray.length;
		}

		public function unshift(...params):uint
		{
			for each (var bmd:BitmapData in params)
			{
				this.frameArray.unshift(bmd);
			}

			return this.frameArray.length;
		}

		public function pop():BitmapData
		{
			return this.frameArray.pop();
		}

		public function shift():BitmapData
		{
			return this.frameArray.shift();
		}

		public function reverse():void
		{
			this.frameArray.reverse();
		}

	}
}