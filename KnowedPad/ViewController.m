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
        [self appendBold:self.input.text];
        [self appendBold:@" → "];
        [self append:r.toString];
        [self append:@"\n"];
        NSRange range = { self.output.attributedText.length, 0 };
        [self.output scrollRangeToVisible:range];
    }
}

#pragma Internal Use

- (void) appendBold:(NSString *)msg
{
    NSAttributedString *buf = [[NSAttributedString alloc] initWithString:msg attributes:inputAttributes];
    [self.output.textStorage appendAttributedString:buf];
}

- (void) append:(NSString *)msg
{
    NSAttributedString *buf = [[NSAttributedString alloc] initWithString:msg attributes:outputAttributes];
    [self.output.textStorage appendAttributedString:buf];
}

- (void) doAlert:(NSString *)msg
{
    alert.message = msg;
    [alert show];
}

- (NSString *) doPrompt:(NSString *)msg
{
    return @"";
}

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak ViewController * me = self;
    inputAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:self.fontSize.floatValue]};
    outputAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize.floatValue]};
    alert = [UIAlertView new];
    [alert addButtonWithTitle:@"OK"];
    context = [JSContext new];

    knowedUtil = [KnowedUtil new];
    knowedUtil->outBlock = ^(NSString *msg) {
        [me doAlert:msg];
    };
    [knowedUtil addSelfToContext:context];
    
    outputBlock = ^(NSString *msg) {
        [me append:@"» "];
        [me append:msg];
        [me append:@"\n"];
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
