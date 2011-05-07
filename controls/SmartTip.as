package org.asclub.controls
{
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.ByteArray;
    import flash.utils.Timer;

    final public class SmartTip extends Sprite
    {
        private var closeMC:Sprite;
        private var _location:String;
        private var _closeOnClickOutside:Boolean;
        private var _target:DisplayObject;
        private var _style:Object;
        private var _content:DisplayObject;
        private var autoCloseTimer:Timer;
        private static var _root:DisplayObjectContainer;
		
		
        public static const LEFT:String = "left";
        public static const BOTTOM:String = "bottom";
        public static const TOP:String = "top";
        public static const RIGHT:String = "right";
		
        private static var _tipDefaultStyle:Object;
        private static var _defaultStyle:Object = {arrowHeight:10, arrowWidth:10, arrowIndentPercent:0, backgroundGap:4, backgroundCornerRadius:4, backgroundIndentPercent:0, backgroundColor:0xffffff, backgroundAlpha:1, backgroundLineColor:0xffffff};

        public function SmartTip(param1:Object)
        {
            if (param1 != _defaultStyle)
            {
                throw new Error("You can not instance SmartTip!");
            }
            _style = defaultStyle;
            closeMC = new Sprite();
			
			//画关闭按钮
            //closeMC.graphics.lineStyle(1, 0xff0000, 1);
            closeMC.graphics.beginFill(0xffffff, 0);
            closeMC.graphics.drawCircle(0, 0, 6);
            closeMC.graphics.beginFill(0x000000, 1);
            closeMC.graphics.drawRect(-1, -6, 2, 12);
            closeMC.graphics.beginFill(0x000000, 1);
            closeMC.graphics.drawRect( -6, -1, 12, 2);
			
            closeMC.buttonMode = true;
            closeMC.rotation = 45;
            closeMC.visible = false;
            closeMC.addEventListener(MouseEvent.CLICK, closeMCClickHandler);
            addChild(closeMC);
			
			
            addEventListener(MouseEvent.ROLL_OUT, mouseEventsHandler);
            addEventListener(MouseEvent.ROLL_OVER, mouseEventsHandler);
            _root.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
            return;
        }

		/**
		 * 设置tip停留一定时间后自动关闭：
		 * @param	delay   延迟时间，以毫秒为单位
		 */
        public function setAutoClose(delay:int):void
        {
            if (autoCloseTimer)
            {
                autoCloseTimer.removeEventListener(TimerEvent.TIMER, autoCloseHandler);
                autoCloseTimer.stop();
            }
            if (delay > 0)
            {
                autoCloseTimer = new Timer(delay, 1);
                autoCloseTimer.addEventListener(TimerEvent.TIMER, autoCloseHandler);
                autoCloseTimer.start();
            }
        }

        public function get showCloseButton() : Boolean
        {
            return closeMC.visible;
        }

		//关闭按钮被点击
        private function closeMCClickHandler(param1:MouseEvent) : void
        {
            close();
        }

        private function adjustLayout() : void
        {
            var bgGap:Number;
            var bgCornerRadius:Number;
            var bgColor:uint;
            var bgAlpha:Number;
            var bgIndentPercent:int;
			var bgLineColor:uint;
            var arrowHeight:Number;
            var arrowWidth:Number;
            var arrowIndentPercent:int;
			
			
            var drawTip:Function = function (param1:String) : void
            {
                var _loc_7:Point;
                var _loc_2:Number;
                var _loc_3:Number;
                if (_location != TOP)
                {
                }
                if (_location == BOTTOM)
                {
                    _loc_2 = (_content.width / 2 + bgGap - bgCornerRadius / 2 - arrowWidth / 2) * bgIndentPercent / 100;
                    _loc_3 = (_loc_2 * (arrowIndentPercent > 0 ? (1) : (-1)) + _content.width / 2 + bgGap - bgCornerRadius / 2 - arrowWidth / 2) * arrowIndentPercent / 100;
                }
                else
                {
                    _loc_2 = (_content.height / 2 + bgGap - bgCornerRadius / 2 - arrowWidth / 2) * bgIndentPercent / 100;
                    _loc_3 = (_loc_2 * (arrowIndentPercent > 0 ? (1) : (-1)) + _content.height / 2 + bgGap - bgCornerRadius / 2 - arrowWidth / 2) * arrowIndentPercent / 100;
                }
                var _loc_4:Array = [];
                var _loc_5:* = _content.getRect(_content);
                switch(param1)
                {
                    case TOP:
                    {
                        _content.x = -_loc_5.x - _loc_5.width / 2 - _loc_2;
                        _content.y = -_loc_5.y - _loc_5.height - arrowHeight - bgGap;
                        _loc_4.push(new Point((-arrowWidth) / 2 - _loc_3, -arrowHeight));
                        _loc_4.push(new Point(arrowWidth / 2 - _loc_3, -arrowHeight));
                        _loc_4.push(new Point(0, 0));
                        break;
                    }
                    case BOTTOM:
                    {
                        _content.x = -_loc_5.x - _loc_5.width / 2 - _loc_2;
                        _content.y = -_loc_5.y + arrowHeight + bgGap;
                        _loc_4.push(new Point((-arrowWidth) / 2 - _loc_3, arrowHeight));
                        _loc_4.push(new Point(arrowWidth / 2 - _loc_3, arrowHeight));
                        _loc_4.push(new Point(0, 0));
                        break;
                    }
                    case LEFT:
                    {
                        _content.x = -_loc_5.x - _loc_5.width - arrowHeight - bgGap - closeMC.getRect(closeMC).width;
                        _content.y = -_loc_5.y - _loc_5.height / 2 - _loc_2;
                        _loc_4.push(new Point(-arrowHeight, (-arrowWidth) / 2 - _loc_3));
                        _loc_4.push(new Point(-arrowHeight, arrowWidth / 2 - _loc_3));
                        _loc_4.push(new Point(0, 0));
                        break;
                    }
                    case RIGHT:
                    {
                        _content.x = -_loc_5.x + arrowHeight + bgGap;
                        _content.y = -_loc_5.y - _loc_5.height / 2 - _loc_2;
                        _loc_4.push(new Point(arrowHeight, (-arrowWidth) / 2 - _loc_3));
                        _loc_4.push(new Point(arrowHeight, arrowWidth / 2 - _loc_3));
                        _loc_4.push(new Point(0, 0));
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_5 = _content.getRect(_content.parent);
				_loc_5.left = _loc_5.left - bgGap;
                _loc_5.right = _loc_5.right + bgGap + closeMC.getRect(closeMC).width;
                _loc_5.top = _loc_5.top - bgGap;
                _loc_5.bottom = _loc_5.bottom + bgGap;
				
                graphics.clear();
				
				//画阴影
				graphics.beginFill(0x333333, 0.2);
                graphics.drawRoundRect(_loc_5.x + 2, _loc_5.y + 2, _loc_5.width, _loc_5.height, bgCornerRadius, bgCornerRadius);
				graphics.endFill();
				//画背景
                graphics.lineStyle(0, bgLineColor, bgAlpha, true, LineScaleMode.NONE);
                graphics.beginFill(bgColor, bgAlpha);
                graphics.drawRoundRect(_loc_5.x, _loc_5.y, _loc_5.width, _loc_5.height, bgCornerRadius, bgCornerRadius);
				//画箭头
                var _loc_6:int = -1;
                while (_loc_6++ < _loc_4.length - 1)
                {
                    
                    _loc_7 = _loc_4[_loc_6];
                    if (_loc_6 == 0)
                    {
                        graphics.moveTo(_loc_7.x, _loc_7.y);
                        continue;
                    }
                    graphics.lineTo(_loc_7.x, _loc_7.y);
                }
                graphics.endFill();
				//用跟背景一样的颜色将多余的一条线隐藏
				graphics.lineStyle(0, bgColor, bgAlpha);
				graphics.moveTo(_loc_4[0].x, _loc_4[0].y);
				graphics.lineTo(_loc_4[1].x, _loc_4[1].y);
				graphics.endFill();
                return;
            }
            ;
            if (!_content)
            {
                throw new Error("The SmartTip\'s content should not be null!");
            }
            bgGap = getStyle("backgroundGap");
            bgCornerRadius = getStyle("backgroundCornerRadius");
            bgColor = getStyle("backgroundColor");
            bgAlpha = getStyle("backgroundAlpha");
            bgIndentPercent = getStyle("backgroundIndentPercent");
            bgIndentPercent = Math.max( -100, Math.min(100, bgIndentPercent));
			bgLineColor = getStyle("backgroundLineColor");
            arrowHeight = getStyle("arrowHeight");
            arrowWidth = getStyle("arrowWidth");
            arrowIndentPercent = getStyle("arrowIndentPercent");
            arrowIndentPercent = Math.max(-100, Math.min(100, arrowIndentPercent));
            drawTip(_location.toLocaleLowerCase());
            var targetRect:Rectangle = _target.getRect(_root);
            switch(_location)
            {
                case TOP:
                {
                    x = targetRect.x + targetRect.width / 2;
                    y = targetRect.y;
                    break;
                }
                case BOTTOM:
                {
                    x = targetRect.x + targetRect.width / 2;
                    y = targetRect.y + targetRect.height;
                    break;
                }
                case RIGHT:
                {
                    x = targetRect.x + targetRect.width;
                    y = targetRect.y + targetRect.height / 2;
                    break;
                }
                case LEFT:
                {
                    x = targetRect.x;
                    y = targetRect.y + targetRect.height / 2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            var tipRect:Rectangle = _content.getRect(_content.parent);
            closeMC.x = tipRect.right + bgGap;
            closeMC.y = tipRect.top - bgGap + 10;
            return;
        }

		/**
		 * 设置是否显示关闭按钮
		 */
        public function set showCloseButton(value:Boolean) : void
        {
            closeMC.visible = value;
        }

		/**
		 * 刷新
		 */
        public function refresh() : void
        {
            adjustLayout();
            return;
        }

		/**
		 * 获取目标对象
		 */
        public function get target() : DisplayObject
        {
            return _target;
        }

		/**
		 * 设置目标对象
		 */
        public function set target(value:DisplayObject) : void
        {
            if (_target != value)
            {
				_target = value;
				adjustLayout();
            }
        }

		/**
		 * 鼠标点击在舞台上
		 * @param	param1
		 */
        private function mouseDownHandler(event:MouseEvent) : void
        {
            if (_closeOnClickOutside && ! this.hitTestPoint(event.stageX, event.stageY, true))
            {
                close();
            }
        }

		/**
		 * 设置tip在目标对象的方位
		 */
        public function set location(value:String) : void
        {
            if (_location != value)
            {
				_location = value.toLowerCase();
				adjustLayout();
            }
        }

		/**
		 * 获取tip在目标对象的方位
		 */
        public function get location() : String
        {
            return _location;
        }
		
		/**
		 * 获取点击舞台其它地方时自动关闭
		 */
        public function get closeOnClickOutside() : Boolean
        {
            return _closeOnClickOutside;
        }

		/**
		 * 设置点击舞台其它地方时自动关闭
		 */
        public function set closeOnClickOutside(value:Boolean) : void
        {
            _closeOnClickOutside = value;
            return;
        }

		/**
		 * 获取tip内容
		 */
        public function get content() : DisplayObject
        {
            return _content;
        }

		/**
		 * 设置tip内容
		 */
        public function set content(value:DisplayObject) : void
        {
            if (_content)
            {
            }
            if (contains(_content))
            {
                removeChild(_content);
            }
            _content = value;
            if (!contains(_content))
            {
                addChildAt(_content, 0);
            }
            adjustLayout();
            return;
        }

		/**
		 * 通过样式名称获取样式
		 * @param	styleName 样式名称
		 * @return
		 */
        public function getStyle(styleName:String):*
        {
            return _style[styleName];
        }

		/**
		 * 设置样式
		 * @param	param1
		 * @param	param2
		 */
        public function setStyle(styleName:String, value:*) : void
        {
            if (_style.hasOwnProperty(styleName))
            {
                if (_style[styleName] != value)
                {
                    _style[styleName] = value;
                    adjustLayout();
                }
            }
        }

		/**
		 * 关闭tip
		 */
        public function close() : void
        {
            _root.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false);
            if (autoCloseTimer)
            {
                autoCloseTimer.stop();
                autoCloseTimer.removeEventListener(TimerEvent.TIMER, autoCloseHandler);
            }
            if (contains(_content))
            {
                removeChild(_content);
            }
            if (_root.contains(this))
            {
                _root.removeChild(this);
            }
            dispatchEvent(new Event(Event.CLOSE));
        }

		/**
		 * 根据tip内容关闭tip
		 * @param	content   tip内容,必须为DisplayObject
		 * @return  tip
		 */
        public static function getTipByContent(content:DisplayObject) : SmartTip
        {
            var displayObject:DisplayObject;
            if (_root)
            {
                var num:int = _root.numChildren;
                while (num --)
                {
                    displayObject = _root.getChildAt(num);
                    if (displayObject as SmartTip && (displayObject as SmartTip).content == content)
                    {
                        return displayObject as SmartTip;
                    }
                }
            }
            return null;
        }

        public static function set root(value:DisplayObjectContainer) : void
        {
            if (_root == value)
            {
                return;
            }
            if (_root)
            {
                throw new Error("You had set the root!");
            }
            _root = value;
        }

		/**
		 * 目标对象的所有tip
		 * @param	target	目标对象
		 * @return
		 */
        public static function getTipsByTarget(target:DisplayObject) : Array
        {
            var displayObject:DisplayObject;
            var tips:Array = [];
            if (_root)
            {
                var num:int = _root.numChildren;
                while (num --)
                {
                    displayObject = _root.getChildAt(num);
                    if ((displayObject as SmartTip).target == target)
                    {
                        tips.push(displayObject);
                    }
                }
            }
            return tips;
        }

		/**
		 * 创建tip  
		 * @param	target		要提示的目标对象
		 * @param	content		提示的内容，必须是String或DisplayObject对象
		 * @param	location	提示在目标对象的方位。上下左右分别由SmartTip.TOP, SmartTip.BOTTON,SmartTip.LEFT,SmartTip.RIGHT定义。默认为下方提示。
		 * @param	style		提示的样式数据。不设置时使用默认样式。
		 * @return	该方法返回一个SmartTip示例。
		 */
        public static function createTip(target:DisplayObject, content:Object, location:String = null, style:Object = null) : SmartTip
        {
            if (!_root)
            {
                root = target.stage;
            }
            if (!_root)
            {
                throw new Error("The tip root object is NULL!");
            }
            if (content is String)
            {
				var textFormat:TextFormat = new TextFormat("宋体", 12);
				textFormat.leading = 5;
                var textField:TextField = new TextField();
				textField.defaultTextFormat = textFormat;
				textField.selectable = false;
				textField.mouseEnabled = false;
                textField.autoSize = TextFieldAutoSize.LEFT;
                textField.text = content as String;
                content = textField;
            }
            if (!(content is DisplayObject))
            {
                throw new Error("The conten should be Display object or String!");
            }
            var smartTip:SmartTip = getTipByContent(content as DisplayObject);
            if (!smartTip)
            {
                smartTip = new SmartTip(_defaultStyle);
                _root.addChild(smartTip);
            }
            for (var i:String in style)
            {
                
                if (smartTip._style.hasOwnProperty(i))
                {
                    smartTip._style[i] = style[i];
                }
            }
            smartTip._content = content as DisplayObject;
            smartTip.addChild(content as DisplayObject);
            smartTip._target = target;
            smartTip._location = location;
            smartTip.refresh();
            return smartTip;
        }

        public static function get defaultStyle():Object
        {
            var byteArray:ByteArray = new ByteArray();
            byteArray.writeObject(_defaultStyle);
            byteArray.position = 0;
            return byteArray.readObject();
        }

        public static function get tipDefaultStyle() : Object
        {
            return _tipDefaultStyle;
        }

        public static function set tipDefaultStyle(style:Object) : void
        {
            _tipDefaultStyle = style;
        }

		/**
		 * 根据tip内容关闭tip。如果内容为String时，不可通过该方法删除对应的tip
		 * @param	content
		 */
        public static function closeTipByContent(content:DisplayObject) : void
        {
            var smartTip:SmartTip = getTipByContent(content);
            if (smartTip)
            {
                smartTip.close();
            }
        }

		/**
		 * 关闭某个显示对象上的所有tip
		 * @param	target
		 */
        public static function closeTipsByTarget(target:DisplayObject) : void
        {
            var tips:Array = getTipsByTarget(target);
            var numTips:int = tips.length;
            while (numTips --)
            {
                (tips[numTips] as SmartTip).close();
            }
        }
		
		
		/**
		 * 自动关闭
		 * @param	param1
		 */
        private function autoCloseHandler(param1:TimerEvent) : void
        {
            close();
        }

		//鼠标在root上的事件
        private function mouseEventsHandler(event:MouseEvent) : void
        {
            switch(event.type)
            {
                case MouseEvent.ROLL_OUT:
                {
                    if (autoCloseTimer)
                    {
                        autoCloseTimer.reset();
                        autoCloseTimer.start();
                    }
                    break;
                }
                case MouseEvent.ROLL_OVER:
                {
                    if (autoCloseTimer)
                    {
                        autoCloseTimer.stop();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

    }//end class
}
