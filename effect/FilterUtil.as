//作者:cordy
//http://www.cordyblog.cn
package org.asclub.effect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BevelFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	
	public class FilterUtil {
		
		public function FilterUtil() {
		}
		
		/**
		 * 反相(底片效果)
		 * @param	source
		 */
		public static function invert(source:BitmapData):BitmapData
		{
			var sourceBitmap:Bitmap = new Bitmap(source);
			var tempMovieClip:Sprite = new Sprite();
			tempMovieClip.addChild(sourceBitmap);
			var mytmpmc:Sprite=new Sprite();
			mytmpmc.graphics.lineStyle(0,0x000000, 100);
			mytmpmc.graphics.moveTo(0,0);
			mytmpmc.graphics.beginFill(0x000000);
			mytmpmc.graphics.lineTo(sourceBitmap.width, 0);
			mytmpmc.graphics.lineTo(sourceBitmap.width, sourceBitmap.height);
			mytmpmc.graphics.lineTo(0, sourceBitmap.height);
			mytmpmc.graphics.lineTo(0,0);
			mytmpmc.graphics.endFill();
			mytmpmc.blendMode = "invert";
			tempMovieClip.addChild(mytmpmc);
			var returnBitmapData:BitmapData = new BitmapData(tempMovieClip.width,tempMovieClip.height,true, 0x00FFFFFF);
			returnBitmapData.draw(tempMovieClip);
			tempMovieClip.removeChild(mytmpmc);
			tempMovieClip.removeChild(sourceBitmap);
			mytmpmc = null;
			return returnBitmapData;
		}
		
		/**
		 * 黑白效果
		 * @param	source   位图数据
		 */
		public static function grayFilter(source:BitmapData):BitmapData
		{
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=[getGrayFilter()];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		public static function getGrayFilter():ColorMatrixFilter
		{
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			var myColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(myElements_array);
			return myColorMatrix_filter;
		}
		
		/**
		 * 浮雕效果
		 * @param	source   位图数据
		 * @param	angle    角度
		 */
		public static function embossFilter(source:BitmapData, angle:uint = 315):BitmapData
		{
			var radian:Number = angle*Math.PI/180;
			var pi4:Number = Math.PI/4;
			var clamp:Boolean = false;
			var clampColor:Number = 0xFF0000;
			var clampAlpha:Number = 256;
			var bias:Number = 128;
			var preserveAlpha:Boolean = false;
			var matrix:Array = [ Math.cos(radian+pi4)*256,Math.cos(radian+2*pi4)*256,Math.cos(radian+3*pi4)*256,
			                     Math.cos(radian)*256,0,Math.cos(radian+4*pi4)*256,
			                     Math.cos(radian-pi4)*256,Math.cos(radian-2*pi4)*256,Math.cos(radian-3*pi4)*256 ];
			var matrixCols:Number = 3;
			var matrixRows:Number = 3;
			var filter:ConvolutionFilter = new ConvolutionFilter(matrixCols, matrixRows, matrix, matrix.length, bias, preserveAlpha, clamp, clampColor, clampAlpha);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			myFilters.push(getGrayFilter());
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=myFilters;
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		/**
		 * 模糊效果
		 * @param	source   位图数据
		 * @param	blurX    x径向模糊
		 * @param	blurY	 y径向模糊
		 */
		public static function blurFilter(source:BitmapData, blurX:Number = 5, blurY:Number = 5):BitmapData
		{
			var filter:BlurFilter=new BlurFilter(blurX, blurY, BitmapFilterQuality.HIGH);
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=[filter];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		/**
		 * 锐化效果
		 * @param	source   位图数据
		 * @param	sharp    锐化强度
		 */
		public static function sharpenFilter(source:BitmapData, sharp:Number = 0.7):BitmapData
		{
			var matrix: Array = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
			matrix[1] = matrix[3] = matrix[5] = matrix[7] = -sharp;
			matrix[4] = 1 + sharp * 4;
			var filter: ConvolutionFilter = new ConvolutionFilter( 3, 3, matrix );
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=[filter];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		/**
		 * 凸起效果
		 * @param	source               位图数据
		 * @param	distance             凸起强度
		 * @param	angleInDegrees       凸起角度
		 */
		public static function raiseFilter(source:BitmapData, distance:Number = 5, angleInDegrees:Number = 45):BitmapData
		{
			var highlightColor:Number = 0xCCCCCC;
			var highlightAlpha:Number = 0.8;
			var shadowColor:Number    = 0x808080;
			var shadowAlpha:Number    = 0.8;
			var blurX:Number          = 5;
			var blurY:Number          = 5;
			var strength:Number       = 5;
			var quality:Number        = BitmapFilterQuality.HIGH;
			var type:String           = BitmapFilterType.INNER;
			var knockout:Boolean      = false;
			var filter: BevelFilter =new BevelFilter(distance,
			                                   angleInDegrees,
			                                   highlightColor,
			                                   highlightAlpha,
			                                   shadowColor,
			                                   shadowAlpha,
			                                   blurX,
			                                   blurY,
			                                   strength,
			                                   quality,
			                                   type,
			                                   knockout);
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=[filter];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		/**
		 * 陈旧效果
		 * @param	source   位图数据
		 */
		public static function oldPictureFilter(source:BitmapData):BitmapData
		{
			var filter:ColorMatrixFilter = getGrayFilter();
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=[filter];
			source=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			source.draw(sourceBitmap);
			var matrix:Array = new Array();
			matrix = matrix.concat([0.94, 0, 0, 0, 0]);
			matrix = matrix.concat([0, 0.9, 0, 0, 0]);
			matrix = matrix.concat([0, 0, 0.8, 0, 0]);
			matrix = matrix.concat([0, 0, 0, 0.8, 0]);
			filter= new ColorMatrixFilter(matrix);
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		/**
		 * 噪声效果
		 * @param	source   位图数据
		 * @param	degree   噪声强度
		 */
		public static function noiseFilter(source:BitmapData, degree:Number = 128):BitmapData
		{
			//degree 0-255
			var noise:int,color:uint,r:uint,g:uint,b:uint;
			var returnBitmapData:BitmapData = source.clone();
			for (var i:int = 0; i< source.height; i++) {
				for (var j:int = 0; j<source.width; j++) {
					noise=int(Math.random()*degree*2)-degree;
					color=source.getPixel(j, i);
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					r=r+noise<0?0:r+noise>255?255:r+noise;
					g=g+noise<0?0:g+noise>255?255:g+noise;
					b=b+noise<0?0:b+noise>255?255:b+noise;
					returnBitmapData.setPixel(j,i,r*65536+g*256+b);
				}
			}
			return returnBitmapData;
		}
		
		/**
		 * 素描效果
		 * @param	source          位图数据
		 * @param	threshold       颜色阔值
		 */
		public static function sketchFilter(source:BitmapData, threshold:Number = 30):BitmapData
		{
			//threshold 0-100
			var filter:ColorMatrixFilter = getGrayFilter();
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=[filter];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			var color:uint,gray1:int,gray2:int;
			for (var i:int = 0; i<source.height-1; i++) {
				for (var j:int = 0; j<source.width-1; j++) {
					color=source.getPixel(j, i);
					gray1 = (color & 0xff0000) >> 16;
					color=source.getPixel(j+1, i+1);
					gray2 = (color & 0xff0000) >> 16;
					if (Math.abs(gray1-gray2)>=threshold) {
						returnBitmapData.setPixel(j,i,0x222222);
					} else {
						returnBitmapData.setPixel(j,i,0xFFFFFF);
					}
				}
			}
			for (i=0; i<source.height; i++) {
				returnBitmapData.setPixel(source.width-1,i,0xFFFFFF);
			}
			for (i=0; i<source.width; i++) {
				returnBitmapData.setPixel(i,source.height-1,0xFFFFFF);
			}
			return returnBitmapData;
		}
		
		/**
		 * 水彩效果
		 * @param	source   位图数据
		 * @param	scaleX   x径向晕彩
		 * @param	scaleY   y径向晕彩
		 */
		public static function waterColorFilter(source:BitmapData, scaleX:Number = 5, scaleY:Number = 5):BitmapData
		{
			var componentX:Number = 1;
			var componentY:Number = 1;
			var color:Number = 0x000000;
			var alpha:Number = 0x000000;
			var tempBitmap:BitmapData = new BitmapData(source.width,source.height,true,0x00FFFFFF);
			tempBitmap.perlinNoise(3, 3, 1, 1, false, true, 1, false);
			var sourceBitmap:Bitmap = new Bitmap(source);
			var filter:DisplacementMapFilter = new DisplacementMapFilter(tempBitmap, new Point(0, 0),componentX, componentY, scaleX, scaleY, DisplacementMapFilterMode.COLOR, color, alpha);
			sourceBitmap.filters=[filter];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		/**
		 * 扩散效果
		 * @param	source   位图数据
		 * @param	scaleX   x径向扩散
		 * @param	scaleY   y径向扩散
		 */
		public static function diffuseFilter(source:BitmapData, scaleX:Number = 5, scaleY:Number = 5):BitmapData
		{
			var componentX:Number = 1;
			var componentY:Number = 1;
			var color:Number = 0x000000;
			var alpha:Number = 0x000000;
			var tempBitmap:BitmapData = new BitmapData(source.width,source.height,true,0x00FFFFFF);
			tempBitmap.noise(888888);
			var sourceBitmap:Bitmap = new Bitmap(source);
			var filter:DisplacementMapFilter = new DisplacementMapFilter(tempBitmap, new Point(0, 0),componentX, componentY, scaleX, scaleY, DisplacementMapFilterMode.COLOR, color, alpha);
			sourceBitmap.filters=[filter];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		/**
		 * 球面效果
		 * @param	source   位图数据
		 */
		public static function spherizeFilter(source:BitmapData):BitmapData
		{
			var midx:int = int(source.width/2);
			var midy:int = int(source.height/2);
			var maxmidxy:int = midx>midy?midx:midy;
			var radian:Number,radius:Number,offsetX:Number,offsetY:Number,color:uint,r:uint,g:uint,b:uint;
			var returnBitmapData:BitmapData = source.clone();
			for (var i:int = 0; i<source.height-1; i++) {
				for (var j:int = 0; j<source.width-1; j++) {

					offsetX=j-midx;
					offsetY=i-midy;
					radian=Math.atan2(offsetY,offsetX);
					radius = (offsetX * offsetX + offsetY * offsetY ) / maxmidxy;
					var x:int = int(radius*Math.cos(radian))+midx;
					var y:int = int(radius*Math.sin(radian))+midy;
					if (x<0) {
						x=0;
					}
					if (x>=source.width) {
						x=source.width-1;
					}
					if (y<0) {
						y=0;
					}
					if (y>=source.height) {
						y=source.height-1;
					}
					color=source.getPixel(x, y);
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					returnBitmapData.setPixel(j,i,r*65536+g*256+b);

				}
			}
			return returnBitmapData;
		}
		
		/**
		 * 挤压效果
		 * @param	source   位图数据
		 * @param	degree   挤压角度
		 */
		public static function pinchFilter(source:BitmapData, degree:Number = 16):BitmapData
		{
			var midx:int = source.width * 0.5 >> 0;
			var midy:int = source.height * 0.5 >> 0;
			var radian:Number,radius:Number,offsetX:int,offsetY:int,color:uint,r:uint,g:uint,b:uint;
			var returnBitmapData:BitmapData = source.clone();
			for (var i:int = 0; i < source.height - 1; i++) {
				for (var j:int = 0; j<source.width - 1; j++) {
					offsetX = j - midx;
					offsetY = i - midy;
					radian = Math.atan2(offsetY,offsetX);
					radius = Math.sqrt(offsetX*offsetX+offsetY*offsetY);
					radius = Math.sqrt(radius)*degree;
					var x:int = radius * Math.cos(radian) >> 0 + midx;
					var y:int = radius * Math.sin(radian) >> 0 + midy;
					if (x<0) {
						x=0;
					}
					if (x>=source.width) {
						x=source.width-1;
					}
					if (y<0) {
						y=0;
					}
					if (y>=source.height) {
						y=source.height-1;
					}
					color=source.getPixel(x, y);
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					returnBitmapData.setPixel(j,i,r*65536+g*256+b);
				}
			}
			return returnBitmapData;
		}
		
		/**
		 * 光照效果
		 * @param	source   位图数据
		 * @param	power    光照强度
		 * @param	posx
		 * @param	posy
		 * @param	r
		 */
		public static function lightingFilter(source:BitmapData, power:Number = 128, posx:Number = 0.5, posy:Number = 0.5, radii:Number = 0):BitmapData
		{
			//power 0-255
			var midx:int = source.width * posx >> 0;
			var midy:int = source.height * posy >> 0;
			if (radii==0) {
				radii = Math.sqrt(midx*midx+midy*midy);
			}
			if (radii == 0) {
				radii=Math.sqrt(source.width*source.width/4+source.height*source.height/4);
			}
			var radius:int = radii >> 0;
			var sr:Number = radii * radii;
			var returnBitmapData:BitmapData = source.clone();
			var sd:Number,color:uint,r:uint,g:uint,b:uint,distance:Number,brightness:int;
			for (var y:int = 0; y < source.height; y++) {
				for (var x:int = 0; x < source.width; x++) {
					sd = (x-midx)*(x-midx)+(y-midy)*(y-midy);
					if (sd<sr) {
						color=source.getPixel(x, y);
						r = (color & 0xff0000) >> 16;
						g = (color & 0x00ff00) >> 8;
						b = color & 0x0000ff;
						distance=Math.sqrt(sd);
						brightness = int(power*(radius-distance)/radius);
						r=r+brightness>255?255:r+brightness;
						g=g+brightness>255?255:g+brightness;
						b=b+brightness>255?255:b+brightness;
						returnBitmapData.setPixel(x,y,r*65536+g*256+b);
					}
				}
			}
			return returnBitmapData;
		}
		
		/**
		 * 晶格效果(马赛克效果)
		 * @param	source   位图数据
		 * @param	block    晶格大小
		 */
		public static function mosaicFilter(source:BitmapData, block:Number = 6):BitmapData
		{
			//block 1-32
			var returnBitmapData:BitmapData = source.clone();
			var sumr:int,sumg:int,sumb:int,product:int,color:uint,r:uint,g:uint,b:uint,br:int,bg:int,bb:int;
			for (var y:int = 0; y<source.height; y+=block) {
				for (var x:int = 0; x < source.width; x+=block) {
					sumr=0;
					sumg=0;
					sumb=0;
					product=0;
					for (var j:int = 0; j<block; j++) {
						for (var i:int = 0; i<block; i++) {
							if (x+i<source.width&&y+j<source.height) {
								color=source.getPixel(x+i, y+j);
								r = (color & 0xff0000) >> 16;
								g = (color & 0x00ff00) >> 8;
								b = color & 0x0000ff;
								sumr+=r;
								sumg+=g;
								sumb+=b;
								product++;
							}
						}
					}
					br=int(sumr/product);
					bg=int(sumg/product);
					bb=int(sumb/product);
					for (j=0; j<block; j++) {
						for (i=0; i<block; i++) {
							if (x+i<source.width&&y+j<source.height) {
								returnBitmapData.setPixel(x+i, y+j,br * 65536 + bg * 256 + bb);
							}
						}
					}
				}
			}
			return returnBitmapData;
		}
		
		/**
		 * 晶格效果(马赛克效果2)
		 * @param	bitmapData   位图数据
		 * @param	block    晶格大小
		 */
		public static function mosaic(bitmapData:BitmapData, block:uint = 5) : void
        {
            var matrix1:Matrix;
            var matrix2:Matrix;
            var sample:BitmapData;
            var shape:Shape;
            if (block < 1)
            {
                block = 5;
            }
            matrix1 = new Matrix();
            matrix1.scale(1 / block, 1 / block);
            matrix2 = new Matrix();
            matrix2.scale(block, block);
            sample = new BitmapData(bitmapData.width / block, bitmapData.height / block, false);
            sample.draw(bitmapData, matrix1);
            shape = new Shape();
            shape.graphics.beginBitmapFill(sample, matrix2);
            shape.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
            bitmapData.draw(shape);
        }// end function
		
		/**
		 * 油画效果
		 * @param	source          位图数据
		 * @param	brushSize       笔刷大小  1-8
		 * @param	coarseness      粗糙度    1-255
		 */
		public static function oilPaintingFilter(source:BitmapData, brushSize:Number = 1, coarseness:Number = 32):BitmapData
		{
			//brushSize 1-8
			//coarseness 1-255
			var color:uint,gray:int,r:uint,g:uint,b:uint,a:uint;
			var arraylen:Number = coarseness+1;
			var CountIntensity:Array=new Array();
			var RedAverage:Array=new Array();
			var GreenAverage:Array=new Array();
			var BlueAverage:Array=new Array();
			var AlphaAverage:Array=new Array();

			var filter:ColorMatrixFilter = getGrayFilter();
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=[filter];
			var tempData:BitmapData;
			tempData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			tempData.draw(sourceBitmap);
			var returnBitmapData:BitmapData = tempData.clone();
			var top:Number,bottom:Number,left:Number,right:Number;

			for (var y:int = 0; y<source.height; y++) {
				top = y - brushSize;
				bottom = y+brushSize+1;
				if (top<0) {
					top=0;
				}
				if (bottom>=source.height) {
					bottom=source.height-1;
				}
				for (var x:int = 0; x<source.width; x++) {
					left=x-brushSize;
					right=x+brushSize+1;
					if (left<0) {
						left=0;
					}
					if (right>=source.width) {
						right=source.width;
					}
					for (var i:int = 0; i<arraylen; i++) {
						CountIntensity[i]=0;
						RedAverage[i]=0;
						GreenAverage[i]=0;
						BlueAverage[i]=0;
						AlphaAverage[i]=0;
					}
					for (var j:int = top; j<bottom; j++) {
						for (i=left; i<right; i++) {
							color=tempData.getPixel(i, j);
							gray = (color & 0xff0000) >> 16;
							color=source.getPixel32(i, j);
							a = color >> 24 & 0xFF;
							r = color >> 16 & 0xFF;
							g = color >> 8 & 0xFF;
							b = color & 0xFF;
							var intensity:int = int(coarseness*gray/255);
							CountIntensity[intensity]++;
							RedAverage[intensity]+=r;
							GreenAverage[intensity]+=g;
							BlueAverage[intensity]+=b;
							AlphaAverage[intensity]+=a;
						}
					}
					var closenIntensity:int = 0;
					var maxInstance:int = CountIntensity[0];
					for (i=1; i<arraylen; i++) {
						if (CountIntensity[i]>maxInstance) {
							closenIntensity=i;
							maxInstance=CountIntensity[i];
						}
					}
					a=int(AlphaAverage[closenIntensity]/maxInstance);
					r=int(RedAverage[closenIntensity]/maxInstance);
					g=int(GreenAverage[closenIntensity]/maxInstance);
					b=int(BlueAverage[closenIntensity]/maxInstance);
					returnBitmapData.setPixel32(x,y,a*16777216+r*65536+g*256+b);
				}
			}
			return returnBitmapData;
		}
		
		/**
		 * 颜色阈值
		 * @param	source       位图数据
		 * @param	threshold    阈值范围
		 */
		public static function thresholdFilter(source:BitmapData, threshold:uint = 128):BitmapData
		{
			var returnBitmapData:BitmapData = new BitmapData(source.width, source.height,true,0xFF000000);
			var pt:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(0, 0,source.width,source.height);
			threshold=threshold<0?0:threshold>255?255:threshold;
			var thre:uint =  255*0xFFFFFF+threshold*0xFFFF+threshold*0xFF+threshold;
			var color:uint = 0x00FFFFFF;
			var maskColor:uint = 0xFFFFFFFF;
			returnBitmapData.threshold(source, rect, pt, ">", thre, color, maskColor, false);
			return returnBitmapData;
		}
		
		/**
		 * 色彩饱和度
		 * @param	source     位图数据
		 * @param	rp         红色饱和度  from -100 to 100
		 * @param	gp         绿色饱和度  from -100 to 100
		 * @param	bp         蓝色饱和度  from -100 to 100
		 */
		public static function saturation(source:BitmapData, rp:Number = 1, gp:Number = 1, bp:Number = 1):BitmapData
		{
			var matrix:Array = [];
			matrix = matrix.concat([rp, 0, 0, 0, 0]);// red
			matrix = matrix.concat([0, gp, 0, 0, 0]);// green
			matrix = matrix.concat([0, 0, bp, 0, 0]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			var filter:BitmapFilter = new ColorMatrixFilter(matrix);
			var sourceBitmap:Bitmap = new Bitmap(source);
			sourceBitmap.filters=[filter];
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		
		/**
		 * 色彩调整
		 * @param	source     位图数据
		 * @param	ro         红色偏移量  from -255 to 255
		 * @param	go         绿色偏移量  from -255 to 255
		 * @param	bo         蓝色偏移量  from -255 to 255
		 */
		public static function colorTrans(source:BitmapData, ro:Number = 0, go:Number = 0, bo:Number = 0):BitmapData
		{
			var resultColorTransform:ColorTransform = new ColorTransform();
			resultColorTransform.redOffset = ro;
			resultColorTransform.greenOffset = go;
			resultColorTransform.blueOffset = bo;
			var sourceBitmap:Bitmap = new Bitmap(source);
			var sp:Sprite = new Sprite();
			sp.addChild(sourceBitmap);
			var sp2:Sprite = new Sprite();
			sp2.addChild(sp);
			sp.transform.colorTransform = resultColorTransform;
			var returnBitmapData:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sp2);
			sp2=null;
			//sp1=null;
			sourceBitmap=null;
			return returnBitmapData;
		}
		
		//改变图像尺寸
		public static function resize(originalBitmap:BitmapData,w:Number,h:Number):BitmapData {
			var returnBitmap:BitmapData=new BitmapData(w,h,false);
			returnBitmap.draw(originalBitmap,new Matrix(w / originalBitmap.width,0,0,h / originalBitmap.height,0,0));
			return returnBitmap;
		}
		
		//扩展边缘
		public static function expand(originalBitmap:BitmapData,b:Number):BitmapData {
			var returnBitmap:BitmapData=new BitmapData(originalBitmap.width+b*2,originalBitmap.height+b*2,false);
			returnBitmap.copyPixels(originalBitmap,new Rectangle(0,0,originalBitmap.width,originalBitmap.height),new Point(b,b));
			return returnBitmap;
		}
		
		//缩小边缘
		public static function inset(originalBitmap:BitmapData,b:Number):BitmapData {
			var returnBitmap:BitmapData=new BitmapData(originalBitmap.width-b*2,originalBitmap.height-b*2,false);
			returnBitmap.copyPixels(originalBitmap,new Rectangle(b,b,originalBitmap.width-b,originalBitmap.height-b),new Point(0,0));
			return returnBitmap;
		}
		
		/**
		*定义形参：
		*pBitmpData: 需要制作倒影的BitmapData
		*pMaxAlpha: 倒影的最大透明度
		*pRate: 倒影的可见高度与实际图片的高度比
		*pBlurValue: 倒影的虚化程度
		*/

		public static function getReflectionBitmapData(pBitmapData:BitmapData,pMaxAlpha:Number=1,pRate:Number = .67,pBlurValue:Number=-1):BitmapData{

		//建立一个空的BitmapData实例，与原图片大小相等。
		var bitmapdata:BitmapData = new BitmapData(pBitmapData.width,pBitmapData.height,true);
		//计算倒影需要显示的高度
		var drawHeight:Number = pRate*bitmapdata.height;
		//做一个循环，开始描绘倒影
		for(var j:int=0;j<=bitmapdata.height;j++){
		//计算每一个纵向位置的透明度
		var alpha:int =Math.max(0,int((1-j/drawHeight)*pMaxAlpha*256));
		//将这个透明度换算成16进制的字符
		var str:String = alpha.toString(16);
		str = "0x"+str+"000000";
		//用这个透明度定义一个位图，用来提取透明度信息
		var alphaBitmapData:BitmapData = new BitmapData(bitmapdata.width,drawHeight,true,Number(str));
		//描绘倒影，一方面从原图片中反向提取颜色值，一方面从上一行定义的位图中提取透明度信息，每次描绘一个像素的高度
		bitmapdata.copyPixels(pBitmapData,new Rectangle(0,Math.floor(pBitmapData.height-j-1),bitmapdata.width,1),
		new Point(0,j),alphaBitmapData);
		}
		if(pBlurValue!=-1){
		for(var c:int=0;c<=drawHeight;c++){
		//给倒影添加虚化效果，最小为2，最大为2+pBlurValue，效果为横纵双向模糊

		var blur:int = 2+int(c*pBlurValue/drawHeight);
		bitmapdata.applyFilter(bitmapdata,new Rectangle(0,c,bitmapdata.width,1),
		new Point(0,c),new BlurFilter(blur,blur));
		}
		}
		//返回做好的倒影位图
		return bitmapdata;
		}
	}//end of class
}