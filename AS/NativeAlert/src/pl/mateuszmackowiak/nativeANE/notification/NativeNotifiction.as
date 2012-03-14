/** @author Mateusz Maćkowiak
* @see http://mateuszmackowiak.wordpress.com/
* @since 2011
 */
package pl.mateuszmackowiak.nativeANE.notification
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	
	public class NativeNotifiction extends EventDispatcher
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		/**
		 * the id of the extension that has to be added in the descriptor file
		 */
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		/**
		 * defines the default sound 
		 */
		public static const DEFAULT_SOUND:String = "defaultSound";
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		private static var context:ExtensionContext;
		
		
		
		/*public function NativeNotifiction()
		{
			if(context==null){
				try{
					context = ExtensionContext.createExtensionContext(EXTENSION_ID, "LocalNotification");
				}catch(e:Error){
					showError(e.message,e.errorID);
				}
			}
		}*/
		
		public static function notifi(message:String,fireDate:Date=null,lounchButtonLabel:String="Launch",soundURL:String=null):void
		{
			if(message==null)
				return;
			if(lounchButtonLabel==null)
				lounchButtonLabel = "";
			
			var fireDateTimestamp:Number=-1;
			if(fireDate!=null){
				fireDateTimestamp = dateToIOSTimestamp(fireDate);
			}
			try{
				if(context==null)
					context = ExtensionContext.createExtensionContext(EXTENSION_ID, "LocalNotification");
				context.call("showNotification",message,lounchButtonLabel,fireDateTimestamp,soundURL);
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
		private static function dateToIOSTimestamp(date:Date):Number
		{
			if(date==null)
				return -1;
			var u:Number = date.time/1000;//-(date.timezoneOffset*60)+0.1;
			return u;
		}
	
		
		public static function dispose():void
		{
			if(context)
				context.dispose();
		}
		/**
		 * Whether NativeNotifiction class is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(Capabilities.os.toLowerCase().indexOf("ip")>-1 )
				return true;
			else 
				return false;
		}
		/**
		 * @private
		 */
		private static function showError(message:String,id:int=0):void
		{
			trace(message);
		}
	}
}