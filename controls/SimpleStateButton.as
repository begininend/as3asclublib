package org.asclub.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	
	/**
	 * 此类为一个简单的按钮，有up,over,down,disabled四个状态。。selectedUp,selectedOver,selectedDown,selectedDisabled还在考虑中
	 * 可用于tabmenu、有选中状态的按钮
	 */
	public class SimpleStateButton extends CustomUIComponent
	{
		
		/**
		 * 状态的位图数据对象
		 */
		private var state_normal:BitmapData;
		private var state_hover:BitmapData;
		private var state_down:BitmapData;
		private var state_disabled:BitmapData;
		
		/**
		 * 状态参数
		 */
		private var has_hover:Boolean = false;
		private var has_down:Boolean = false;
		private var hovering:Boolean = false;
		private var is_selected:Boolean = false;
		private var _enabled:Boolean = false;
		
		private var instance:Bitmap;
		
		/**
		 * Boolean "selected" allows to toggle the button. 
		 * 当“selected”设置为true，只有“下”按钮的状态显示。
		 */
		public function set selected(value:Boolean):void {
			is_selected = value;
			if(is_selected) {
				updateState(state_down);
			} else {
				if(hovering) {
					updateState(state_hover);
				} else {
					updateState(state_normal);
				}
			}
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
			if (_enabled)
			{
				updateState(state_normal);
			}
			else
			{
				updateState(state_disabled);
			}
			
		}
		
		/**
		 * 获取按钮可用性
		 */
		public function get enabled():Boolean
		{
			return _enabled;
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
		
			var skin:DisplayObject = getDisplayObjectInstance(value);
			var skinBitmapData:BitmapData = new BitmapData(skin.width, skin.height);
			skinBitmapData.draw(skin);
			switch (style)
			{
				case "upSkin":
				{
					state_normal = skinBitmapData;
					break;
				}
				case "overSkin":
				{
					state_hover = skinBitmapData;
					break;
				}
				case "downSkin":
				{
					state_down = skinBitmapData;
					break;
				}
				case "disabledSkin":
				{
					state_disabled = skinBitmapData;
					break;
				}
			}
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
			addChild(instance);
			if(has_hover) {
				addEventListener(MouseEvent.ROLL_OVER, onStateRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onStateRollOut);
			}
			if(has_down) {
				addEventListener(MouseEvent.MOUSE_DOWN, onStateMouseDown);
				addEventListener(MouseEvent.MOUSE_UP,onStateMouseUp);
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Over
		 */
		
		private function onStateRollOver(evt:MouseEvent):void {
			hovering = true;
			if(!is_selected) {
				updateState(state_hover);
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Out
		 */
		
		private function onStateRollOut(evt:MouseEvent):void {
			hovering = false;
			if(!is_selected) {
				updateState(state_normal);
			}
		}
		
		/**
		 * Event Handler
		 * On Mouse Down
		 */
		
		private function onStateMouseDown(evt:MouseEvent):void {
			updateState(state_down);
		}
		
		/**
		 * Event Handler
		 * On Mouse Up
		 */
		
		private function onStateMouseUp(evt:MouseEvent):void {
			if(!selected) {
				if(hovering) {
					updateState(state_hover);
				} else {
					updateState(state_normal);
				}
			}
		}
		
		/**
		 * 更新按钮状态
		 * @param	bitmapData
		 */
		private function updateState(bitmapData:BitmapData):void
		{
			instance.bitmapData = bitmapData;
		}
	}//end of class
}