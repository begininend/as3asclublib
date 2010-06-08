package org.asclub.net
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.display.Sprite;
	
	import org.asclub.events.JmailEvent;

	public class Jmail extends Sprite
	{
		public var MailServer:String;                    //用来发送邮件的SMTP服务器
		public var MailLoginname:String;                 //登录用户名
		public var MailLoginpassword:String;             //登录密码
		public var MailFromname:String;                  //发信人姓名
		public var MailFrommail:String;                  //发信人信箱
		public var MailToname:String;                    //收信人姓名
		public var MailTomail:String;                    //收信人信箱
		public var MailSubject:String;                   //信件主题
		public var MailBody:String;                      //信件内容
		public var MailAD:String;                        //底部广告
		public var MailPriority:int;                  //邮件等级，1为加急，3为普通，5为低级
		
		public function Jmail()
		{
			Init();
		}
		
		//初始化
		private function Init():void
		{
			MailAD = "http://www.gscy.org" + "  \n<br>" + "期待您时常来逛逛: )";
			MailPriority = 3;
		}
		
		//发送邮件
		public function SendMail():void
		{
			var MailURLVariables:URLVariables = new URLVariables();
			MailURLVariables.mailserver = MailServer;
			MailURLVariables.mailserverloginname = MailLoginname;
			MailURLVariables.mailserverloginpass = MailLoginpassword;
			MailURLVariables.fromname = MailFromname;
			MailURLVariables.frommail = MailFrommail;
			MailURLVariables.toname = MailToname;
			MailURLVariables.tomail = MailTomail;
			MailURLVariables.mailtitle = MailSubject;
			MailURLVariables.mailbody = MailBody;
			MailURLVariables.mailAD = MailAD;
			MailURLVariables.Priority = MailPriority;
			
			var MailURLRequest:URLRequest = new URLRequest();
			MailURLRequest.url = "http://freesky.vhost020.dns345.cn/formmail.asp";
			MailURLRequest.data = MailURLVariables;
			MailURLRequest.method = URLRequestMethod.POST;
			
			var MailURLLoader:URLLoader = new URLLoader();
			MailURLLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			MailURLLoader.addEventListener(Event.COMPLETE,MailsuccessHandle);
			MailURLLoader.addEventListener(IOErrorEvent.IO_ERROR, MailIOErrorHandle);
			MailURLLoader.load(MailURLRequest);
		}
		
		//邮件发送成功
		private function MailsuccessHandle(Evt:Event):void
		{
			//trace(Evt.target.data.SendResult);
			this.dispatchEvent(new JmailEvent(JmailEvent.LOADCOMPLETE));
		}
		
		//邮件发送失败
		private function MailIOErrorHandle(Evt:IOErrorEvent):void
		{
			trace("邮件发送失败");
		}
	}//end of class
}