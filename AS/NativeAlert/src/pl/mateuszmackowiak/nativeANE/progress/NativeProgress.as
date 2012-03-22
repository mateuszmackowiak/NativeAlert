/** 
 * @author Mateusz Maćkowiak
 * @see http://www.mateuszmackowiak.art.pl/blog
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.progress
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	import pl.mateuszmackowiak.nativeANE.LogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeExtensionErrorEvent;
	
	public class NativeProgress extends EventDispatcher
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		public static const STYLE_HORIZONTAL:int = 0x00000001;
		public static const STYLE_SPINNER:int = 0x00000000;
		
		public static const THEME_DEVICE_DEFAULT_DARK:int = 0x00000004;
		public static const THEME_DEVICE_DEFAULT_LIGHT:int = 0x00000005;
		public static const THEME_HOLO_DARK:int = 0x00000002;
		public static const THEME_HOLO_LIGHT:int = 0x00000003;
		public static const THEME_TRADITIONAL:int = 0x00000001;
		
		
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		
		
		
		private static var _defaultTheme:int = THEME_HOLO_LIGHT;
		private static var _set:Boolean = false;
		private static var _isSupp:Boolean = false;
		
		
		private static var isAndroid:Boolean=false;
		private static var isIOS:Boolean=false;
		private static var showProgressPopup:String = "showProgressPopup";
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
		private var _style:int = STYLE_HORIZONTAL;
		private var _theme:int = -1;
		private var _maxProgress:int  = 100;
		private var _indeterminate:Boolean = false;
		
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * @author Mateusz Maćkowiak
		 * @see http://www.mateuszmackowiak.art.pl/blog
		 * @since 2011
		 */
		public function NativeProgress(style:int = 0x00000001,title:String ="",message:String = "")
		{
			if(Capabilities.os.toLowerCase().indexOf("linux")>-1)
				isAndroid = true;
			else if(Capabilities.os.toLowerCase().indexOf("iph")>-1)
				isIOS = true;
				
			if(title!= null && title!=="")
				_title = title;
			if(style == STYLE_HORIZONTAL || style==STYLE_SPINNER)
				_style = style;
			if(message!=null && message!=="")
				_message = message;
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, "ProgressContext");
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the extension "+e.message,e.errorID);
			}
		}
		
		
		
		/**
		 * AVAILEBLE ONLY ON IOS
		 */
		public static function isNetworkActivityIndicatoror():Boolean{
			if(Capabilities.os.toLowerCase().indexOf("ip")>-1){
				return true;
			}else
				return false;
		}
		/**
		 * AVAILEBLE ONLY ON IOS
		 */
		public static function showNetworkActivityIndicatoror(show:Boolean):Boolean{
			if(Capabilities.os.toLowerCase().indexOf("ip")>-1){
				try{
					var context:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "NetworkActivityIndicatoror");
					var ret:Boolean = context.call("showHidenetworkIndicator",show)as Boolean;
					context.dispose();
					return ret;
				}catch(e:Error){
					trace("Error calling showIOSnetworkActivityIndicator method "+e.message,e.errorID);
				}
			}return false;
		}

		

		public function show(progress:int=-1,title:String="",message:String="",cancleble:Boolean=false,indeterminate:Object=null):Boolean
		{
			if(!isNaN(progress) && progress>=0 && progress<= _maxProgress)
				_progress = progress;
			if(title!= null && title!=="")
				_title = title;
			if(_theme ==-1)
				_theme = defaultTheme;
			if(message!=null && message!=="")
				_message = message;
			if(indeterminate!==null)
				_indeterminate = indeterminate;
			
			try{
				if(isAndroid)
					context.call(showProgressPopup,"showPopup",_progress,_secondary,_style,_title,_message,cancleble,_indeterminate,_theme);
				else if(isIOS)
					context.call(showProgressPopup,_progress/_maxProgress,null,_style,title,message,cancleble,_indeterminate);
				return true;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		public function showIndeterminate(title:String="",message:String="",cancleble:Boolean=false):Boolean
		{
			if(title!= null && title!=="")
				_title = title;
			if(_theme ==-1)
				_theme = defaultTheme;
			if(message!=null && message!=="")
				_message = message;
			_indeterminate = true;
			try{
				if(isAndroid)
					context.call(showProgressPopup,"showPopup",null,null,STYLE_HORIZONTAL,_title,_message,cancleble,true,_theme);
				else if(isIOS)
					context.call(showProgressPopup,null,null,STYLE_HORIZONTAL,_title,_message,cancleble,true);	
				return true;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		public function showSpinner(title:String="",message:String="",cancleble:Boolean=false):Boolean
		{
			if(title!= null && title!=="")
				_title = title;
			if(_theme ==-1)
				_theme = defaultTheme;
			if(message!=null && message!=="")
				_message = message;
			try{
				if(isAndroid)
					context.call(showProgressPopup,"showPopup",null,null,STYLE_SPINNER,_title,_message,cancleble,false,_theme);
				else if(isIOS)
					context.call(showProgressPopup,null,null,STYLE_SPINNER,_title,_message,cancleble,true);
				return true;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		
		/**
		 * availeble only on Andorid
		 */
		public function setIndeterminate(value:Boolean):Boolean{
			if(isAndroid && _indeterminate!==value  && value>=0 && value<= _maxProgress){
				try{
					context.call(showProgressPopup,"setIndeterminate",value);
					_indeterminate = value;
					return true;
				}catch(e:Error){
					showError("Error setting setIndeterminate "+e.message,e.errorID);
				}
			}
			return false;
		}
		public function getIndeterminate():Boolean{
			return _indeterminate;
		}
		
		
		/**
		 * availeble only on Andorid
		 */
		public function setSecondaryProgress(value:int):Boolean{
			if(isAndroid && _secondary!==value  && value>=0 && value<= _maxProgress){
				try{
					context.call(showProgressPopup,"setSecondary",value);
					_secondary = value;
					return true;
				}catch(e:Error){
					showError("Error setting secondary progress "+e.message,e.errorID);
				}
			}
			return false;
		}
		
		public function getSecondaryProgress():int{
			return _secondary;
		}
		
		
		
		
		public function setProgress(value:int):Boolean{
			if(!isNaN(value) && _progress!==value  && value>=0 && value<= _maxProgress){
				try{
					if(isAndroid)
						context.call(showProgressPopup,"update",value);
					else
						context.call("updateProgress",value/_maxProgress);
					_progress = value;
					return true;
				}catch(e:Error){
					showError("Error setting progress "+e.message,e.errorID);
				}
			}
			return false;
		}
		
		public function getProgress():int{
			return _progress;
		}
		
		
		
		/**
		 * availeble only on Andorid
		 */
		public function setMax(value:int):Boolean{
			if(!isNaN(value) && _maxProgress!==value){
				try{
					if(isAndroid)
						context.call(showProgressPopup,"max",value);
					if(_progress>value)
						_progress = value;
					_maxProgress= value;
					return true;
				}catch(e:Error){
					showError("Error setting MAX "+e.message,e.errorID);
				}
			}
			return false;
		}
		
		public function getMax():int{
			return _maxProgress;
		}
		
		
		
		

		public function setMessage(value:String):Boolean
		{
			if(value!=null && value!==_message){
				try{
					if(isAndroid)
						context.call(showProgressPopup,"setMessage",value);
					else
						context.call("updateMessage",value);
					_message = value;
					return true;
				}catch(e:Error){
					showError("Error setting message "+e.message,e.errorID);
				}
			}
			return false;
		}
		public function getMessage():String
		{
			return _message;
		}
		
		
		
		
		
		

		public function setTitle(value:String):Boolean
		{
			if(value!=null && value!==_title){
				try{
					if(isAndroid)
						context.call(showProgressPopup,"setTitle",value);
					else
						context.call("updateTitle",value);
					_title = value;
					return true;
				}catch(e:Error){
					showError("Error setting title "+e.message,e.errorID);
				}
			}
			return false;
		}
		public function getTitle():String
		{
			return _title;
		}
		
		
		
		
		/**
		 * availeble only on Andorid
		 */
		public function isShowing():Boolean{
			if(context){
				if(isAndroid)
					return context.call(showProgressPopup,"isShowing");
				else
					return context.call("isShowing");
			}else
				return false;
				
		}
		
		
		public function get theme():int
		{
			return _theme;
		}
		public function set theme(value:int):void
		{
			_theme = value;
		}
		
		
		
		public function hide():Boolean
		{
			try{
				if(isAndroid)
					context.call(showProgressPopup,"hide");
				else
					context.call("hideProgress");
				return true;
			}catch(e:Error){
				showError("Error calling hide method "+e.message,e.errorID);
			}
			return false;
		}
		public function kill():Boolean
		{
			try{
				context.dispose();
				return true;
			}catch(e:Error){
				showError("Error calling hide method "+e.message,e.errorID);
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
		
		public static function set defaultTheme(value:int):void
		{
			_defaultTheme = value;
		}
		public static function get defaultTheme():int
		{
			return _defaultTheme;
		}
		
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		private function showError(message:String,id:int=0):void
		{
			/*if(hasEventListener(NativeExtensionErrorEvent.ERROR))
				dispatchEvent(new NativeExtensionErrorEvent(NativeExtensionErrorEvent.ERROR,false,false,message,id));
			else*/
				throw new Error(message,id);
		}
		private function onStatus(event:StatusEvent):void
		{
			try{
				if(event.code == NativeDialogEvent.CLOSED)
				{
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level));
				}else if(event.code == NativeDialogEvent.CANCELED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level));
				}else if(event.code == NativeDialogEvent.OPENED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				}else if(event.code == LogEvent.LOG_EVENT){
					dispatchEvent(new LogEvent(LogEvent.LOG_EVENT,event.level));
				}else if(event.code ==NativeExtensionErrorEvent.ERROR){
					dispatchEvent(new NativeExtensionErrorEvent(NativeExtensionErrorEvent.ERROR,false,false,event.level,0));
				}else{
					showError(event.toString());
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
	}
}