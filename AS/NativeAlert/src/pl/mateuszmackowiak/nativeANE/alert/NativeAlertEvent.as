/** @author Mateusz Maćkowiak
 * @see http://www.mateuszmackowiak.art.pl/blog
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.alert
{
	import flash.events.Event;
	
	public class NativeAlertEvent extends Event
	{
		
		/**
		 * event type when window closes
		 */
		public static const CLOSE:String = "ALERT_CLOSED";
		
		/**
		 * @private
		 */
		private var _index:String;
		
		/**
		 * The dispached event of closed winodw
		 */
		public function NativeAlertEvent(type:String, index:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			super(type, bubbles, cancelable);
		}
		/**
		 * the index of the pressed button
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
			return new NativeAlertEvent(type,_index);
		}
	}
}