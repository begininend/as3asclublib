package
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

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

        public function get content() : DisplayObject
        {
            return _content;
        }

        private function autoCloseHandler(param1:TimerEvent) : void
        {
            close();
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

        public function get showCloseButton() : Boolean
        {
            return closeMC.visible;
        }

		//关闭按钮被点击
        private function closeMCClickHandler(param1:MouseEvent) : void
        {
            close();
        }

        public function get target() : DisplayObject
        {
            return _target;
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
                        _content.x = -_loc_5.x - _loc_5.width - arrowHeight - bgGap;
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
                _loc_5.right = _loc_5.right + bgGap;
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
            var targetRect:* = _target.getRect(_root);
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
            //closeMC.graphics.lineStyle(1, bgLineColor, bgAlpha);
            closeMC.graphics.beginFill(bgColor, 0);
            closeMC.graphics.drawCircle(0, 0, 4);
            closeMC.graphics.beginFill(4294967295 - bgColor, bgAlpha);
            closeMC.graphics.drawRect(-1, -6, 2, 12);
            closeMC.graphics.beginFill(4294967295 - bgColor, bgAlpha);
            closeMC.graphics.drawRect(-6, -1, 12, 2);
            var tipRect:Rectangle = _content.getRect(_content.parent);
            closeMC.x = tipRect.right + bgGap - 10;
            closeMC.y = tipRect.top - bgGap + 10;
            return;
        }

        public function set showCloseButton(param1:Boolean) : void
        {
            closeMC.visible = param1;
            return;
        }

        public function refresh() : void
        {
            adjustLayout();
            return;
        }

        public function set target(param1:DisplayObject) : void
        {
            if (_target == param1)
            {
                return;
            }
            _target = param1;
            adjustLayout();
            return;
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

        public function set location(param1:String) : void
        {
            if (_location == param1)
            {
                return;
            }
            _location = param1.toLowerCase();
            adjustLayout();
            return;
        }

        public function get closeOnClickOutside() : Boolean
        {
            return _closeOnClickOutside;
        }

        public function setStyle(param1:String, param2:*) : void
        {
            if (_style.hasOwnProperty(param1))
            {
                if (_style[param1] != param2)
                {
                    _style[param1] = param2;
                    adjustLayout();
                }
            }
            return;
        }

        public function get location() : String
        {
            return _location;
        }

        public function set closeOnClickOutside(param1:Boolean) : void
        {
            _closeOnClickOutside = param1;
            return;
        }

        public function set content(param1:DisplayObject) : void
        {
            if (_content)
            {
            }
            if (contains(_content))
            {
                removeChild(_content);
            }
            _content = param1;
            if (!contains(_content))
            {
                addChildAt(_content, 0);
            }
            adjustLayout();
            return;
        }

        public function getStyle(param1:String):*
        {
            return _style[param1];
        }

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
            return;
        }

        public static function getTipByContent(param1:DisplayObject) : SmartTip
        {
            var _loc_2:int;
            var _loc_3:uint;
            var _loc_4:Object;
            if (_root)
            {
                _loc_2 = -1;
                _loc_3 = _root.numChildren;
                while (_loc_2++ < _loc_3 - 1)
                {
                    
                    _loc_4 = _root.getChildAt(_loc_2);
                    if (_loc_4 as SmartTip && (_loc_4 as SmartTip).content == param1)
                    {
                        return _loc_4 as SmartTip;
                    }
                }
            }
            return null;
        }

        public static function set root(param1:DisplayObjectContainer) : void
        {
            if (_root == param1)
            {
                return;
            }
            if (_root)
            {
                throw new Error("You had set the root!");
            }
            _root = param1;
            return;
        }

        public static function getTipsByTarget(param1:DisplayObject) : Array
        {
            var _loc_3:uint;
            var _loc_4:uint;
            var _loc_5:Object;
            var _loc_2:Array;
            if (_root)
            {
                _loc_3 = 0;
                _loc_4 = _root.numChildren;
                while (_loc_3++ < _loc_4)
                {
                    
                    _loc_5 = _root.getChildAt(_loc_3);
                    if ((_loc_5 as SmartTip).target == param1)
                    {
                        _loc_2.push(_loc_5);
                    }
                }
            }
            return _loc_2;
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

        public static function closeTipByContent(param1:DisplayObject) : void
        {
            var _loc_2:* = getTipByContent(param1);
            if (_loc_2)
            {
                _loc_2.close();
            }
            return;
        }

        public static function closeTipsByTarget(param1:DisplayObject) : void
        {
            var _loc_2:* = getTipsByTarget(param1);
            var _loc_3:uint;
            var _loc_4:* = _loc_2.length;
            while (_loc_3++ < _loc_4)
            {
                
                (_loc_2[_loc_3] as SmartTip).close();
            }
            return;
        }

        public static function set tipDefaultStyle(param1:Object) : void
        {
            _tipDefaultStyle = param1;
        }

    }
}
