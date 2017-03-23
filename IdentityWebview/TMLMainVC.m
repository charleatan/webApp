//
//  TMLMainVC.m
//  identityForH5
//
//  Created by tml on 2017/3/22.
//  Copyright © 2017年 charles. All rights reserved.
//

#import "TMLMainVC.h"
#import "TMLVideoIdentityVC.h"
#import "identityContants.h"


@interface TMLMainVC ()

@end

@implementation TMLMainVC

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setUserInterface];
}

// 设置界面
-(void)setUserInterface {
    
    self.navigationItem.title = @"视屏认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * identityBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH * 0.5) - 50, SCREEN_HEIGHT * 0.5, 100, 50)];
    
    [identityBtn setBackgroundColor:[UIColor redColor]];
    [identityBtn setTitle:@"播放视屏" forState:UIControlStateNormal];
    [identityBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [identityBtn sizeToFit];
    
    [self.view addSubview:identityBtn];

}

-(void)playVideo {
    
    NSString * videoURLStr = @"xblj://www.baidu.com";
    
    TMLVideoIdentityVC * videoIdententityVC = [[TMLVideoIdentityVC alloc] init];
    
    videoIdententityVC.urlStr = videoURLStr;
    
//    [self.view addSubview:videoIdententityVC.view];
    [self.navigationController pushViewController:videoIdententityVC animated:YES];
    TMLLog(@"播放视频");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
