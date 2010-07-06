package org.asclub.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

    public class InstanceManager
    {
        private static var instances:Dictionary = new Dictionary();

        public function InstanceManager()
        {
        
        }

		/**
		 * 创建一个实例
		 * @param	value
		 */
        public static function createInstance(value:*)
        {
            if (value is String)
            {
                value = getClass(value);
            }
            if (value is Class)
            {
                return new value;
            }
            return value;
        }

		/**
		 * 创建一个单例
		 * @param	value
		 */
        public static function createSingletonInstance(value:*)
        {
            return createUniqueInstance(value, "singleton");
        }

        public static function createUniqueInstance(value:*, tag:*)
        {
            if (value is String)
            {
                value = getClass(value);
            }
            if (value is Class)
            {
                if (instances[value] == null)
                {
                    instances[value] = new Dictionary();
                }
                if (instances[value][tag] == null)
                {
                    instances[value][tag] = createInstance(value);
                }
                return instances[value][tag];
            }
            return value;
        }

		/**
		 * 获取类
		 * @param	value
		 * @return
		 */
        public static function getClass(value:String) : Class
        {
            return ApplicationDomain.currentDomain.getDefinition(value) as Class;
        }

    }//end of class
}
