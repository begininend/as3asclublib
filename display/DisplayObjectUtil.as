package org.asclub.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public final class DisplayObjectUtil
	{
		public function DisplayObjectUtil()
		{
			
		}
		
		/**
		 * 复制显示对象
		 * @param	target
		 * @param	autoAdd
		 * @return
		 */
		public function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject
		{
			// create duplicate(创建显示对象)
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
			// duplicate properties(复制属性)
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid)
			{
				var rect:Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent) 
			{
				target.parent.addChild(duplicate);
			}
			return duplicate;
		}
		
		/**
			Returns the children of a <code>DisplayObjectContainer</code> as an <code>Array</code>.
			返回一个显示对象容器的子对象数组集合
			@param parent: The <code>DisplayObjectContainer</code> from which to get the children from.
			@return All the children of the <code>DisplayObjectContainer</code>.
		*/
		public static function getChildren(parent:DisplayObjectContainer):Array 
		{
			const children:Array = [];
			var i:int            = -1;
			
			while (++i < parent.numChildren)
				children.push(parent.getChildAt(i));
			
			return children;
		}
		
		/**
		 * 获取一个显示对象距离其左上角x、y偏移
		 * Returns the X and Y offset to the top left corner of the <code>DisplayObject</code>. The offset can be used to position <code>DisplayObject</code>s whose alignment point is not at 0, 0 and/or is scaled.
		 * @param	displayObject: The <code>DisplayObject</code> to align.
		 * @return  The X and Y offset to the top left corner of the <code>DisplayObject</code>.
		 * @example
				<code>
					var box:CasaSprite = new CasaSprite();
					box.scaleX         = -2;
					box.scaleY         = 1.5;
					box.graphics.beginFill(0xFF00FF);
					box.graphics.drawRect(-20, 100, 50, 50);
					box.graphics.endFill();
					
					const offset:Point = DisplayObjectUtil.getOffsetPosition(box);
					
					trace(offset)
					
					box.x = 10 + offset.x;
					box.y = 10 + offset.y;
					
					this.addChild(box);
				</code>
		 */
		public static function getOffsetPosition(displayObject:DisplayObject):Point 
		{
			const bounds:Rectangle = displayObject.getBounds(displayObject);
			const offset:Point     = new Point();
			
			offset.x = (displayObject.scaleX > 0) ? bounds.left * displayObject.scaleX * -1 : bounds.right * displayObject.scaleX * -1
			offset.y = (displayObject.scaleY > 0) ? bounds.top * displayObject.scaleY * -1 : bounds.bottom * displayObject.scaleY * -1
			
			return offset;
		}
		
		/**
		 * Converts a rotation in the coordinate system of a display object 
		 * to a global rotation relative to the stage.
		 * 
		 * @param obj The display object
		 * @param rotation The rotation
		 * 
		 * @return The rotation relative to the stage's coordinate system.
		 */
		public static function localToGlobalRotation( obj:DisplayObject, rotation:Number ):Number
		{
			var rot:Number = rotation + obj.rotation;
			for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
			{
				rot += current.rotation;
			}
			return rot;
		}

		/**
		 * Converts a global rotation in the coordinate system of the stage 
		 * to a local rotation in the coordinate system of a display object.
		 * 
		 * @param obj The display object
		 * @param rotation The rotation
		 * 
		 * @return The rotation relative to the display object's coordinate system.
		 */
		public static function globalToLocalRotation( obj:DisplayObject, rotation:Number ):Number
		{
			var rot:Number = rotation - obj.rotation;
			for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
			{
				rot -= current.rotation;
			}
			return rot;
		}
		
		
	}//end of class
}