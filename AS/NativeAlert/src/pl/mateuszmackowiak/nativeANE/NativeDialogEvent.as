package pl.mateuszmackowiak.nativeANE
{
	import flash.events.Event;
	
	public class NativeDialogEvent extends Event
	{
		public static const CANCLED:String = "nativeDialog_cancled";
		public static const CLOSED:String = "nativeDialog_closed";
		public static const OPENED:String = "nativeDialog_opened";
		
		private var _index:String;
		public function NativeDialogEvent(type:String,index:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			super(type, bubbles, cancelable);
		}
		
		public function get index() : String
		{
			return _index;
		}
		
		override public function clone() : Event
		{
			return new NativeDialogEvent(type,_index);
		}
	}
}