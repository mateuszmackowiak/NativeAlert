package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.Event;
	
	public class NativeTextInputDialogEvent extends Event
	{
		public static const CLOSED:String = "nativeTextInputDialog_closed";
		private var _buttonIndex:int = -1;
		private var _list:Vector.<NativeTextField>;
		public function NativeTextInputDialogEvent(type:String,buttonIndex:String,list:Vector.<NativeTextField>, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_list = list;
			_buttonIndex = int(buttonIndex);
			super(type, bubbles, cancelable);
		}

		public function get list():Vector.<NativeTextField>
		{
			return _list;
		}

		public function get buttonIndex():int
		{
			return _buttonIndex;
		}


	}
}