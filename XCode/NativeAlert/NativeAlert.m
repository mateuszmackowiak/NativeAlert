//
//  NativeAlert.m
//  NativeAlert
//
//  Created by Mateusz Maćkowiak
//  Copyright (c) 2012 Mateusz Maćkowiak. All rights reserved.
//

#include "FlashRuntimeExtensions.h"
#import "MobileAlert.h"
#import "UIApplication+UIID.h"
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
    
    uint32_t showActivityValue;
    int32_t style;
    //Turn our actionscrpt code into native code.
    FREGetObjectAsDouble(argv[0], &progressParam);
    ///Secondary progress ignored
    FREGetObjectAsInt32(argv[2], &style);
    FREGetObjectAsUTF8(argv[3], &titleLength, &title);
    FREGetObjectAsUTF8(argv[4], &messageLength, &message);
    ///Cancleble ignored
    FREGetObjectAsBool(argv[6], &showActivityValue);
    
    //Create our Strings for our Alert.
    NSInteger styleValue=(NSInteger)style;
    NSString *titleString = [NSString stringWithUTF8String:(char*)title];
    NSString *messageString = [NSString stringWithUTF8String:(char*)message];
    //NSString *closeLabelString = [NSString stringWithUTF8String:(char*)closeLabel];    
    // NSString *otherLabelsString = [NSString stringWithUTF8String:(char*)otherLabels];    
    NSNumber *progressValue =[NSNumber numberWithDouble:progressParam];
    
    alert = [[MobileAlert alloc] init];
    [alert showProgressPopup:titleString 
                       style:styleValue
                     message:messageString 
                    progress:progressValue
                showActivity:showActivityValue
                     context:ctx];
    
    return NULL;    
}




FREObject showHidenetworkIndicator(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    
    uint32_t shownetworkActivity;
    FREGetObjectAsBool(argv[0], &shownetworkActivity);
    
    UIApplication* app = [UIApplication sharedApplication];
    if(app.networkActivityIndicatorVisible != shownetworkActivity)
        app.networkActivityIndicatorVisible = shownetworkActivity;
    
    FREObject retVal;
    if(FRENewObjectFromBool(app.networkActivityIndicatorVisible, &retVal) == FRE_OK){
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
FREObject hideProgress(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    [alert hideProgress];
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
    if(alert!=NULL){
        NSString *nsMessage =@"";
        if(message!=NULL){
            nsMessage = [NSString stringWithUTF8String:(char*)message];
        }
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
    if(alert!=NULL){
        NSString *nsTitle =@"";
        if(title!=NULL){
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
    FREObject retVal;
    if(FRENewObjectFromBool(ret, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
    
}


//---------------------------------------------------------------------
//
// SYSTEM PROPERTIES
//
//---------------------------------------------------------------------

FREObject getSystemProperties(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    
    FREObject dic;
    if(FRENewObject((const uint8_t *)"flash.utils.Dictionary",0, NULL, &dic, NULL)==FRE_OK){
        UIDevice * device = [UIDevice currentDevice];
        
        const char *osCh = [[device systemName] UTF8String];
        const char *versionCh = [[device systemVersion] UTF8String];
        const char *udidCh = [[device uniqueIdentifier] UTF8String];
        const char *uidCh = "";//[[[UIApplication sharedApplication] uniqueInstallationIdentifier] UTF8String];
        const char *nameCh = [[device name] UTF8String];
        // float batLevel = [device batteryLevel];
       
        FREObject uidObj;
        FREObject udidObj;
        FREObject osObj;
        FREObject versionObj;
        FREObject nameObj;
        
        FRENewObjectFromUTF8(strlen(udidCh)+1, (const uint8_t*)udidCh, &udidObj);
        FRENewObjectFromUTF8(strlen(uidCh)+1, (const uint8_t*)uidCh, &uidObj);
        FRENewObjectFromUTF8(strlen(osCh)+1, (const uint8_t*)osCh, &osObj);
        FRENewObjectFromUTF8(strlen(versionCh)+1, (const uint8_t*)versionCh, &versionObj);
        FRENewObjectFromUTF8(strlen(nameCh)+1, (const uint8_t*)nameCh, &nameObj);

        FRESetObjectProperty(dic, (const uint8_t*)"UID", uidObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"UDID", udidObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"os", osObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"version", versionObj, NULL);
        FRESetObjectProperty(dic, (const uint8_t*)"name", nameObj, NULL);
        
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



FREObject isSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}



// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void ContextInitializer(void* extData, const uint8_t * ctxType, FREContext ctx, 
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
    int count=2;
    if(strcmp((const char *)ctxType, PROGRESS_KEY)==0)
        count = 7;
    
	*numFunctionsToTest = count;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * count);
    
    if(strcmp((const char *)ctxType, SYSTEM_PROPERTIES_KEY)==0){
        func[0].name = (const uint8_t *) "getSystemProperty";
        func[0].functionData = NULL;
        func[0].function = &getSystemProperties;
    }else if(strcmp((const char *)ctxType, NETWORK_ACTIVITY_INDICATOR)==0){
        
        func[0].name = (const uint8_t *) "showHidenetworkIndicator";
        func[0].functionData = NULL;
        func[0].function = &showHidenetworkIndicator;
        
    }else if(strcmp((const char *)ctxType, PROGRESS_KEY)==0){
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = NULL;
        func[0].function = &isShowing;
        
        func[2].name = (const uint8_t *) "showProgressPopup";
        func[2].functionData = NULL;
        func[2].function = &showProgressPopup;
        
        func[3].name = (const uint8_t*) "updateProgress";
        func[3].functionData = NULL;
        func[3].function = &updateProgress;
        
        func[4].name = (const uint8_t*) "hideProgress";
        func[4].functionData = NULL;
        func[4].function = &hideProgress;
        
        func[5].name = (const uint8_t*) "updateMessage";
        func[5].functionData = NULL;
        func[5].function = &updateMessage;

        func[6].name = (const uint8_t*) "updateTitle";
        func[6].functionData = NULL;
        func[6].function = &updateTitle;
        
    }else{
        func[0].name = (const uint8_t *) "showAlertWithTitleAndMessage";
        func[0].functionData = NULL;
        func[0].function = &showAlertWithTitleAndMessage;
    }
    func[1].name = (const uint8_t *) "isSupported";
    func[1].functionData = NULL;
    func[1].function = &isSupported;
    
	*functionsToSet = func;
}



// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void ContextFinalizer(FREContext ctx) {
    
    NSLog(@"Entering ContextFinalizer()");
    if(alert!=NULL){
        [alert hideProgress];
        [alert release];
    }
    NSLog(@"Exiting ContextFinalizer()");
    
	return;
}

// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void ExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                    FREContextFinalizer* ctxFinalizerToSet) {
    
    NSLog(@"Entering ExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;
    
    NSLog(@"Exiting ExtInitializer()");
}

// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void ExtFinalizer(void* extData) {
    
    NSLog(@"Entering ExtFinalizer()");
    
    // Nothing to clean up.
    
    NSLog(@"Exiting ExtFinalizer()");
    return;
}