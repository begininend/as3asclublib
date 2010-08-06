package com.riaoo.net
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class FileUpload
	{
		public function FileUpload()
		{
		}
		
		/**
		 * 用指定的 URLLoader 对象上传文件。
		 * 
		 * @param loader 用于上传的 URLLoader 对象。
		 * @param url 上传地址。
		 * @param file 文件的二进制数据。
		 * @param fileNamesName 服务器端接收文件时变量名。
		 * @param fileName 文件名。
		 * @param contentType 文件的 content-type 。
		 */	
		public static function uploadFile(loader:URLLoader, url:String, file:ByteArray, fileNamesName:String, fileName:String, contentType:String = 'application/octet-stream'	):void
		{
			var i        :int;
			var boundary :String     = '--';
			var request  :URLRequest = new URLRequest;
			var postData :ByteArray  = new ByteArray;
			var bytes    :String;
			
			for ( i = 0; i < 0x10; i++ )
				boundary += String.fromCharCode( int( 97 + Math.random() * 25 ) );
	
			loader.dataFormat = URLLoaderDataFormat.BINARY;
						
			request.url = url;
			request.contentType = 'multipart/form-data; boundary=' + boundary;
			request.method = URLRequestMethod.POST;
			
			postData.endian = Endian.BIG_ENDIAN;
			
			// -- + boundary
			postData.writeShort( 0x2d2d );
			for ( i = 0; i < boundary.length; i++ )
				postData.writeByte( boundary.charCodeAt( i ) );
			
			// line break
			postData.writeShort( 0x0d0a );
			
			// content disposition
			bytes = 'Content-Disposition: form-data; name="' + fileNamesName + '"';
			for ( i = 0; i < bytes.length; i++ )
				postData.writeByte( bytes.charCodeAt( i ) );
			
			// 2 line breaks
			postData.writeInt( 0x0d0a0d0a );
			
			// file name
			postData.writeUTFBytes( fileName );
			
			// line break
			postData.writeShort( 0x0d0a );
			
			// -- + boundary
			postData.writeShort( 0x2d2d );
			for ( i = 0; i < boundary.length; i++ )
				postData.writeByte( boundary.charCodeAt( i ) );
			
			// line break
			postData.writeShort( 0x0d0a );
			
			// content disposition
			bytes = 'Content-Disposition: form-data; name="Filedata"; filename="';
			for ( i = 0; i < bytes.length; i++ )
				postData.writeByte( bytes.charCodeAt( i ) );
			
			// file name
			postData.writeUTFBytes( fileName );
			
			// missing "
			postData.writeByte( 0x22 );
			
			// line break
			postData.writeShort( 0x0d0a );
			
			// content type
			bytes = 'Content-Type: ' + contentType;
			for ( i = 0; i < bytes.length; i++ )
				postData.writeByte( bytes.charCodeAt( i ) );
			
			// 2 line breaks
			postData.writeInt( 0x0d0a0d0a );
			
			// file data
			postData.writeBytes( file, 0, file.length );
			
			// line break
			postData.writeShort( 0x0d0a );
			
			// -- + boundary
			postData.writeShort( 0x2d2d );
			for ( i = 0; i < boundary.length; i++ )
				postData.writeByte( boundary.charCodeAt( i ) );
	
			// line break			
			postData.writeShort( 0x0d0a );
			
			// upload field
			bytes = 'Content-Disposition: form-data; name="Upload"';
			for ( i = 0; i < bytes.length; i++ )
				postData.writeByte( bytes.charCodeAt( i ) );
			
			// 2 line breaks
			postData.writeInt( 0x0d0a0d0a );
			
			// submit
			bytes = 'Submit Query';
			for ( i = 0; i < bytes.length; i++ )
				postData.writeByte( bytes.charCodeAt( i ) );
			
			// line break
			postData.writeShort( 0x0d0a );
			
			// -- + boundary + --
			postData.writeShort( 0x2d2d );
			for ( i = 0; i < boundary.length; i++ )
				postData.writeByte( boundary.charCodeAt( i ) );
			postData.writeShort( 0x2d2d );
	
			request.data = postData;
			request.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			loader.load( request );
		}

	}
}