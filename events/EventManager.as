package org.asclub.events
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.events.EventDispatcher; 

	/**
	 * EventManager 事件集中管理器
	 * @author 阿伍 2010/4/1
	 */
	public class EventManager 
	{

		private static var FnDict: Dictionary = new Dictionary(false );
		private static var OnceFnDict: Dictionary = new Dictionary(false );

		public static function AddEventFn(obj: EventDispatcher,type: String,fn: Function,para: Array = null,eventPara: Boolean = false): void
		{
			//如果该obj从未注册过
			if(! FnDict[obj])
			{
				FnDict[obj] = {};
			}
			//如果没注册过该事件
			if(! FnDict[obj][type])
			{
				FnDict[obj][type] = [];
				obj.addEventListener(type, onEventCatch );
			}
			FnDict[obj][type].push([fn,para,eventPara] );
		}

		//删除事件
		public static function delEventFn(obj: EventDispatcher,type: String,fn: Function): void
		{ 
			 
			var arr: Array = FnDict[obj][type];//取出 此侦听器 所有的侦听函数
		 
			for each(var item:Array in arr)
			{ 
				if(item[0] == fn)
				{
					FnDict[obj][type].splice(FnDict[obj][type].indexOf(item ), 1 );
					break;
				}
			}
 
			
			//如果obj的这种侦听已经无意义，则删除
			if(! FnDict[obj][type].length)
			{
				obj.removeEventListener(type, onEventCatch );
				delete FnDict[obj][type];
			}
		} 

		//删除一个obj的所有type为指定类型的事件
		public static function delEventByType(obj: EventDispatcher,type: String): void
		{
			obj.removeEventListener(type, onEventCatch );  
			delete FnDict[obj][type];
		}

		//删除一个obj所有的事件
		public static function delAllEvent(obj: EventDispatcher): void
		{
			for(var type:String in FnDict[obj])
			{ 
				obj.removeEventListener(type, onEventCatch ); 
			}	
			delete FnDict[obj];
		}

		//执行事件
		private static function onEventCatch(e: Event): void
		{
			var arr: Array = FnDict[e.target][e.type];
			for(var i: int = 0;i < arr.length; i ++)
			{ 
				var fn: Function = arr[i][0];
				if(arr[i][2])
				{
					var paras: Array = arr[i][1] ? arr[i][1].concat().unshift(e ):[e]; 
					fn.apply(null, paras );
				}
				else
				{
					fn.apply(null, arr[i][1] );
				}
			}
		}

		//只执行一次的事件
		public static function AddOnceEventFn(obj: EventDispatcher,type: String,fn: Function,para: Array = null): void
		{
			//如果该obj从未注册过
			OnceFnDict[obj] || (OnceFnDict[obj] = {});
			 
			//如果也没有注册过该事件
			if(! OnceFnDict[obj][type])
			{
				OnceFnDict[obj][type] = [];
				obj.addEventListener(type, onOnceEventCatch );
			}
			OnceFnDict[obj][type].push([fn,para] );
            //obj.adde
		}

		//只执行一次的事件被触发了
		private static function onOnceEventCatch(e: Event): void
		{          
			EventDispatcher(e.target ).removeEventListener(e.type, onOnceEventCatch );
			
			var arr: Array = OnceFnDict[e.target][e.type];
			for(var i: int = 0;i < arr.length; i ++)
			{  
				arr[i][0].apply(null, arr[i][1] );
			}
			delete OnceFnDict[e.target][e.type];
		}
	}
}
