package pl.mateuszmackowiak.nativeANE
{
	import flash.events.ErrorEvent;
	
	public class NativeExtensionErrorEvent extends ErrorEvent
	{
		/**
		 * Defines the value of the type property of a NativeExtensionErrorEvent object.
		 */
		public static const ERROR:String = "nativeError";
		
		/**
		 * Dispatched event if an error has been found on the native code side
		 */
		public function NativeExtensionErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, text:String="", id:int=0)
		{
			super(type, bubbles, cancelable, text, id);
		}
		
	}
}