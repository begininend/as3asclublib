package org.asclub.controls
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
 
	 /**
	  * ...
	  * @author pz
	  */
	public class ScrollBar extends Sprite
	{
		public var displayRectWidth:Number;              //显示区域宽度
		public var displayRectHeight:Number;             //显示区域高度
		private var scrollThumbScrollSpace:Rectangle;    //滚动条可滚动的距离(横向/纵向)
		private var scrollThumbHeightLowerLimit:Number;  //滚动条最小高度

		public var content:DisplayObject;//内容实例
		private var contentHeight:Number; //内容实例的高
		
		private var scrollBar_mc : Sprite;
		private var up_btn : SimpleButton;
		private var down_btn : SimpleButton;
		private var scrollThumb_mc : Sprite;
		private var bg_sprite : Sprite;

		private var spacebetween:Number; //内容实例和滚条实例的间隔
		
		////上下滚动按钮按钮下时间
		private var putTime : Number;

		/**
		 * 构造函数
		 * @param	content               显示内容
		 * @param	scrollBarMc           滚动条(滑块实例名:ScrollThumb_mc,向下按钮实例名:down_btn,向上按钮实例名:up_btn,背景实例名:bg_mc)
		 * @param	displayRectWidth      显示区域宽度
		 * @param	displayRectHeight     显示区域高度
		 * @param	spacebetween          滚动条与显示内容的距离
		 */
		public function ScrollBar(content:DisplayObject,scrollBarMc:Sprite,displayRectWidth:Number,displayRectHeight:Number,spacebetween:Number=10)
		{
		    this.content = content;
			this.scrollBar_mc = scrollBarMc;
		    this.scrollThumb_mc = this.scrollBar_mc["ScrollThumb_mc"] as MovieClip;
		    this.down_btn = this.scrollBar_mc["down_btn"] as SimpleButton;
		    this.up_btn = this.scrollBar_mc["up_btn"] as SimpleButton;
		    this.bg_sprite = this.scrollBar_mc["bg_mc"] as Sprite;
		    this.displayRectHeight = displayRectHeight;
		    this.displayRectWidth = displayRectWidth;
		    this.spacebetween = spacebetween;
			this.contentHeight = content.height;
		    init();
		}
		  
		//初始化
		private function init():void
		{
			content.scrollRect = new Rectangle(0, 0, displayRectWidth, displayRectHeight);
			scrollThumbHeightLowerLimit = 20;
			
			scrollThumbScrollSpace = new Rectangle(bg_sprite.x, bg_sprite.y + up_btn.height, 0, displayRectHeight - scrollThumb_mc.height - up_btn.height - down_btn.height);
			update();
			
			//内容
			content.addEventListener(MouseEvent.MOUSE_WHEEL, contentMouseWheelHandler);
			
			//向上按钮
			up_btn.addEventListener(MouseEvent.MOUSE_DOWN, upBtnMouseHandler);
			up_btn.addEventListener(MouseEvent.MOUSE_UP, upBtnMouseHandler);
		    
			//滑块
			scrollThumb_mc.y = up_btn.y + up_btn.height;
			scrollThumb_mc.addEventListener(MouseEvent.ROLL_OVER, scrollThumbEventHandler);
			scrollThumb_mc.addEventListener(MouseEvent.ROLL_OUT, scrollThumbEventHandler);
			scrollThumb_mc.addEventListener(MouseEvent.MOUSE_DOWN, scrollThumbEventHandler);
			scrollThumb_mc.addEventListener(MouseEvent.MOUSE_UP, scrollThumbEventHandler);
			
			//背景
			bg_sprite.addEventListener(MouseEvent.MOUSE_DOWN, bgMouseDownHandler);
			
			//向下按钮
			down_btn.addEventListener(MouseEvent.MOUSE_DOWN, downBtnMouseHandler);
			down_btn.addEventListener(MouseEvent.MOUSE_UP, downBtnMouseHandler);
		}
		
		//在内容上滚轮
		private function contentMouseWheelHandler(evt:MouseEvent):void
		{
			scrollThumb_mc.y -= evt.delta;
			if (scrollThumb_mc.y < scrollThumbScrollSpace.top) scrollThumb_mc.y = scrollThumbScrollSpace.top;
			if (scrollThumb_mc.y > scrollThumbScrollSpace.bottom) scrollThumb_mc.y = scrollThumbScrollSpace.bottom;
			updateContent();
		}
		
		//向上按钮事件处理
		private function upBtnMouseHandler(evt:MouseEvent):void
		{
			switch(evt.type)
			{
				case MouseEvent.MOUSE_DOWN:
					scrollThumb_mc.y -= 1;
					if (scrollThumb_mc.y < scrollThumbScrollSpace.top) scrollThumb_mc.y = scrollThumbScrollSpace.top;
					//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
					putTime = getTimer();
					scrollBar_mc.addEventListener(Event.ENTER_FRAME, upBtnkeepDown);	
					updateContent();
				break;
				case MouseEvent.MOUSE_UP:
					scrollBar_mc.removeEventListener(Event.ENTER_FRAME, upBtnkeepDown);
				break;
			}
		}
		
		//向上按钮一直摁下
		private function upBtnkeepDown(evt:Event):void
		{
			if (getTimer() - putTime > 500) {
				scrollThumb_mc.y -= 1;
					if (scrollThumb_mc.y < scrollThumbScrollSpace.top) scrollThumb_mc.y = scrollThumbScrollSpace.top;
					updateContent();
			}
		}
		
		
		//滑块事件处理
		private function scrollThumbEventHandler(evt:MouseEvent):void
		{
			switch(evt.type)
			{
				case MouseEvent.ROLL_OVER:
					evt.currentTarget.gotoAndStop("over");
				break;
				case MouseEvent.ROLL_OUT:
					evt.currentTarget.gotoAndStop("normal");
				break;
				case MouseEvent.MOUSE_DOWN:
					evt.currentTarget.gotoAndStop("down");
					scrollThumb_mc.stage.addEventListener(MouseEvent.MOUSE_MOVE, eventHandler);
					scrollThumb_mc.stage.addEventListener(MouseEvent.MOUSE_UP, eventHandler);
					scrollThumb_mc.startDrag(false, scrollThumbScrollSpace);
				break;
				case MouseEvent.MOUSE_UP:
					evt.currentTarget.gotoAndStop("over");
				break;
			}
		}
		
		//滚动条背景被点击时
		private function bgMouseDownHandler(evt:MouseEvent):void
		{
			var nowPosition : Number;
			if ((scrollBar_mc.mouseY - scrollThumbScrollSpace.top) < (scrollThumb_mc.height * 0.5))
				nowPosition = scrollThumbScrollSpace.top; 
			else if ((down_btn.y - scrollBar_mc.mouseY) < scrollThumb_mc.height * 0.5)  
				nowPosition = scrollThumb_mc.y = scrollThumbScrollSpace.bottom;
			else 
				nowPosition = scrollBar_mc.mouseY - scrollThumb_mc.height * 0.5;
			scrollThumb_mc.y = nowPosition;
			updateContent();
		}
		
		//向下按钮事件处理
		private function downBtnMouseHandler(evt:MouseEvent):void
		{
			switch(evt.type)
			{
				case MouseEvent.MOUSE_DOWN:
					scrollThumb_mc.y += 1;
					if (scrollThumb_mc.y > scrollThumbScrollSpace.bottom) scrollThumb_mc.y = scrollThumbScrollSpace.bottom;
					//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
					putTime = getTimer();
					scrollBar_mc.addEventListener(Event.ENTER_FRAME, downBtnkeepDown);
					updateContent();
				break;
				case MouseEvent.MOUSE_UP:
					scrollBar_mc.removeEventListener(Event.ENTER_FRAME, downBtnkeepDown);
				break;
			}
		}
		
		//向下按钮一直摁下
		private function downBtnkeepDown(evt:Event):void
		{
			if (getTimer() - putTime > 500)
			{
				scrollThumb_mc.y += 1;
				if (scrollThumb_mc.y > scrollThumbScrollSpace.bottom) scrollThumb_mc.y = scrollThumbScrollSpace.bottom;
				updateContent();
			}
		}
			
		/**
		 * 根据内容的宽度和高度刷新滚动条属性。 如果 ScrollPane 的内容在运行时会更改，这就会很有用。
		 */
		public function update():void
		{
			contentHeight = content.height;
			scrollBar_mc.x = displayRectWidth + spacebetween;
			scrollBar_mc.y = content.y;
			bg_sprite.height = displayRectHeight;
			down_btn.y = (displayRectHeight - down_btn.height);
			scrollThumb_mc.height = (contentHeight > displayRectHeight ? displayRectHeight / contentHeight : 1) * (displayRectHeight - up_btn.height - down_btn.height);
			if (scrollThumb_mc.height < scrollThumbHeightLowerLimit ) scrollThumb_mc.height = scrollThumbHeightLowerLimit;
			scrollThumbScrollSpace.height = displayRectHeight - scrollThumb_mc.height - up_btn.height - down_btn.height;
			updateContent();
		}
	  
		private function eventHandler(e:MouseEvent):void
		{
	        if (e.type == MouseEvent.MOUSE_UP)
	        {
				scrollThumb_mc.stopDrag();
				scrollThumb_mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, eventHandler);
				scrollThumb_mc.stage.removeEventListener(MouseEvent.MOUSE_UP, eventHandler);
		    }
	        else if (e.type == MouseEvent.MOUSE_MOVE)
	        {
				updateContent();
				e.updateAfterEvent(); //刷新
			}
		}
		
		//更新内容
		private function updateContent():void
		{
		    var per:Number;
		    var rect:Rectangle;
			per= (scrollThumb_mc.y - content.y - up_btn.height)/ scrollThumbScrollSpace.height; //滚动条y与滚动条可移动距离比例
			rect = content.scrollRect;
			rect.y = per * (contentHeight - displayRectHeight); //内容可移动距离乖以比例得到内容的y
			content.scrollRect = rect;
		}
	  
	}//end of class
}