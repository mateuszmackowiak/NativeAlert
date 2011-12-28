/** 
* @author Mateusz Maćkowiak
* @see http://www.mateuszmackowiak.art.pl/blog
* @since 2011
*  this project is based on a project by Liquid-Photo
* @see http://www.liquid-photo.com/2011/10/28/native-extension-for-adobe-air-and-ios-101/
*/
package pl.mateuszmackowiak.nativeANE
{
	//import com.pialabs.eskimo.controls.SkinnableAlert;
	
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	

	
	/**
	 * Evant dispatched when the Alert is closed
	 * @eventType pl.mateuszmackowiak.nativeANE.NativeAlertEvent.CLOSED
	 */
	[Event(name ="ALERT_CLOSED", type = "pl.mateuszmackowiak.nativeANE.NativeAlertEvent")] // NO PMD
	
	/**
	 * Evant dispatched when an Error acures
	 * @eventType flash.events.ErrorEvent.ERROR
	 */
	[Event(name = "error", type = "flash.events.ErrorEvent")]
	
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
		
		private static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		
		private static var context:ExtensionContext;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		//private var context:ExtensionContext;
		private static var _set:Boolean = false;
		private static var _isSupp:Boolean = false;
		
		public var title:String="";
		public var message:String="";
		public var closeLabel:String="OK";
		public var otherLabels:String ="";
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		
		public function NativeAlert()
		{
			
		}
		
		
		public static function initialize():void{
			context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
		}
		public static function dispose():void{
			context.dispose();
		}
		/**
		 * @param title Title to be displayed in the Alert.
		 * @param message Message to be displayed in the Alert.
		 * @param closeLabel Label for the close button.
		 * @param otherLabels shoud be a comma separated sting of button labels.
		 * for example "one,two,three"
		 */
		public function showAlert( title : String ="", message : String ="", closeLabel : String ="OK", otherLabels : String = "" ) : void
		{
			if(title!==null && title!=="")
				this.title = title;
			if(message!==null && message!=="")
				this.message = message;
			if(closeLabel!==null && closeLabel!=="")
				this.closeLabel = closeLabel;
			if(otherLabels!==null && otherLabels!=="")
				this.otherLabels = otherLabels;
			
			try{
				context.addEventListener(StatusEvent.STATUS, onAlertHandler);
				
				context.call("showAlertWithTitleAndMessage", this.title, this.message, this.closeLabel,this.otherLabels );
				
			}catch(e:Error){
				if(hasEventListener(ErrorEvent.ERROR))
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,e.message,e.errorID));
				else
					trace(e);
			}
		}
		
		
		
		/**
		 * Create and show an Alert control
		 * @param text     Text showed in the Alert control
		 * @param title    Title of the Alert control
		 * @param closeLabel Text of the default button (work on IOS)
		 * @param otherLabels Text of the other buttons. Sepperated with "," adds aditional buttons (work on IOS) in the close event answer is the string representing the label
		 * @param closeHandler  Close function callback
		 */
		public static function show(message:String = "", title:String = "Error", closeLabel : String="OK", otherLabels : String = "" , closeHandler:Function = null):NativeAlert
		{
				try{
					var alert:NativeAlert = new NativeAlert();
					if (closeHandler !== null)
					{
						alert.addEventListener(NativeAlertEvent.CLOSE, closeHandler);
						
						/*if(Capabilities.isDebugger && Capabilities.os.indexOf("Win")>-1)
							closeHandler(new NativeAlertEvent(NativeAlertEvent.CLOSE,"0"));*/
					}
					alert.showAlert(title,message,closeLabel,otherLabels);
					
					return alert;
				}catch(e:Error){
					trace(e);
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
					//var context:ExtensionContext = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
					_isSupp = context.call("isSupported");
					//context.dispose();
				}catch(e:Error){
					trace(e);
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
			(event.target as ExtensionContext).removeEventListener( StatusEvent.STATUS, onAlertHandler );
			//NativeAlert.show("level:  "+event.level+"     code:"+event.code,"ODPOWIEDZ");
			if( event.code == NativeAlertEvent.CLOSE)
			{
				var level:int = int(event.level);
				if(Capabilities.os.indexOf("Win")>-1)
					level--;
				dispatchEvent(new NativeAlertEvent(NativeAlertEvent.CLOSE,level.toString()))
			}else{
				if(hasEventListener(ErrorEvent.ERROR))
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,event.toString(),0));
			}
		}

	}
}