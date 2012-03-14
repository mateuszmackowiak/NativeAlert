package pl.mateuszmackowiak.nativeANE
{
	import flash.events.Event;
	
	public class NativeDialogEvent extends Event
	{
		/**
		 * Defines the value of the type property of a NativeDialogEvent object.
		 */
		public static const CANCLED:String = "nativeDialog_cancled";
		/**
		 * Defines the value of the type property of a NativeDialogEvent object.
		 */
		public static const CLOSED:String = "nativeDialog_closed";
		/**
		 * Defines the value of the type property of a NativeDialogEvent object.
		 */
		public static const OPENED:String = "nativeDialog_opened";
		/**
		 * @private
		 */
		private var _index:String;
		
		public function NativeDialogEvent(type:String,index:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			super(type, bubbles, cancelable);
		}
		/**
		 * the index of the clicked button
		 */
		public function get index() : String
		{
			return _index;
		}
		/**
		 * @copy flash.events.Event.clone()
		 */
		override public function clone() : Event
		{
			return new NativeDialogEvent(type,_index);
		}
	}
}