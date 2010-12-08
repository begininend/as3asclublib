package org.asclub.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	
	public class FileBrower extends EventDispatcher
	{
		private var _fileReferenceList:FileReferenceList;
		
		private var _fileReference:FileReference;
		
		//是否支持多选
		private var _allowMultipleSelection:Boolean;
		
		//
		public var datas:Array = [];
		
		private var _numTotalFile:int;
		
		private var _numLoadedFile:int;
		
		public function FileBrower()
		{
			_fileReferenceList = new FileReferenceList();
			_fileReferenceList.addEventListener(Event.SELECT, fileReferenceListSelectHandler);
		}
		
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		
		public function set allowMultipleSelection(value:Boolean):void
		{
			_allowMultipleSelection = value;
		}

		
		public function browse(typeFilter:Array = null):void
		{
			if (_allowMultipleSelection)
			{
				_fileReferenceList.browse(typeFilter);
			}
			else
			{
				if (_fileReference)
				{
					_fileReference.browse(typeFilter);
				}
				else
				{
					_fileReference = new FileReference();
					_fileReference.addEventListener(Event.SELECT, fileReferenceSelectHandler);
					_fileReference.addEventListener(Event.COMPLETE, fileReferenceCompleteHandler);
					_fileReference.browse(typeFilter);
				}
			}
		}
		
		//多文件选择
		private function fileReferenceListSelectHandler(event:Event):void
		{
			
		}
		
		//单文件选择
		private function fileReferenceSelectHandler(event:Event):void
		{
			_numTotalFile = 1;
			datas = [];
			_fileReference.load();
		}
		
		//单文件加载完成
		private function fileReferenceCompleteHandler(event:Event):void
		{
			_numLoadedFile ++;
			datas.push(_fileReference.data);
			//当所有文件加载完成后调度事件
			if (_numLoadedFile == _numTotalFile)
			{
				this.dispatchEvent(event);
			}
		}
		
		
	}//end class
}