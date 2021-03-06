﻿package org.asclub.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.asclub.core.IDestroyable;
	
	/**
	 * 此类为一个简单的按钮，有up,over,down,disabled四个状态。。selectedUp,selectedOver,selectedDown,selectedDisabled还在考虑中
	 * 可用于tabmenu、有选中状态的按钮
	 */
	public class SimpleStateButton extends CustomUIComponent implements IDestroyable
	{
		
		/**
		 * 状态的位图数据对象
		 */
		private var state_normal:BitmapData;
		private var state_hover:BitmapData;
		private var state_down:BitmapData;
		private var state_disabled:BitmapData;
		
		private var _states:Array;
		
		/**
		 * 状态参数
		 */
		private var has_hover:Boolean = false;
		private var has_down:Boolean = false;
		private var hovering:Boolean = false;
		private var is_selected:Boolean = false;
		private var _enabled:Boolean = false;
		
		//文本和组件边缘之间的距离，以及文本和图标之间的距离（以像素为单位）。 默认值为 5.
		private var _textPadding:int = 2;
		
		private var _adaptLabel:Boolean;
		
		private var _selectedBold:Boolean;
		private var _selectedColor:int;
		
		private var _label:String;
		private var _textFormat = new TextFormat("宋体", 12, 0x000000);
		private var _disabledTextFormat:TextFormat;
		
		private var instance:Bitmap;
		private var _textLabel:TextField;
		
		/**
		 * 宽度根据文本适应
		 */
		public function set adaptLabel(value:Boolean):void
		{
			_adaptLabel = value;
		}
		
		/**
		 * Boolean "selected" allows to toggle the button. 
		 * 当“selected”设置为true，只有“下”按钮的状态显示。
		 */
		public function set selected(value:Boolean):void 
		{
			is_selected = value;
			var textFormat:TextFormat = _textLabel.defaultTextFormat;
			if (is_selected) 
			{
				updateState(state_down);
				textFormat.bold = _selectedBold;
				textFormat.color = _selectedColor ? _selectedColor : textFormat.color;
			} 
			else 
			{
				if(hovering) {
					updateState(state_hover);
				} else {
					updateState(state_normal);
				}
				textFormat.bold = _selectedBold ? false : textFormat.bold;
				textFormat.color = _selectedColor ? textFormat.color : _selectedColor;
			}
			_textLabel.setTextFormat(textFormat);
		}
		
		/**
		 *  返回 按钮是否被选中
		 */
		public function get selected():Boolean {
			return is_selected;
		}
		
		/**
		 * 设置按钮可用性
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			this.mouseEnabled = _enabled;
			this.tabEnabled = _enabled;
			var textFormat:TextFormat;
			if (_enabled)
			{
				if (is_selected)
				{
					updateState(state_down);
				}
				else
				{
					updateState(state_normal);
				}
				textFormat = _textLabel.defaultTextFormat;
			}
			else
			{
				updateState(state_disabled);
				textFormat = _disabledTextFormat ? _disabledTextFormat : _textLabel.defaultTextFormat;
			}
			_textLabel.setTextFormat(textFormat);
		}
		
		/**
		 * 获取按钮可用性
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			_textLabel.text = _label;
			if (_adaptLabel)
			{
				stateBitmapDataAdapt();
			}
			resize();
		}
		
		/**
		 * 文本和组件边缘之间的距离，以及文本和图标之间的距离（以像素为单位）。 默认值为 5.
		 */
		public function set textPadding(value:int):void
		{
			_textPadding = value;
		}
		
		/**
		 * 构造函数
		 * @param	normal   
		 * @param	hover
		 * @param	down
		 */
		public function SimpleStateButton(normal:BitmapData, hover:BitmapData = null, down:BitmapData = null, disabled:BitmapData = null)
		{
			state_normal = normal.clone();
			
			//是否有“悬停”状态下的皮肤
			if(hover) {
				has_hover = true;
				state_hover = hover.clone();
			} else {
				state_hover = normal.clone();
			}
			
			//是否有“按下”状态下的皮肤
			if(down) {
				has_down = true;
				state_down = down.clone();
			} else {
				state_down = normal.clone();
			}
			
			//是否有“禁用”状态下的皮肤
			if (disabled)
			{
				state_disabled = disabled.clone();
			}
			else
			{
				state_disabled = normal.clone();
			}
			
			_states = [ { name:"state_normal", bitmapdata:state_normal },
						{ name:"state_hover", bitmapdata:state_hover },
						{ name:"state_down", bitmapdata:state_down },
						{ name:"state_disabled", bitmapdata:state_disabled } ];
			
			if(state_normal.rect.equals(state_hover.rect) && state_normal.rect.equals(state_down.rect)) {
				init();
			} else {
				/* 
				 * WIDTH AND HEIGHT OF THE BITMAP DATA OBJECT REPRESENTING EACH STATE (NORMAL, HOVER, DOWN) 
				 * MUST BE EQUAL. 
				 */
				throw(new Error("State bitmap data dimensions must be equal"));
			}
		}
		
		/**
		 * 设置样式
		 * @param	style   样式名称
		 * @param	value   样式值
		 */
		override public function setStyle(style:String, value:Object):void 
		{
			switch (style)
			{
				case "textFormat":
				{
					_textFormat = value;
					_textLabel.setTextFormat(_textFormat);
					_textLabel.defaultTextFormat = _textFormat;
					resize();
					break;
				}
				case "disabledTextFormat":
				{
					_disabledTextFormat = value as TextFormat;
					break;
				}
				case "selectedBold":
				{
					_selectedBold = Boolean(value);
					break;
				}
				case "selectedColor":
				{
					_selectedColor = int(value);
					selected = selected;
					break;
				}
				case "upSkin":
				{
					state_normal = getSkinBitmapData(value);
					updateSkin();
					break;
				}
				case "overSkin":
				{
					state_hover = getSkinBitmapData(value);
					updateSkin();
					break;
				}
				case "downSkin":
				{
					state_down = getSkinBitmapData(value);
					updateSkin();
					break;
				}
				case "disabledSkin":
				{
					state_disabled = getSkinBitmapData(value);
					updateSkin();
					break;
				}
			}
		}
		
		//销毁
		public function destroy():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onStateRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onStateRollOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onStateMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onStateMouseUp);
			instance.bitmapData.dispose();
		}
		//************************************private function******************************************************
		
		/**
		 * 主要初始化功能
		 * 初始化按钮实例
		 * 默认设置按钮
		 * 设立适当的事件监听器按钮状态
		 */
		
		private function init():void {
			buttonMode = true;
			useHandCursor = true;
			instance = new Bitmap();
			instance.bitmapData = state_normal;
			_textLabel = new TextField();
			_textLabel.autoSize = TextFieldAutoSize.CENTER;
			_textLabel.selectable = false;
			_textLabel.mouseEnabled = false;
			
			addChild(instance);
			addChild(_textLabel);
			if(has_hover) {
				addEventListener(MouseEvent.ROLL_OVER, onStateRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onStateRollOut);
			}
			if(has_down) {
				addEventListener(MouseEvent.MOUSE_DOWN, onStateMouseDown);
				addEventListener(MouseEvent.MOUSE_UP,onStateMouseUp);
			}
		}
		
		//更换皮肤后更新
		private function updateSkin():void
		{
			if (is_selected)
			{
				updateState(state_down);
			} 
			else 
			{
				if (hovering) 
				{
					updateState(state_hover);
				} 
				else
				{
					updateState(state_normal);
				}
			}
			resize();
		}
		
		private function resize():void
		{
			_textLabel.width = _textLabel.textWidth + 4;
			_textLabel.x = (instance.width - _textLabel.width) * 0.5;
			_textLabel.y = (instance.height - _textLabel.height) * 0.5;
		}
		
		/**
		 * 更新按钮状态
		 * @param	bitmapData
		 */
		private function updateState(bitmapData:BitmapData):void
		{
			instance.bitmapData = bitmapData;
		}
		
		//宽度根据文本适应
		private function stateBitmapDataAdapt():void
		{
			var num:int = _states.length;
			var w:int = _textLabel.textWidth + 2 * _textPadding + 4;
			var bitmapdata:BitmapData;
			var state:BitmapData;
			for (var i:int = 0; i < num; i ++)
			{
				state = _states[i]["bitmapdata"] as BitmapData;
				var matrix:Matrix = new Matrix();
				matrix.scale(w / state.width, 1);
				bitmapdata = new BitmapData(w, state.height);
				bitmapdata.draw(state, matrix);
				this[_states[i]["name"]] = bitmapdata;
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Over
		 */
		
		private function onStateRollOver(evt:MouseEvent):void {
			hovering = true;
			if (!is_selected && enabled) 
			{
				updateState(state_hover);
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Out
		 */
		
		private function onStateRollOut(evt:MouseEvent):void {
			hovering = false;
			if (!is_selected && enabled) 
			{
				updateState(state_normal);
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Down
		 */
		
		private function onStateMouseDown(evt:MouseEvent):void 
		{
			if (enabled)
			{
				updateState(state_down);
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Up
		 */
		
		private function onStateMouseUp(evt:MouseEvent):void {
			if(!selected && enabled) {
				if(hovering) {
					updateState(state_hover);
				} else {
					updateState(state_normal);
				}
			}
		}
	}//end of class
}