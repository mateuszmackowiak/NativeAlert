//
//  MobileAlert.h
//  NativeAlert
//
//  Created by Mateusz Maćkowiak / Paweł Meller / Anthony McCormick on 2011/2012.
//

#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import "FlashRuntimeExtensions.h"
    #import "SBTableAlert.h"
    #import "AlertTextView.h"

#endif

@interface ListItem : NSObject
@property( nonatomic, retain ) NSString *text;
@property( nonatomic ) uint32_t selected;
@end


@interface MobileAlert : NSObject <UIAlertViewDelegate,SBTableAlertDelegate,SBTableAlertDataSource>
@property( nonatomic, retain ) UIProgressView *progressView;
@property( nonatomic, retain ) UIAlertView *alert;
@property( nonatomic, retain ) SBTableAlert *sbAlert;



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

-(void)showSelectDialogWithTitle: (NSString *)title
                              message: (NSString*)message
                              options: (FREObject*)options
                              checked: (FREObject*)checked
                              buttons: (FREObject*)buttons
                              context: (FREContext *)ctx;

- (void)shake;

-(void)updateProgress: (CGFloat)perc;

-(void)updateMessage: (NSString *)message;

-(void)updateTitle: (NSString*)title;

-(BOOL)isShowing;

-(void)hide;
@end
