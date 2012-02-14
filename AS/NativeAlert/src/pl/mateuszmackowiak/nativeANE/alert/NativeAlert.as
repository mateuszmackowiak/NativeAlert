/** 
* @author Mateusz Maćkowiak
* @see http://www.mateuszmackowiak.art.pl/blog
* @since 2011
*  this project is based on a project by Liquid-Photo
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
	 */
	public class NativeAlert extends EventDispatcher
	{
		
		
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		
		public static const THEME_DEVICE_DEFAULT_DARK:int = 0x00000004;
		public static const THEME_DEVICE_DEFAULT_LIGHT:int = 0x00000005;
		public static const THEME_HOLO_DARK:int = 0x00000002;
		public static const THEME_HOLO_LIGHT:int = 0x00000003;
		public static const THEME_TRADITIONAL:int = 0x00000001;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		private static var context:ExtensionContext;
		private static var _set:Boolean = false;
		private static var _isSupp:Boolean = false;
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
		private var androidTheme:int = -1;
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * @author Mateusz Maćkowiak
		 * @see http://www.mateuszmackowiak.art.pl/blog
		 * @since 2011
		 *  this project is based on a project by Liquid-Photo
		 * @see http://www.liquid-photo.com/2011/10/28/native-extension-for-adobe-air-and-ios-101/
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

		public static function dispose():void{
			if(context){
				context.dispose();
			}
		}
			
		/**
		 * @param title Title to be displayed in the Alert.
		 * @param message Message to be displayed in the Alert.
		 * @param closeLabel Label for the close button.
		 * @param otherLabels shoud be a comma separated sting of button labels.
		 * for example "one,two,three"
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
				if(androidTheme==THEME_DEVICE_DEFAULT_DARK || androidTheme==THEME_DEVICE_DEFAULT_LIGHT || androidTheme==THEME_HOLO_DARK || androidTheme==THEME_HOLO_LIGHT || androidTheme==THEME_TRADITIONAL)
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
		 * @param closeHandler  Close function callback
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
		 * Whether a Notification system is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(!_set){// checks if a value was set before
				try{
					_set = true;
					if(context==null)
						context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
					_isSupp = context.call("isSupported");
				}catch(e:Error){
					showError(e.message,e.errorID);
					return _isSupp;
				}
			}	
			return _isSupp;
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

		
		
		private static function showError(message:String,id:int=0):void
		{
			trace(message);
		}
	}
}