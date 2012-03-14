/** 
* @author Mateusz Maćkowiak
* @see http://mateuszmackowiak.wordpress.com/
* @since 2011
*  this class is based on a project by Liquid-Photo
* @see http://www.liquid-photo.com/2011/10/28/native-extension-for-adobe-air-and-ios-101/
*/
package pl.mateuszmackowiak.nativeANE.alert
{
	
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	

		
	/**
	 * Simple NativeAlert extension that allows you to
	 * Open device specific alerts and recieve information about
	 * what button the user pressed to close the alert.
	 * Dispatches NativeAlertEvent
	 * @author Mateusz Maćkowiak
	 * @see http://mateuszmackowiak.wordpress.com/
	 * @since 2011
	 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlertEvent
	 */
	public class NativeAlert extends EventDispatcher
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
		 * use the device's default alert theme with a dark background
		 * <br>Constant Value: 4 (0x00000004)
		 */
		public static const THEME_DEVICE_DEFAULT_DARK:int = 0x00000004;
		/**
		 *  use the device's default alert theme with a dark background.
		 * <br>Constant Value: 5 (0x00000005)
		 */
		public static const THEME_DEVICE_DEFAULT_LIGHT:int = 0x00000005;
		/**
		 * use the holographic alert theme with a dark background
		 * <br>Constant Value: 2 (0x00000002)
		 */
		public static const THEME_HOLO_DARK:int = 0x00000002;
		/**
		 * use the holographic alert theme with a light background
		 * <br>Constant Value: 3 (0x00000003)
		 */
		public static const THEME_HOLO_LIGHT:int = 0x00000003;
		/**
		 * use the traditional (pre-Holo) alert dialog theme
		 * <br>Constant Value: 1 (0x00000001)
		 */
		public static const THEME_TRADITIONAL:int = 0x00000001;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		private static var context:ExtensionContext;
		/**
		 * @private
		 */
		private static var _theme:int = THEME_HOLO_LIGHT;
		
		//---------------------------------------------------------------------
		//
		// public Properties.
		//
		//---------------------------------------------------------------------
		public var title:String="";
		public var message:String="";
		public var closeLabel:String="";
		public var otherLabels:String ="";
		/**
		 * @private
		 */
		private var androidTheme:int = -1;
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * @author Mateusz Maćkowiak
		 * @see http://mateuszmackowiak.wordpress.com/
		 * @since 2011
		 *  this class is based on a project by Liquid-Photo
		 * @see http://www.liquid-photo.com/2011/10/28/native-extension-for-adobe-air-and-ios-101/
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlertEvent
		 */
		public function NativeAlert()
		{
			if(context==null){
				try{
					context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				}catch(e:Error){
					showError(e.message,e.errorID);
				}
			}
		}
		/**
		 * Should be called in the end if You know that there will be now reference to NativeAlert
		 * @copy flash.external.ExtensionContext.dispose()
		 * @see flash.external.ExtensionContext.dispose()
		 */
		public static function dispose():void{
			if(context){
				context.dispose();
			}
		}
			
		/**
		 * @param title Title to be displayed in the Alert.
		 * @param message Message to be displayed in the Alert.
		 * @param closeLabel Label for the close button.(NativeAlertEvent)
		 * @param otherLabels shoud be a comma separated sting of button labels.<br>for example "one,two,three"
		 * @param androidTheme - default -1 uses the defaultAndroidTheme 
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.defaultAndroidTheme
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.show
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlertEvent
		 */
		public function showAlert( title : String ="", message : String ="", closeLabel : String ="OK", otherLabels : String = "" ,cancelable:Boolean = true,androidTheme:int = -1) : void
		{
			try{
				if(title!==null && title!=="")
					this.title = title;
				if(message!==null && message!=="")
					this.message = message;
				if(closeLabel!==null && closeLabel!=="")
					this.closeLabel = closeLabel;
				if(otherLabels!==null && otherLabels!=="")
					this.otherLabels = otherLabels;
				if(androidTheme>-1)
					this.androidTheme = androidTheme;
				else
					this.androidTheme = _theme;
				
				context.addEventListener(StatusEvent.STATUS, onAlertHandler);
				
				if(Capabilities.os.indexOf("Linux")>-1)
					context.call("showAlertWithTitleAndMessage", this.title, this.message, this.closeLabel,this.otherLabels, cancelable, this.androidTheme);
				else
					context.call("showAlertWithTitleAndMessage", this.title, this.message, this.closeLabel,this.otherLabels);
				
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
		
		/**
		 * the theme from which to get the dialog's style (one of the constants THEME_DEVICE_DEFAULT_DARK, THEME_DEVICE_DEFAULT_LIGHT, or THEME_HOLO_LIGHT.
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.THEME_DEVICE_DEFAULT_DARK
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.THEME_DEVICE_DEFAULT_LIGHT
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.THEME_HOLO_LIGHT
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.THEME_HOLO_DARK
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.THEME_TRADITIONAL
		 */
		public static function set defaultAndroidTheme(value:int):void
		{
			_theme = value;
		}
		public static function get defaultAndroidTheme():int
		{
			return _theme;
		}
		/**
		 * Create and show an Alert control
		 * @param text     Text showed in the Alert control
		 * @param title    Title of the Alert control
		 * @param closeLabel Text of the default button (work on IOS)
		 * @param otherLabels Text of the other buttons. Sepperated with "," adds aditional buttons (work on IOS) in the close event answer is the string representing the label
		 * @param closeHandler  Close function callback (NativeAlertEvent)
		 * @param cancelable - on back button or outside relese closes with index -1
		 * @param androidTheme - default -1 uses the defaultAndroidTheme 
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlertEvent
		 */
		public static function show(message:String = "", title:String = "Error", closeLabel : String="OK", otherLabels : String = "" , closeHandler:Function = null ,cancelable:Boolean = true, androidTheme:int = NaN):NativeAlert
		{
				try{
					var alert:NativeAlert = new NativeAlert();
					if (closeHandler !== null)
						alert.addEventListener(NativeAlertEvent.CLOSE, closeHandler);
					alert.showAlert(title,message,closeLabel,otherLabels,cancelable,androidTheme);
		
					return alert;
				}catch(e:Error){
					showError(e.message,e.errorID);
				}
			return null;
		}
		
		/**
		 * Whether NativeAlert class is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(Capabilities.os.toLowerCase().indexOf("ip")>-1 || Capabilities.os.toLowerCase().indexOf("win")>-1 || Capabilities.os.toLowerCase().indexOf("linux")>-1)
				return true;
			else 
				return false;
		}
		/**
		 * Whether the badge is available on the device (true);<br>otherwise false
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.badge
		 */
		public static function isBadgeSupported():Boolean
		{
			if(Capabilities.os.toLowerCase().indexOf("ip")>-1)
				return true;
			else 
				return false;
		}
		
		/**
		 * The number currently set as the badge of the application icon in Springboard
		 * <br>Set to 0 (zero) to hide the badge number. The default is 0.
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.isBadgeSupported
		 */
		public static  function set badge(value:uint):void
		{
			if(isNaN(value))
				return;
			try{
				if(context==null)
					context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				context.call("setBadge",value);
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
		public static function get badge():uint
		{
			try{
				if(context==null)
					context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				return context.call("getBadge") as uint;
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
			return NaN;
		}
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 * When the Alert closes in the device we will redispatch the event
		 * through ActionScript so that we can handle the user interaction.
		 * The event will contain the index of the button that the user selected.
		 */
		private function onAlertHandler( event : StatusEvent ) : void
		{
			try{
				(event.target as ExtensionContext).removeEventListener( StatusEvent.STATUS, onAlertHandler );
				
				if( event.code == NativeAlertEvent.CLOSE)
				{
					var level:int = int(event.level);
					if(Capabilities.os.indexOf("Win")>-1)
						level--;
					dispatchEvent(new NativeAlertEvent(NativeAlertEvent.CLOSE,level.toString()));
				}else{
					showError(event.toString());
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
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