//
//  MobileAlert.h
//  NativeAlert
//
//  Created by Anthony McCormick on 22/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import "FlashRuntimeExtensions.h"
#endif


@interface MobileAlert : NSObject <UIAlertViewDelegate>
@property( nonatomic, retain ) UIProgressView *progressView;
@property( nonatomic, retain ) UIAlertView *alert;

-(void)showAlertWithTitle: (NSString *)title 
                  message: (NSString*)message 
               closeLabel: (NSString*)closeLabel
              otherLabels: (NSString*)otherLabels
                  context: (FREContext *)context;
-(void)showProgressPopup: (NSString *)title 
                   style: (NSInteger)style
                 message: (NSString*)message 
                progress: (NSNumber*)progress
            showActivity:(Boolean)showActivity
               cancleble:(Boolean)cancleble
                 context: (FREContext *)ctx;

-(void)showTextInputDialog: (NSString *)title
                   message: (NSString*)message
                textInputs: (FREObject*)textInputs
                   buttons: (FREObject*)buttons
                   context: (FREContext *)ctx;

- (void)shake;

-(void)updateProgress: (CGFloat)perc;

-(void)updateMessage: (NSString *)message;

-(void)updateTitle: (NSString*)title;

-(BOOL)isShowing;

-(void)hide;
@end
