//
//  TMLWebView.m
//  identityForH5
//
//  Created by tml on 2017/3/22.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "TMLWebView.h"

@implementation TMLWebView

#pragma Mark : - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self commonInit];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    
    [self commonInit];
    return  self;
}


-(void)commonInit{
    
    // ...
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
