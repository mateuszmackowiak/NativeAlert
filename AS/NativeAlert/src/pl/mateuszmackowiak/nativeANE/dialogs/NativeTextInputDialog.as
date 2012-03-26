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
		
		private static var isAndroid:Boolean=false;
		private static var isIOS:Boolean=false;
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		private var context:ExtensionContext;
		private var _title:String="";
		private var _theme:int = -1;
		private var _buttons:Vector.<String>=null;
		private var _textInputs:Vector.<NativeTextField>=null;
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
		public function NativeTextInputDialog()
		{
			if(Capabilities.os.toLowerCase().indexOf("linux")>-1)
				isAndroid = true;
			else if(Capabilities.os.toLowerCase().indexOf("iph")>-1)
				isIOS = true;
			else
				trace("NativeTextInputDialog is not supported on this platform");
			
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, "TextInputDialogContext");
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the extension "+e.message,e.errorID);
			}
		}
		
		
		public function show(title:String,textInputs:Vector.<NativeTextField>,buttons:Vector.<String>=null):Boolean{
			if(title!= null && title!=="")
				_title = title;
			
			if (!buttons || buttons.length == 0){
				//no buttons exist, lets make the default buttons
				trace("Buttons not configured, assigning default CANCEL,OK buttons");
				buttons = new Vector.<String>();
				buttons.push("Cancel","OK");
			}
			_buttons = buttons;

			
			if(textInputs==null || textInputs.length==0){
				throw new Error("textInputs cannot be null");
				return false;
			}
			try{
				_textInputs = textInputs;
				if(isAndroid){
					context.call(FRE_FUNCTIONL,"show",_title,textInputs,buttons,_theme);
					return true;
				}
				if(isIOS){
					var message:String = null;
					if(textInputs[0].editable==false)
						message = textInputs[0].text;
					if(buttons.length>2){
						trace("Warning: There can be only 2 buttons on IOS NativeTextInputDialog");
						return false;
					}
					if(textInputs.length>3){
						trace("Warning: There can be max only 3 NativeTextFields (first with editable==false to display aditional message) on IOS NativeTextInputDialog ");
						return false;
					}
					context.call("show",_title,message,textInputs,buttons);
					return true;
				}
				return false;
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
					if(isAndroid){
						context.call(FRE_FUNCTIONL,"setTitle",value);
						_title = value;
						return true;
					}
					if(isIOS){
						context.call("setTitle",value);
						_title = value;
						return true;
					}
					
					return false;
				}catch(e:Error){
					showError("Error setting title "+e.message,e.errorID);
				}
			}
			return false;
		}
		
		public function isShowing():Boolean{
			if(context){
				if(isAndroid)
					return context.call(FRE_FUNCTIONL,"isShowing");
				if(isIOS)
					return context.call("isShowing");
				return false;
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
				if(context!=null){
					if(isAndroid){
						context.call(FRE_FUNCTIONL,"hide");
						return true;
					}
					if(isIOS){
						context.call("hide");
						return true;
					}
				}
				return false;
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
					if(Capabilities.os.indexOf("Linux")>-1 || Capabilities.os.toLowerCase().indexOf("ip")>-1){
						_isSupp = true;
					}else
						_isSupp = false;
				}catch(e:Error){
					trace("NativeTextInputDialog extension is not supported on this platform");
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
					const a:Array = event.level.split("#_#");
					
					if(isAndroid){
						var v:Vector.<NativeTextField> = new Vector.<NativeTextField>();
						var nt:NativeTextField=null;
						for (var i:int = 1; i < a.length; i+=2) 
						{
							nt=new NativeTextField(a[i]);
							nt.text = a[i+1];
							v.push(nt);
						}
						for each (var n:NativeTextField in _textInputs) 
						{
							for each (var n2:NativeTextField in v) 
							{
								if(n.name == n2.name)
									n.text = n2.text;
							}
						}	
					}else if(isIOS){
						if(_textInputs[0].editable==false){
							_textInputs[1].text = a[1];
							if(_textInputs.length>1)
								_textInputs[2].text = a[2];
						}else{
							_textInputs[0].text = a[0];
							if(_textInputs.length>0)
								_textInputs[1].text = a[1];
						}
					}
					dispatchEvent(new NativeTextInputDialogEvent(NativeTextInputDialogEvent.CLOSED,a[0],_textInputs));
				}else if(event.code == NativeDialogEvent.CANCELED)
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level));
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