package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReferenceList;
	
	
	public class FileBrower extends EventDispatcher
	{
		private var _fileReferenceList:FileReferenceList;
		public function FileBrower()
		{
			_fileReferenceList = new FileReferenceList();
			_fileReferenceList.addEventListener(Event.SELECT, fileReferenceListSelectHandler);
		}
		
		public function get allowMultipleSelection():Boolean
		{
			
		}
		
		public function set allowMultipleSelection(value:Boolean):void
		{
			
		}

		
		public function browse():void
		{
			_fileReferenceList.browse();
		}
		
		private function fileReferenceListSelectHandler(event:Event):void
		{
			
		}
		
		
	}//end class
}