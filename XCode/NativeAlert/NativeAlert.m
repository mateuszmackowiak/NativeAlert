//
//  NativeAlert.m
//  NativeAlert
//
//  Created by Mateusz Maćkowiak
//  Copyright (c) 2012 Mateusz Maćkowiak. All rights reserved.
//

#include "FlashRuntimeExtensions.h"
#import "MobileAlert.h"

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
    
    MobileAlert *alert = [[MobileAlert alloc] init];
    [alert showAlertWithTitle:titleString 
                      message:messageString 
                   closeLabel:closeLabelString
                  otherLabels:otherLabelsString
                      context:ctx];
    return NULL;    
}

FREObject isSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}


FREObject getSystemProperties(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    
    FREObject dic;
    if(FRENewObject((const uint8_t *)"flash.utils.Dictionary",0, NULL, &dic, NULL)==FRE_OK){
        UIDevice * device = [UIDevice currentDevice];
        
        const char *osCh = [[device systemName] UTF8String];
        const char *versionCh = [[device systemVersion] UTF8String];
        const char *uidCh = [[device uniqueIdentifier] UTF8String];
        const char *nameCh = [[device name] UTF8String];
        //float batLevel = [device batteryLevel];
       
        FREObject uidObj;
        FREObject osObj;
        FREObject versionObj;
        FREObject nameObj;
        
        
        FRENewObjectFromUTF8(strlen(uidCh)+1, (const uint8_t*)uidCh, &uidObj);
        FRENewObjectFromUTF8(strlen(osCh)+1, (const uint8_t*)osCh, &osObj);
        FRENewObjectFromUTF8(strlen(versionCh)+1, (const uint8_t*)versionCh, &versionObj);
        FRENewObjectFromUTF8(strlen(nameCh)+1, (const uint8_t*)nameCh, &nameObj);

        
        FRESetObjectProperty(dic, (const uint8_t*)"UID", uidObj, NULL);
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
// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void ContextInitializer(void* extData, const uint8_t * ctxType, FREContext ctx, 
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
	*numFunctionsToTest = 2;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 1);
    
    if(strcmp((const char *)ctxType, SYSTEM_PROPERTIES_KEY)==0){
        func[0].name = (const uint8_t *) "getSystemProperty";
        func[0].functionData = NULL;
        func[0].function = &getSystemProperties;
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
    
    // Nothing to clean up.
    
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