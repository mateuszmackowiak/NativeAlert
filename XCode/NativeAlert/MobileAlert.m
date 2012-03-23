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
               cancleble:(Boolean)cancleble
                 context: (FREContext *)ctx
{
    //Hold onto the context so we can dispatch our message later.
    context = ctx;
    [self hide];
    //Create our alert.
    
    self.alert = [[[UIAlertView alloc] initWithTitle:title 
                                             message:message
                                            delegate:self 
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil] retain];
    
    if (style== 0 || showActivity) {
        
        UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityWheel.frame = CGRectMake(142.0f-activityWheel.bounds.size.width*.5, 80.0f, activityWheel.bounds.size.width, activityWheel.bounds.size.height);
        [alert addSubview:activityWheel];
        [activityWheel startAnimating];
        [activityWheel release];
        
    } else {
        
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 90.0f, 225.0f, 90.0f)];
        [alert addSubview:progressView];
        [progressView setProgressViewStyle: UIProgressViewStyleBar];
        progressView.progress=[progress floatValue];
    }
    FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_opened", NULL);
    [alert show];
}

-(void)showAlertWithTitle: (NSString *)title 
                  message: (NSString*)message 
               closeLabel: (NSString*)closeLabel
              otherLabels: (NSString*)otherLabels
                  context: (FREContext *)ctx
{
    //clean previous windows
    [self hide];
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
    FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_opened", NULL);
    [alert show];
}


-(void)showTextInputDialog: (NSString *)title
                   message: (NSString*)message
                textInputs: (FREObject*)textInputs
                   buttons: (FREObject*)buttons
                   context: (FREContext *)ctx{
    //clean previous windows
    [self hide];
    //Hold onto the context so we can dispatch our message later.
    context = ctx;
    
    NSString* closeLabel=nil;
    
    
    uint32_t buttons_len;
    FREGetArrayLength(buttons, &buttons_len);
    
    if(buttons_len>0){
        FREObject button0;
        FREGetArrayElementAt(buttons, 0, &button0);
        
        uint32_t button0LabelLength;
        const uint8_t *button0Label;
        FREGetObjectAsUTF8(button0, &button0LabelLength, &button0Label);
        
        closeLabel = [NSString stringWithUTF8String:(char*)button0Label];
    }
    
    //Create our alert.
    self.alert = [[[UIAlertView alloc] initWithTitle:title 
                                             message:message
                                            delegate:self 
                                   cancelButtonTitle:closeLabel
                                   otherButtonTitles:nil] retain];
    if(buttons_len>1){
        FREObject button1;
        FREGetArrayElementAt(buttons, 1, &button1);
        
        uint32_t button1LabelLength;
        const uint8_t *button1Label;
        FREGetObjectAsUTF8(button1, &button1LabelLength, &button1Label);
        NSString* otherButton=[NSString stringWithUTF8String:(char*)button1Label];
        
        if(otherButton!=nil && ![otherButton isEqualToString:@""])
            [alert addButtonWithTitle:otherButton];
    }
    
    uint32_t textInputs_len;
    FREGetArrayLength(textInputs, &textInputs_len);
    
    int8_t index =0;
    if(message!=nil && ![message isEqualToString:@""])
        index++;
    
    if (textInputs_len>index) {
        UITextField *textField=nil;
        FREObject textObj;
        if(textInputs_len==1){
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            textField = [alert textFieldAtIndex:0];
            FREGetArrayElementAt(textInputs, index, &textObj);
            setupTextInputParamsFormFREOBJ(textField,textObj);
        }else if(textInputs_len>1){
            [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            
            textField = [alert textFieldAtIndex:0];
            FREGetArrayElementAt(textInputs, index, &textObj);
            setupTextInputParamsFormFREOBJ(textField,textObj);
            
            textField = [alert textFieldAtIndex:1];
            FREGetArrayElementAt(textInputs, index+1, &textObj);
            setupTextInputParamsFormFREOBJ(textField,textObj);
        }
        
    }
    FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_opened", NULL);
    [alert show];
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



-(void)hide
{
    if(progressView)
       [progressView release];
    if(alert)
    {
       [alert release];
       [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
}









- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //Create our params to pass to the event dispatcher.
    NSString *buttonID = [NSString stringWithFormat:@"%d", buttonIndex];
 

    if([alertView alertViewStyle]==UIAlertViewStyleDefault){
        FREDispatchStatusEventAsync(context, (uint8_t*)"ALERT_CLOSED", (uint8_t*)[buttonID UTF8String]);
    }else{
        NSString* returnString=nil;
        if([alertView alertViewStyle]==UIAlertViewStyleLoginAndPasswordInput){
            returnString = [NSString stringWithFormat:@"%@#_#%@#_#%@",buttonID,[[alertView textFieldAtIndex:0] text],[[alertView textFieldAtIndex:1] text]];
        }else{
            returnString = [NSString stringWithFormat:@"%@#_#%@",buttonID,[[alertView textFieldAtIndex:0] text]];
        }
        FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_closed", (uint8_t*)[returnString UTF8String]);
    }
    
    //Cleanup references.
    [alert release];
    context = nil;
}




UIReturnKeyType getReturnKeyTypeFormChar(const char* type){
    if(strcmp(type, "done")==0){
        return UIReturnKeyDone;
    }else if(strcmp(type, "go")==0){
        return UIReturnKeyGo;
    }else if(strcmp(type, "next")==0){
        return UIReturnKeyNext;
    }else if(strcmp(type, "search")==0){
        return UIReturnKeySearch;
    }else {
        return UIReturnKeyDefault;
    }
}



UIKeyboardType getKeyboardTypeFormChar(const char* type){
    if(strcmp(type, "punctuation")==0){
        return UIKeyboardTypeNumbersAndPunctuation;
    }else if(strcmp(type, "url")==0){
        return UIKeyboardTypeURL;
    }else if(strcmp(type, "number")==0){
        return UIKeyboardTypeNumberPad;
    }else if(strcmp(type, "contact")==0){
        return UIKeyboardTypePhonePad;
    }else if(strcmp(type, "email")==0){
        return UIKeyboardTypeEmailAddress;
    }else {
        return UIKeyboardTypeDefault;
    }
}

UITextAutocorrectionType getAutocapitalizationTypeFormChar(const char* type){
    
    if(strcmp(type, "word")==0){
        return UITextAutocapitalizationTypeWords;
    }else if(strcmp(type, "sentence")==0){
        return UITextAutocapitalizationTypeSentences;
    }else if(strcmp(type, "all")==0){
        return UITextAutocapitalizationTypeAllCharacters;
    }else {
        return UITextAutocorrectionTypeNo;
    }
}


void setupTextInputParamsFormFREOBJ(UITextField* textfiel, FREObject obj){
    
    FREObject returnKeyObj,autocapitalizationTypeObj, keyboardTypeObj,prompTextObj,textObj, autoCorrectObj,displayAsPasswordObj;
    
    FREGetObjectProperty(obj, (const uint8_t *)"returnKeyLabel", &returnKeyObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"softKeyboardType", &keyboardTypeObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"autoCapitalize", &autocapitalizationTypeObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"prompText", &prompTextObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"text", &textObj, NULL);
    
    FREGetObjectProperty(obj, (const uint8_t *)"autoCorrect", &autoCorrectObj, NULL);
    FREGetObjectProperty(obj, (const uint8_t *)"displayAsPassword", &displayAsPasswordObj, NULL);
    
    uint32_t returnKeyTypeLength , autocapitalizationTypeLength , keyboardTypeLength, prompTextLength , textLength , autoCorrect,displayAsPassword;
    const uint8_t* returnKeyType;
    const uint8_t* autocapitalizationType;
    const uint8_t* keyboardType;
    const uint8_t* prompText;
    const uint8_t* text;
    
    FREGetObjectAsUTF8(autocapitalizationTypeObj, &autocapitalizationTypeLength, &autocapitalizationType);
    FREGetObjectAsUTF8(returnKeyObj, &returnKeyTypeLength, &returnKeyType);
    FREGetObjectAsUTF8(keyboardTypeObj, &keyboardTypeLength, &keyboardType);
    FREGetObjectAsUTF8(textObj, &textLength, &text);
    FREGetObjectAsUTF8(prompTextObj, &prompTextLength, &prompText);
    
    FREGetObjectAsBool(autoCorrectObj, &autoCorrect);
    FREGetObjectAsBool(displayAsPasswordObj, &displayAsPassword);
    
    if(displayAsPassword)
        textfiel.secureTextEntry = YES;
    else 
        textfiel.secureTextEntry = NO;
    
    if(autoCorrect)
        textfiel.autocorrectionType = UITextAutocorrectionTypeYes;
    else
        textfiel.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [textfiel setText:[NSString stringWithUTF8String:(const char *)text]];
    [textfiel setPlaceholder:[NSString stringWithUTF8String:(const char *)prompText]];
                            
    textfiel.keyboardType = getKeyboardTypeFormChar((const char *)keyboardType);
    textfiel.autocapitalizationType = getAutocapitalizationTypeFormChar((const char *)autocapitalizationType);
    textfiel.returnKeyType = getReturnKeyTypeFormChar((const char *)returnKeyType);
}



@end
