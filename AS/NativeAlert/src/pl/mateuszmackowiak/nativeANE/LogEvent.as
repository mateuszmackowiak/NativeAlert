package pl.mateuszmackowiak.nativeANE
{
	import flash.events.Event;
	
	public class LogEvent extends Event
	{
		public static const LOG_EVENT:String = "logEvent";
		/**
		 * @private
		 */
		private var _text:String ="";
		
		public function LogEvent(type:String, text:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_text = text;
			super(type, bubbles, cancelable);
		}

		public function get text():String
		{
			return _text;
		}

	}
}