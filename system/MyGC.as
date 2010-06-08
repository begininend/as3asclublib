package org.asclub.system
{
	import flash.net.LocalConnection;
	
	public class MyGC
	{
		
		public function MyGC()
		{
		}
		
		public static function gc():void
		{
			try
			{
				var lc1:LocalConnection = new LocalConnection();
				var lc2:LocalConnection = new LocalConnection();
				lc1.connect("name");
				lc2.connect("name");
			}
			catch (e:Error)
			{
			}
		}
	}//end of class
}