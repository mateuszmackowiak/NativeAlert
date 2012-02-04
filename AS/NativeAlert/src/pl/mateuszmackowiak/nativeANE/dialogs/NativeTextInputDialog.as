package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	import pl.mateuszmackowiak.nativeANE.LogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeExtensionErrorEvent;

	
	public class NativeTextInputDialog extends EventDispatcher
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		private static const FRE_FUNCTIONL:String = "showTextInput";
		
		
		public static const THEME_DEVICE_DEFAULT_DARK:int = 0x00000004;
		public static const THEME_DEVICE_DEFAULT_LIGHT:int = 0x00000005;
		public static const THEME_HOLO_DARK:int = 0x00000002;
		public static const THEME_HOLO_LIGHT:int = 0x00000003;
		public static const THEME_TRADITIONAL:int = 0x00000001;
		
		private static var _defaultTheme:int = THEME_HOLO_LIGHT;
		private static var _set:Boolean = false;
		private static var _isSupp:Boolean = false;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		private var context:ExtensionContext;
		private var _title:String="";
		private var _theme:int = -1;
		private var _buttons:Vector.<String>=null;
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
		public function NativeTextInputDialog(title:String ="")
		{
			if(title!= null && title!=="")
				_title = title;
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, "TextInputDialogContext");
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the extension "+e.message,e.errorID);
			}
		}
		
		
		public function show(title:String,textInputs:Vector.<NativeTextInput>,buttons:Vector.<String>=null):Boolean{
			if(title!= null && title!=="")
				_title = title;
			
			if(buttons!=null)
				_buttons = buttons;
			
			if(textInputs==null || textInputs.length==0){
				throw new Error("textInputs cannot be null");
				return false;
			}
			try{
				context.call(FRE_FUNCTIONL,"show",_title,textInputs,buttons,_theme);
				return true;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
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
					context.call(FRE_FUNCTIONL,"setTitle",value);
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
				return context.call(FRE_FUNCTIONL,"isShowing");
			}else
				return false;
			
		}
		
		public function get buttons():Vector.<String>
		{
			return _buttons;
		}
		
		public function set buttons(value:Vector.<String>):void
		{
			_buttons = value;
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
				if(context!=null)
					context.call(FRE_FUNCTIONL,"hide");
				return true;
			}catch(e:Error){
				showError("Error calling hide method "+e.message,e.errorID);
			}
			return false;
		}
		public function kill():Boolean
		{
			try{
				if(context!=null){
					context.dispose();
					context.removeEventListener(StatusEvent.STATUS, onStatus);
				}
				return true;
			}catch(e:Error){
				showError("Error calling kill method "+e.message,e.errorID);
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
						var context:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "TextInputDialogContext");
						_isSupp = context.call("isSupported");
						context.dispose();
					}else
						_isSupp = false;
				}catch(e:Error){
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
			if(hasEventListener(NativeExtensionErrorEvent.ERROR))
				dispatchEvent(new NativeExtensionErrorEvent(NativeExtensionErrorEvent.ERROR,false,false,message,id));
			else
				throw new Error(message,id);
		}
		private function onStatus(event:StatusEvent):void
		{
			try{
				if(event.code == NativeDialogEvent.CLOSED){
					var v:Vector.<NativeTextInput> = new Vector.<NativeTextInput>();
					const a:Array = event.level.split("#_#");
					var nt:NativeTextInput=null;
					for (var i:int = 1; i < a.length; i+=2) 
					{
						nt=new NativeTextInput(a[i]);
						nt.text = a[i+1];
						v.push(nt);
					}
					dispatchEvent(new NativeTextInputDialogEvent(NativeTextInputDialogEvent.CLOSED,a[0],v));
				}else if(event.code == NativeDialogEvent.CANCLED)
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCLED,event.level));
				else if(event.code == NativeDialogEvent.OPENED)
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				else if(event.code == LogEvent.LOG_EVENT)
					dispatchEvent(new LogEvent(LogEvent.LOG_EVENT,event.level));
				else if(event.code ==NativeExtensionErrorEvent.ERROR)
					dispatchEvent(new NativeExtensionErrorEvent(NativeExtensionErrorEvent.ERROR,false,false,event.level,0));
				else
					showError(event.toString());
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
		
	}
}