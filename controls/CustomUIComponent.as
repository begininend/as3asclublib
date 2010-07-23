package org.asclub.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.system.ApplicationDomain;

	
	public class CustomUIComponent extends Sprite
    {
		
		//抽象类(抽象类不允许实例化，只允许继承)
		public function CustomUIComponent()
		{
			
		}
		
		
		/**
		 * 获取显示对象实例
		 * @param	value
		 * @return
		 */
		//protected
		public function getDisplayObjectInstance(value:Object) : DisplayObject
        {
            var classDef:Object;
            var skin:* = value;
            if (skin is Class)
            {
				trace("skin is Class");
                return new skin as DisplayObject;
            }
            if (skin is DisplayObject)
            {
				trace("skin is DisplayObject");
                (skin as DisplayObject).x = 0;
                (skin as DisplayObject).y = 0;
                return skin as DisplayObject;
            }
            try
            {
                classDef = getDefinitionByName(skin.toString());
            }
            catch (e:Error)
            {
                try
                {
                    //classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
					classDef = ApplicationDomain.currentDomain.getDefinition(skin.toString()) as Object;
                }
                catch (e:Error)
                {
                }
                if (classDef == null)
                {
                    return null;
                }
			}
			trace("classDef is Object");
            return new classDef as DisplayObject;
		}
		
		/**
		 * 设置样式
		 * @param	style   样式名称
		 * @param	value   样式值
		 */
		public function setStyle(style:String, value:Object):void {};
	
	}//end of class
}