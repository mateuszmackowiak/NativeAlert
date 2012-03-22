/** 
 * @author Mateusz Maćkowiak
 * @see http://mateuszmackowiak.wordpress.com/
 * @since 2011
 */
package pl.mateuszmackowiak.nativeANE.dialogs
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	import pl.mateuszmackowiak.nativeANE.LogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeDialogListEvent;
	import pl.mateuszmackowiak.nativeANE.NativeExtensionErrorEvent;
	
	
	/** 
	 * @author Mateusz Maćkowiak
	 * @see http://mateuszmackowiak.wordpress.com/
	 * @since 2011
	 */
	public class NativeListDialog extends EventDispatcher
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
		
		public static const STYLE_HORIZONTAL:int = 0x00000001;
		public static const STYLE_SPINNER:int = 0x00000000;
		
		/**
		 * use the device's default alert theme with a dark background
		 * <br>Constant Value: 4 (0x00000004)
		 */
		public static const THEME_DEVICE_DEFAULT_DARK:int = 0x00000004;
		/**
		 *  use the device's default alert theme with a dark background.
		 * <br>Constant Value: 5 (0x00000005)
		 */
		public static const THEME_DEVICE_DEFAULT_LIGHT:int = 0x00000005;
		/**
		 * use the holographic alert theme with a dark background
		 * <br>Constant Value: 2 (0x00000002)
		 */
		public static const THEME_HOLO_DARK:int = 0x00000002;
		/**
		 * use the holographic alert theme with a light background
		 * <br>Constant Value: 3 (0x00000003)
		 */
		public static const THEME_HOLO_LIGHT:int = 0x00000003;
		/**
		 * use the traditional (pre-Holo) alert dialog theme
		 * <br>Constant Value: 1 (0x00000001)
		 */
		public static const THEME_TRADITIONAL:int = 0x00000001;
		
		/**
		 * @private
		 */
		private static var _defaultTheme:int = THEME_HOLO_LIGHT;

		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		private var context:ExtensionContext;
		/**
		 * @private
		 */
		private var _title:String="";
		/**
		 * @private
		 */
		private var _buttons:Vector.<String>=null;
		/**
		 * @private
		 */
		private var _theme:int = -1;
		/**
		 * @private
		 */
		private var _cancleble:Boolean = false;
		/**
		 * @private
		 */
		private var _list:Vector.<Object> = null;
		/**
		 * @private
		 */
		private var _selectedIndex:int = -1;
		
		
		/**
		 * 
		 */
		public function NativeListDialog()
		{
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, "ListDialogContext");
				context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the extension "+e.message,e.errorID);
			}
		}
		
		
		
		/**
		 * 
		 */
		public function showSingleChoice(labels:Vector.<String>,checkedLabel:int=-1,buttons:Vector.<String>=null,title:String="",cancleble:Object=null):Boolean
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
				if(checkedLabel!==-1)
					_list[checkedLabel].selected = true;
			}
			
			try{
				context.call("showListDialog","show",_title,_buttons,labels,checkedLabel,_cancleble,_theme);
				return true;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}

		
		/**
		 * 
		 */
		public function showMultiChoice(labels:Vector.<String>,checkedLabels:Vector.<Boolean>,buttons:Vector.<String>=null,title:String="",cancleble:Object=null):Boolean
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
			_selectedIndex = -1;
			try{
				context.call("showListDialog","show",_title,_buttons,labels,checkedLabels,_cancleble,_theme);
				return true;
			}catch(e:Error){
				showError("Error calling show method "+e.message,e.errorID);
			}
			return false;
		}
		
		
		
		/**
		 * 
		 */
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
		
		
		/**
		 * 
		 */
		public function get selectedLabels():Vector.<String>{
			var lab:Vector.<String> = new Vector.<String>();
			if(_list!==null && _list.length>0){
				for each (var obj:Object in _list) 
				{
					if(obj.selected == true)
						lab.push(obj.label);
				}
				if(lab.length>0 && _selectedIndex>-1)
					lab.push(_list[_selectedIndex].label);
			}
			return lab;
		}
		
		/**
		 * 
		 */
		public function get selectedIndexes():Vector.<int>{
			var indexes:Vector.<int> = new Vector.<int>();
			if(_list!==null && _list.length>0){
				for (var i:int = 0; i < _list.length; i++) 
				{
					if(_list[i].selected == true)
						indexes.push(i);
				}
				if(indexes.length>0 && _selectedIndex>-1)
					indexes.push(_selectedIndex);
			}
			return indexes;
		}
		
		
		/**
		 * 
		 */
		public function get selectedIndex():int{
			return _selectedIndex;
		}
		
		
		/**
		 * 
		 */
		public function get selectedLabel():String{
			if(_selectedIndex>-1 && _list!=null && _list.length>0)
				return _list[_selectedIndex].label;
			else
				return null;
		}
		
		
		
		/**
		 * 
		 */
		public function isShowing():Boolean{
			if(context){
				return context.call("showListDialog","isShowing");
			}else
				return false;
			
		}

		
		/**
		 * 
		 */
		public function get title():String
		{
			return _title;
		}
		/**
		 * 
		 */
		public function set title(value:String):void
		{
			if(value!=null && value!==_title){
				_title = value;
			}
		}
		/**
		 * 
		 */
		public function get cancleble():Boolean
		{
			return _cancleble;
		}
		/**
		 * 
		 */
		public function set cancleble(value:Boolean):void
		{
			_cancleble = value;
		}
		/**
		 * 
		 */
		public function get theme():int
		{
			return _theme;
		}
		/**
		 * 
		 */
		public function get buttons():Vector.<String>
		{
			return _buttons;
		}
		/**
		 * 
		 */
		public function set buttons(value:Vector.<String>):void
		{
			_buttons = value;
		}
		/**
		 * 
		 */
		public function set theme(value:int):void
		{
			_theme = value;
		}
		
		
		/**
		 * hides 
		 */
		public function hide():Boolean
		{
			try{
				context.call("showListDialog","hide");
				return true;
			}catch(e:Error){
				showError("Error calling hide method "+e.message,e.errorID);
			}
			return false;
		}
		/**
		 * 
		 */
		public function kill():Boolean
		{
			try{
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
		 * Whether the extension class is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(Capabilities.os.toLowerCase().indexOf("linux")>-1)
				return true;
			else 
				return false;
		}
		
		/**
		 * the theme from which to get the dialog's style (one of the constants THEME_DEVICE_DEFAULT_DARK, THEME_DEVICE_DEFAULT_LIGHT, or THEME_HOLO_LIGHT.
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeListDialog.THEME_DEVICE_DEFAULT_DARK
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeListDialog.THEME_DEVICE_DEFAULT_LIGHT
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeListDialog.THEME_HOLO_LIGHT
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeListDialog.THEME_HOLO_DARK
		 * @see pl.mateuszmackowiak.nativeANE.alert.NativeListDialog.THEME_TRADITIONAL
		 */
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
		/**
		 * @private
		 */
		private function showError(message:String,id:int=0):void
		{
			if(hasEventListener(NativeExtensionErrorEvent.ERROR))
				dispatchEvent(new NativeExtensionErrorEvent(NativeExtensionErrorEvent.ERROR,false,false,message,id));
			else
				throw new Error(message,id);
		}
		/**
		 * @private
		 */
		private function onStatus(event:StatusEvent):void
		{
			try{
				if(event.code == NativeDialogEvent.CLOSED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,event.level));
				}else if(event.code == NativeDialogEvent.CANCELED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CANCELED,event.level));
				}else if(event.code == NativeDialogEvent.OPENED){
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				}else if(event.code ==LogEvent.LOG_EVENT){
					dispatchEvent(new LogEvent(LogEvent.LOG_EVENT,event.level));
				}else if(event.code ==NativeDialogListEvent.LIST_CHANGE){
					var index:int = -1;
					if(event.level.indexOf("_")>-1){
						const args:Array = event.level.split("_");
						index = int(args[0]);
						var selected:Boolean=false;
						const selectedStr:String= String(args[1]).toLocaleLowerCase();
						if(selectedStr=="true" || selectedStr=="1")
							selected = true;
						_list[index].selected = selected;
						
						dispatchEvent(new NativeDialogListEvent(NativeDialogListEvent.LIST_CHANGE,index,selected));
					}else{
						index = int(event.level);
						_selectedIndex = index;
						dispatchEvent(new NativeDialogListEvent(NativeDialogListEvent.LIST_CHANGE,index,true));
					}
				}else{
					showError(event.toString());
				}
			}catch(e:Error){
				showError(e.message,e.errorID);
			}
		}
	}
}