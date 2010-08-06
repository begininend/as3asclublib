package com.riaoo.utils
{
	/**
	 * 逻辑类。
	 * @author Y.Boy
	 * 
	 */	
	public class Logic
	{
		public function Logic()
		{
		}
		
		/**
		 * 在给出的所有参数里，只要有一个参数为 true ，则返回 true ；否则返回 false 。
		 * @param bool1 参数一。
		 * @param bool2 参数二。
		 * @param params 任意多个类型为 Boolean 的参数。
		 * @return 对所有参数进行或运算（||）的结果。
		 * 
		 */		
		public static function any(bool1:Boolean, bool2:Boolean, ... params):Boolean
		{
			if (bool1 || bool2)
			{
				return true;
			}
			
			for each (var bool:Boolean in params)
			{
				if (bool)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 在给出的所有参数里，当且仅当全部为 true 时，返回 true ；否则只要有一个参数为 false 时，返回 false 。
		 * @param bool1 参数一。
		 * @param bool2 参数二。
		 * @param params 任意多个类型为 Boolean 的参数。
		 * @return 对所有参数进行且运算（&&）的结果。
		 * 
		 */		
		public static function all(bool1:Boolean, bool2:Boolean, ... params):Boolean
		{
			if (!(bool1 && bool2))
			{
				return false;
			}
			
			for each (var bool:Boolean in params)
			{
				if (!bool)
				{
					return false;
				}
			}
			
			return true;
		}
		
	}
}