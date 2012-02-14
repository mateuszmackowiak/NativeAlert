package pl.mateuszmackowiak.nativeANE.toast
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	public class Toast extends EventDispatcher
	{
		
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		public static const LENGTH_LONG:int = 0x00000001;
		public static const LENGTH_SHORT:int = 0x00000000;
		
		public static const GRAVITY_BOTTOM:int = 0x00000050;
		public static const GRAVITY_CENTER:int = 0x00000011;
		public static const GRAVITY_TOP:int = 0x00000030;
		public static const GRAVITY_LEFT:int = 0x00000003;
		public static const NO_GRAVITY:int = 0x00000000;
		public static const GRAVITY_RIGHT:int = 0x00000005;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		private static var context:ExtensionContext;
		private static var _set:Boolean = false;
		private static var _isSupp:Boolean = false;
		
		
		public static function dispose():void{
			if(context)
				context.dispose();
		}
		
		
		
		
		public static function show(message:String , durration:int):void
		{
			if(Capabilities.os.indexOf("Linux")>-1){
				if(message==null)
					message="";
				if(isNaN(durration))
					durration = 0;
				
				if(context==null){
					try{
						context = ExtensionContext.createExtensionContext(EXTENSION_ID, "ToastContext");
					}catch(e:Error){
						showError(e.message,e.errorID);
					}
				}
				
				context.call("Toast",message,durration);
			}else
				trace("Toast extension is not supported on this platform");
		}
		
		public static function showWithDifferentGravit(message:String , durration:int , gravity:int=NaN , xOffset:int=0 , yOffset:int=0 ):void
		{
			if(Capabilities.os.indexOf("Linux")>-1){
				if(message==null)
					message="";
				if(isNaN(durration))
					durration = 0;
				if(isNaN(gravity) || isNaN(xOffset) || isNaN(yOffset))
					return;
				
				if(context==null){
					try{
						context = ExtensionContext.createExtensionContext(EXTENSION_ID, "ToastContext");
					}catch(e:Error){
						showError(e.message,e.errorID);
					}
				}
				
				context.call("Toast", message, durration, gravity, xOffset, yOffset);
			}else
				trace("Toast extension is not supported on this platform");
		}
		
		
		
		/**
		 * Whether a Notification system is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(!_set){// checks if a value was set before
				try{
					_set = true;
					if(Capabilities.os.indexOf("Linux")>-1){
						if(context==null)
							var context:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "ToastContext");
						_isSupp = context.call("isSupported")==true;
						context.dispose();
					}else
						_isSupp = false;
				}catch(e:Error){
					//showError(e.message,e.errorID);
					trace("Toast extension is not supported on this platform");
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
		private static function showError(message:String,id:int=0):void
		{
			trace(message);
			//FlexGlobals.topLevelApplication.dispatchEvent(new NativeAlertErrorEvent(NativeAlertErrorEvent.ERROR,false,false,message,id));
		}
	}
}