package org.asclub.controls
{
	import flash.display.Sprite;
	
	public class UIComponent extends Sprite
    {
		
		public function UIComponent()
		{
			
		}
		
		protected function getDisplayObjectInstance(param1:Object) : DisplayObject
        {
            var classDef:Object;
            var skin:* = param1;
            classDef;
            if (skin is Class)
            {
                return new skin as DisplayObject;
            }// end if
            if (skin is DisplayObject)
            {
                (skin as DisplayObject).x = 0;
                (skin as DisplayObject).y = 0;
                return skin as DisplayObject;
            }// end if
            try
            {
                classDef = getDefinitionByName(skin.toString());
            }// end try
            catch (e:Error)
            {
                try
                {
                    classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
                }// end try
                catch (e:Error)
                {
                }// end catch
                if (classDef == null)
                {
                    return null;
                }// end if
                return new classDef as DisplayObject;
        }// end function
		
	}//end of class
}