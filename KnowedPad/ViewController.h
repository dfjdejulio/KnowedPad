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


@interface ViewController : UIViewController {
    UIAlertView *alert;
    JSContext *context;
    NSDictionary *inputAttributes;
    NSDictionary *outputAttributes;
    KnowedConsole *console;
    KnowedOutputBlock outputBlock;
    KnowedUtil *knowedUtil;
}

@property IBOutlet UITextView *output;
@property IBOutlet UITextField *input;
@property NSNumber *fontSize;

- (IBAction)execute:(id)sender;

@end
