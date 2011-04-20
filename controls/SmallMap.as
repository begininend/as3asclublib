package com.meitu.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SmallMap extends Sprite
	{
		//小地图的最大宽度(默认200)
		private var _maxWidth:int = 200;
		//小地图的最大高度
		private var _maxHeight:int = 200;
		
		//拖动块可拖动区域
		private var _dragRect:Rectangle;
		
		//区域宽度比例
		private var _areaPercentWidth:Number;
		//区域高度比例
		private var _areaPercentHeight:Number;
		//区域x坐标比例
		private var _areaPercentX:Number;
		//区域y坐标比例
		private var _areaPercentY:Number;
		
		//背景图位图数据
		private var _bitmapData:BitmapData;
		//背景图
		private var _image:Bitmap;
		//背景图副本
		private var _imageClone:Bitmap;
		//灰色层
		private var _grayLayer:Shape;
		//遮罩物
		private var _maskObj:Shape;
		//拖动块
		private var _dragObj:Sprite;
		
		public var dragObjMoveCallback:Function;
		
		public function SmallMap(bitmapData:BitmapData = null)
		{
			_bitmapData = bitmapData ? bitmapData.clone() : new BitmapData(1, 1);
			_image = new Bitmap(_bitmapData, "auto", true);
			_imageClone = new Bitmap(_bitmapData, "auto", true);
			_dragRect = new Rectangle();
			grayLayerInit();
			maskObjInit();
			dragObjInit();
			this.addChild(_maskObj);
			this.addChild(_image);
			this.addChild(_grayLayer);
			this.addChild(_dragObj);
			this.addChild(_imageClone);
			bgResize();
		}
		
		//------------------------------------------------------------------------------------------------
		// GETTER AND SETTER
		//------------------------------------------------------------------------------------------------
		
		/**
		 * 小地图的最大宽度
		 */
		public function set maxWidth(value:int):void
		{
			_maxWidth = value;
		}
		
		/**
		 * 小地图的最大高度
		 */
		public function set maxHeight(value:int):void
		{
			_maxHeight = value;
		}
		
		/**
		 * 设置区域宽度比例
		 */
		public function set areaPercentWidth(value:Number):void
		{
			_areaPercentWidth = value;
			_dragObj.width = _image.width * _areaPercentWidth;
			_dragRect.width = _image.width - _dragObj.width;
			_maskObj.width = _dragObj.width - 0.5;
		}
		
		/**
		 * 设置区域高度比例
		 */
		public function set areaPercentHeight(value:Number):void
		{
			_areaPercentHeight = value;
			_dragObj.height = _image.height * _areaPercentHeight;
			_dragRect.height = _image.height - _dragObj.height + 0.1;
			_maskObj.height = _dragObj.height - 0.5;
		}
		
		/**
		 * 区域x坐标比例
		 */
		public function get areaPercentX():Number
		{
			return _dragObj.x / _image.width;
		}
		
		/**
		 * 区域x坐标比例
		 */
		public function set areaPercentX(value:Number):void
		{
			_areaPercentX = value;
			_dragObj.x = _image.width * _areaPercentX;
			_maskObj.x = _dragObj.x + 0.5;
		}
		
		/**
		 * 区域y坐标比例
		 */
		public function get areaPercentY():Number
		{
			return _dragObj.y / _image.height;
		}
		
		/**
		 * 区域y坐标比例
		 */
		public function set areaPercentY(value:Number):void
		{
			_areaPercentY = value;
			_dragObj.y = _image.height * _areaPercentY;
			_maskObj.y = _dragObj.y + 0.5;
		}
		
		//------------------------------------------------------------------------------------------------
		// PUBLIC MOTHOD
		//------------------------------------------------------------------------------------------------
		
		/**
		 * 更新背景
		 * @param	bitmapData
		 */
		public function updateBg(bitmapData:BitmapData):void
		{
			var currentWidth:int = _bitmapData.width;
			var currentHeight:int = _bitmapData.height;
			_bitmapData.dispose();
			_bitmapData = null;
			_bitmapData = bitmapData.clone();
			//_bitmapData = bitmapData;
			_image.bitmapData = _bitmapData;
			_image.smoothing = true;
			_imageClone.bitmapData = _bitmapData;
			_imageClone.smoothing = true;
			bgResize();
			if (currentWidth != _bitmapData.width || currentHeight != _bitmapData.height)
			{
				this.dispatchEvent(new Event(Event.RESIZE));
			}
		}
		
		//------------------------------------------------------------------------------------------------
		// PRIVATE MOTHOD
		//------------------------------------------------------------------------------------------------
		
		//背景图大小重置
		private function bgResize():void
		{
			var widthRate:Number = _bitmapData.width / _maxWidth;
			var heightRate:Number = _bitmapData.height / _maxHeight;
			var rate:Number = Math.max(widthRate, heightRate, 1);
			_imageClone.scaleY = _imageClone.scaleX = _image.scaleY = _image.scaleX = 1 / rate;
			_grayLayer.width = _image.width;
			_grayLayer.height = _image.height;
			
			areaPercentWidth = 1;
			areaPercentHeight = 1;
			areaPercentX = 0;
			areaPercentY = 0;
		}
		
		//灰色层初始化
		private function grayLayerInit():void
		{
			if (! _grayLayer)
			{
				_grayLayer = new Shape();
				_grayLayer.graphics.beginFill(0x000000, 0.5);
				_grayLayer.graphics.drawRect(0, 0, 1, 1);
				_grayLayer.graphics.endFill();
			}
		}
		
		//遮罩层初始化
		private function maskObjInit():void
		{
			if (! _maskObj)
			{
				_maskObj = new Shape();
				_maskObj.graphics.beginFill(0xff0000);
				_maskObj.graphics.drawRect(0, 0, 1, 1);
				_maskObj.graphics.endFill();
				_imageClone.mask = _maskObj;
			}
		}
		
		private function dragObjInit():void
		{
			if (! _dragObj)
			{
				_dragObj = new Sprite();
				_dragObj.graphics.beginFill(0xff0000, 0);
				_dragObj.graphics.lineStyle(0, 0xffff00,1,false,LineScaleMode.NONE);
				_dragObj.graphics.drawRect(0, 0, 1, 1);
				_dragObj.graphics.endFill();
				_dragObj.addEventListener(MouseEvent.MOUSE_DOWN, dragObjMouseDownHandler);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		// EVENT HANDLER
		//------------------------------------------------------------------------------------------------
		
		private function dragObjMouseDownHandler(event:MouseEvent):void
		{
			_dragObj.startDrag(false,_dragRect);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseMoveHandler);
		}
		

		private function stageMouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMouseMoveHandler);
			_dragObj.stopDrag();
		}

		private function stageMouseMoveHandler(event:MouseEvent):void
		{
			_maskObj.x = _dragObj.x + 0.5;
			_maskObj.y = _dragObj.y + 0.5;
			if (dragObjMoveCallback != null)
			{
				dragObjMoveCallback();
			}
		}
		
		
	}//end class
}