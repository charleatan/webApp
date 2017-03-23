//
//  TMLWebView.m
//  identityForH5
//
//  Created by tml on 2017/3/22.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "TMLWebView.h"

@implementation TMLWebView

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    
    NSString *urlString = request.URL.absoluteString;
    if ([urlString hasPrefix:@"xblj://"]) {
        
        NSString * host = [self sliceHost:urlString];
        
        NSDictionary * params = [self sliceParams:urlString];
        
        if ([host isEqualToString:@"openOrderDetail"]) {
            [self openOrderDetail:params];
        }
        return NO;
    }
    return YES;
}


-(NSString *)sliceHost:(NSString *) urlString{
    
    NSString * sliceString ;
    
    return sliceString;
}


-(void)openOrderDetail:(NSDictionary *)params{
    
    
}

-(NSDictionary *)sliceParams:(NSString *)urlString{
    
    NSDictionary * sliceParams;
    
    
    return sliceParams;
}


@end
