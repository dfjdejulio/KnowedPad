//
//  ViewController.h
//  KnowedPad
//
//  Created by Doug DeJulio on 2014-05-21.
//  Copyright (c) 2014 Doug DeJulio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "Knowed/Knowed.h"
#import "UITextView+BILogTextView.h"


@interface ViewController : UIViewController <UIAlertViewDelegate> {
    JSContext *context;
    NSDictionary *inputAttributes;
    NSDictionary *outputAttributes;
    KnowedConsole *console;
    KnowedOutputBlock outputBlock;
    KnowedUtil *knowedUtil;
    NSString *promptAnswer;
}

@property IBOutlet UITextView *output;
@property IBOutlet UITextField *input;

- (IBAction)execute:(id)sender;

- (NSString *)doPrompt:(NSString*)msg;
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
