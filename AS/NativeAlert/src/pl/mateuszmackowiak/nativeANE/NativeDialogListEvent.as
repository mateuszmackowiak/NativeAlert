package pl.mateuszmackowiak.nativeANE
{
	import flash.events.Event;
	
	public class NativeDialogListEvent extends Event
	{
		public static const LIST_CHANGE:String = "nativeExtensionList_change";
		
		private var _index:int=-1;
		private var _selected:Boolean=false;
		public function NativeDialogListEvent(type:String, index:int , selected:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			_selected  = selected;
			super(type, bubbles, cancelable);
		}
		
		public function get index() : int
		{
			return _index;
		}
		public function get selected() : Boolean
		{
			return _selected;
		}
		override public function clone() : Event
		{
			return new NativeDialogListEvent(type,_index,_selected);
		}
	}
}