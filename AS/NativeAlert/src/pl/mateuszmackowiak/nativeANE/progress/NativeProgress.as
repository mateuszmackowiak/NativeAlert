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
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		private var context:ExtensionContext;
		private var _progress:int=0;
		private var _title:String="";
		private var _message:String = "";
		private var _style:int = STYLE_HORIZONTAL;
		private var _theme:int = -1;
		private var _maxProgress:int  = 100;
	
		
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
			if(title!= null && title!=="")
				_title = title;
			if(style == STYLE_HORIZONTAL || style==STYLE_SPINNER)
				_style = style;
			if(message!=null && message!=="")
				_message = message;
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the extension "+e.message,e.errorID);
			}
		}
		
		

		

		public function show(progress:int=-1,title:String="",message:String="",cancleble:Boolean=false):Boolean
		{
			if(!isNaN(progress) && progress>=0 && progress<= _maxProgress)
				_progress = progress;
			if(title!= null && title!=="")
				_title = title;
			if(_theme ==-1)
				_theme = defaultTheme;
			if(message!=null && message!=="")
				_message = message;

			
			try{
				context.call("NativeProgress","showPopup",progress,_style,_title,_message,cancleble,_theme);
				return true;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		public function setProgress(value:int):Boolean{
			if(!isNaN(value) && _progress!==value  && value>=0 && value<= _maxProgress){
				try{
					context.call("NativeProgress","update",value);
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
		
		
		public function setMax(value:int):Boolean{
			if(!isNaN(value) && _maxProgress!==value){
				try{
					context.call("NativeProgress","max",value);
					_progress = value;
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
		
		
		public function getMessage():String
		{
			return _message;
		}
		
		public function setMessage(value:String):Boolean
		{
			if(value!=null && value!==_message){
				try{
					context.call("NativeProgress","setMessage",value);
					_message = value;
					return true;
				}catch(e:Error){
					showError("Error setting message "+e.message,e.errorID);
				}
			}
			return false;
		}
		
		public function getTitle():String
		{
			return _title;
		}
		
		public function setTitle(value:String):Boolean
		{
			if(value!=null && value!==_title){
				try{
					context.call("NativeProgress","setTitle",value);
					_title = value;
					return true;
				}catch(e:Error){
					showError("Error setting title "+e.message,e.errorID);
				}
			}
			return false;
		}
		
		public function isShowing():Boolean{
			if(context){
				return context.call("NativeProgress","isShowing");
			}else
				return false;
				
		}
		
		
		public function get theme():int
		{
			return _theme;
		}
		
		public function set theme(value:int):void
		{
			if(value==THEME_DEVICE_DEFAULT_DARK || value==THEME_DEVICE_DEFAULT_LIGHT || value==THEME_HOLO_DARK || value==THEME_HOLO_LIGHT || value==THEME_TRADITIONAL)
				_theme = value;
		}
		
		
		
		public function hide():Boolean
		{
			try{
				context.call("NativeProgress","hide");
				return true;
			}catch(e:Error){
				showError("Error calling hide method "+e.message,e.errorID);
			}
			return false;
		}
		public function kill():Boolean
		{
			try{
				context.call("NativeProgress","hide");
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
					var context:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
					_isSupp = context.call("isSupported");
					context.dispose();
				}catch(e:Error){
					return _isSupp;
				}
			}	
			return _isSupp;
		}
		
		public static function set defaultTheme(value:int):void
		{
			if(value==THEME_DEVICE_DEFAULT_DARK || value==THEME_DEVICE_DEFAULT_LIGHT || value==THEME_HOLO_DARK || value==THEME_HOLO_LIGHT || value==THEME_TRADITIONAL)
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
			if(hasEventListener(NativeExtensionErrorEvent.ERROR))
				dispatchEvent(new NativeExtensionErrorEvent(NativeExtensionErrorEvent.ERROR,false,false,message,id));
			else
				throw new Error(message,id);
		}
		private function onStatus(event:StatusEvent):void
		{
			try{
				if(event.code == NativeProgressEvent.CLOSED)
				{
					dispatchEvent(new NativeProgressEvent(NativeProgressEvent.CLOSED,event.level));
				}else if(event.code == NativeProgressEvent.CANCLED){
					dispatchEvent(new NativeProgressEvent(NativeProgressEvent.CANCLED,event.level));
				}else if(event.code == NativeProgressEvent.OPENED){
					dispatchEvent(new NativeProgressEvent(NativeProgressEvent.OPENED,event.level));
				}else{
					showError(event.toString());
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
	}
}