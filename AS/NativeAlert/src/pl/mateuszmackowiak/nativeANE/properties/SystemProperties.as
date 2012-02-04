package pl.mateuszmackowiak.nativeANE.properties
{
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	public class SystemProperties
	{
		public static const OS:String = 'os';
		public static const JAVA_NUMBER:String = 'java';
		public static const LANGUAGE:String = 'language';
		public static const ARCHITECTURE:String = 'arch';
		public static const VERSION:String = 'version';
		
		public static const PACKAGE_NAME:String = 'packageName';
		public static const PACKAGE_DIRECTORY:String = 'sourceDir';
		public static const APP_UID:String = 'AppUid';
		public static const UID:String = 'UID';
		
		public static function getAndroidProperites():Dictionary
		{
			try{
				var context:ExtensionContext = ExtensionContext.createExtensionContext('pl.mateuszmackowiak.nativeANE.NativeAlert','SystemProperites');
				return context.call('getSystemProperty') as Dictionary;
				context.dispose();
			}catch(e:Error){
				trace(e.message);
			}
			return null;
		}
		public static function isSupported():Boolean{
			if(Capabilities.os.indexOf("Linux")>-1)
				return true;
			else
				return false;
		}
	}
}