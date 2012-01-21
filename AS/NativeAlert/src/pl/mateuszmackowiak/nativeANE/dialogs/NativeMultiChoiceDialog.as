/** 
 * @author Mateusz Maćkowiak
 * @see http://www.mateuszmackowiak.art.pl/blog
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import pl.mateuszmackowiak.nativeANE.LogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeDialogListEvent;
	import pl.mateuszmackowiak.nativeANE.NativeExtensionErrorEvent;
	
	public class NativeMultiChoiceDialog extends EventDispatcher
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		public static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		
		public static const STYLE_HORIZONTAL:int = 0x00000001;
		public static const STYLE_SPINNER:int = 0x00000000;
		
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
		private var _buttons:Vector.<String>=null;
		private var _theme:int = -1;
		private var _cancleble:Boolean = false;
		private var _list:Vector.<Object> = null;
		
		public function NativeMultiChoiceDialog()
		{
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, "MultiChoiceDialogContext");
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the extension "+e.message,e.errorID);
			}
		}
		
		
		

		

		public function show(labels:Vector.<String>,checkedLabels:Vector.<Boolean>,buttons:Vector.<String>=null,title:String="",cancleble:Object=null):Boolean
		{
			if(title!= null && title!=="")
				_title = title;
			if(_theme ==-1)
				_theme = defaultTheme;
			if(buttons!=null)
				_buttons = buttons;
			if(cancleble!==null)
				_cancleble = cancleble;
			
			if(labels!==null && labels.length>0){
				_list = new Vector.<Object>();
				for each (var label:String in labels) 
				{
					_list.push({label:label,selected:false});
				}
				const l:int = checkedLabels.length;
				if(checkedLabels!=null && labels.length == l){
					for (var i:int = 0; i < l; i++) 
					{
						_list[i].selected = checkedLabels[i];
					}
				}
			}
				
			try{
				context.call("showMultiChoiceDialog","showPopup",_title,_buttons,labels,checkedLabels,_cancleble,_theme);
				return true;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		public function get labels():Vector.<String>{
			var lab:Vector.<String> = new Vector.<String>();
			if(_list!==null){
				for each (var obj:Object in _list) 
				{
					lab.push(obj.label);
				}
			}
			return lab;
		}
		public function get selectedLabels():Vector.<String>{
			var lab:Vector.<String> = new Vector.<String>();
			if(_list!==null){
				
				for each (var obj:Object in _list) 
				{
					if(obj.selected == true)
						lab.push(obj.label);
				}

			}
			return lab;
		}
		public function get selectedIndexes():Vector.<int>{
			var indexes:Vector.<int> = new Vector.<int>();
			if(_list!==null && _list.length>0){
				for (var i:int = 0; i < _list.length; i++) 
				{
					if(_list[i].selected == true)
						indexes.push(i);;
				}
			}
			return indexes;
		}
		
		public function isShowing():Boolean{
			if(context){
				return context.call("showMultiChoiceDialog","isShowing");
			}else
				return false;
			
		}

		
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			if(value!=null && value!==_title){
				_title = value;
			}
		}
		public function get cancleble():Boolean
		{
			return _cancleble;
		}
		public function set cancleble(value:Boolean):void
		{
			_cancleble = value;
		}
		
		public function get theme():int
		{
			return _theme;
		}
		public function get buttons():Vector.<String>
		{
			return _buttons;
		}
		
		public function set buttons(value:Vector.<String>):void
		{
			_buttons = value;
		}
		
		public function set theme(value:int):void
		{
			if(value==THEME_DEVICE_DEFAULT_DARK || value==THEME_DEVICE_DEFAULT_LIGHT || value==THEME_HOLO_DARK || value==THEME_HOLO_LIGHT || value==THEME_TRADITIONAL)
				_theme = value;
		}
		
		
		
		public function hide():Boolean
		{
			try{
				context.call("showMultiChoiceDialog","hide");
				return true;
			}catch(e:Error){
				showError("Error calling hide method "+e.message,e.errorID);
			}
			return false;
		}
		public function kill():Boolean
		{
			try{
				context.call("showMultiChoiceDialog","hide");
				context.dispose();
				context.removeEventListener(StatusEvent.STATUS, onStatus);
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
				if(event.code == NativeDialogEvent.CLOSED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level));
				}else if(event.code == NativeDialogEvent.CANCLED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCLED,event.level));
				}else if(event.code == NativeDialogEvent.OPENED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				}else if(event.code ==LogEvent.LOG_EVENT){
					dispatchEvent(new LogEvent(LogEvent.LOG_EVENT,event.level));
				}else if(event.code ==NativeDialogListEvent.LIST_CHANGE){
					
					const args:Array = event.level.split("_");
					const index:int = int(args[0]);
					var selected:Boolean=false;
					const selectedStr:String= String(args[1]).toLocaleLowerCase();
					if(selectedStr=="true" || selectedStr=="1")
						selected = true;
					_list[index].selected = selected;
					
					dispatchEvent(new NativeDialogListEvent(NativeDialogListEvent.LIST_CHANGE,index,selected));
				}else{
					showError(event.toString());
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
	}
}