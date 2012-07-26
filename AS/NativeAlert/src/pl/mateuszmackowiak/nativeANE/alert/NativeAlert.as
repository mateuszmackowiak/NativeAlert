/** 
* @author Mateusz Maćkowiak
* @see http://mateuszmackowiak.wordpress.com/
* @since 2011
*  this class is based on a project by Liquid-Photo
* @see http://www.liquid-photo.com/2011/10/28/native-extension-for-adobe-air-and-ios-101/
*/
package pl.mateuszmackowiak.nativeANE.alert
{
	
	
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	

		
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
		public static const ANDROID_DEVICE_DEFAULT_DARK_THEME:int = 0x00000004;
		/**
		 *  use the device's default alert theme with a dark background.
		 * <br>Constant Value: 5 (0x00000005)
		 */
		public static const ANDROID_DEVICE_DEFAULT_LIGHT_THEME:int = 0x00000005;
		/**
		 * use the holographic alert theme with a dark background
		 * <br>Constant Value: 2 (0x00000002)
		 */
		public static const ANDROID_HOLO_DARK_THEME:int = 0x00000002;
		/**
		 * use the holographic alert theme with a light background
		 * <br>Constant Value: 3 (0x00000003)
		 */
		public static const ANDROID_HOLO_LIGHT_THEME:int = 0x00000003;
		/**
		 * use the traditional (pre-Holo) alert dialog theme
		 * <br>Constant Value: 1 (0x00000001)
		 */
		public static const DEFAULT_THEME:int = 0x00000001;
		
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
		private static var _defaultTheme:uint = DEFAULT_THEME;
		//---------------------------------------------------------------------
		//
		// public Properties.
		//
		//---------------------------------------------------------------------
		private var _title:String="";
		private var _message:String="";
		private var _closeLabel:String="OK";
		private var _otherLabels:String ="";
		
		/**
		 * @private
		 */
		private var _isShowing:Boolean=false;
		private var _theme:int = -1;


		private var _closeHandler:Function=null;
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
		public function NativeAlert(theme:int=-1)
		{
			if(!isNaN(theme) && theme>-1)
				_theme = theme;
			else
				_theme = _defaultTheme;
			
			
			
			if(context==null){
				try{
					context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				}catch(e:Error){
					showError(e.message,e.errorID);
				}
			}
			
		}
		
		override public function willTrigger(type:String):Boolean{
			if(type == ErrorEvent.ERROR)
				return context.willTrigger(type);
			else
				return super.willTrigger(type);
		}
		override public function hasEventListener(type:String):Boolean{
			if(type == ErrorEvent.ERROR)
				return context.hasEventListener(type);
			else
				return super.hasEventListener(type);
		}
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			if(type == ErrorEvent.ERROR)
				context.addEventListener(type,listener,useCapture,priority,useWeakReference);
			else
				super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			if(type == ErrorEvent.ERROR)
				context.removeEventListener(type,listener,useCapture);
			else
				super.removeEventListener(type,listener,useCapture);
		}
		
		
		
		/**
		 * 
		 */
		public function set closeHandler(value:Function):void
		{
			
			if(_closeHandler!=null && hasEventListener(NativeDialogEvent.CLOSED))
				removeEventListener(NativeDialogEvent.CLOSED,_closeHandler);
			_closeHandler = value;
			if(value!=null)
				addEventListener(NativeDialogEvent.CLOSED,value);
		}
		/**
		 * @private
		 */
		public function get closeHandler():Function
		{
			return _closeHandler;
		}
		
		/**
		 * list of buttons as a string with comma as separator
		 */
		public function set otherLabels(value:String):void
		{
			_otherLabels = value;
		}
		/**
		 * @private
		 */
		public function get otherLabels():String
		{
			return _otherLabels;
		}

		
		
		/**
		 * cancle button for the alert
		 * @sefault "OK"
		 */
		public function set closeLabel(value:String):void
		{
			_closeLabel = value;
		}
		/**
		 * @private
		 */
		public function get closeLabel():String
		{
			return _closeLabel;
		}


		/**
		 * The title of the dialog
		 */
		public function set title(value:String):void
		{
			_title = value;
		}
		/**
		 * The title of the dialog
		 */
		public function get title():String
		{
			return _title;
		}

		
		/**
		 * the theme of the NativeProgress
		 * (if isShowing will be ignored until next show)
		 */
		public function set theme(value:int):void
		{
			if(!isNaN(value))
				_theme = value;
			else
				_theme = _defaultTheme;
		}
		/**
		 * @private
		 */
		public function get theme():int
		{
			return _theme;
		}
		
		/**
		 * The message of the dialog
		 */
		public function set message(value:String):void
		{
			_message = value;
		}
		/**
		 * The message of the dialog
		 * @see setMessage()
		 */
		public function get message():String
		{
			return _message;
		}
		
		
		/**
		 * Should be called in the end if You know that there will be now reference to NativeAlert
		 * @copy flash.external.ExtensionContext.dispose()
		 * @see flash.external.ExtensionContext.dispose()
		 */
		public static function dispose():void{
			try{
				if(context){
					context.dispose();
					context = null;
				}
			}catch(e:Error){
				showError("Error calling dispose method "+e.message,e.errorID);
			}
		}
			
		/**
		 * @param title Title to be displayed in the Alert.
		 * @param cancelable if pressing outside the dialog or the back button hides the popup 
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.defaultTheme
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlert.show
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlertEvent
		 */
		public function show(cancelable:Boolean = true) : Boolean
		{
			try{
				if(!_title)
					_title="";
				if(!_closeLabel && (!otherLabels || otherLabels==""))
					_closeLabel ="OK";
				if(!otherLabels)
					otherLabels="";
				if(!_message)
					_message="";
				
				context.addEventListener(StatusEvent.STATUS, onAlertHandler);
				context.call("showAlertWithTitleAndMessage", _title, _message, _closeLabel, _otherLabels, cancelable, _theme);
				return true;
			}catch(e:Error){
				showError("While showAlertWithTitleAndMessage  "+e.message,e.errorID);
			}
			return false;
		}
		
		

		
		
		/**
		 * the default theme of all NativeProges dialogs
		 * @default pl.mateuszmackowiak.nativeANE.progress.NativeProgess#DEFAULT_THEME
		 */
		public static function set defaultTheme(value:int):void
		{
			_defaultTheme = value;
		}
		/**
		 * @private
		 */
		public static function get defaultTheme():int
		{
			return _defaultTheme;
		}
		
		
		/**
		 * Create and show an Alert control
		 * @param text     Text showed in the Alert control
		 * @param title    Title of the Alert control
		 * @param closeLabel Text of the default button
		 * @param otherLabels Text of the other buttons. Sepperated with "," adds aditional buttons in the close event answer is the string representing the label
		 * @param closeHandler  Close function callback (NativeAlertEvent)
		 * @param cancelable - on back button or outside relese closes with index -1 (only Android)
		 * @param androidTheme - default -1 uses the defaultAndroidTheme 
		 * 
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeAlertEvent
		 */
		public static function show(message:String = "", title:String = "Error", closeLabel : String="OK", otherLabels : String = "" , closeHandler:Function = null ,cancelable:Boolean = true, theme:int = -1):NativeAlert
		{
			var alert:NativeAlert = new NativeAlert(theme);
			if (closeHandler !== null){
				alert.closeHandler = closeHandler;
			}
			alert.title = title;
			alert.message = message;
			alert.closeLabel = closeLabel;
			alert.otherLabels = otherLabels;
			alert.show(cancelable);

			return alert;
		}
		
		
		protected static function isIOS():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("ip")>-1;
		}
		protected static function isAndroid():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("linux")>-1;
		}
		protected static function isWindows():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("win")>-1;
		}
		/**
		 * Whether NativeAlert class is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(isIOS() || isWindows() || isAndroid())
				return true;
			else 
				return false;
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
			if( event.code == NativeDialogEvent.CLOSED || event.code =="ALERT_CLOSED")
			{
				(event.target as ExtensionContext).removeEventListener( StatusEvent.STATUS, onAlertHandler );
				event.stopImmediatePropagation();
				var level:int = int(event.level);
				if(isWindows())
					level--;
				
				if(hasEventListener(NativeDialogEvent.CLOSED)){
					if(!dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,level.toString())) && _closeHandler!=null){
						removeEventListener(NativeDialogEvent.CLOSED,_closeHandler);
						_closeHandler = null;
						dispose();
					}
				}
			}else{
				showError(event.toString());
			}
		}

		
		/**
		 * @private
		 */
		private static function showError(message:String,id:int=0):void
		{
			if(context.hasEventListener(ErrorEvent.ERROR))
				context.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,message,id));
			else
				trace(message);
		}
		
		
		
		
		
		
		
		
		
		[Deprecated(replacement="pl.mateuszmackowiak.nativeANE.properties.SystemProperties.getInstance().isBadgeSupported()")] 
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
		[Deprecated(replacement="pl.mateuszmackowiak.nativeANE.properties.SystemProperties.getInstance().badge")] 
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
				trace(e.message,e.errorID);
			}
		}
		
		public static function get badge():uint
		{
			try{
				if(context==null)
					context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				return context.call("getBadge") as uint;
			}catch(e:Error){
				trace(e.message,e.errorID);
			}
			return NaN;
		}
	}
}