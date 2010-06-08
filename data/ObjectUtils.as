/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.asclub.data
{
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;


public class ObjectUtils
{
	/**
	 * Deep clone object using thiswind@gmail.com 's solution
	 */
	public static function baseClone(source:*):*{
		var typeName:String = getQualifiedClassName(source);
        var packageName:String = typeName.split("::")[1];
        var type:Class = Class(getDefinitionByName(typeName));

        registerClassAlias(packageName, type);
        
        var copier:ByteArray = new ByteArray();
        copier.writeObject(source);
        copier.position = 0;
        return copier.readObject();
	}
	
	/**
	 * 合并两个Object
	 * @param	obj1
	 * @param	obj2
	 * @return  Object
	 */
	public static function mergeObjects(obj1:Object, obj2:Object):Object
	{
		//var obj:Object = baseClone(obj1);
		for (var k:String in obj2)
		{
			if (obj1.hasOwnProperty(k))
			{
				if (typeof obj2[k] == 'object')
				{
					mergeObjects(obj1[k], obj2[k]);
				}
			}
			else
			{
				obj1[k] = obj2[k];
			}
		}
		return obj1;
	}

	
	/**
	 * Checks wherever passed-in value is <code>String</code>.
	 */
	public static function isString(value:*):Boolean {
		return ( typeof(value) == "string" || value is String );
	}
	
	/**
	 * Checks wherever passed-in value is <code>Number</code>.
	 */
	public static function isNumber(value:*):Boolean {
		return ( typeof(value) == "number" || value is Number );
	}

	/**
	 * Checks wherever passed-in value is <code>Boolean</code>.
	 */
	public static function isBoolean(value:*):Boolean {
		return ( typeof(value) == "boolean" || value is Boolean );
	}

	/**
	 * Checks wherever passed-in value is <code>Function</code>.
	 */
	public static function isFunction(value:*):Boolean {
		return ( typeof(value) == "function" || value is Function );
	}

	
}
}