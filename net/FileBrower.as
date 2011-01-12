package org.asclub.net
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.utils.ByteArray;
	
	public class FileBrower extends EventDispatcher
	{
		private static var _instance:FileBrower;
		
		private var _status:String;
		
		private var _fileReferenceList:FileReferenceList;
		
		private var _fileReference:FileReference;
		
		//是否支持多选
		private var _allowMultipleSelection:Boolean;
		
		//打开的所有文件的字节流
		public var datas:Array = [];
		
		//打开的所有位图文件
		public var bitmaps:Array = [];
		
		private var _bitmapFileFilter:FileFilter = new FileFilter("图像格式(*.jpg,*.jpeg,*.gif,*.png)", "*.jpg;*.jpeg;*.gif;*.png;");
		
		private var _bitmapFileIndex:Array = [];
		
		//全部文件
		private var _numTotalFile:int;
		//已经加载的文件
		private var _numLoadedFile:int;
		//全部的位图文件
		private var _numTotalBitmapFile:int;
		//已经加载的位图文件
		private var _numLoadedBitmapFile:int;
		
		public function FileBrower(privateClass:PrivateClass)
		{
			_fileReferenceList = new FileReferenceList();
			_fileReferenceList.addEventListener(Event.SELECT, fileReferenceListSelectHandler);
		}
		
		//------------------------------------------------------------------------------------------------
		// PUBLIC METHOD
		//------------------------------------------------------------------------------------------------
		
		/**
		 * 获取单例
		 * @return
		 */
		public static function getInstance():FileBrower
		{
			if ( _instance == null ) 
			{
				_instance = new FileBrower(new PrivateClass());
			}
            return _instance;
		}
		
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		
		public function set allowMultipleSelection(value:Boolean):void
		{
			_allowMultipleSelection = value;
		}

		/**
		 * 
		 * @param	typeFilter
		 */
		public function browse(typeFilter:Array = null,imageCompleteHandler:Function = null):void
		{
			if (_allowMultipleSelection)
			{
				_fileReferenceList.browse(typeFilter);
				_status = "load";
			}
			else
			{
				if (_fileReference)
				{
					_fileReference.browse(typeFilter);
					_status = "load";
				}
				else
				{
					_fileReference = new FileReference();
					_fileReference.addEventListener(Event.SELECT, fileReferenceSelectHandler);
					_fileReference.addEventListener(Event.COMPLETE, fileReferenceCompleteHandler);
					_fileReference.browse(typeFilter);
					_status = "load";
				}
			}
		}
		
		/**
		 * 保存文件到本地
		 * @param	datas
		 * @param	defaultFileName
		 */
		public function save(datas:ByteArray, defaultFileName:String = null):void
		{
			if (! _fileReference)
			{
				_fileReference = new FileReference();
				_fileReference.addEventListener(Event.SELECT, fileReferenceSelectHandler);
				_fileReference.addEventListener(Event.COMPLETE, fileReferenceCompleteHandler);
			}
			_fileReference.save(datas, defaultFileName);
			_status = "save";
		}
		
		
		//多文件选择
		private function fileReferenceListSelectHandler(event:Event):void
		{
			var fileList:Array = event.currentTarget.fileList;
			_numLoadedFile = 0;
			_numTotalFile = fileList.length;
			_numLoadedBitmapFile = 0;
			_numTotalBitmapFile = 0;
			_bitmapFileIndex.length = 0;
			datas.length = 0;
			bitmaps.length = 0;
			var fileReference:FileReference;
			for (var i:int = 0; i < _numTotalFile; i++)
			{
				fileReference = fileList[i] as FileReference;
				fileReference.addEventListener(Event.COMPLETE, fileReferenceCompleteHandler);
				fileReference.load();
				_status = "load";
			}
		}
		
		//单文件选择
		private function fileReferenceSelectHandler(event:Event):void
		{
			if (_status != "save")
			{
				_numLoadedFile = 0;
				_numTotalFile = 1;
				_numLoadedBitmapFile = 0;
				_numTotalBitmapFile = 0;
				_bitmapFileIndex.length = 0;
				datas.length = 0;
				bitmaps.length = 0;
				_fileReference.load();
				_status = "load";
			}
		}
		
		//单文件加载完成
		private function fileReferenceCompleteHandler(event:Event):void
		{
			if (_status == "load")
			{
				var fileReference:FileReference = event.currentTarget as FileReference;
				//检索是否是图片(通过后缀名)
				if (_bitmapFileFilter.extension.indexOf(fileReference["type"]) != -1)
				{
					_bitmapFileIndex.push(datas.length);
					_numTotalBitmapFile ++;
				}
				
				datas.push(fileReference.data);
				_numLoadedFile ++;
				
				
				//当所有文件加载完成后调度事件
				if (_numLoadedFile == _numTotalFile)
				{
					loadImage();
					this.dispatchEvent(event);
				}
			}
			else if(_status == "save")
			{
				this.dispatchEvent(new Event("saveComplete"));
				//_status = "load";
			}
		}
		
		//加载位图
		private function loadImage():void
		{
			var numTotalBitmapFile:int = _bitmapFileIndex.length;
			for (var i:int = 0; i < numTotalBitmapFile ; i++)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadedCompleteHandler);
				loader.loadBytes(datas[_bitmapFileIndex[i]]);
			}
		}
		
		//图片加载完成
		private function imageLoadedCompleteHandler(event:Event):void
		{
			var image:Bitmap = event.currentTarget.content as Bitmap;
			image.smoothing = true;
			bitmaps.push(image);
			event.currentTarget.removeEventListener(Event.COMPLETE, imageLoadedCompleteHandler);
			_numLoadedBitmapFile ++;
			//当所有文件加载完成后调度事件
			if (_numLoadedBitmapFile == _numTotalBitmapFile)
			{
				this.dispatchEvent(new Event("imageComplete"));
			}
		}
		
		
	}//end class
}


class PrivateClass
{
	
}