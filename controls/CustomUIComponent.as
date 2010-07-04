﻿package org.asclub.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.system.ApplicationDomain;

	
	public class CustomUIComponent extends Sprite
    {
		
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
	
	}//end of class
}