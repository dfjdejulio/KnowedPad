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

static void (^stopRunLoop)(UIAlertAction *action) = ^(UIAlertAction *action) {
    CFRunLoopStop(CFRunLoopGetCurrent());
};


- (void) doAlert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: stopRunLoop];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:false completion: nil];
    CFRunLoopRun();
}

- (NSString *) doPrompt:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Prompt" message:msg preferredStyle: UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"response";
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:stopRunLoop];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:false completion:nil];
    CFRunLoopRun();
    // The problem: "CFRunLoopRun()" breaks the keyboard.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
