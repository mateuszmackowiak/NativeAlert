/** @author Mateusz Maćkowiak
 * @see http://www.mateuszmackowiak.art.pl/blog
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.alert
{
	import flash.events.Event;
	
	public class NativeAlertEvent extends Event
	{
		public static const CLOSE:String = "ALERT_CLOSED";
		
		private var _index:String;
		
		public function NativeAlertEvent(type:String, index:String, bubbles:Boolean=false, cancelable:Boolean=false)
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
			return new NativeAlertEvent(type,_index);
		}
	}
}