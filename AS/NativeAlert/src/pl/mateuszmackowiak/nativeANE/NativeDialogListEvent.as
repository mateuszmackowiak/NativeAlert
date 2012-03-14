package pl.mateuszmackowiak.nativeANE
{
	import flash.events.Event;
	
	public class NativeDialogListEvent extends Event
	{
		/**
		* Defines the value of the type property of a NativeDialogListEvent object.
		*/
		public static const LIST_CHANGE:String = "nativeListDialog_change";
		/**
		 * @private
		 */
		private var _index:int=-1;
		/**
		 * @private
		 */
		private var _selected:Boolean=false;
		
		
		/**
		 * Dispatched every time a state has changed in the native windowś
		 */
		public function NativeDialogListEvent(type:String, index:int , selected:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			_selected  = selected;
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * the index of the button that has changed it state
		 */
		public function get index() : int
		{
			return _index;
		}
		/**
		 * defines if the new state of the button
		 */
		public function get selected() : Boolean
		{
			return _selected;
		}
		
		/**
		 * @copy flash.events.Event.clone()
		 */
		override public function clone() : Event
		{
			return new NativeDialogListEvent(type,_index,_selected);
		}
	}
}