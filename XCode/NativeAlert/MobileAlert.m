//
//  MobileAlert.m
//  NativeAlert
//
//  Created by Anthony McCormick on 22/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MobileAlert.h"

@implementation MobileAlert

@synthesize alert;
@synthesize progressView;
FREContext *context;
-(void)showProgressPopup: (NSString *)title 
                   style: (NSInteger)style
                 message: (NSString*)message 
                progress: (NSNumber*)progress
            showActivity:(Boolean)showActivity
                 context: (FREContext *)ctx
{
    //Hold onto the context so we can dispatch our message later.
    context = ctx;
    [self hideProgress];
    //Create our alert.
    if (style== 0 || showActivity) {
        self.alert = [[[UIAlertView alloc] initWithTitle:title 
                                                 message:message
                                                delegate:self 
                                       cancelButtonTitle:nil
                                       otherButtonTitles:nil] retain];
        
        [alert show];
        UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityWheel.frame = CGRectMake(142.0f-activityWheel.bounds.size.width*.5, 80.0f, activityWheel.bounds.size.width, activityWheel.bounds.size.height);
        [alert addSubview:activityWheel];
        [activityWheel startAnimating];
        [activityWheel release];
        
        
    } else {
        self.alert = [[[UIAlertView alloc] initWithTitle:title 
                                                 message:message
                                                delegate:self 
                                       cancelButtonTitle:nil
                                       otherButtonTitles:nil] retain];
        
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 90.0f, 225.0f, 90.0f)];
        [alert addSubview:progressView];
        [progressView setProgressViewStyle: UIProgressViewStyleBar];
        progressView.progress=[progress floatValue];
        [alert show];
        
    }	
}


-(BOOL)isShowing{
    if(alert && alert.isHidden==NO)
        return YES;
    else
        return NO;
}


-(void)updateMessage: (NSString*)message
{
    [self performSelectorOnMainThread: @selector(updateMessageWithSt:)
                           withObject: message waitUntilDone:NO];
}
- (void) updateMessageWithSt:(NSString*)message { 
   alert.message = message; }

-(void)updateTitle: (NSString*)title
{
    [self performSelectorOnMainThread: @selector(updateTitleWithSt:)
                           withObject: title waitUntilDone:NO];
}
- (void) updateTitleWithSt:(NSString*)title { 
    alert.title = title; }



-(void)updateProgress: (CGFloat)perc
{
    [self performSelectorOnMainThread: @selector(updateProgressBar:)
                           withObject: [NSNumber numberWithFloat:perc] waitUntilDone:NO];
}
- (void) updateProgressBar:(NSNumber*)num { 
    progressView.progress=[num floatValue]; }



-(void)hideProgress
{
    if(progressView)
       [progressView release];
    if(alert)
    {
       [alert release];
       [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
}



-(void)showAlertWithTitle: (NSString *)title 
                  message: (NSString*)message 
               closeLabel: (NSString*)closeLabel
              otherLabels: (NSString*)otherLabels
                  context: (FREContext *)ctx
{
    //clean previous windows
    [self hideProgress];
    //Hold onto the context so we can dispatch our message later.
    context = ctx;
    
    //Create our alert.
    self.alert = [[[UIAlertView alloc] initWithTitle:title 
                                                    message:message
                                                   delegate:self 
                                          cancelButtonTitle:closeLabel
                                          otherButtonTitles:nil] retain];

    if (otherLabels != nil && ![otherLabels isEqualToString:@""]) { 
        //Split our labels into an array
        NSArray *labels = [otherLabels componentsSeparatedByString:@","];
    
        //Add each label to our array.
        for (NSString *label in labels) 
        {
            [alert addButtonWithTitle:label];
        }
    }
    [alert show];
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //Create our params to pass to the event dispatcher.
    NSString *buttonID = [NSString stringWithFormat:@"%d", buttonIndex];
    //This is the event name we will use in actionscript to know it is our 
    //event that was dispatched.
    NSString *event_name = @"ALERT_CLOSED";
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[event_name UTF8String], (uint8_t*)[buttonID UTF8String]);
    //Cleanup references.
    [alert release];
    context = nil;
}

@end
