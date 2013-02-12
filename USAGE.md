Checked iOS 5.1 / android 2.3/3.1

See more info [here](http://mateuszmackowiak.wordpress.com)

[See compiled demo APK on You're android device](https://github.com/mateuszmackowiak/NativeAlert/blob/master/example/NativeAlertMobile/NativeAlertMobile.apk?raw=true)


This extension enables showing native dialogs within a Air based project.

#####Available themes for android:

* ANDROID\_DEVICE\_DEFAULT\_DARK\_THEME
* ANDROID\_DEVICE\_DEFAULT\_LIGHT\_THEME
* ANDROID\_HOLO\_DARK\_THEME
* ANDROID\_HOLO\_LIGHT\_THEME
* DEFAULT\_THEME


## NativeAlert (IOS/Android/Windows) ##
Android and iOS:
  Displays a native alert dialog.

iOS only:
	setting the badge of the app




*Usage:*

	NativeAlert.defaultTheme = NativeAlert.ANDROID_DEVICE_DEFAULT_DARK_THEME;// not necessary
	if(NativeAlert.isSuported)
	NativeAlert.show( "some message" , "title" , "first button label" , "otherButtons,LabelsSeperated,WithAComma" , someAnswerFunction);
	
	NativeAlert.dispose(); //only when exiting app
	private function someAnswerFunction(event:NativeDialogEvent):void{
		//event.preventDefault(); // default behavior is to remove listener for function "someAnswerFunction()"
		trace(event.toString());
	}






# NativeProgress (Android / IOS) #
Android and iOS:
  The ability to display the native dialog showing a progress bar or a spinner.

NativeProgress for IOS by [memeller](https://github.com/memeller)

Available themes for IOS:

* IOS\_SVHUD\_BLACK\_BACKGROUND\_THEME - uses [SVProgressHUD](http://github.com/samvermette/SVProgressHUD)
* IOS\_SVHUD\_NON\_BACKGROUND\_THEME - uses [SVProgressHUD](http://github.com/samvermette/SVProgressHUD)
* IOS\_SVHUD\_GRADIENT\_BACKGROUND\_THEME - uses [SVProgressHUD](http://github.com/samvermette/SVProgressHUD)
* DEFAULT\_THEME (cancleble is ignored)


iOS only:
![](https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/NetworkActivityIndicatoror.png)
  The ability to show and hide the native status-bar networki busy indicator.

	if(NativeProgress.isNetworkActivityIndicatorSupported())
		NativeProgress.showNetworkActivityIndicator(true);

*Usage:*

	private var progressPopup:NativeProgress;
	private var p:int = 0;
	private var myTimer:Timer = new Timer(100);
	protected function openProgressPopup(style:int):void
	{
    		progressPopup = new NativeProgress(style);
		progressPopup.setSecondaryProgress(45);
		progressPopup.addEventListener(NativeDialogEvent.CANCELED,closeNativeProcessHandler);
		progressPopup.addEventListener(NativeDialogEvent.OPENED,traceEvent);
		progressPopup.addEventListener(NativeDialogEvent.CLOSED,closeNativeProcessHandler);
		progressPopup.addEventListener(ErrorEvent.ERROR,onError);// changed from NativeExtensionErrorEvent
		progressPopup.theme = ThemeSelector.selectedItem.data;
		progressPopup.setMax(50);
		progressPopup.setTitle(titleInput.text);
		progressPopup.setMessage(messageInput.text);
		progressPopup.show(canclebleCheckbox.selected,indeterminateInput.selected);
		myTimer.addEventListener(TimerEvent.TIMER, updateProgress);
		myTimer.start();
	}

	private function closeNativeProcessHandler(event:Event):void
	{
     		progressPopup.removeEventListener(NativeDialogEvent.CANCELED,closeNativeProcessHandler);
     		progressPopup.removeEventListener(NativeDialogEvent.CLOSED,closeNativeProcessHandler);
     		progressPopup.removeEventListener(ErrorEvent.ERROR,onError);// changed from NativeExtensionErrorEvent
     		progressPopup.removeEventListener(NativeDialogEvent.OPENED,traceEvent);

		progressPopup.dispose();//before kill()
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
	    		progressPopup.hide("some message");
     		}
	}
	
	NativeApplication.nativeApplication.addEventListener(Event.EXITING,exiting);
	
	protected function exiting(event:Event):void
	{
    		if(progressPopup)
	    		progressPopup.dispose();//before kill()
	}


# NativeListDialog(Android / IOS) #
IOS uses: [SBTableAlert](https://github.com/blommegard/SBTableAlert)

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
    		multChDialog.theme = NativeListDialog.ANDROID_DEVICE_DEFAULT_LIGHT_THEME;
    		
      		multChDialog.addEventListener(NativeDialogEvent.CANCELED,closeNativeDialogHandler);
      		multChDialog.addEventListener(NativeDialogEvent.OPENED,traceEvent);
      		multChDialog.addEventListener(NativeDialogEvent.CLOSED,closeNativeDialogHandler);
      		multChDialog.addEventListener(ErrorEvent.ERROR,onError);// changed from NativeExtensionErrorEvent
     		multChDialog.addEventListener(NativeDialogListEvent.LIST_CHANGE,onListChange);
     		
      		multChDialog.setTitle(titleInput.text); // before title ="Some Title"; - can change while in popup
      		multChDialog.setCancelable(canclebleCheckbox.selected);// before cancleble = true;- can change while in popup
      		multChDialog.buttons = buttons;//before in show method
      		multChDialog.showMultiChoice(choces,checkedItems);
	}
	public function openSingleChoiceDialog(event:MouseEvent):void
	{
		singleChDialog = new NativeListDialog();
		singleChDialog.theme = NativeListDialog.ANDROID_DEVICE_DEFAULT_LIGHT_THEME;
		singleChDialog.addEventListener(NativeDialogEvent.CANCELED,closeNativeDialogHandler);
		singleChDialog.addEventListener(NativeDialogEvent.OPENED,traceEvent);
		singleChDialog.addEventListener(NativeDialogEvent.CLOSED,closeNativeDialogHandler);

		singleChDialog.addEventListener(ErrorEvent.ERROR,onError);// changed from NativeExtensionErrorEvent
		
		singleChDialog.addEventListener(NativeDialogListEvent.LIST_CHANGE,onListChange);
		singleChDialog.setCancelable(canclebleCheckbox.selected);// before cancleble = true;- can change while in popup
		singleChDialog.buttons = buttons;//before in show method
		singleChDialog.setTitle(titleInput.text); // before title ="Some Title"; - can change while in popup
		singleChDialog.showSingleChoice(choces,selectedIndex);
	}
	public function closeNativeDialogHandler(event:NativeDialogEvent):void
	{
		var dialog:NativeListDialog = (event.target  as NativeListDialog);
		dialog.removeEventListener(NativeDialogEvent.CANCELED,closeNativeDialogHandler);
		dialog.removeEventListener(NativeDialogEvent.CLOSED,closeNativeDialogHandler);
		dialog.removeEventListener(NativeDialogEvent.OPENED,traceEvent);
		dialog.removeEventListener(ErrorEvent.ERROR,onError);// changed from NativeExtensionErrorEvent
		dialog.dispose();//before kill()
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

# Text input Dialog (Android /IOS) #
Show a dialog with defined by user input text fields.

NOW ON IOS 4.0 (on IOS 5 uses the new methods) - on ios 4 don't know if Apple will not refuses
###Important:###
IOS limitations -  There can be only 2 buttons and 2 text inputs. To display message specyfie for the first NativeTextField editable == false

*Usage:*

	public function openTextInputDialog(event:MouseEvent):void{
		if(NativeTextInputDialog.isSupported()){
			textInputDialog = new NativeTextInputDialog();
			textInputDialog.theme = NativeTextInputDialog.ANDROID_HOLO_DARK_THEME;
			
			textInputDialog.addEventListener(NativeDialogEvent.CANCELED,trace);
			textInputDialog.addEventListener(NativeDialogEvent.OPENED,trace);
			textInputDialog.addEventListener(ErrorEvent.ERROR,trace);// changed from NativeExtensionErrorEvent
			textInputDialog.addEventListener(NativeDialogEvent.CLOSED, onTextInputDialogClosedHandler);//before NativeTextInputDialogEvent

			var v:Vector.<NativeTextField> = new Vector.<NativeTextField>();
				
			var ti1:NativeTextField = new NativeTextField(null);
			ti1.text ="enter name and password:";
			ti1.editable = false;
			v.push(ti1);
				
			var ti:NativeTextField = new NativeTextField("name");
			ti.prompText = "name";
			ti.text = "John Doe";
			v.push(ti);
				
			var ti2:NativeTextField = new NativeTextField("password");
			ti2.displayAsPassword = true;
			ti2.prompText = "password";
			ti2.softKeyboardType = SoftKeyboardType.NUMBER;
			ti2.text = "77799";
			v.push(ti2);
				
			textInputDialog.show(titleInput.text,v,buttons);
		}
	}
	private function onTextInputDialogClosedHandler(event:NativeDialogEvent):void // before NativeTextInputDialogEvent
	{
		for each (var n:NativeTextField in event.list) 
		{
			trace(n.name+":  "+n.text);
		}
		trace(event.buttonIndex);
	}
	
# Toast (Android / IOS) #

![](https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/AndoridToast.png)

For IOS uses : [SlideNotification](https://github.com/mateuszmackowiak/SlideNotification)

![](https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/IOSToast.png)

###Important:###
IOS limitations - Toast will always be on the bottom of the screen (both functions work)


*Usage:*

	Toast.show("some message",Toast.LENGTH_LONG);


	var randX:int = Math.random()*600;
	var randY:int = Math.random()*600;
	Toast.showWithDifferentGravit("some message",Toast.LENGTH_SHORT,Toast.GRAVITY_LEFT,randX,randY);




# System Properties (Android / IOS) #
SystemProperties class can provide some of the missing properties that You can’t get in adobe air


*Usage (badge):*

	if(SystemProperties.isBadgeSupported())
		SystemProperties.getInstance().badge = 4;
		
		
Available parameters: 

(IOS/Android)
* version - The current version of the operating system.
* os - The name of the operating system running on the device.
* language - the set language in the system
* UID - created a unique ID for the device based on some of the device properties
* name - the name of the device
* MACAddress - MAC Address
* model

(Android)
* serial - serial number of Android system 
* arch - architecture of the cpu
* packageName - package name
* sourceDir - source directory
* AppUid -always when a application is installed on device the system creates a unique id for setting up the space for it
* phoneNumber
* IMSI
* IMEI

(IOS)
* localizedModel 


**requires **

	<uses-permission android:name="android.permission.READ_PHONE_STATE" />
*Usage:*

	if(SystemProperties.isSupported()){
	
		// getProperites(); -Deprecated
		
		var dictionary:Dictionary = SystemProperties.getInstance().getSystemProperites();
		for (var key:String in dictionary) 
		{ 
			var readingType:String = key; 
			var readingValue:String = dictionary[key]; 
			trace(readingType + "=" + readingValue); 
		} 
		dictionary = null;
		
		
		
		if(SystemPropertie.isIOS()){
			trace(SystemProperties.getInstance().canOpenUrl("http://maps.google.com/maps?ll=-37.812022,144.969277"));
		}
		
		
		SystemProperties.getInstance().console("some text to console");
	}
	
	
###### This project has been started based on a project by [liquid-photo](https://github.com/mccormicka/NativeAlert).
