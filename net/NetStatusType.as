package src
{
	public class NetStatusType
	{
		public function NetStatusType()
		{
			
		}
		
		//密码错误
		public static const WRONG_PASSWORD:String = "wrongPassword";
		//用户名中含有敏感信息
		public static const ILLEGAL_USERNAME:String = "illegalUserName";
		//连接数过多
		public static const CONNECTIONS_LIMITED:String = "connectionsLimited";
		//域名限制
		public static const NOT_ALLOW_DOMAIN:String = "notAllowDomain";
	}
}