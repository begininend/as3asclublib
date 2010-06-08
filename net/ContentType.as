package org.asclub.net
{
	public final class ContentType
	{
		public function ContentType() { }
		
		//*****************   Text and Text-Related Types(文本类型)   *****************//
		
		
		public static const HTML_TEXT_DATA:String = "text/html";
		
		/**
		 * txt c c++ pl cc h asc as
		 */
		public static const PLAIN_TXT:String = "text/plain";
		
		/**
		 * text/xml
		 */
		public static const XML:String = "text/xml";
		
		
		
		
		
		
		
		//*****************   Document Stylesheet Types     *****************//
		
		/**
		 * CSS
		 */
		public static const CASCADING_STYLESHEETS:String = "text/css";
		
		
		
		
		
		
		
		
		//*****************   Image Types(图片类型)*****************//
		
		/**
		 * GIF 
		 */
		public static const GIF:String = "image/gif";
		
		/**
		 * PNG
		 */
		public static const PNG:String = "image/png";
		
		/**
		 * jpeg  jpe  jpg
		 */
		public static const JPEG:String = "image/jpeg";
		
		
		
		
		
		//*****************   Audio/Voice/Music Related Types(音频类型)*****************//
		
		/**
		 * MP3 mp2
		 */
		public static const MP3:String = "audio/mpeg";
		
		/**
		 * WAV
		 */
		public static const WAV:String = "audio/x-wav";
		
		/**
		 * MID  mid  midi
		 */
		public static const MID:String = "audio/midi";
		
		
		//*****************   Video Types(视频类型) *****************//
		
		/**
		 * MPEG video   (mpeg mpg mpe mpga)
		 */
		public static const MPEG_VIDEO:String = "video/mpeg";
		
		
		//*****************   Special HTTP/Web Application Types   *****************//
		
		/**
		 * Proxy autoconfiguration (Netscape browsers)  pac
		 */
		public static const PAC:String = "application/x-ns-proxy-autoconfig";
		
		
		//*****************   Application Types   *****************//
		
		/**
		 * flash 
		 */
		public static const FLASH:String = "application/x-shockwave-flash";
		
		/**
		 * amf
		 */
		public static const AMF:String = "application/x-amf";
		
		/**
		 * JS
		 */
		public static const JS:String = "application/x-javascript";
		
		/**
		 * bin(二进制)
		 */
		public static const BIN:String = "application/octet-stream";
		 
		 
		//*****************   Multipart Types (mostly email)  *****************//
		
		/**
		 * Messages with multiple parts
		 */
		public static const MULTIPART:String = "multipart/mixed";
		
		
		//*****************   Message Types (mostly email)   *****************//
		
		/**
		 * Message Types (mostly email)
		 */
		public static const MIME_MESSAGE:String = "message/rfc822";
		
		
		//*****************   2D/3D Data/Virtual Reality Types   *****************//
		
		/**
		 * VRML data file   wrl vrml
		 */
		public static const WRL_VRML:String = "x-world/x-vrml ";
		
		
		//*****************  Scientific/Math/CAD Types   *****************//
		
		/**
		 * Vis5D 5-dimensional data 
		 */
		public static const V5D:String = "application/vis5d";
		
		
		//*****************   Largely Platform-Specific Types   *****************//
		
		/**
		 * Directory Viewer
		 */
		public static const DIR:String = "application/x-dirview";
		
		
	}
}