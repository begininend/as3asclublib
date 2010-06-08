package org.asclub.display
{
	/**
	 * 主要用于处理对齐
	 */
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public final class AlignUtil
	{
		public static const BOTTOM:String        = "bottom";
		public static const BOTTOM_CENTER:String = "bottomCenter";
		public static const BOTTOM_LEFT:String   = "bottomLeft";
		public static const BOTTOM_RIGHT:String  = "bottomRight";
		public static const CENTER:String        = "center";
		public static const LEFT:String          = "left";
		public static const MIDDLE:String        = "middle";
		public static const MIDDLE_CENTER:String = "middleCenter";
		public static const MIDDLE_LEFT:String   = "middleLeft";
		public static const MIDDLE_RIGHT:String  = "middleRight";
		public static const RIGHT:String         = "right";
		public static const TOP:String           = "top";
		public static const TOP_CENTER:String    = "topCenter";
		public static const TOP_LEFT:String      = "topLeft";
		public static const TOP_RIGHT:String     = "topRight";
		
		public function AlignUtil()
		{
			
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the bounding <code>Rectangle</code> acording to the defined alignment.
			将一个显示对象按预定的对齐方式进行对齐
			@param alignment: The alignment type/position.(对齐方式)
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function align(alignment:String, displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			const targetPosition:Point = AlignUtil._getPosition(alignment, displayObject.width, displayObject.height, bounds, outside);
			const offsetPosition:Point = DisplayObjectUtil.getOffsetPosition(displayObject);
			
			displayObject.x = targetPosition.x + offsetPosition.x;
			displayObject.y = targetPosition.y + offsetPosition.y;
			
			if (snapToPixel)
				AlignUtil.alignToPixel(displayObject);
		}
		
		/**
			Aligns a <code>Rectangle</code> to another <code>Rectangle</code>.
			
			@param align: The alignment type/position.
			@param rectangle: The <code>Rectangle</code> to align.
			@param bounds: The area in which to align the <code>Rectangle</code>.(要对齐的矩形区域)
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>Rectangle</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>Rectangle</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
			@return A new aligned <code>Rectangle</code>.
		*/
		public static function alignRectangle(alignment:String, rectangle:Rectangle, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):Rectangle {
			const alignedRectangle:Rectangle = rectangle.clone();
			
			alignedRectangle.offsetPoint(AlignUtil._getPosition(alignment, rectangle.width, rectangle.height, bounds, outside));
			
			if (snapToPixel) {
				alignedRectangle.x = Math.round(alignedRectangle.x);
				alignedRectangle.y = Math.round(alignedRectangle.y);
			}
			
			return alignedRectangle;
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the nearest Pixel.
			
			@param displayObject: The <code>DisplayObject</code> to align.
		*/
		public static function alignToPixel(displayObject:DisplayObject):void {
			displayObject.x = Math.round(displayObject.x);
			displayObject.y = Math.round(displayObject.y);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the bottom of the bounding <code>Rectangle</code>.
			底对齐
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.(要对齐的矩形区域)
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignBottom(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.BOTTOM, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the bottom left of the bounding <code>Rectangle</code>.
			底部左对齐
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.(要对齐的矩形区域)
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignBottomLeft(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.BOTTOM_LEFT, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the bottom and horizontal center of the bounding <code>Rectangle</code>.
			底部居中对齐
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignBottomCenter(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.BOTTOM_CENTER, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the bottom right of the bounding <code>Rectangle</code>.
			底部右对齐
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignBottomRight(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.BOTTOM_RIGHT, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the horizontal center of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
		*/
		public static function alignCenter(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true):void {
			AlignUtil.align(AlignUtil.CENTER, displayObject, bounds, snapToPixel);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the left side of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignLeft(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.LEFT, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the vertical middle of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
		*/
		public static function alignMiddle(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true):void {
			AlignUtil.align(AlignUtil.MIDDLE, displayObject, bounds, snapToPixel);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the vertical middle and left side of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignMiddleLeft(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.MIDDLE_LEFT, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the vertical middle and horizontal center of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
		*/
		public static function alignMiddleCenter(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true):void {
			AlignUtil.align(AlignUtil.MIDDLE_CENTER, displayObject, bounds, snapToPixel);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the vertical middle and right side of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignMiddleRight(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.MIDDLE_RIGHT, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the right side of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignRight(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.RIGHT, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the top of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignTop(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.TOP, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the top left of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignTopLeft(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.TOP_LEFT, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the top side and horizontal center of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignTopCenter(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.TOP_CENTER, displayObject, bounds, snapToPixel, outside);
		}
		
		/**
			Aligns a <code>DisplayObject</code> to the top right of the bounding <code>Rectangle</code>.
			
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
		*/
		public static function alignTopRight(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):void {
			AlignUtil.align(AlignUtil.TOP_RIGHT, displayObject, bounds, snapToPixel, outside);
		}
		
		protected static function _getPosition(alignment:String, targetWidth:uint, targetHeight:uint, bounds:Rectangle, outside:Boolean):Point {
			const position:Point = new Point();
			
			switch (alignment) {
				case AlignUtil.BOTTOM_LEFT :
				case AlignUtil.LEFT :
				case AlignUtil.MIDDLE_LEFT :
				case AlignUtil.TOP_LEFT :
					position.x = outside ? bounds.x - targetWidth : bounds.x;
					break;
				case AlignUtil.BOTTOM_CENTER :
				case AlignUtil.CENTER :
				case AlignUtil.MIDDLE_CENTER :
				case AlignUtil.TOP_CENTER :
					position.x = (bounds.width - targetWidth) * 0.5 + bounds.x;
					break;
				case AlignUtil.BOTTOM_RIGHT:
				case AlignUtil.MIDDLE_RIGHT:
				case AlignUtil.RIGHT:
				case AlignUtil.TOP_RIGHT:
					position.x = outside ? bounds.right : bounds.right - targetWidth;
					break;
			}
			
			switch (alignment) {
				case AlignUtil.TOP:
				case AlignUtil.TOP_CENTER:
				case AlignUtil.TOP_LEFT:
				case AlignUtil.TOP_RIGHT:
					position.y = outside ? bounds.y - targetHeight : bounds.y;
					break;
				case AlignUtil.MIDDLE :
				case AlignUtil.MIDDLE_CENTER :
				case AlignUtil.MIDDLE_LEFT :
				case AlignUtil.MIDDLE_RIGHT :
					position.y = (bounds.height - targetHeight) * 0.5 + bounds.y;
					break;
				case AlignUtil.BOTTOM:
				case AlignUtil.BOTTOM_CENTER:
				case AlignUtil.BOTTOM_LEFT:
				case AlignUtil.BOTTOM_RIGHT:
					position.y = outside ? bounds.bottom : bounds.bottom - targetHeight;
					break;
			}
			
			return position;
		}
		
		
	}//end of class
}