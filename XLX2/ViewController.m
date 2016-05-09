//
//  ViewController.m
//  XLX2
//
//  Created by bean on 15/10/20.
//  Copyright (c) 2015年 com.xile. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"



#define APPID @"wxac6cc1564c1b0d8e"
#define APPSEC @"ed1118008bce937b40ee81c3dd874dc1"
#define Description @"*****"

#define AccrssToken @"AccrssToken"
#define OpenId @"OpenId"
#define RefreshToken @"RefreshToken"

@interface ViewController ()<WXApiDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
}
#pragma mark 微信登陆授权
-(void)login
{
    
    SendAuthReq * req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = Description;
//    [WXApi sendReq:req];//废弃了
    [WXApi sendAuthReq:req viewController:self delegate:self];//可以发短信登录
    
#warning 注意查看readme
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
