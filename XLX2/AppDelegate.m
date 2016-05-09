//
//  AppDelegate.m
//  XLX2
//
//  Created by bean on 15/10/20.
//  Copyright (c) 2015年 com.xile. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "RootViewController.h"

#define WXAPPID @"wxac6cc1564c1b0d8e"
#define WXAPPSEC @"ed1118008bce937b40ee81c3dd874dc1"
#define Description @"*****"


#define RefreshToken @"WeiXinRefreshToken"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:WXAPPID withDescription:Description];
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onReq:(BaseReq *)req
{
    
}
#pragma mark 微信授权回调
-(void)onResp:(BaseResp *)resp
{
    
    
    [self getCode:resp];
}

#pragma mark 通过判断微信返回的状态码进行判断授权是否成功
-(void)getCode:(BaseResp *)resp
{
    if (resp.errCode == 0) {
        SendAuthResp * aresp = (SendAuthResp*)resp;
        
#warning 此处实现跳转到主界面!!!!!!
        RootViewController * root = [[RootViewController alloc]init];
        self.window.rootViewController = root;
        [self getAccessToken:aresp.code];
        NSLog(@"%@",aresp);
        
    }
    else if (resp.errCode == -4)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"用户拒绝授权" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else if (resp.errCode == -2)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"用户取消授权" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark 获取accessToken和openid
-(void)getAccessToken:(NSString*)code
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPID,WXAPPSEC,code];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        if (data)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([dict objectForKey:@"errcode"])
            {
                
            }
            else{
            [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                
                NSLog(@"%@",[dict objectForKey:@"access_token"]);
                NSLog(@"%@",[dict objectForKey:@"openid"]);
                
            }
        }
        });
    });
    
}


#pragma mark 通过accesstoken和openid获取用户信息
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:RefreshToken]];
                }else
                {
                    
#warning 获取用户信息！！！！
                    
                    NSLog(@"userInfo:::::::::::::%@",dict);
                    
                    /*
                     userInfo:::::::::::::{
                     city = Huaihua;
                     country = CN;
                     headimgurl = "http://wx.qlogo.cn/mmopen/Q3auHgzwzM6Bjeb1FX8jzorFE2ve2f8f52JAvwePhNx2dngj251QKibiauOib4pzp7jTgGxZnIaic6sUWbvkvk4Kca8VwqicS9b5hIn0p6PGlkaA/0";
                     language = "zh_CN";
                     nickname = "\U848b\U592a\U751f";
                     openid = oARrPv77jzdFe68uAJFavZ77rJAE;
                     privilege =     (
                     );
                     province = Hunan;
                     sex = 1;
                     unionid = "oIIrtv8anlUy1-oGmHA1jmVzfa0I";
                     }
                     */
                    
                }
            }
        });
    });
}


#pragma mark accessToken失效时重新获取
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WXAPPID,refreshToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    
                }else
                {
                    
                }
            }
        });
    });
        
        
        
}


@end
