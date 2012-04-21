//
//  MobileAlert.m
//  NativeAlert
//
//  Created by Mateusz Maćkowiak / Paweł Meller / Anthony McCormick on 2011/2012.
//

#import "MobileAlert.h"


#pragma mark - ListItem



@implementation ListItem

@synthesize text;
@synthesize selected;

+(ListItem*)listItemWithText:(NSString*)text{
    return [[ListItem alloc] initWithText:text];
}
- (id)initWithText:(NSString*)_text
{
    self = [super init];
    if (self) {
        self.text = _text;
        self.selected = NO;
    }
    return self;
}

-(void)dealloc{
    if(text)
        [text release];
    [super dealloc];
}

@end


@implementation MobileAlert

@synthesize alert;
@synthesize sbAlert;

@synthesize progressView;



FREContext *context;







#pragma mark - Progress


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


-(void)updateProgress: (CGFloat)perc
{
    [self performSelectorOnMainThread: @selector(updateProgressBar:)
                           withObject: [NSNumber numberWithFloat:perc] waitUntilDone:NO];
}


- (void) updateProgressBar:(NSNumber*)num {
    if(progressView)
        progressView.progress=[num floatValue];
}


#pragma mark - Alert


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
       // if(labels)
         //   [labels release];
    }
    FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_opened", NULL);
    [alert show];
}



#pragma mark - Text Input


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
    }else{
        closeLabel = NSLocalizedString(@"OK", nil);
    }
    
    BOOL isIOS_5 = [[[UIDevice currentDevice] systemVersion] floatValue]>=5.0;
    
    //Create our alert.
    if( isIOS_5){
        self.alert = [[[UIAlertView alloc] initWithTitle:title 
                                             message:message
                                            delegate:self 
                                   cancelButtonTitle:closeLabel
                                   otherButtonTitles:nil] retain];
    }else{
        self.alert = [[[AlertTextView alloc] initWithTitle:title 
                                    message:message
                                   delegate:self 
                          cancelButtonTitle:closeLabel
                          otherButtonTitles:nil] retain];
    }
    
    [closeLabel release];
    
    if(buttons_len>1){
        FREObject button1;
        FREGetArrayElementAt(buttons, 1, &button1);
        
        uint32_t button1LabelLength;
        const uint8_t *button1Label;
        FREGetObjectAsUTF8(button1, &button1LabelLength, &button1Label);
        NSString* otherButton=[NSString stringWithUTF8String:(char*)button1Label];
        
        if(otherButton!=nil && ![otherButton isEqualToString:@""]){
            [alert addButtonWithTitle:otherButton];
            [otherButton release];
        }
        
    }
    
    uint32_t textInputs_len;
    FREGetArrayLength(textInputs, &textInputs_len);
    
    int8_t index =0;
    if(message!=nil && ![message isEqualToString:@""])
        index++;
    
    if (textInputs_len > index) {
        UITextField *textField=nil;
        FREObject textObj;
        if(textInputs_len==(index+1)){

            if(isIOS_5)
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            else
                [alert setAlertViewStyle:AlertTextViewStylePlainTextInput];
                
            textField = [alert textFieldAtIndex:0];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            FREGetArrayElementAt(textInputs, index, &textObj);
            setupTextInputParamsFormFREOBJ(textField,textObj);
           // [textField release];
        }else if(textInputs_len > (index+1)){
            if(isIOS_5)
                [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            else
                [alert setAlertViewStyle:AlertTextViewStyleLoginAndPasswordInput];
            
            textField = [alert textFieldAtIndex:0];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            FREGetArrayElementAt(textInputs, index, &textObj);
            setupTextInputParamsFormFREOBJ(textField,textObj);
            
            textField = [alert textFieldAtIndex:1];
            [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
            FREGetArrayElementAt(textInputs, index+1, &textObj);
            setupTextInputParamsFormFREOBJ(textField,textObj);
           
            //[textField release];
        }
        
    }
    FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_opened", NULL);
    
    [alert show];
}

-(void)textFieldDidChange:(id)sender {
    // whatever you wanted to do
    int8_t index = 0;
    if(sender != [alert textFieldAtIndex:0])
        index =1;
    NSString* returnString = [NSString stringWithFormat:@"%i#_#%@",index,((UITextField *)sender).text];
    NSLog(@"text changed: %@",((UITextField *)sender).text);
    FREDispatchStatusEventAsync(context, (uint8_t*)"change", (uint8_t*)[returnString UTF8String]);
   // [returnString release];
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






#pragma mark - List Dialog

NSMutableArray *tableItemList = nil;

-(void)showSelectDialogWithTitle: (NSString *)title
                         message: (NSString*)message
                         options: (FREObject*)options
                         checked: (FREObject*)checked
                         buttons: (FREObject*)buttons
                         context: (FREContext *)ctx{
    
    if(!checked)
        return;
    //clean previous windows
    [self hide];
    //Hold onto the context so we can dispatch our message later.
    context = ctx;
    
    
    NSString* closeLabel=nil;
    NSString* otherLabel=nil;
    uint32_t buttons_len;
    FREGetArrayLength(buttons, &buttons_len);
    
    if(buttons_len>0){
        FREObject button;
        FREGetArrayElementAt(buttons, 0, &button);
        
        uint32_t buttonLabelLength;
        const uint8_t *buttonLabel;
        if(button){
            FREGetObjectAsUTF8(button, &buttonLabelLength, &buttonLabel);
            closeLabel = [NSString stringWithUTF8String:(char*)buttonLabel];
        }
        if(buttons_len>1){
            FREGetArrayElementAt(buttons, 1, &button);
            if(button){
                FREGetObjectAsUTF8(button, &buttonLabelLength, &buttonLabel);
                otherLabel = [NSString stringWithUTF8String:(char*)buttonLabel];
            }
        }
    }
    
    if(!closeLabel || [closeLabel isEqualToString:@""]){
        closeLabel = NSLocalizedString(@"OK", nil);
    }
    

    //Create our alert.
    self.sbAlert = [[[SBTableAlert alloc] initWithTitle:title cancelButtonTitle:closeLabel messageFormat: message] retain];
    [closeLabel release];
    if(otherLabel && ![otherLabel isEqualToString:@""]){
        [sbAlert.view addButtonWithTitle:otherLabel ];
        [otherLabel release];
    }
    
    uint32_t options_len; // array length
    FREGetArrayLength(options, &options_len);

    for(int32_t i=options_len-1; i>=0;i--){
        
        // get an element at index
        FREObject element;
        FREGetArrayElementAt(options, i, &element);
        
        if(element){
            uint32_t elementLength;
            const uint8_t *elementLabel;
            FREGetObjectAsUTF8(element, &elementLength, &elementLabel);
            ListItem* item = [[ListItem listItemWithText:[NSString stringWithUTF8String:(char*)elementLabel]] autorelease];
            
            if(tableItemList==nil)
                tableItemList= [[NSMutableArray alloc] initWithObjects:item, nil];
            else
                [tableItemList addObject:item];
        }
    }
    
   // options
    if(checked!=nil){
        FREObjectType type;
        FREGetObjectType(checked, &type);
        if(type == FRE_TYPE_NUMBER){
            
            int32_t checkedValue;
            FREGetObjectAsInt32(checked, &checkedValue);

            if(checkedValue>=0 || checkedValue< options_len){
                ListItem* item = [tableItemList objectAtIndex:checkedValue];
                if(item)
                    item.selected = YES;
            }
            [sbAlert setType:SBTableAlertTypeSingleSelect];
            [sbAlert setStyle:SBTableAlertStyleApple];
            [sbAlert setDataSource:self];
            [sbAlert setDelegate:self];
            [sbAlert show];
            FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_opened", NULL);
        }else if(type ==FRE_TYPE_VECTOR || type ==FRE_TYPE_ARRAY){
            
            uint32_t checkedItems_len; // array length
            FREGetArrayLength(checked, &checkedItems_len);
            if(checkedItems_len == options_len && tableItemList!=nil){
                for(int32_t i=checkedItems_len-1; i>=0;i--){
                    // get an element at index
                    FREObject checkedListItem;
                    FREGetArrayElementAt(checked, i, &checkedListItem);
                    if(checkedListItem){
                        uint32_t boolean;
                        if(FREGetObjectAsBool(checkedListItem, &boolean)==FRE_OK){
                            ListItem* item = [tableItemList objectAtIndex:i];
                            if(item)
                                item.selected = boolean;
                        }
                    }
                }
            }
            [self createMultiChoice];
        }
    }else{
        [self createMultiChoice];
    }
}


- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell = [[[SBTableAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	
    if(tableItemList){
        ListItem* item = [tableItemList objectAtIndex:indexPath.row];
        [cell.textLabel setText:item.text];
        if(item.selected)
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType:UITableViewCellAccessoryNone];
	}
    
	return cell;
}
- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section{
    if(tableItemList)
        return [tableItemList count];
    else 
        return 0;
}

-(void)createMultiChoice{
    
    [sbAlert setDataSource:self];
    [sbAlert setType:SBTableAlertTypeMultipleSelct];

    [sbAlert setDelegate:self];
    
    [sbAlert show];
    FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_opened", NULL);
}


- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *returnString =nil;
    if (tableAlert.type == SBTableAlertTypeMultipleSelct) {
		UITableViewCell *cell = [tableAlert.tableView cellForRowAtIndexPath:indexPath];
		if (cell.accessoryType == UITableViewCellAccessoryNone){
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            returnString = [NSString stringWithFormat:@"%d_true",[indexPath row]];
        }else{
			[cell setAccessoryType:UITableViewCellAccessoryNone];
            returnString = [NSString stringWithFormat:@"%d_false",[indexPath row]];
		}
		[tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}else
        returnString = [NSString stringWithFormat:@"%d%", [indexPath row]];
    
     
    FREDispatchStatusEventAsync(context, (uint8_t*)"nativeListDialog_change", (uint8_t*)[returnString UTF8String]);
}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonID = [NSString stringWithFormat:@"%d", buttonIndex];
    FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_closed", (uint8_t*)[buttonID UTF8String]);
    //Cleanup references.
    
    [tableItemList removeAllObjects];
    [tableItemList release];
     tableItemList = nil;
    [sbAlert release];
    sbAlert = nil;
    context = nil;
}




////////////////////


#pragma mark - All dialog methods


- (void)shake
{
    if(alert && alert.isHidden==NO){
        CGRect r = alert.frame;
        r.origin.x = r.origin.x - r.origin.x * 0.1;
	
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.1f];
        [UIView setAnimationRepeatCount:5];
        [UIView setAnimationRepeatAutoreverses:NO];
        [alert setFrame:r];
	
        [UIView commitAnimations];
    }
    if(sbAlert && sbAlert.view.isHidden==NO){
        CGRect r = sbAlert.view.frame;
        r.origin.x = r.origin.x - r.origin.x * 0.1;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.1f];
        [UIView setAnimationRepeatCount:5];
        [UIView setAnimationRepeatAutoreverses:NO];
        [sbAlert.view setFrame:r];
        
        [UIView commitAnimations];
    }
}



-(BOOL)isShowing{
    if(sbAlert && sbAlert.view.isHidden==NO){
        return YES;
    }else if(alert && alert.isHidden==NO)
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
    if(sbAlert)
        sbAlert.view.message = message;
    if(alert)
        alert.message = message;
}

-(void)updateTitle: (NSString*)title
{
    [self performSelectorOnMainThread: @selector(updateTitleWithSt:)
                           withObject: title waitUntilDone:NO];
}
- (void) updateTitleWithSt:(NSString*)title {
    if(sbAlert)
        sbAlert.view.title =title;
    if(alert)
        alert.title = title;
}







-(void)hide
{
    if(sbAlert){
        [sbAlert release];
        [sbAlert.view dismissWithClickedButtonIndex:0 animated:YES];
    }
    if(progressView)
       [progressView release];
    if(alert)
    {
       [alert release];
       [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
}




#pragma mark - Button Click


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //Create our params to pass to the event dispatcher.
    NSString *buttonID = [NSString stringWithFormat:@"%d", buttonIndex];

   /* if(([alert isKindOfClass:[UIAlertView class]] && [alertView alertViewStyle]==UIAlertViewStyleDefault)
       || ([alert isKindOfClass:[AlertTextView class]] && [alertView alertViewStyle]==AlertTextViewStyleDefault)){
     */   
            FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_closed", (uint8_t*)[buttonID UTF8String]);
    /*}else{
        
     
        NSString* returnString=nil;
        [[alertView textFieldAtIndex:0] removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        if(([alert isKindOfClass:[UIAlertView class]] && [alertView alertViewStyle]==UIAlertViewStyleLoginAndPasswordInput) 
                || ([alert isKindOfClass:[AlertTextView class]] && [alertView alertViewStyle]==AlertTextViewStyleLoginAndPasswordInput)){
            
            [[alertView textFieldAtIndex:1] removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            returnString = [NSString stringWithFormat:@"%@#_#%@#_#%@",buttonID,[[alertView textFieldAtIndex:0] text],[[alertView textFieldAtIndex:1] text]];
        }else{
            
            returnString = [NSString stringWithFormat:@"%@#_#%@",buttonID,[[alertView textFieldAtIndex:0] text]];
        }
        FREDispatchStatusEventAsync(context, (uint8_t*)"nativeDialog_closed", (uint8_t*)[returnString UTF8String]);
    }*/

    
    //Cleanup references.
    [alert release];
    context = nil;
}


@end



