package com.meitu.view
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AlignmentBox extends Sprite
	{
		//图片
		private var _bitmap:Bitmap;
		//图片容器
		private var _imageContainer:Sprite;
		//遮罩
		private var _maskShape:Shape;
		//图片角度
		private var _imageRotation:Number = 0;
		//角度改变
		private var _rotationChange:Boolean;
		//校直后的图片
		private var _bitmapData:BitmapData;
		//旋转后的可见区域
		private var _rect:Rectangle;
		
		//网格
		//单元格宽度
		private var _gridWidth:int = 30;
		//单元格高度
		private var _gridHeight:int = 30;
		//网格层
		private var _gridShape:Shape;
		
		public function AlignmentBox(bitmap:BitmapData = null,rotation:Number = NaN)
		{
			_bitmap = new Bitmap(bitmap,"auto",true);
			_imageContainer = new Sprite();
			_imageContainer.addChild(_bitmap);
			addChild(_imageContainer);
			//遮罩
			_maskShape = new Shape();
			_maskShape.graphics.beginFill(0xff0000, 0);
			_maskShape.graphics.drawRect(0, 0, 1, 1);
			_maskShape.graphics.endFill();
			addChild(_maskShape);
			this.mask = _maskShape;
			//网格层
			_gridShape = new Shape();
			addChild(_gridShape);
			
			_rect = new Rectangle();
			
			if (bitmap)
			{
				bitmapData = bitmap;
			}
		}
		
		/**
		 * 获取校直后的图片
		 */
		public function get bitmapData():BitmapData
		{
			if (_rotationChange || ! _bitmapData)
			{
				if (_bitmapData)
				{
					//_bitmapData.dispose();
					_bitmapData = null;
				}
				_bitmapData = new BitmapData(_maskShape.width, _maskShape.height, false);
				//因为图片已经旋转，所以不能使用copyPixels方法
				var ma:Matrix = new Matrix();
				ma.rotate(_imageRotation * Math.PI / 180);
				ma.translate(_maskShape.width * 0.5, _maskShape.height * 0.5);
				_bitmapData.draw(_imageContainer,ma);
			}
			return _bitmapData;
		}
		
		/**
		 * 设置图片
		 */
		public function set bitmapData(value:BitmapData):void
		{
			if (value)
			{
				_bitmap.bitmapData = value;
				_bitmap.x = - _bitmap.width * 0.5;
				_bitmap.y = - _bitmap.height * 0.5;
				_bitmap.smoothing = true;
				_imageContainer.x = _bitmap.width * 0.5;
				_imageContainer.y = _bitmap.height * 0.5;
				
				suitSize();
				createGridding();
			}
		}
		
		/**
		 * 获取校直角度
		 */
		public function get imageRotation():Number
		{
			return _imageRotation;
		}
		
		/**
		 * 设置校直角度
		 */
		public function set imageRotation(value:Number):void
		{
			if (_imageRotation != value)
			{
				_imageContainer.rotation = _imageRotation = value;
				suitSize();
				_rotationChange = true;
			}
		}
		
		/**
		 * 获取可见区域
		 */
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		/**
		 * 设置可见区域
		 */
		public function set rect(value:Rectangle):void
		{
			
		}
		
		//遮罩进行自适应缩放
		private function suitSize():void
		{
			var widthRate:Number = _imageContainer.width / _bitmap.width;
			var heightRate:Number = _imageContainer.height / _bitmap.height;
			var rate:Number = Math.max(widthRate, heightRate, 1);
			var adaptiveScale:Number = 1 / rate;
			_rect.width = _maskShape.width = _bitmap.width * adaptiveScale;
			_rect.height = _maskShape.height = _bitmap.height * adaptiveScale;
			_rect.x = _maskShape.x =  (_bitmap.width - _maskShape.width) * 0.5;
			_rect.y = _maskShape.y =  (_bitmap.height - _maskShape.height) * 0.5;
		}
		
		//生成网格
		private function createGridding():void
		{
			_gridShape.graphics.clear();
			_gridShape.graphics.lineStyle(1, 0xffffff,1,false,LineScaleMode.NONE);
			//横向单元格个数
			var numGridHorizontal:int = Math.ceil(_bitmap.bitmapData.width / _gridWidth);
			//纵向单元格个数
			var numGridVertical:int = Math.ceil(_bitmap.bitmapData.height / _gridHeight);
			//画横线(第一条不画)
			for (var i:int = 1; i < numGridVertical; i++)
			{
				_gridShape.graphics.moveTo(0, i * _gridHeight);
				_gridShape.graphics.lineTo(_bitmap.bitmapData.width,i * _gridHeight);
			}
			//画竖线(第一条不画)
			for (var j:int = 1; j < numGridHorizontal; j++)
			{
				_gridShape.graphics.moveTo(j * _gridWidth, 0);
				_gridShape.graphics.lineTo(j * _gridWidth, _bitmap.bitmapData.height);
			}
			
		}
		
	}//end class
}