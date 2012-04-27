package pl.mateuszmackowiak.nativeANE.properties
{
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	/**
	 * SystemProperties class can provide some of the missing properties that You can’t get in adobe air
	 * @author Mateusz Maćkowiak
	 * @see http://www.mateuszmackowiak.art.pl/blog
	 * @since 2011
	 */
	public class SystemProperties
	{
		/**
		 * IOS / Android
		 */
		public static const OS:String = 'os';
		/**
		 * Android
		 */
		public static const LANGUAGE:String = 'language';
		/**
		 * Android
		 */
		public static const ARCHITECTURE:String = 'arch';
		/**
		 * IOS / Android
		 */
		public static const VERSION:String = 'version';
		/**
		 * Android
		 */
		public static const PACKAGE_NAME:String = 'packageName';
		/**
		 * Android
		 */
		public static const PACKAGE_DIRECTORY:String = 'sourceDir';
		/**
		 * Android
		 */
		public static const APP_UID:String = 'AppUid';
		
		/**
		 * IOS / Android
		 */
		public static const UID:String = (Capabilities.os.toLowerCase().indexOf("iph")>-1)?'UDID':'UID';

		
		/**
		 * IOS / Android
		 */
		public static const NAME:String = 'name';
		
		/**
		 * IOS / Android
		 */
		public static const MAC_ADRESS:String = 'MACAdress';
		
		/**
		 * IOS
		 */
		public static const LOCALIZED_MODEL:String = 'localizedModel';
		
		/**
		 * 
		 */
		public static function getProperites():Dictionary
		{
			try{
				var context:ExtensionContext = ExtensionContext.createExtensionContext('pl.mateuszmackowiak.nativeANE.NativeAlert','SystemProperites');
				const d:Dictionary = context.call('getSystemProperty') as Dictionary;
				context.dispose();
				return d;
			}catch(e:Error){
				trace(e.message);
				if(context!=null)
					context.dispose();
			}
			return null;
		}
		
		/**
		 * If the extension is available on the device (true);<br>otherwise false
		 */
		public static function isSupported():Boolean{
			if(Capabilities.os.indexOf("Linux")>-1 || Capabilities.os.indexOf("iPhone")>-1)
				return true;
			else
				return false;
		}
	}
}