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
		 * 绘制一个圆。
		 * @param	graphics    绘制对象
		 * @param	radius      圆的半径（以像素为单位）。
		 * @param	bgColor     填充颜色(当值为负数时不进行填充)
		 * @param	lineColor   笔触颜色(当值为负数时不进行填充)
		 * @param	x           相对于父显示对象注册点的圆心的 x 位置（以像素为单位）。 
		 * @param	y           相对于父显示对象注册点的圆心的 y 位置（以像素为单位）。 
		 * @param	alpha       透明度
		 * @param	thickness   笔触粗细(当thickness 的值为NaN时，则不进行线条填充)
		 */
		public static function drawCircle(graphics:Graphics, radius:Number, bgColor:int = -1, lineColor:int = -1, x:Number = 0, y:Number = 0, alpha:Number = 1, thickness:Number = 1):void
		{
			graphics.lineStyle(NaN);
			if(lineColor >= 0) graphics.lineStyle(thickness,lineColor,alpha);
			graphics.beginFill(bgColor,alpha);
			if(bgColor >= 0) graphics.drawCircle(x, y, radius);
			graphics.endFill();
		}
		
		/**
		 * 绘制一个椭圆。
		 * @param	graphics    绘制对象
		 * @param	w           椭圆的宽度（以像素为单位）。 
		 * @param	h           椭圆的高度（以像素为单位）。
		 * @param	bgColor     填充颜色(当值为负数时不进行填充)
		 * @param	lineColor   笔触颜色(当值为负数时不进行填充)
		 * @param	x           相对于父显示对象注册点的圆心的 x 位置（以像素为单位）。 
		 * @param	y           相对于父显示对象注册点的圆心的 y 位置（以像素为单位）。
		 * @param	alpha       透明度
		 * @param	thickness   笔触粗细(当thickness 的值为NaN时，则不进行线条填充)
		 */
		public static function drawEllipse(graphics:Graphics, w:int, h:int, bgColor:int = -1, lineColor:int = -1, x:Number = 0, y:Number = 0,alpha:Number = 1, thickness:Number = 1):void
		{
			graphics.beginFill(bgColor, alpha);
			graphics.lineStyle(NaN);
			if(lineColor >= 0) graphics.lineStyle(thickness,lineColor,alpha,true);
			if(bgColor >= 0) graphics.drawEllipse(x,y,w,h);
			graphics.endFill();
		}
		
		/**
		 * 绘制圆(直)角矩形
		 * @param	graphics    绘制对象
		 * @param	w           宽度
		 * @param	h           高度
		 * @param	bgColor     填充颜色(当值为负数时不进行填充)
		 * @param	lineColor   笔触颜色(当值为负数时不进行填充)
		 * @param	x           x坐标
		 * @param	y           y坐标
		 * @param	alpha       透明度
		 * @param	ellipse     矩形圆角半径
		 * @param	thickness   笔触粗细(当thickness 的值为NaN时，则不进行线条填充)
		 * @return
		 */
		public static function drawRoundRect(graphics:Graphics, w:int, h:int, bgColor:int = -1, lineColor:int = -1, x:Number = 0, y:Number = 0,alpha:Number = 1,ellipse:Number = 5, thickness:Number = 1):void
		{
			graphics.beginFill(bgColor, alpha);
			graphics.lineStyle(NaN);
			if(lineColor >= 0) graphics.lineStyle(thickness,lineColor,alpha,true);
			if(bgColor >= 0) graphics.drawRoundRect(x,y,w,h,ellipse);
			graphics.endFill();
		}
		
		/**
		 * 绘制复杂圆角矩形(不完全圆角矩形)
		 * @param	graphics    绘制对象
		 * @param	w           宽度
		 * @param	h           高度
		 * @param	bgColor     填充颜色(当值为负数时不进行填充)
		 * @param	lineColor   笔触颜色(当值为负数时不进行填充)
		 * @param	x           x坐标
		 * @param	y           y坐标
		 * @param	alpha       透明度
		 * @param	ellipseTL   左上角圆角半径
		 * @param	ellipseTR   右上角圆角半径
		 * @param	ellipseBR   右下角圆角半径
		 * @param	ellipseBL   左下角圆角半径
		 * @param	thickness   笔触粗细(当thickness 的值为NaN时，则不进行线条填充)
		 */
		public static function drawRoundRectComplex(graphics:Graphics, w:int, h:int, bgColor:int = -1, lineColor:int = -1, x:Number = 0, y:Number = 0, alpha:Number = 1, ellipseTL:Number = 0, ellipseTR:Number = 0, ellipseBR:Number = 0, ellipseBL:Number = 0, thickness:Number = 1):void
		{
			graphics.beginFill(bgColor, alpha);
			graphics.lineStyle(NaN);
			if (lineColor >= 0) graphics.lineStyle(thickness, lineColor, alpha, true);
			if (bgColor >= 0) graphics.drawRoundRectComplex(x, y, w, h, ellipseTL, ellipseTR, ellipseBR, ellipseBL);
			graphics.endFill();
		}
		
		/**
		 * 绘制圆(直)角渐变矩形
		 * @param	graphics  绘制对象
		 * @param	colors    要在渐变中使用的 RGB 十六进制颜色值数组（例如，红色为 0xFF0000，蓝色为 0x0000FF，等等）。 可以至多指定 15 种颜色。 对于每种颜色，请确保在 alphas 和 ratios 参数中指定对应的值。
		 * @param	alphas    colors 数组中对应颜色的 alpha 值数组；有效值为 0 到 1。 如果值小于 0，则默认值为 0。 如果值大于 1，则默认值为 1。 
		 * @param	ratios    颜色分布比例的数组；有效值为 0 到 255。 该值定义 100% 采样的颜色所在位置的宽度百分比。 值 0 表示渐变框中的左侧位置，255 表示渐变框中的右侧位置。
		 * @param	w         填充宽度
		 * @param	h         填充高度
		 * @param	x         x坐标
		 * @param	y         y坐标
		 * @param	type      用于指定要使用哪种渐变类型的 GradientType.LINEAR  指定线性渐变填充    GradientType.RADIAL  指定放射状渐变填充
		 * @param	rotation  填充角度
		 * @param	tx        渐变框中心点x位置
		 * @param	ty		  渐变框中心点x位置
		 * @param	spreadMethod   用于指定要使用哪种 spread 方法的 SpreadMethod 类的值：SpreadMethod.PAD、SpreadMethod.REFLECT 或 SpreadMethod.REPEAT。
		 */
		public static function drawGradientRoundRect(graphics:Graphics,colors:Array,alphas:Array,ratios:Array,w:int,h:int, x:Number = 0, y:Number = 0,ellipse:Number = 5,type:String = "linear",rotation:Number = 0,tx:Number = 0,ty:Number = 0,spreadMethod:String = "pad"):void
		{
			graphics.lineStyle(NaN);
  			var matrix:Matrix = new Matrix();
			rotation = ((rotation % 360) / 180) * Math.PI;
  			matrix.createGradientBox(w, h, rotation, tx, ty);
			//graphics.lineStyle(1,colors[0],alphas[0],true);
  			graphics.beginGradientFill(type, colors, alphas, ratios,matrix, spreadMethod);
 			graphics.drawRoundRect(x, y, w, h, ellipse);
			graphics.endFill();
		}
		
		/**
		 * 
		 * @param	graphics　　　　　　　　　绘制对象
		 * @param	x						  x坐标
		 * @param	y						  y坐标
		 * @param	width                     填充宽度
		 * @param	height                    填充高度
		 * @param	ellipseWidth              圆角半径
		 * @param	ellipseHeight             圆角半径
		 * @param	topLeft                   左上角是否圆角
		 * @param	topRight                  右上角是否圆角
		 * @param	bottomRight               右下角是否圆角
		 * @param	bottomLeft                左下角是否圆角
		 */
		public static function drawIncompletionRoundRect(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number, topLeft:Boolean = true, topRight:Boolean = true, bottomRight:Boolean = true, bottomLeft:Boolean = true):void 
		{
			const radiusWidth:Number  = ellipseWidth * 0.5;
			const radiusHeight:Number = ellipseHeight * 0.5;
			
			if (topLeft)
				graphics.moveTo(x + radiusWidth, y);
			else
				graphics.moveTo(x, y);
			
			if (topRight) {
				graphics.lineTo(x + width - radiusWidth, y);
				graphics.curveTo(x + width, y, x + width, y + radiusHeight);
			} else
				graphics.lineTo(x + width, y);
			
			if (bottomRight) {
				graphics.lineTo(x + width, y + height - radiusHeight);
				graphics.curveTo(x + width, y + height, x + width - radiusWidth, y + height);
			} else
				graphics.lineTo(x + width, y + height);
			
			if (bottomLeft) {
				graphics.lineTo(x + radiusWidth, y + height);
				graphics.curveTo(x, y + height, x, y + height - radiusHeight);
			} else
				graphics.lineTo(x, y + height);
			
			if (topLeft) {
				graphics.lineTo(x, y + radiusHeight);
				graphics.curveTo(x, y, x + radiusWidth, y);
			} else
				graphics.lineTo(x, y);
		}
		
		/**
		 * 绘制路径
		 * @param	graphics     绘制对象
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
		public static function drawShape(graphics:Graphics, bgColor:int, lineColor:int, points:Array, thickness:Number = 1):void
		{
			var i:uint = points.length;
			while (i--)
				if (!(points[i] is Point))
					throw new Error("数组中所包含的路径错误");
			
			if (points.length < 3)
				throw new Error("At least three Points are needed to draw a shape.");
			
			graphics.beginFill(bgColor);
			graphics.lineStyle(NaN);
			if(lineColor >= 0) graphics.lineStyle(thickness,lineColor);
			graphics.moveTo(points[0].x, points[0].y);
			
			i = 0;
			var numPoints:int = points.length;
			while (++i < numPoints)
				graphics.lineTo(points[i].x, points[i].y);
				
			graphics.lineTo(points[0].x, points[0].y);
		}
		
		public static function burst(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number = 0) : void
        {
            var _loc_8:Number;
            var _loc_9:Number;
            var _loc_10:Number;
            var _loc_11:Number;
            var _loc_12:int;
            if (param4 >= 2)
            {
                _loc_8 = Math.PI * 2 / param4;
                _loc_9 = _loc_8 / 2;
                _loc_10 = _loc_8 / 4;
                _loc_11 = param7 / 180 * Math.PI;
                param1.moveTo(param2 + Math.cos(_loc_11) * param6, param3 - Math.sin(_loc_11) * param6);
                _loc_12 = 1;
                while (_loc_12 <= param4)
                {
                    
                    param1.curveTo(param2 + Math.cos(_loc_11 + _loc_8 * _loc_12 - _loc_10 * 3) * (param5 / Math.cos(_loc_10)), param3 - Math.sin(_loc_11 + _loc_8 * _loc_12 - _loc_10 * 3) * (param5 / Math.cos(_loc_10)), param2 + Math.cos(_loc_11 + _loc_8 * _loc_12 - _loc_9) * param5, param3 - Math.sin(_loc_11 + _loc_8 * _loc_12 - _loc_9) * param5);
                    param1.curveTo(param2 + Math.cos(_loc_11 + _loc_8 * _loc_12 - _loc_10) * (param5 / Math.cos(_loc_10)), param3 - Math.sin(_loc_11 + _loc_8 * _loc_12 - _loc_10) * (param5 / Math.cos(_loc_10)), param2 + Math.cos(_loc_11 + _loc_8 * _loc_12) * param6, param3 - Math.sin(_loc_11 + _loc_8 * _loc_12) * param6);
                    _loc_12++;
                }
            }
            return;
        }// end function

        public static function star(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number = 0) : void
        {
            var _loc_9:Number;
            var _loc_10:Number;
            var _loc_11:Number;
            var _loc_12:int;
            var _loc_8:* = Math.abs(param4);
            if (Math.abs(param4) >= 2)
            {
                _loc_9 = Math.PI * 2 / param4;
                _loc_10 = _loc_9 / 2;
                _loc_11 = param7 / 180 * Math.PI;
                param1.moveTo(param2 + Math.cos(_loc_11) * param6, param3 - Math.sin(_loc_11) * param6);
                _loc_12 = 1;
                while (_loc_12 <= _loc_8)
                {
                    
                    param1.lineTo(param2 + Math.cos(_loc_11 + _loc_9 * _loc_12 - _loc_10) * param5, param3 - Math.sin(_loc_11 + _loc_9 * _loc_12 - _loc_10) * param5);
                    param1.lineTo(param2 + Math.cos(_loc_11 + _loc_9 * _loc_12) * param6, param3 - Math.sin(_loc_11 + _loc_9 * _loc_12) * param6);
                    _loc_12++;
                }
            }
            return;
        }// end function

        public static function polygon(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 0) : void
        {
            var _loc_8:Number;
            var _loc_9:Number;
            var _loc_10:int;
            var _loc_7:* = Math.abs(param4);
            if (Math.abs(param4) >= 2)
            {
                _loc_8 = Math.PI * 2 / param4;
                _loc_9 = param6 / 180 * Math.PI;
                param1.moveTo(param2 + Math.cos(_loc_9) * param5, param3 - Math.sin(_loc_9) * param5);
                _loc_10 = 1;
                while (_loc_10 <= _loc_7)
                {
                    
                    param1.lineTo(param2 + Math.cos(_loc_9 + _loc_8 * _loc_10) * param5, param3 - Math.sin(_loc_9 + _loc_8 * _loc_10) * param5);
                    _loc_10++;
                }
            }
            return;
        }// end function

        public static function arcTo(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
        {
            var _loc_8:Number;
            var _loc_9:Number;
            var _loc_14:int;
            if (Math.abs(param5) > 360)
            {
                param5 = 360;
            }
            var _loc_10:* = Math.ceil(Math.abs(param5) / 45);
            var _loc_11:* = param5 / _loc_10;
            var _loc_12:* = (-param5 / _loc_10 / 180) * Math.PI;
            var _loc_13:* = (-param4 / 180) * Math.PI;
            _loc_8 = param2 - Math.cos(_loc_13) * param6;
            _loc_9 = param3 - Math.sin(_loc_13) * param7;
            if (_loc_10 > 0)
            {
                param1.moveTo(param2, param3);
                _loc_14 = 0;
                while (_loc_14 < _loc_10)
                {
                    
                    _loc_13 = _loc_13 + _loc_12;
                    param1.curveTo(_loc_8 + Math.cos(_loc_13 - _loc_12 / 2) * (param6 / Math.cos(_loc_12 / 2)), _loc_9 + Math.sin(_loc_13 - _loc_12 / 2) * (param7 / Math.cos(_loc_12 / 2)), _loc_8 + Math.cos(_loc_13) * param6, _loc_9 + Math.sin(_loc_13) * param7);
                    _loc_14++;
                }
            }
            return;
        }// end function
		
		
	}//end of class
}