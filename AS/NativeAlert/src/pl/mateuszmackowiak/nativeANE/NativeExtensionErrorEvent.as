package pl.mateuszmackowiak.nativeANE
{
	import flash.events.ErrorEvent;
	
	public class NativeExtensionErrorEvent extends ErrorEvent
	{
		public static const ERROR:String = "nativeAlertError";
		
		public function NativeExtensionErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, text:String="", id:int=0)
		{
			super(type, bubbles, cancelable, text, id);
		}
	}
}