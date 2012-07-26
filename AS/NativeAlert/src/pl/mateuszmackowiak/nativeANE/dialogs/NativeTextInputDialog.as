/** 
 * @author Mateusz Maćkowiak
 * @see http://www.mateuszmackowiak.art.pl/blog
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;

	/** 
	 * @author Mateusz Maćkowiak
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeTextInputAndroidDefaultLightTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeTextInputAndroidHaloLightTheme.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NativeTextInputAndroidHaloDarkTheme.png"></img>
	 * @see http://mateuszmackowiak.wordpress.com/
	 */
	public class NativeTextInputDialog extends EventDispatcher
	{
		//---------------------------------------------------------------------
		//
		// Public Static Constants
		//
		//---------------------------------------------------------------------
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		
		/**
		 * use the device's default alert theme with a dark background
		 * <br>Constant Value: 4 (0x00000004)
		 */
		public static const ANDROID_DEVICE_DEFAULT_DARK_THEME:uint = 0x00000004;
		/**
		 *  use the device's default alert theme with a dark background.
		 * <br>Constant Value: 5 (0x00000005)
		 */
		public static const ANDROID_DEVICE_DEFAULT_LIGHT_THEME:uint = 0x00000005;
		/**
		 * use the holographic alert theme with a dark background
		 * <br>Constant Value: 2 (0x00000002)
		 */
		public static const ANDROID_HOLO_DARK_THEME:uint = 0x00000002;
		/**
		 * use the holographic alert theme with a light background
		 * <br>Constant Value: 3 (0x00000003)
		 */
		public static const ANDROID_HOLO_LIGHT_THEME:uint = 0x00000003;
		/**
		 * use the traditional (pre-Holo) alert dialog theme
		 * <br>the default style for Android devices
		 * <br>Constant Value: 1 (0x00000001)
		 */
		public static const DEFAULT_THEME:uint = 0x00000001;
		
		//---------------------------------------------------------------------
		//
		// Private Static Constants
		//
		//---------------------------------------------------------------------
		private static const FRE_FUNCTION:String = "showTextInput";
		
		private static var _defaultTheme:int = DEFAULT_THEME;
		//private static var _set:Boolean = false;
		//private static var _isSupp:Boolean = false;
		
		//private static var isAndroid:Boolean=false;
	//	private static var isIOS:Boolean=false;
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		private var context:ExtensionContext;
		
		private var _title:String="";
		private var _theme:int = -1;
		private var _cancelable:Boolean = false;
		private var _buttons:Vector.<String>=null;
		private var _textInputs:Vector.<NativeTextField>=null;
		private var _isShowing:Boolean = false;
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/** 
		 * Events:
		 *
		 * <br> flash.events.ErrorEvent
		 * <br> pl.mateuszmackowiak.nativeANE.NativeDialogEvent
		 * 
		 * @param the theme of the dialog - defined by the version of software
		 * 
		 * @author Mateusz Maćkowiak
		 * @see http://www.mateuszmackowiak.art.pl/blog
		 * @since 2012
		 * @see pl.mateuszmackowiak.nativeANE.NativeDialogEvent
		 * @see flash.events.ErrorEvent
		 */
		public function NativeTextInputDialog(theme:int=-1)
		{
			if(!isAndroid() && !isIOS()){
				trace("NativeTextInputDialog is not supported on this platform");
				return;
			}
			if(!isNaN(theme) && theme>-1)
				_theme = theme;
			else
				_theme = _defaultTheme;
			
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, "TextInputDialogContext");
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the extension "+e.message,e.errorID);
			}
		}
		
		
		protected static function isIOS():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("ip")>-1;
		}
		protected static function isAndroid():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("linux")>-1;
		}
		/**
		 * shows the NativeTextInput dialog
		 * @param textInputs list of NativeTextFields where param <code>editable</code> defines if it is a text input or standard lable.
		 * <br><b><i>On IOS</i></b> there can by <b>max 3</b> fields where the first one must have <code>editable</code> set to <code>TRUE</code> to be displayed
		 * as message if not it will be treated as text input.
		 * @param buttons list of labels of buttons in dialog <b><i>On IOS</i></b> max 2 <b><i>On Android</i></b> max 3
		 * @param cancleble if pressing outside the popup or the back button hides the popup (IOS default theme not supported). If null is set to default or as set by setCancelable
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog#setCancelable()
		 * 
		 */
		public function show(textInputs:Vector.<NativeTextField>,buttons:Vector.<String>=null,cancelable:Object=null):Boolean{
			
			if (!buttons || buttons.length == 0){
				//no buttons exist, lets make the default buttons
				trace("Buttons not configured, assigning default CANCEL,OK buttons");
				buttons = new Vector.<String>();
				buttons.push("Cancel","OK");
			}
			if(textInputs==null || textInputs.length==0){
				showError("textInputs cannot be null");
				return false;
			}
			
			_buttons = buttons;
			_textInputs = textInputs;
			if(cancelable!==null)
				_cancelable = cancelable;
			
			try{
				if(isAndroid()){
					if(buttons.length>3){
						trace("Warning: There can be only 3 buttons on Andorid NativeTextInputDialog");
					}
					context.call(FRE_FUNCTION,"show",_title,_textInputs,_buttons,_cancelable,_theme);
					_isShowing = true;
					return true;
				}
				if(isIOS()){
					var message:String = (textInputs[0].editable==false)? message = textInputs[0].text :null;
					
					if(buttons.length>2){
						trace("Warning: There can be only 2 buttons on IOS NativeTextInputDialog");
					}
					if(textInputs.length>3){
						trace("Warning: There can be max only 3 NativeTextFields (first with editable==false to display aditional message) on IOS NativeTextInputDialog ");
					}
					
					context.call("show",_title,message,_textInputs,_buttons);
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
		 * if back button on Android cancles Dialog
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 */
		public function setCancelable(value:Boolean):Boolean
		{
			if(_cancelable!==value){
				_cancelable = value;
				if(_isShowing){
					try{
						if(isAndroid()){
							context.call(FRE_FUNCTION,"setCancleble",value);
							return true;
						}
						/*if(isIOS){
							context.call("setCancleble",value);
							return true;
						}*/
					}catch(e:Error){
						showError("Error setting secondary progress "+e.message,e.errorID);
					}
				}
			}
			return false;	
		}
		/**
		 * if back button cancles Dialog
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 */
		public function getCancelable():Boolean
		{
			return _cancelable;
		}

		/**
		 * list of NativeTextFields where param <code>editable</code> defines if it is a text input or standard lable.
		 */
		public function get textInputs():Vector.<NativeTextField>
		{
			return _textInputs;
		}
		/**
		 * buttons list of labels of buttons in dialog
		 */
		public function get buttons():Vector.<String>
		{
			return _buttons;
		}

		
		/**
		 * helper method to get the text input by name
		 */
		public function getTextInputByName(name:String):NativeTextField
		{
			if(_textInputs && _textInputs.length>0){
				for each (var t:NativeTextField in _textInputs) 
				{
					if(t.name ==name)
						return t;
				}
			}
			return null;
		}
		
		/**
		 * The title of the dialog
		 * @return if call sucessfull
		 */
		public function setTitle(value:String):Boolean
		{
			if(value!==_title){
				_title = value;
				if(_isShowing){
					try{
						if(isAndroid()){
							context.call(FRE_FUNCTION,"setTitle",value);
							return true;
						}
						if(isIOS()){
							context.call("setTitle",value);
							return true;
						}
						return false;
					}catch(e:Error){
						showError("Error setting title "+e.message,e.errorID);
					}
				}
			}
			return false;
		}
		/**
		 * The title of the dialog
		 */
		public function getTitle():String
		{
			return _title;
		}
		
		/**
		 * if the dialog is showing
		 */
		public function isShowing():Boolean{
			if(context){
				if(isAndroid()){
					const b:Boolean = context.call(FRE_FUNCTION,"isShowing");
					_isShowing = b;
					return b;
				}else if(isIOS()){
					const b2:Boolean = context.call("isShowing");
					_isShowing = b2;
					return b2;
				}
			}
			return false;
			
		}
		
		/**
		 * the theme of the NativeTextInputDialog
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
		 * hides the dialog if is showing and does not dispach any event
		 * <br><b>AVAILABLE ONLY ON ANDROID</b>
		 * @return if call sucessfull
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog#hide()
		 */
		public function dismiss():Boolean
		{
			_isShowing = false;
			try{
				if(context!=null){
					if(isAndroid()){
						context.call(FRE_FUNCTION,"dismiss");
						return true;
					}
					/*if(isIOS){
						context.call("dismiss");
						return true;
					}*/
				}
				return false;
			}catch(e:Error){
				showError("Error calling hide method "+e.message,e.errorID);
			}
			return false;
		}
		/**
		 * hides the dialog if is showing and dispaches NativeDialogEvent.CANCELED
		 * @return if call sucessfull
		 * @see pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog#hideWithoutEvent()
		 */
		public function hide(buttonIndex:int =NaN):Boolean
		{
			_isShowing = false;
			try{
				if(context!=null){
					if(isAndroid()){
						context.call(FRE_FUNCTION,"hide");
						return true;
					}
					if(isIOS()){
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
		/**
		 * Disposes of this ExtensionContext instance.<br><br>
		 * The runtime notifies the native implementation, which can release any associated native resources. After calling <code>dispose()</code>,
		 * the code cannot call the <code>call()</code> method and cannot get or set the <code>actionScriptData</code> property.
		 */
		public function dispose():void
		{
			_isShowing = false;
			if(context){
				context.dispose();
				context = null;
			}
			
			/*
			_isShowing = false;
			try{
				if(context!=null){
					context.dispose();
					context.removeEventListener(StatusEvent.STATUS, onStatus);
				}
				return true;
			}catch(e:Error){
				showError("Error calling kill method "+e.message,e.errorID);
			}
			return false;*/
		}
		
		
		/**
		 * ONLY IOS
		 * @return if call sucessfull
		 */
		public function shake():Boolean
		{
			try{
				if(context!=null && isIOS()){
					context.call(FRE_FUNCTION,"shake");
					return true;
				}
			}catch(e:Error){
				showError("Error calling shake method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		//---------------------------------------------------------------------
		//
		// Public Static Methods.
		//
		//---------------------------------------------------------------------
		/**
		 * If the extension is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(isAndroid() || isIOS())
				return true;
			return false;
		}
		
		/**
		 * default theme of dialog
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
				if(event.code == Event.CHANGE){
					if(isIOS()){
						const a2:Array = event.level.split("#_#");
						var t:NativeTextField = null;
						if(_textInputs[0].editable==false){
							t = _textInputs[int(a2[0])+1];
							t.text = a2[1];
						}else{
							t = _textInputs[int(a2[0])];
							t.text = a2[1];
						}
						
						t.dispatchEvent(new Event(Event.CHANGE));
					}
					if(isAndroid()){
						const a3:Array = event.level.split("#_#");
						
						for each (var n1:NativeTextField in _textInputs)
						{
							if(n1.name==a3[0]){
								if(n1.text != a3[1]){
									n1.text = a3[1];
									n1.dispatchEvent(new Event(Event.CHANGE));
								}
							}
						}
						
					}
				}else if(event.code == NativeDialogEvent.CLOSED){
					_isShowing = false;
					//const a:Array = event.level.split("#_#");
					if(dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level,false,true))){
						if(isAndroid()){
							dismiss();
						}
					}
				}else if(event.code == NativeDialogEvent.CANCELED){
					_isShowing = false;
					if(dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level,false,true))){
						if(isAndroid()){
							dismiss();
						}
					}
				}else if(event.code == NativeDialogEvent.OPENED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,"",false,true));

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