# Native Dialogs - Adobe air Native Extension #
Update: NativeProgress for IOS // by [memeller](https://github.com/memeller)

Checked iOS 4.3,5.1 / android 3.1

See more info [here](http://mateuszmackowiak.wordpress.com)

[See compiled demo APK on You're android tablet](https://github.com/mateuszmackowiak/NativeAlert/blob/master/example/NativeAlertMobile/NativeAlertMobile.apk?raw=true)
###### This project has been started based on [liquid-photo](https://github.com/mccormicka/NativeAlert).

This extension enables showing native dialogs within a Air based project.

Available themes for android:

* THEME\_DEVICE\_DEFAULT\_DARK
* THEME\_DEVICE\_DEFAULT\_LIGHT
* THEME\_HOLO_DARK
* THEME\_HOLO_LIGHT
* THEME\_TRADITIONAL


## NativeAlert (IOS/Android/Windows) ##
Displays a native alert dialog.

*Usage:*

	NativeAlert.defaultAndroidTheme = NativeAlert.THEME_DEVICE_DEFAULT_DARK;
	if(NativeAlert.isSuported)
	NativeAlert.show( "some message" , "title" , "first button label" , "otherButtons,LabelsSeperated,WithAComma" , someAnswerFunction);
	NativeAlert.dispose();`







# NativeProgress (Android / IOS)#
Android and iOS:
  The ability to display the native dialog showing a progress bar or a spinner.

iOS only:
  The ability to show and hide the native status-bar networki busy indicator.

	if(NativeProgress.isNetworkActivityIndicatorAvalieble())
		NativeProgress.showNetworkActivityIndicator(true);

*Usage:*

	private var progressPopup:NativeProgress;
	private var p:int = 0;
	private var myTimer:Timer = new Timer(100);
	protected function openProgressPopup(style:int):void
	{
    	progressPopup = new NativeProgress(style);
     	progressPopup.theme = NativeProgress.THEME_HOLO_DARK;
	 	progressPopup.setSecondaryProgress(45);//This only works in android 
     	progressPopup.addEventListener(NativeDialogEvent.OPENED,traceEvent);
     	progressPopup.addEventListener(NativeDialogEvent.CANCLED,closeNativeProcessHandler);
     	progressPopup.addEventListener(NativeDialogEvent.CLOSED,closeNativeProcessHandler);
     	progressPopup.addEventListener(NativeExtensionErrorEvent.ERROR,onError);
	 	progressPopup.setMax(50);
	 	progressPopup.setIndeterminate = true;//This only works in android
     	progressPopup.show(0, titleInput.text , messageInput.text,true);

     	myTimer.addEventListener(TimerEvent.TIMER, updateProgress);
     	myTimer.start();
	}

	private function closeNativeProcessHandler(event:Event):void
	{
     	progressPopup.removeEventListener(NativeDialogEvent.CANCLED,closeNativeProcessHandler);
     	progressPopup.removeEventListener(NativeDialogEvent.CLOSED,closeNativeProcessHandler);
     	progressPopup.removeEventListener(NativeExtensionErrorEvent.ERROR,onError);
     	progressPopup.removeEventListener(NativeDialogEvent.OPENED,traceEvent);

		progressPopup.kill();
     	myTimer.removeEventListener(TimerEvent.TIMER,updateProgress);
     	myTimer.stop();
    	p = 0;
	}
	private function updateProgress(event:TimerEvent):void
	{
    	p++;
    	if(p>=50){
    		p = 0;
    		progressPopup.hide();
			(event.target as Timer).stop();
    	}else
		progressPopup.setProgress(p);
	}
	
	protected function viewBackKeyPressedHandler(event:FlexEvent):void
	{
    	event.preventDefault();
     	myTimer.removeEventListener(TimerEvent.TIMER,updateProgress);
     	myTimer.stop();
     	p = 0;
     	if(progressPopup){
	    	progressPopup.hide();
     	}
	}
	NativeApplication.nativeApplication.addEventListener(Event.EXITING,exiting);
	protected function exiting(event:Event):void
	{
    	if(progressPopup)
	    	progressPopup.kill();
	}


# NativeListDialog(Android) #

NativeListDialog has the ability to show a native android popup dialog with a multi-choice or single-choice inside a Adobe Air project.

*Usage:*

	private var multChDialog:NativeListDialog;
	private var choces:Vector.<String>;
	private var buttons:Vector.<String>;
	private var checkedItems:Vector.<Boolean>;
	private var selectedIndex:int = -1;
	
	protected function view1_viewActivateHandler(event:ViewNavigatorEvent):void
	{
		choces = new Vector.<String>();
		//the text of the items to be displayed in the list.
      	choces.push("one","two","three","four");
      	checkedItems = new Vector.<Boolean>();  
		// specifies which items are checked. It should be null in which case no items are checked. If non null it must be exactly the same length as the array of items.
      	checkedItems.push(true,false,false,true);
      	buttons = new Vector.<String>();
		//the labels for the buttons. It should be null in which case there will be only one button "OK". If non null max length 3 buttons
      	buttons.push("OK","Settings","Cancle");
	}
	protected function openMultiChoiceDialog(event:MouseEvent):void
	{
		multChDialog = new NativeListDialog();
    	multChDialog.theme = NativeListDialog.THEME_HOLO_DARK;
      	multChDialog.addEventListener(NativeDialogEvent.CANCLED,closeNativeDialogHandler);
      	multChDialog.addEventListener(NativeDialogEvent.OPENED,traceEvent);
      	multChDialog.addEventListener(NativeDialogEvent.CLOSED,closeNativeDialogHandler);
      	multChDialog.addEventListener(NativeExtensionErrorEvent.ERROR,onError);
     	multChDialog.addEventListener(NativeDialogListEvent.LIST_CHANGE,onListChange);
      	multChDialog.title ="Some Title";
      	multChDialog.cancleble = true;
      	multChDialog.showMultiChoice(choces,checkedItems,buttons);
	}
	public function openSingleChoiceDialog(event:MouseEvent):void
	{
		singleChDialog = new NativeListDialog();
		singleChDialog.theme = ThemeSelector.selectedItem.data;
		singleChDialog.addEventListener(NativeDialogEvent.CANCLED,closeNativeDialogHandler);
		singleChDialog.addEventListener(NativeDialogEvent.OPENED,traceEvent);
		singleChDialog.addEventListener(NativeDialogEvent.CLOSED,closeNativeDialogHandler);
		singleChDialog.addEventListener(LogEvent.LOG_EVENT,traceEvent);
		singleChDialog.addEventListener(NativeExtensionErrorEvent.ERROR,onError);
		singleChDialog.addEventListener(NativeDialogListEvent.LIST_CHANGE,onListChange);
		singleChDialog.cancleble = true;
		singleChDialog.showSingleChoice(choces,selectedIndex,buttons,titleInput.text);
	}
	public function closeNativeDialogHandler(event:NativeDialogEvent):void
	{
		var dialog:NativeListDialog = (event.target  as NativeListDialog);
		dialog.removeEventListener(NativeDialogEvent.CANCLED,closeNativeDialogHandler);
		dialog.removeEventListener(NativeDialogEvent.CLOSED,closeNativeDialogHandler);
		dialog.removeEventListener(NativeDialogEvent.OPENED,traceEvent);
		dialog.removeEventListener(NativeExtensionErrorEvent.ERROR,onError);
		dialog.kill();
	}
	private function onListChange(event:NativeDialogListEvent):void
	{
    	var dialog:NativeListDialog = (event.target as NativeListDialog)
		if(dialog.selectedIndex>-1){
			selectedIndex = dialog.selectedIndex;
		}else{
			const a:Vector.<String> = dialog.selectedLabels;
			if(a.length>0){
				for (var i:int = 0; i < a.length; i++) 
				{
					trace(a[i]);
				}
			}
		}
	}

# Text input Dialog (Android) #
Show a dialog with defined by user input text fields.

*Usage:*

	public function openTextInputDialog(event:MouseEvent):void{
		if(NativeTextInputDialog.isSupported()){
			textInputDialog = new NativeTextInputDialog();
			textInputDialog.theme = NativeTextInputDialog.THEME_HOLO_LIGHT;
			textInputDialog.addEventListener(NativeDialogEvent.CANCLED,trace);
			textInputDialog.addEventListener(NativeDialogEvent.OPENED,trace);
			textInputDialog.addEventListener(NativeExtensionErrorEvent.ERROR,trace);
			textInputDialog.addEventListener(NativeTextInputDialogEvent.CLOSED, onTextInputDialogClosedHandler);
			var buttons:Vector.<String> = new Vector.<String>();
			buttons.push("OK","Cancle");
			var v:Vector.<NativeTextInput> = new Vector.<NativeTextInput>();
			var ti1:NativeTextInput = new NativeTextInput("name");
			ti1.inputType = NativeTextInput.text;
			ti1.messageBefore ="name:";
			ti1.text = "jacek";
			v.push(ti1);
			var ti2:NativeTextInput = new NativeTextInput("password");
			ti2.inputType = NativeTextInput.textPassword;
			ti2.messageBefore ="password:";
			ti2.text = "dddd";
			v.push(ti2);
			textInputDialog.show(titleInput.text,v,buttons);
		}
	}
	private function onTextInputDialogClosedHandler(event:NativeTextInputDialogEvent):void
	{
		for each (var n:NativeTextInput in event.list) 
		{
			trace(n.name+":  "+n.text);
		}
		trace(event.buttonIndex);
	}
# Toast (Android) #


*Usage:*

	Toast.show("some message",Toast.LENGTH_LONG);


	var randX:int = Math.random()*600;
	var randY:int = Math.random()*600;
	Toast.showWithDifferentGravit("some message",Toast.LENGTH_SHORT,Toast.GRAVITY_LEFT,randX,randY);




# System Properties (Android) #
SystemProperties class can provide some of the missing properties that You can’t get in adobe air

Available parameters: 

* os - like in Capabilities (IOS/Androdi)
* language - the set language in the system (Android)
* architecture of the cpu (Android)
* package name (Android)
* source directory (Android)
* application uid -always when a application is installed on device the system creates a unique id for setting up the space for it (Android)
* UID - created a unique ID for the device based on some of the device properties (Android) - The UDID of the device (IOS)
* name - the name of the device (IOS)


**requires **

	<uses-permission android:name="android.permission.READ_PHONE_STATE" />
*Usage:*

	if(SystemProperties.isSupported()){
		var dictionary:Dictionary = SystemProperties.getProperites(); 
		for (var key:String in dictionary) 
		{ 
			var readingType:String = key; 
			var readingValue:String = dictionary[key]; 
			trace(readingType + "=" + readingValue); 
		} 
		dictionary = null;
	}
	