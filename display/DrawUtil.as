package org.asclub.display
{
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	
	public final class DrawUtil
	{
		public function DrawUtil()
		{
			
		}
		
		/**
		 * 绘制一个直角矩形
		 * @param	graphics     绘制对象
		 * @param	bgColor      背景颜色
		 * @param	lineColor    线条颜色
		 * @param	w            宽度
		 * @param	h            高度
		 * @param	thickness    线条粗细
		 */
		public static function drawRect(graphics:Graphics,bgColor:uint,lineColor:uint,w:int,h:int,thickness:Number = 1):void
		{
			graphics.beginFill(bgColor);
			graphics.lineStyle(thickness,lineColor);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
		
		/**
		 * 绘制圆角矩形
		 * @param	graphics    绘制对象
		 * @param	bgColor     填充颜色
		 * @param	lineColor   笔触颜色
		 * @param	w           宽度
		 * @param	h           高度
		 * @param	ellipse     矩形圆角半径
		 * @param	thickness   笔触粗细
		 * @return
		 */
		public static function drawRoundRect(graphics:Graphics,bgColor:uint, lineColor:uint, w:int, h:int, ellipse:Number = 5, thickness:Number = 1):void
		{
			graphics.beginFill(bgColor);
			graphics.lineStyle(thickness,lineColor,1,true);
			graphics.drawRoundRect(0,0,w,h,ellipse);
			graphics.endFill();
		}
		
		/**
		 * 绘制直角渐变矩形
		 * @param	graphics  绘制对象
		 * @param	colors    要在渐变中使用的 RGB 十六进制颜色值数组（例如，红色为 0xFF0000，蓝色为 0x0000FF，等等）。 可以至多指定 15 种颜色。 对于每种颜色，请确保在 alphas 和 ratios 参数中指定对应的值。
		 * @param	alphas    colors 数组中对应颜色的 alpha 值数组；有效值为 0 到 1。 如果值小于 0，则默认值为 0。 如果值大于 1，则默认值为 1。 
		 * @param	ratios    颜色分布比例的数组；有效值为 0 到 255。 该值定义 100% 采样的颜色所在位置的宽度百分比。 值 0 表示渐变框中的左侧位置，255 表示渐变框中的右侧位置。
		 * @param	w         填充宽度
		 * @param	h         填充高度
		 * @param	type      用于指定要使用哪种渐变类型的 GradientType.LINEAR  指定线性渐变填充    GradientType.RADIAL  指定放射状渐变填充
		 * @param	rotation  填充角度
		 * @param	tx        渐变框中心点x位置
		 * @param	ty		  渐变框中心点x位置
		 * @param	spreadMethod   用于指定要使用哪种 spread 方法的 SpreadMethod 类的值：SpreadMethod.PAD、SpreadMethod.REFLECT 或 SpreadMethod.REPEAT。
		 */
		public static function drawGradientRect(graphics:Graphics,colors:Array,alphas:Array,ratios:Array,w:int,h:int,ellipse:Number = 5,type:String = "linear",rotation:Number = 0,tx:Number = 0,ty:Number = 0,spreadMethod:String = "pad"):void
		{
  			var matrix:Matrix = new Matrix();
			rotation = ((rotation % 360) / 180) * Math.PI;
  			matrix.createGradientBox(w, h, rotation, tx, ty);
			//graphics.lineStyle(1,0x000000);
  			graphics.beginGradientFill(type, colors, alphas, ratios,matrix, spreadMethod);
 			graphics.drawRoundRect(0, 0, w, h, ellipse);
			graphics.endFill();
		}
		
		/**
		 * 绘制路径
		 * @param	graphics
		 * @param	points
		 * @param	lineColor
		 * @param	thickness
		 */
		public static function drawPath(graphics:Graphics, points:Array, lineColor:uint = 0xff0000, thickness:Number = 1):void 
		{
			var i:uint = points.length;
			while (i--)
				if (!(points[i] is Point))
					throw new Error("数组中所包含的路径错误");
			
			if (points.length < 2)
				throw new Error("At least three Points are needed to draw a shape.");
				
			graphics.lineStyle(thickness,lineColor);
			graphics.moveTo(points[0].x, points[0].y);
			
			i = 0;
			var numPoints:int = points.length;
			while (++i < numPoints)
				graphics.lineTo(points[i].x, points[i].y);
		}
		
		/**
		 * 绘制不规则形状
		 * @param	graphics
		 * @param	points
		 * @param	bgColor
		 * @param	lineColor
		 * @param	thickness
		 */
		public static function drawShape(graphics:Graphics, bgColor:uint, lineColor:uint, points:Array, thickness:Number = 1):void
		{
			var i:uint = points.length;
			while (i--)
				if (!(points[i] is Point))
					throw new Error("数组中所包含的路径错误");
			
			if (points.length < 3)
				throw new Error("At least three Points are needed to draw a shape.");
			
			graphics.beginFill(bgColor);
			graphics.lineStyle(thickness,lineColor);
			graphics.moveTo(points[0].x, points[0].y);
			
			i = 0;
			var numPoints:int = points.length;
			while (++i < numPoints)
				graphics.lineTo(points[i].x, points[i].y);
				
			graphics.lineTo(points[0].x, points[0].y);
		}
		
	}//end of class
}