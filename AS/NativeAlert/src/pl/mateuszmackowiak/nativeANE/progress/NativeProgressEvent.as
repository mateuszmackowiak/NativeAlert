package pl.mateuszmackowiak.nativeANE.progress
{
	import flash.events.Event;
	
	public class NativeProgressEvent extends Event
	{
		public static const CANCLED:String = "nativeProgress_cancled";
		public static const CLOSED:String = "nativeProgress_closed";
		public static const OPENED:String = "nativeProgress_opened";
		
		private var _index:String;
		public function NativeProgressEvent(type:String,index:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new NativeProgressEvent(type,_index);
		}
	}
}