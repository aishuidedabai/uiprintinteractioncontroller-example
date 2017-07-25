//
//  HTMLPrinter.m
//  UIPrint​Interaction​Controller-Example
//
//  Created by Serhii Londar on 7/25/17.
//  Copyright © 2017 serhii-londar. All rights reserved.
//

#import "HTMLPrinter.h"
#import <UIKit/UIKit.h>

@interface HTMLPrinter()<UIWebViewDelegate> {
    UIWebView *_webView;
    UIPrintInteractionController *_printController;
}

@end

@implementation HTMLPrinter

+ (HTMLPrinter *)sharedPrinter {
    static HTMLPrinter *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [HTMLPrinter new];
    });
    return shared;
}

- (void)printHTMLWithName:(NSString *)fileName fromFilePath:(NSString *)filePath {
    NSURL *printUrl = [NSURL URLWithString:filePath];
    NSURL *htmlURL = [printUrl URLByAppendingPathComponent:fileName];
    
    NSString* htmlString = [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
    _webView = [[UIWebView alloc] init];
    [_webView loadHTMLString:htmlString baseURL:printUrl];
    _webView.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.jobName = @"Printing html";
    
    _printController = [UIPrintInteractionController sharedPrintController];
    _printController.printInfo = printInfo;
    
    _printController.printFormatter = _webView.viewPrintFormatter;
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_printController presentAnimated:true completionHandler: nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
