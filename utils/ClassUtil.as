package org.asclub.utils
{
	public final class ClassUtil
	{
		public function ClassUtil()
		{
			
		}
		
		public static function construct(type:Class, ...arguments):* 
		{
			if (arguments.length > 10)
				throw new Error('You have passed more arguments than the "construct" method accepts (accepts ten or less).');
			
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
	}//end of class
}