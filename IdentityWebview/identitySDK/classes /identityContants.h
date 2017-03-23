//
//  identityContants.h
//  identityForH5
//
//  Created by tml on 2017/3/22.
//  Copyright © 2017年 charles. All rights reserved.
//

#ifndef identityContants_h
#define identityContants_h


#define CHECK_PREFIX            @"xblj://"
#define HTTP_PREFIX             @"http://"

#ifdef DEBUG
#define TMLLog(...) NSLog(__VA_ARGS__)
#else
#define TMLLog(...)
#endif


#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#endif /* identityContants_h */
