/*
 * ErrorText.as
 * Copyright CYJB
 * All Rights Reserved.
 * NOTICE: You can use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
*/
package org.asclub.errors {

	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 * @private
	 * <code>ErrorUtil</code> 类可以快速的创建一系列确定代码的错误提示.
	 * 
	 * <p>该类支持 flash 内建的错误代码以及以下自定义错误代码:</p>
	 * <ul>
	 * <li><code>9999</code> : (自定义错误)拒绝调用方法 %1。</li>
	 * </ul>
	 * 
	 * @author CYJB
	 * @versions 2.0
	 * @since 2009-3-2
	 */
	public final class ErrorUtil {
		/**
		 * @private
		 * 该类的版本.
		 */
		public static const version:String = "2.0";
		/**
		 * 用于保存错误提示的对象.
		 */
		private static var ERROR_TEXT:Object = {};
		ERROR_TEXT[9999] = "(自定义错误)错误的调用方法 %1。";
		/**
		 * 使用指定错误代码引发错误.
		 * 
		 * @param 要引发的错误类.
		 * @param id 错误的代码.
		 * @param ...args 错误的相关信息.该信息就是错误提示中需要被替换的文字,所有需要被
		 * 替换的文字按顺序传入.
		 */
		public static function throwError(type:Class, id:uint, ...args:Array):void {
			if(ERROR_TEXT[id]) {
				var f:Function = function(match:String, ...rest:Array):String {
					var arg_num:int = -1;
					switch(match.charAt(1)) {
						case "1":
							arg_num = 0;
							break;
						case "2":
							arg_num = 1;
							break;
						case "3":
							arg_num = 2;
							break;
						case "4":
							arg_num = 3;
							break;
						case "5":
							arg_num = 4;
							break;
						case "6":
							arg_num = 5;
							break;
					}
					if(arg_num > -1 && args.length > arg_num)
						return args[arg_num];
					else
						return "";
				};
				var message:String = "Error #" + id + ":" + 
					ERROR_TEXT[id].replace(/%[0-9]/g, f);
				throw new type(message, id);
			} else {
				Error.throwError.apply(null, [type, id].concat(args));
			}
		}
	}
}
