package org.asclub.utils
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedSuperclassName;
	
	public final class ClassUtil
	{
		public function ClassUtil()
		{
			
		}
		
		/**
		 * 构造一个实例
		 * @param	type            类
		 * @param	...arguments    参数
		 * @return
		 */
		public static function construct(type:Class, ...arguments):* 
		{
			if (arguments.length > 10)
			{
				throw new Error('You have passed more arguments than the "construct" method accepts (accepts ten or less).');
			}
			
			switch (arguments.length) 
			{
				case 0 :
					return new type();
				case 1 :
					return new type(arguments[0]);
				case 2 :
					return new type(arguments[0], arguments[1]);
				case 3 :
					return new type(arguments[0], arguments[1], arguments[2]);
				case 4 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3]);
				case 5 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]);
				case 6 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
				case 7 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]);
				case 8 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]);
				case 9 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]);
				case 10 :
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]);
			}
		}
		
		/**
		 * 获取对象所继承的所有父类,以数组返回.
		 * 
		 * @param arg 目标对象.可以是对象实例,原始类型或者类对象.
		 * 
		 * @return 目标对象父类列表.
		 */	
		public static function getClassExtendedList(arg:Object):Array
		{
			var result:Array = new Array;
			var list:XMLList = describeType(arg is Class ? arg : arg.constructor).factory.extendsClass;
			for each(var index:XML in list) result.push(index.@type.toString());
			list = null;
			return result;
		}
		
		/**
		 * 获取对象是否是静态类.
		 * 
		 * @param arg 目标对象.可以是对象实例,原始类型或者类对象.
		 * 
		 * @return 如果目标对象是静态类,则为true.
		 */	
		public static function getIsStaticClass(arg:Object):Boolean
		{
			return describeType(arg).@isStatic == true;
		}
		
		/**
		 * 获取对象基类的类名.
		 * 
		 * <p>不同于getQualifiedSuperclassName,该方法获取的只是对象基类的不完全限定类名,也就是不含有路径的类名.</p>
		 * 
		 * @param arg 目标对象.可以是对象实例,原始类型或者类对象.
		 * 
		 * @return 目标对象基类的类名.
		 */	
		public function getSuperClassShortName(arg:Object):String
		{
			return getQualifiedSuperclassName(arg).split(":").pop();
		}
		
		/**
		 * 获取对象所实现的所有接口,以数组返回.
		 * 
		 * @param arg 目标对象.可以是对象实例,原始类型或者类对象.
		 * 
		 * @return 目标对象现实过的接口列表.
		 */	
		public function getClassImplementedList(arg:Object):Array
		{
			var result:Array = new Array;
			var list:XMLList = describeType(arg is Class ? arg : arg.constructor).factory.implementsInterface;
			for each(var index:XML in list) result.push(index.@type.toString());
			list = null;
			return result;
		}
		
		/**
		 * 获取对象的类名.
		 * 
		 * <p>不同于getQualifiedClassName,该方法获取的只是类对象的不完全限定类名,也就是不含有路径的类名.</p>
		 * 
		 * @param arg 目标对象.可以是对象实例,原始类型或者类对象.
		 * 
		 * @return 目标对象的类名.
		 */	
		public function getClassShortName(arg:Object):String
		{
			return getQualifiedClassName(arg).split(":").pop();
		}
		
		/**
		 * 获取对象的构造函数详细资料,以数组返回.
		 * 
		 * <p>返回的参数以数组存在.数组的每一项也是一个数组,而新的数组中第一项表示该参数的类型,第二项表示是否可选参数.</p>
		 * <p>例如调用getConstructorDetails(new Event(""));<br>那么返回的数组每一项如下值:
		 * <table class="innertable">
		 * <tr><th>数组索引</th><th>参数类型</th><th>可选参数</th><th>第几个参数</th></tr>
		 * <tr><td>0</td><td>String</td><td>true</td><td>1</td></tr>
		 * <tr><td>1</td><td>Boolean</td><td>false</td><td>2</td></tr>
		 * <tr><td>2</td><td>Boolean</td><td>false</td><td>3</td></tr>
		 * </table></p>
		 * 
		 * 注意:当目标对象是类对象时,那么获取到的构造函数参数类型将全是"&#42;".
		 * 
		 * @param arg 目标对象.可以是对象实例,原始类型或者类对象.
		 * 
		 * @return 目标对象构造函数的详细资料.
		 */	
		public function getConstructorDetails(arg:Object):Array
		{
			var result:Array = new Array;
			var list:XMLList = arg is Class ? describeType(arg).factory.constructor.parameter : describeType(arg).constructor.parameter;
			for each(var index:XML in list) result.push([index.@type,index.@optional == "false"]);
			list = null;
			return result;
		}
		
		/**
		 * 获取对象构造函数的参数长度.
		 * 
		 * @param arg 目标对象.可以是对象实例,原始类型或者类对象.
		 * 
		 * @return 目标对象构造函数的参数长度.
		 */	
		public function getConstructorLength(arg:Object):uint
		{
			return describeType(arg is Class ? arg : arg.constructor).factory.constructor.parameter.length();
		}
		
		/**
		 * 获取对象是否是动态类.
		 * 
		 * @param arg 目标对象.可以是对象实例,原始类型或者类对象.
		 * 
		 * @return 如果目标对象是动态类,则为true.
		 */	
		public function getIsDynamicClass(arg:Object):Boolean
		{
			return describeType(arg).@isDynamic == true;
		}
		
	}//end of class
}