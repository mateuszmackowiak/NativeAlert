//
//  MobileAlert.h
//  NativeAlert
//
//  Created by Anthony McCormick on 22/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

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
                 context: (FREContext *)ctx;
-(void)updateProgress: (CGFloat)perc;
-(void)hideProgress;
@end
