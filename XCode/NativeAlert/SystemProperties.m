//
//  Settings.m
//  NativeAlert
//
//  Created by Mateusz Mackowiak on 20.02.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SystemProperties.h"
#import "FlashRuntimeExtensions.h"

@implementation SystemProperties
    
static char *key = "SystemProperites";

+ (char *)KEY { return key; }


+ (FREObject)isSupported{
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}

@end
