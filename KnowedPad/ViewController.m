//
//  ViewController.m
//  KnowedPad
//
//  Created by Doug DeJulio on 2014-05-21.
//  Copyright (c) 2014 Doug DeJulio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark Actions

- (IBAction)execute:(id)sender
{
    JSValue *r;
    r = [context evaluateScript:self.input.text];
    if (console.shouldClear) {
        self.output.text = @"";
        [console didClear];
    } else {
        [self.output appendBold:self.input.text];
        [self.output appendBold:@" → "];
        [self.output append:r.toString];
        [self.output append:@"\n"];
        NSRange range = { self.output.attributedText.length, 0 };
        [self.output scrollRangeToVisible:range];
    }
}

#pragma Internal Use

- (void) doAlert:(NSString *)msg
{
    UIAlertView *alert = [UIAlertView new];
    [alert addButtonWithTitle:@"OK"];
    alert.message = msg;
    alert.delegate = self;
    [alert show];
    CFRunLoopRun();
}

- (NSString *) doPrompt:(NSString *)msg
{
    UIAlertView *alert = [UIAlertView new];
    [alert addButtonWithTitle:@"OK"];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.message = msg;
    alert.delegate = self;
    [alert show];
    [[alert textFieldAtIndex:0] becomeFirstResponder];
    CFRunLoopRun();
    //return [[alert textFieldAtIndex:0] text];
    return @"This does not work yet.";
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //promptAnswer = [[alertView textFieldAtIndex:0] text];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak ViewController *me = self;
    __weak UITextView *output = self.output;

    context = [JSContext new];

    knowedUtil = [KnowedUtil new];
    knowedUtil->outBlock = ^(NSString *msg) {
        [me doAlert:msg];
    };
    knowedUtil->inBlock = ^(NSString *msg) {
        return [me doPrompt:msg];
    };
    [knowedUtil addSelfToContext:context];
    
    outputBlock = ^(NSString *msg) {
        [output append:@"» "];
        [output append:msg];
        [output append:@"\n"];
    };
    console = [[KnowedConsole new] initWithOutputBlock:outputBlock];
    [console addSelfToContext:context];
    [[KnowedFileUtil new] addSelfToContext:context];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
