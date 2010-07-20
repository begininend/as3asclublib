/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.asclub.data
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;


	public class ObjectUtil
	{
		/**
		 * Deep clone object using thiswind@gmail.com 's solution
		 * 复杂一个对象
		 */
		public static function baseClone(source:*):*{
			var typeName:String = getQualifiedClassName(source);
			var packageName:String = typeName.split("::")[1];
			var type:Class = Class(getDefinitionByName(typeName));

			if (packageName != null)
			{
				registerClassAlias(packageName, type);
			}
			
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return copier.readObject();
		}
		
		/*
		Creates an Array comprised of all the keys in an Object.
		获取一个Object的所有key值的一个数组
		@param obj: Object in which to find keys.
		@return Array containing all the string key names.
		*/
		public static function getKeys(obj:Object):Array
		{
			var keys:Array = new Array();
			
			for (var i:String in obj)
				keys.push(i);
			
			return keys;
		}
		
		/**
		 * 合并两个Object
		 * @param	obj1
		 * @param	obj2
		 * @return  Object     返回合并后的新的Object
		 */
		public static function mergeObjects(obj1:Object, obj2:Object):Object
		{
			var obj:Object = baseClone(obj1);
			for (var k:String in obj2)
			{
				if (obj.hasOwnProperty(k))
				{
					if (typeof obj2[k] == 'object')
					{
						mergeObjects(obj[k], obj2[k]);
					}
				}
				else
				{
					obj[k] = obj2[k];
				}
			}
			return obj;
		}

		
		/**
		 * Checks wherever passed-in value is <code>String</code>.
		 * 是否是字符型
		 */
		public static function isString(value:*):Boolean {
			return ( typeof(value) == "string" || value is String );
		}
		
		/**
		 * Checks wherever passed-in value is <code>Number</code>.
		 * 是否是数值型
		 */
		public static function isNumber(value:*):Boolean {
			return ( typeof(value) == "number" || value is Number );
		}

		/**
		 * Checks wherever passed-in value is <code>Boolean</code>.
		 * 是否是布尔型
		 */
		public static function isBoolean(value:*):Boolean {
			return ( typeof(value) == "boolean" || value is Boolean );
		}

		/**
		 * Checks wherever passed-in value is <code>Function</code>.
		 * 是否是函数型
		 */
		public static function isFunction(value:*):Boolean {
			return ( typeof(value) == "function" || value is Function );
		}

		
	}//end of class
}