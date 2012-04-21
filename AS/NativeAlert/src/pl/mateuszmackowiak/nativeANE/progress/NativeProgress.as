/** 
 * @author Mateusz Maćkowiak
 * @see http://www.mateuszmackowiak.art.pl/blog
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.progress
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;

	
	/** 
	 * @author Mateusz Maćkowiak
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridHorizontalDefaultTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridHorizontalHaloDarkTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridHorizontalIndeterminateDefaultTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridHorizontalIndeterminateHaloDarkTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridSpinnerDefaultTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressAndoridSpinnerHaloLightTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressIOSHorizontal.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressIOSSpinner.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeProgressIOS_SVHUD_Theme.png"></img>
	 * @see http://mateuszmackowiak.wordpress.com/
	 */
	public class NativeProgress extends EventDispatcher
	{
		//---------------------------------------------------------------------
		//
		// Public Static Constants
		//
		//---------------------------------------------------------------------
		public static const STYLE_HORIZONTAL:uint = 0x00000001;
		public static const STYLE_SPINNER:uint = 0x00000000;
		
		
		public static const ANDROID_DEVICE_DEFAULT_DARK_THEME:uint = 0x00000004;
		public static const ANDROID_DEVICE_DEFAULT_LIGHT_THEME:uint = 0x00000005;
		public static const ANDROID_HOLO_DARK_THEME:uint = 0x00000002;
		public static const ANDROID_HOLO_LIGHT_THEME:uint = 0x00000003;
		/**
		 * uses : SVProgressHUD
		 * @see http://github.com/samvermette/SVProgressHUD
		 */
		public static const IOS_SVHUD_BLACK_BACKGROUND_THEME:uint=0x00000002;
		/**
		 * uses : SVProgressHUD
		 * @see http://github.com/samvermette/SVProgressHUD
		 */
		public static const IOS_SVHUD_NON_BACKGROUND_THEME:uint=0x00000003;
		/**
		 * uses : SVProgressHUD
		 * @see http://github.com/samvermette/SVProgressHUD
		 */
		public static const IOS_SVHUD_GRADIENT_BACKGROUND_THEME:uint=0x00000004;
		
		/**
		 * the default style for bouth IOS and Android devices 
		 */
		public static const DEFAULT_THEME:uint = 0x00000001;
		
		
		//---------------------------------------------------------------------
		//
		// Private Static Constants
		//
		//---------------------------------------------------------------------
		private static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		private static const showProgressPopup:String = "showProgressPopup";
		//---------------------------------------------------------------------
		//
		// Private Static Variables
		//
		//---------------------------------------------------------------------

		private static var _defaultAndroidTheme:uint = DEFAULT_THEME;
		private static var _defaultIOSTheme:uint = DEFAULT_THEME;
		private static var _set:Boolean = false;
		private static var _isSupp:Boolean = false;
		private static var isAndroid:Boolean=false;
		private static var isIOS:Boolean=false;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		private var context:ExtensionContext;
		private var _progress:int=0;
		private var _secondary:int=NaN;
		private var _title:String="";
		private var _message:String = "";
		private var _style:uint = STYLE_SPINNER;
		private var _androidTheme:int = -1;
		private var _iosTheme:int = -1;
		private var _maxProgress:int  = 100;
		private var _indeterminate:Boolean = false;
		private var _isShowing:Boolean=false;
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * @author Mateusz Maćkowiak
		 * @since 2011
		 * @param defined style of the progress dialog <code>STYLE_HORIZONTAL</code> or <code>STYLE_SPINNER</code> - also defined by <i>style</i> or <i>indeterminate</i> can be ignored. By default set to <code>STYLE_HORIZONTAL</code>
		 * @param android theme for progoress dialog. If NaN uses <code>defaultAndroidTheme</code>
		 * @param theme for progoress dialog. If NaN uses <code>defaultIOSTheme</code>
		 * @throws Error if not supported or native files not packaged
		 * @playerversion 3.0
		 */
		public function NativeProgress(style:int = 0x00000000,androidTheme:uint=NaN,iosTheme:uint=NaN)
		{
			if(Capabilities.os.toLowerCase().indexOf("linux")>-1)
				isAndroid = true;
			else if(Capabilities.os.toLowerCase().indexOf("iph")>-1)
				isIOS = true;
			else{
				trace("NativeProgress is not supported on this platform");
				return;
			}
				
			if(style == STYLE_HORIZONTAL || style==STYLE_SPINNER)
				_style = style;

			if(!isNaN(androidTheme))
				_androidTheme = androidTheme;
			else
				_androidTheme = _defaultAndroidTheme;
			if(!isNaN(iosTheme))
				_iosTheme = iosTheme;
			else
				_iosTheme = _defaultIOSTheme;
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, "ProgressContext");
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				throw new Error("Error initiating contex of the extension: "+e.message,e.errorID);
			}
		}
		
		

		/**
		 * shows the nativeProgress dialog
		 * @param cancleble if pressing outside the popup or the back button hides the popup
		 * @param indeterminate if the progressbar should indicate indeterminate values (on IOS shows with <code>STYLE_SPINNER</code>)
		 * @return if call sucessfull
		 */
		public function show(cancleble:Boolean=false,indeterminate:Object=null):Boolean
		{
			if(indeterminate!==null)
				_indeterminate = indeterminate;
			try{
				if(isAndroid){
					context.call(showProgressPopup,"showPopup",_progress,_secondary,_style,_title,_message,cancleble,_indeterminate,_androidTheme);
					_isShowing = true;
					return true;
				}
				else if(isIOS){
					context.call(showProgressPopup,_progress/_maxProgress,null,_style,_title,_message,cancleble,_indeterminate,_iosTheme);
					_isShowing = true;
					return true;
				}
				return false;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		/**
		 * shows the nativeProgress dialog with a Horizontal style progress bar
		 * @param cancleble if pressing outside the popup or the back button hides the popup 
		 * @return if call sucessfull
		 */
		public function showHorizontal(cancleble:Boolean=false):Boolean
		{
			_indeterminate = true;
			try{
				if(isAndroid){
					context.call(showProgressPopup,"showPopup",_progress,_secondary,STYLE_HORIZONTAL,_title,_message,cancleble,true,_androidTheme);
					_isShowing = true;
					return true;
				}
				else if(isIOS){
					context.call(showProgressPopup,_progress,null,STYLE_HORIZONTAL,_title,_message,cancleble,true);
					_isShowing = true;
					return true;
				}
				return false;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		
		/**
		 * shows the nativeProgress dialog with a spinner style progress indicator
		 * @param cancleble if pressing outside the popup or the back button hides the popup
		 * @return if call sucessfull
		 */
		public function showSpinner(cancleble:Boolean=false):Boolean
		{
			try{
				if(isAndroid){
					context.call(showProgressPopup,"showPopup",_progress,_secondary,STYLE_SPINNER,_title,_message,cancleble,false,_androidTheme);
					_isShowing = true;
					return true;
				}
				else if(isIOS){
					context.call(showProgressPopup,_progress,null,STYLE_SPINNER,_title,_message,cancleble,true,_iosTheme);
					_isShowing = true;
					return true;
				}
				return false;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		
		/**
		 * If style set to <code>STYLE_HORIZONTAL</code> defines if progressbar shows indeterminate values. Otherwise it is ignored.
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 */
		public function setIndeterminate(value:Boolean):Boolean{
			if(_indeterminate!==value  && value>=0 && value<= _maxProgress){
				_indeterminate = value;
				if(isAndroid && _isShowing){
					try{
						context.call(showProgressPopup,"setIndeterminate",value);
						return true;
					}catch(e:Error){
						showError("Error setting setIndeterminate "+e.message,e.errorID);
					}
				}
			}
			return false;
		}
		/**
		 * If progressbar shows indeterminate values. Only if style set to <code>STYLE_HORIZONTAL</code>
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @see setIndeterminate()
		 */
		public function get indeterminate():Boolean{
			return _indeterminate;
		}
		
		
		/**
		 * Sets the value of the second values in progressbar. Only if style set to <code>STYLE_HORIZONTAL</code>
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 */
		public function setSecondaryProgress(value:int):Boolean{
			if(_secondary!==value  && value>=0 && value<= _maxProgress){
				_secondary = value;
				if(isAndroid && _isShowing){
					try{
						context.call(showProgressPopup,"setSecondary",value);
						return true;
					}catch(e:Error){
						showError("Error setting secondary progress "+e.message,e.errorID);
					}
				}
			}
			return false;
		}
		/**
		 * The second vaule of the progressbar
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @see setSecondaryProgress()
		 */
		public function get secondaryProgress():int{
			return _secondary;
		}
		
		
		
		/**
		 * Sets the value of the values in progressbar. Only if style set to <code>STYLE_HORIZONTAL</code>
		 * @return if call sucessfull
		 */
		public function setProgress(value:int):Boolean{
			if(!isNaN(value) && _progress!==value  && value>=0 && value<= _maxProgress){
				_progress = value;
				try{
					if(_isShowing){
						if(isAndroid)
							context.call(showProgressPopup,"update",value);
						else
							context.call("updateProgress",value/_maxProgress);
						return true;
					}
				}catch(e:Error){
					showError("Error setting progress "+e.message,e.errorID);
				}
			}
			return false;
		}
		/**
		 * The vaule of the progressbar
		 * @see setProgress()
		 */
		public function get progress():int{
			return _progress;
		}
		
		
		
		/**
		 * Sets the Max value of the second values in progressbar. Only if style set to <code>STYLE_HORIZONTAL</code>
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 */
		public function setMax(value:int):Boolean{
			if(_maxProgress!==value){
				_maxProgress= value;
				if(_progress>value)
					_progress = value;
				if(_secondary>value)
					_secondary = value;
				if(!isNaN(value) && _isShowing){
					try{
						if(isAndroid)
							context.call(showProgressPopup,"max",value);
						if(_progress>value)
							_progress = value;
						
						return true;
					}catch(e:Error){
						showError("Error setting MAX "+e.message,e.errorID);
					}
				}
			}
			return false;
		}
		/**
		 * The Max vaule of the progressbar
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @see setMax()
		 */
		public function get max():int{
			return _maxProgress;
		}
		
		
		
		
		/**
		 * The message of the dialog
		 * @return if call sucessfull
		 */
		public function setMessage(value:String):Boolean
		{
			if(value!==_message){
				_message = value;
				try{
					if(_isShowing){
						if(isAndroid)
							context.call(showProgressPopup,"setMessage",value);
						else
							context.call("updateMessage",value);
						return true;
					}
				}catch(e:Error){
					showError("Error setting message "+e.message,e.errorID);
				}
			}
			return false;
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
		 * The title of the dialog
		 * @return if call sucessfull
		 */
		public function setTitle(value:String):Boolean
		{
			if(value!==_title){
				_title = value;
				try{
					if(isAndroid){
						context.call(showProgressPopup,"setTitle",value);
						return true;
					}else{
						context.call("updateTitle",value);
						return true;
					}
					return false;
				}catch(e:Error){
					showError("Error setting title "+e.message,e.errorID);
				}
			}
			return false;
		}
		/**
		 * The title of the dialog
		 * @see setTitle()
		 */
		public function get title():String
		{
			return _title;
		}
		
		
		
		
		/**
		 * if the dialog is showing
		 */
		public function isShowing():Boolean{
			if(context){
				if(isAndroid){
					const b:Boolean = context.call(showProgressPopup,"isShowing");
					_isShowing = b;
					return b;
				}else if(isIOS){
					const b2:Boolean = context.call("isShowing");
					_isShowing = b2;
					return b2;
				}
			}
			return false;
				
		}
		
		/**
		 * the theme of the NativeProgress
		 * (if isShowing will be ignored until next show)
		 */
		public function set androidTheme(value:int):void
		{
			if(!isNaN(value))
				_androidTheme = value;
			else
				_androidTheme = _defaultAndroidTheme;
		}
		/**
		 * @private
		 */
		public function get androidTheme():int
		{
			return _androidTheme;
		}
		
		/**
		 * the theme of the NativeProgress
		 * (if isShowing will be ignored until next show)
		 */
		public function set iosTheme(value:int):void
		{
			if(!isNaN(value))
				_iosTheme = value;
			else
				_iosTheme = _defaultIOSTheme;
		}
		/**
		 * @private
		 */
		public function get iosTheme():int
		{
			return _iosTheme;
		}
		
		/**
		 * hides the dialog if is showing and dispaches NativeDialogEvent.CANCELED
		 * @param message message displayed after closing progress popup <b>ONLY IOS </b> else ignore
		 * @param error if the message will be displayed with success icon or error icon <b>ONLY IOS </b> else ignored
		 * @return if call sucessfull
		 */
		public function hide(message:String=null,error:Boolean=false):Boolean
		{
			try{
				_isShowing = false;
				
				if(context){
					if(isAndroid){
						context.call(showProgressPopup,"hide");
					}else {
						if(message!=null)
							context.call("hide",message,error);
						else
							context.call("hide");
					}
					return true;
				}
			}catch(e:Error){
				showError("Error calling hide method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		/**
		 * Disposes of this ExtensionContext instance.<br><br>
		 * The runtime notifies the native implementation, which can release any associated native resources. After calling <code>dispose()</code>,
		 * the code cannot call the <code>call()</code> method and cannot get or set the <code>actionScriptData</code> property.
		 */
		public function dispose():Boolean
		{
			try{
				_isShowing = false;
				context.dispose();
				return true;
			}catch(e:Error){
				showError("Error calling dispose method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		//---------------------------------------------------------------------
		//
		// Public Static Methods.
		//
		//---------------------------------------------------------------------
		/**
		 * Whether the extension is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(!_set){// checks if a value was set before
				try{
					_set = true;
					if(Capabilities.os.indexOf("Linux")>-1){
						isAndroid = true;
						var context:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "ProgressContext");
						_isSupp = context.call("isSupported")==true;
						context.dispose();
					}else if(Capabilities.os.toLowerCase().indexOf("ip")>-1)
					{
						context = ExtensionContext.createExtensionContext(EXTENSION_ID,null);
						_isSupp = context.call("isSupported")==true;
						context.dispose();
					}
					else
						_isSupp = false;
				}catch(e:Error){
					trace("NativeProcess Extension is not supported on this platform");
					return _isSupp;
				}
			}	
			return _isSupp;
		}
		
		/**
		 * the andorid default theme of all NativeProges dialogs
		 * @default pl.mateuszmackowiak.nativeANE.progress.NativeProgess#DEFAULT_THEME
		 */
		public static function set defaultAndroidTheme(value:int):void
		{
			_defaultAndroidTheme = value;
		}
		/**
		 * @private
		 */
		public static function get defaultAndroidTheme():int
		{
			return _defaultAndroidTheme;
		}
		/**
		 * the IOS default theme of all NativeProges dialogs
		 * @default pl.mateuszmackowiak.nativeANE.progress.NativeProgess#DEFAULT_THEME
		 */
		public static function set defaultIOSTheme(value:int):void
		{
			_defaultIOSTheme = value;
		}
		/**
		 * @private
		 */
		public static function get defaultIOSTheme():int
		{
			return _defaultIOSTheme;
		}
		
		
		
		/**
		 * defines if the Network Activiti Indicatior is availeble on platform (<b>AVAILABLE ONLY ON IOS</b>)
		 * <br><img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NetworkActivityIndicatoror.png"></img>
		 * @see pl.mateuszmackowiak.nativeANE.progress.NativeProgress#showNetworkActivityIndicatoror()
		 */
		public static function isNetworkActivityIndicatoror():Boolean{
			if(Capabilities.os.toLowerCase().indexOf("ip")>-1){
				return true;
			}else
				return false;
		}
		/**
		 * <b>AVAILABLE ONLY ON IOS</b>
		 * <br><img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NetworkActivityIndicatoror.png"></img>
		 * @see pl.mateuszmackowiak.nativeANE.progress.NativeProgress#isNetworkActivityIndicatoror()
		 * @return if call sucessfull
		 */
		public static function showNetworkActivityIndicatoror(show:Boolean):Boolean{
			if(Capabilities.os.toLowerCase().indexOf("ip")>-1){
				try{
					var context:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "NetworkActivityIndicatoror");
					const answer:Object = context.call("showHidenetworkIndicator",show);
					if(answer is Boolean)
						var ret:Boolean = answer as Boolean;
					else trace(answer);
					context.dispose();
					return ret;
				}catch(e:Error){
					trace("Error calling showIOSnetworkActivityIndicator method "+e.message,e.errorID);
				}
			}return false;
		}
		
		
		
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		private function showError(message:String,id:int=0):void
		{
			if(hasEventListener(ErrorEvent.ERROR))
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,message,id));
			else
				throw new Error(message,id);
		}
		/**
		 * @private
		 */
		private function onStatus(event:StatusEvent):void
		{
			try{
				if(event.code == NativeDialogEvent.CLOSED)
				{
					_isShowing = false;
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level));
				}else if(event.code == NativeDialogEvent.CANCELED){
					_isShowing = false;
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level));
				}else if(event.code == NativeDialogEvent.OPENED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				}else if(event.code ==ErrorEvent.ERROR){
					_isShowing = isShowing();
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,event.level,0));
				}else{
					_isShowing = isShowing();
					showError(event.toString());
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
	}
}