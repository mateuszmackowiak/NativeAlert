//
//  NativeAlert.m
//  NativeAlert
//
//  Created by Mateusz Maćkowiak
//  Copyright (c) 2012 Mateusz Maćkowiak. All rights reserved.
//

#include "FlashRuntimeExtensions.h"
#import "MobileAlert.h"


#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>


#import "SlideNotification.h"
//#import "SVProgressHUD.h"
MobileAlert *alert;



//---------------------------------------------------------------------
//
// ALERT
//
//---------------------------------------------------------------------
FREObject showAlertWithTitleAndMessage(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    //Temporary values to hold our actionscript code.
    uint32_t titleLength;
    const uint8_t *title;
    uint32_t messageLength;
    const uint8_t *message;
    uint32_t closeLength;
    const uint8_t *closeLabel;
    uint32_t otherLength;
    const uint8_t *otherLabels;
    
    //Turn our actionscrpt code into native code.
    FREGetObjectAsUTF8(argv[0], &titleLength, &title);
    FREGetObjectAsUTF8(argv[1], &messageLength, &message);
    FREGetObjectAsUTF8(argv[2], &closeLength, &closeLabel);
    FREGetObjectAsUTF8(argv[3], &otherLength, &otherLabels);
    
    //Create our Strings for our Alert.
    NSString *titleString = [NSString stringWithUTF8String:(char*)title];
    NSString *messageString = [NSString stringWithUTF8String:(char*)message];
    NSString *closeLabelString = [NSString stringWithUTF8String:(char*)closeLabel];    
    NSString *otherLabelsString = [NSString stringWithUTF8String:(char*)otherLabels];    
    
    alert = [[MobileAlert alloc] init];
    [alert showAlertWithTitle:titleString 
                      message:messageString 
                   closeLabel:closeLabelString
                  otherLabels:otherLabelsString
                      context:ctx];
    return NULL;    
}


//---------------------------------------------------------------------
//
// PROGRESS
//
//---------------------------------------------------------------------
FREObject showProgressPopup(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    //Temporary values to hold our actionscript code.
    uint32_t titleLength;
    const uint8_t *title;
    uint32_t messageLength;
    const uint8_t *message;;
    double progressParam;
    
    uint32_t showActivityValue, cancleble;
    int32_t style,theme;
    //Turn our actionscrpt code into native code.
    FREGetObjectAsDouble(argv[0], &progressParam);
    ///Secondary progress ignored
    FREGetObjectAsInt32(argv[2], &style);
    FREGetObjectAsUTF8(argv[3], &titleLength, &title);
    FREGetObjectAsUTF8(argv[4], &messageLength, &message);
    FREGetObjectAsBool(argv[5], &cancleble);
    FREGetObjectAsBool(argv[6], &showActivityValue);
    FREGetObjectAsInt32(argv[7], &theme);
    
    //Create our Strings for our Alert.
    NSInteger styleValue=(NSInteger)style;
  
    NSString *titleString = [NSString stringWithUTF8String:(char*)title];
    NSString *messageString = [NSString stringWithUTF8String:(char*)message];
    NSNumber *progressValue =[NSNumber numberWithDouble:progressParam];
    
   /* if(theme == 2){
        if(messageString && ![messageString isEqualToString:@""])
            if(cancleble)
                //[SVProgressHUD showWithStatus:messageString];
            else
                //[SVProgressHUD showWithStatus:messageString maskType:SVProgressHUDMaskTypeBlack];
        else {
            if (cancleble) 
                [SVProgressHUD show];
            else
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        }
    }else if(theme == 3){
        if(messageString && ![messageString isEqualToString:@""])
            if(cancleble)
                [SVProgressHUD showWithStatus:messageString];
            else
                [SVProgressHUD showWithStatus:messageString maskType:SVProgressHUDMaskTypeClear];
            else {
                if (cancleble) 
                    [SVProgressHUD show];
                else
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            }
    }else{*/
        alert = [[MobileAlert alloc] init];
        [alert showProgressPopup:titleString 
                           style:styleValue
                         message:messageString 
                        progress:progressValue
                    showActivity:showActivityValue
                       cancleble:cancleble
                         context:ctx];
   // }
    return NULL;    
}

//---------------------------------------------------------------------
//
// TEXT INPUT DIALOG
//
//---------------------------------------------------------------------
FREObject showTextInputDialog(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    //Temporary values to hold our actionscript code.
    uint32_t titleLength;
    const uint8_t *title;
    uint32_t messageLength;
    const uint8_t *message;
    
    
    

    
    //Create our Strings for our Alert.
   
   
    NSString *titleString = nil;
    NSString *messageString =nil;
    
    if(argv[0]!=NULL){
        FREGetObjectAsUTF8(argv[0], &titleLength, &title);
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    if(argv[1]!=NULL){
        FREGetObjectAsUTF8(argv[1], &messageLength, &message);
        messageString = [NSString stringWithUTF8String:(char*)message]; 
    }
    alert = [[MobileAlert alloc] init];
    [alert showTextInputDialog:titleString message:messageString textInputs:argv[2] buttons:argv[3] context:ctx];
    
    return NULL;    
}
FREObject shake(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    if(alert!=NULL)
        [alert shake];
    return NULL;
}

FREObject showHidenetworkIndicator(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    UIApplication* app = [UIApplication sharedApplication];
    if(argc>0 && argv[0]){
        uint32_t shownetworkActivity;
        FREGetObjectAsBool(argv[0], &shownetworkActivity);
        
        if(app && app.networkActivityIndicatorVisible != shownetworkActivity)
            app.networkActivityIndicatorVisible = shownetworkActivity;
    }
    FREObject retVal;
    
    if(app && FRENewObjectFromBool(app.networkActivityIndicatorVisible, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}
FREObject updateProgress(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    //Temporary values to hold our actionscript code.
    double perc;
    //Turn our actionscrpt code into native code.
    FREGetObjectAsDouble(argv[0], &perc);
    CGFloat percFloat = perc;	
    [alert updateProgress:percFloat];
    //Create our Strings for our Alert.
    return NULL;    
}	
FREObject hide(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    if(alert)
        [alert hide];
    //[SVProgressHUD dismiss];
    //Create our Strings for our Alert.
    return NULL; 
}
FREObject updateMessage(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    //Temporary values to hold our actionscript code.
    uint32_t messageLength;
    const uint8_t *message;
    //Turn our actionscrpt code into native code.
    
    FREGetObjectAsUTF8(argv[0], &messageLength, &message);
    
    NSString *nsMessage = nil;
    if(message){
        nsMessage = [NSString stringWithUTF8String:(char*)message];
      //  if(SVProgressHUD.isVisible)
      //      [SVProgressHUD setStatus:nsMessage];
        if(alert)
            [alert updateMessage:nsMessage];
    }
    
    
    //Create our Strings for our Alert.
    return NULL;    
}
FREObject updateTitle(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    //Temporary values to hold our actionscript code.
    uint32_t titleLength;
    const uint8_t *title;
    //Turn our actionscrpt code into native code.
    
    FREGetObjectAsUTF8(argv[0], &titleLength, &title);
    if(alert){
        NSString *nsTitle =@"";
        if(title){
             [NSString stringWithUTF8String:(char*)title];
        }
        [alert updateTitle:nsTitle];
    }
    //Create our Strings for our Alert.
    return NULL;    
}

FREObject isShowing(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    BOOL ret = NO;
    if (alert) {
        ret = alert.isShowing;
    }
    //if(SVProgressHUD.isVisible)
      //  ret = YES;
    FREObject retVal;
    if(FRENewObjectFromBool(ret, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
    
}
//


FREObject showToast(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    if(argv==NULL)
        return NULL;
    
    uint32_t messageLength;
    const uint8_t *message;
    double dur;
    FREGetObjectAsDouble(argv[1], &dur);
    FREGetObjectAsUTF8(argv[0], &messageLength, &message);
    
    NSString* messageString=[NSString stringWithUTF8String:(char*)message];

    float duration = [SlideNotification SHORT];
    if(dur==1)
        duration = [SlideNotification LONG];
    //NSLog(@"%f",dur);
    if(messageString!=nil && ![messageString isEqualToString:@""]){
        [SlideNotification showMessage2:messageString duration:duration];
    }
    
    
    return NULL;
}



FREObject showNotification(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    
    uint32_t messageLength;
    uint32_t soundUrlLength;
    uint32_t buttonLabelLength;
    double timeStamp;
    
    const uint8_t *message;
    const uint8_t *buttonLabel;
    const uint8_t *soundUrl;
    
    FREGetObjectAsUTF8(argv[0], &messageLength, &message);
    FREGetObjectAsUTF8(argv[1], &buttonLabelLength, &buttonLabel);
    
    NSString *buttonLabelString = [NSString stringWithUTF8String:(char*)buttonLabel];
    NSString *messageString = [NSString stringWithUTF8String:(char*)message];
    
    
    // NSDictionary *userInfo = [NSDictionary dictionaryWithObject: @"ID" forKey: @"Test"];;
   
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
     //Set the date when the alert will be launched using the date adding the time the user selected on the timer
    [localNotification setAlertAction:buttonLabelString]; //The button's text that launches the application and is shown in the alert
    [localNotification setAlertBody:messageString]; //Set the message in the notification from the textField's text
    [localNotification setHasAction: YES]; //Set that pushing the button will launch the application
    [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1]; //Set the Application Icon Badge Number of the application's icon to the current Application Icon Badge Number plus 1
    // localNotification.userInfo = userInfo;
    if(argc>2){
        FREGetObjectAsDouble(argv[2], &timeStamp);
        NSLog(@"timeStamp %f",timeStamp);
        if(timeStamp>-1){
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
            NSLog(@"converted date: %@",date);
            
            NSLog(@"current date: %@",[NSDate date]);
            [localNotification setFireDate:date];
        }
    }

    if(argc>3 && argv[3]!=nil){
        FREGetObjectAsUTF8(argv[3], &soundUrlLength, &soundUrl);
        NSString *soundUrlString = [NSString stringWithUTF8String:(char*)soundUrl];
        
        if (soundUrlString != nil && ![soundUrlString isEqualToString:@""]){
           if([soundUrlString isEqualToString:@"defaultSound"]) { 
               localNotification.soundName = @"UILocalNotificationDefaultSoundName";
              
           }else
               localNotification.soundName =soundUrlString;
        }
    }

  
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //Schedule the notification with the system
    [localNotification release];
    
    return nil;
}



//---------------------------------------------------------------------
//
// SYSTEM PROPERTIES
//
//---------------------------------------------------------------------


/**
*John Muchow (http://iPhoneDeveloperTips.com/device/determine-mac-address.html)
*/
NSString * getMacAddress()
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;              
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) 
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) 
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                                  macAddress[0], macAddress[1], macAddress[2], 
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

//[[UIApplication sharedApplication] setApplicationIconBadgeNumber:99];
NSString* getCustomUDID(){
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return [uuidString autorelease];
}

FREObject getSystemProperties(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    
    FREObject dic;
    if(FRENewObject((const uint8_t *)"flash.utils.Dictionary",0, NULL, &dic, NULL)==FRE_OK){
        UIDevice * device = [UIDevice currentDevice];
        
        const char *osCh = [[device systemName] UTF8String];
        const char *versionCh = [[device systemVersion] UTF8String];
        //const char *udidCh = [[device uniqueIdentifier] UTF8String];
        
        NSString *uid = nil;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"NativeAletUID"] == nil) {
            uid = getCustomUDID();
            [defaults setObject:uid forKey:@"NativeAletUID"];
            [defaults synchronize];
        }else{
            uid = [defaults objectForKey:@"NativeAletUID"];
        }
        
        const char *udidCh = [uid UTF8String];
        
        //const char *uidCh = "";//[[[UIApplication sharedApplication] uniqueInstallationIdentifier] UTF8String];
        const char *nameCh = [[device name] UTF8String];
        const char *MACadress = [getMacAddress() UTF8String];
        const char *localizedModel = [[device localizedModel] UTF8String];
        const char *model = [[device model] UTF8String];
        // float batLevel = [device batteryLevel];
        
       
        //FREObject uidObj;
        FREObject udidObj;
        FREObject osObj;
        FREObject versionObj;
        FREObject nameObj;
        FREObject MACadressObj;
        FREObject localizedModelObj;
        FREObject modelObj;
        
        
        
        FRENewObjectFromUTF8(strlen(udidCh)+1, (const uint8_t*)udidCh, &udidObj);
        //FRENewObjectFromUTF8(strlen(uidCh)+1, (const uint8_t*)uidCh, &uidObj);
        FRENewObjectFromUTF8(strlen(osCh)+1, (const uint8_t*)osCh, &osObj);
        FRENewObjectFromUTF8(strlen(versionCh)+1, (const uint8_t*)versionCh, &versionObj);
        FRENewObjectFromUTF8(strlen(nameCh)+1, (const uint8_t*)nameCh, &nameObj);
        
        FRENewObjectFromUTF8(strlen(MACadress)+1, (const uint8_t*)MACadress, &MACadressObj);
        FRENewObjectFromUTF8(strlen(localizedModel)+1, (const uint8_t*)localizedModel, &localizedModelObj);
        FRENewObjectFromUTF8(strlen(model)+1, (const uint8_t*)model, &modelObj);

       // FRESetObjectProperty(dic, (const uint8_t*)"UID", uidObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"UDID", udidObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"os", osObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"version", versionObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"name", nameObj, NULL);
        
        FRESetObjectProperty(dic, (const uint8_t*)"MACAdress", MACadressObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"localizedModel", localizedModelObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"model", modelObj, NULL);
        return dic;
    }else{
        return nil;
    }
}







//------------------------------------
//
// Required Methods.
//
//------------------------------------
static const char * SYSTEM_PROPERTIES_KEY = "SystemProperites";
static const char * PROGRESS_KEY = "ProgressContext";
static const char * NETWORK_ACTIVITY_INDICATOR = "NetworkActivityIndicatoror";
static const char * LOCAL_NOTIFICATION = "LocalNotification";
static const char * TEXT_INPUT_DIALOG = "TextInputDialogContext";
static const char * TOAST = "ToastContext";

FREObject setBadge(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    int32_t value;
    FREGetObjectAsInt32(argv[0], &value);
    NSLog(@"setting badege to %i",value);
    [UIApplication sharedApplication].applicationIconBadgeNumber = value;
    return NULL;
}
FREObject getBadge(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    
    uint32_t ret = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    FREObject retObj = nil;
    FRENewObjectFromUint32(ret, &retObj);
    
    return retObj;
}

FREObject isSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}


// NativeDialogContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void NativeDialogContextInitializer(void* extData, const uint8_t * ctxType, FREContext ctx, 
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    int count=2;
    if(strcmp((const char *)ctxType, PROGRESS_KEY)==0){
        count = 7;
        NSLog(@"ctxType %s",ctxType);
    }else if(strcmp((const char *)ctxType, TEXT_INPUT_DIALOG)==0){
        count = 6;
        NSLog(@"ctxType %s",ctxType);
    }else if (strcmp((const char *)ctxType, "")==0){
        count = 4;
        NSLog(@"ctxType is empty");
    }else{
        NSLog(@"ctxType %s",ctxType);
    }
    
    
	*numFunctionsToTest = count;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * count);
    
    
    func[0].name = (const uint8_t *) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &isSupported;
    
    if(strcmp((const char *)ctxType, SYSTEM_PROPERTIES_KEY)==0){
        func[1].name = (const uint8_t *) "getSystemProperty";
        func[1].functionData = NULL;
        func[1].function = &getSystemProperties;
    }else if(strcmp((const char *)ctxType, TOAST)==0){
        
        func[1].name = (const uint8_t *) "Toast";
        func[1].functionData = NULL;
        func[1].function = &showToast;
        
    }else if(strcmp((const char *)ctxType, NETWORK_ACTIVITY_INDICATOR)==0){
        
        func[1].name = (const uint8_t *) "showHidenetworkIndicator";
        func[1].functionData = NULL;
        func[1].function = &showHidenetworkIndicator;
        
    }else if(strcmp((const char *)ctxType, LOCAL_NOTIFICATION)==0){
        
        func[1].name = (const uint8_t *) "showNotification";
        func[1].functionData = NULL;
        func[1].function = &showNotification;
        
    }else if(strcmp((const char *)ctxType, TEXT_INPUT_DIALOG)==0){
    
        func[1].name = (const uint8_t*) "isShowing";
        func[1].functionData = NULL;
        func[1].function = &isShowing;
        
        func[2].name = (const uint8_t *) "show";
        func[2].functionData = NULL;
        func[2].function = &showTextInputDialog;
        
        func[3].name = (const uint8_t*) "updateTitle";
        func[3].functionData = NULL;
        func[3].function = &updateTitle;
        
        func[4].name = (const uint8_t*) "hide";
        func[4].functionData = NULL;
        func[4].function = &hide;
        
        func[5].name = (const uint8_t*) "shake";
        func[5].functionData = NULL;
        func[5].function = &shake;
        
    }else if(strcmp((const char *)ctxType, PROGRESS_KEY)==0){
        func[1].name = (const uint8_t*) "isShowing";
        func[1].functionData = NULL;
        func[1].function = &isShowing;
        
        func[2].name = (const uint8_t *) "showProgressPopup";
        func[2].functionData = NULL;
        func[2].function = &showProgressPopup;
        
        func[3].name = (const uint8_t*) "updateProgress";
        func[3].functionData = NULL;
        func[3].function = &updateProgress;
        
        func[4].name = (const uint8_t*) "hideProgress";
        func[4].functionData = NULL;
        func[4].function = &hide;
        
        func[5].name = (const uint8_t*) "updateMessage";
        func[5].functionData = NULL;
        func[5].function = &updateMessage;

        func[6].name = (const uint8_t*) "updateTitle";
        func[6].functionData = NULL;
        func[6].function = &updateTitle;
        
    }else{
        func[1].name = (const uint8_t *) "showAlertWithTitleAndMessage";
        func[1].functionData = NULL;
        func[1].function = &showAlertWithTitleAndMessage;
        
        func[2].name = (const uint8_t *) "setBadge";
        func[2].functionData = NULL;
        func[2].function = &setBadge;
        
        func[3].name = (const uint8_t *) "getBadge";
        func[3].functionData = NULL;
        func[3].function = &getBadge;
    }
    
    
    
	*functionsToSet = func;
}



// NativeDialogContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void NativeDialogContextFinalizer(FREContext ctx) {
    
    NSLog(@"Entering ContextFinalizer()");
    if(alert!=NULL){
        [alert hide];
        [alert release];
    }
    NSLog(@"Exiting ContextFinalizer()");
    
	return;
}

// NativeDialogExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void NativeDialogExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                    FREContextFinalizer* ctxFinalizerToSet) {
    
    NSLog(@"Entering ExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &NativeDialogContextInitializer;
    *ctxFinalizerToSet = &NativeDialogContextFinalizer;
    
    NSLog(@"Exiting ExtInitializer()");
}

// NativeDialogExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void NativeDialogExtFinalizer(void* extData) {
    
    NSLog(@"Entering ExtFinalizer()");
    
    // Nothing to clean up.
    
    NSLog(@"Exiting ExtFinalizer()");
    return;
}