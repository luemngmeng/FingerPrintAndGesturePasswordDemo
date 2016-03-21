//
//  LMTouchIDManager.m
//  FingerprintUnlockPaymentDemo
//
//  Created by mengmenglu on 3/21/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "LMTouchIDManager.h"


@interface LMTouchIDManager ()<UIAlertViewDelegate>

@end

@implementation LMTouchIDManager

#pragma mark - 初始化
+ (instancetype)sharedManager {
    
    static LMTouchIDManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[LMTouchIDManager alloc] init];
        
    });
    
    return _sharedManager;
}

#pragma mark - Public Method
#pragma mark 判断手机是否支持使用touchId(一般只有在iOS8系统以后才支持)
- (BOOL)validateCanUseTouchIdWith:(LAContext *)locontext {
    
    if (!locontext) {
        locontext = [[LAContext alloc] init];
    }

    NSError *error;
    
    return [locontext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
}


#pragma mark 指纹解锁验证
- (void)touchIDWithlocalizedFallbackTitle:(NSString *)localizedFallbackTitle localizedFallbackMessage:(NSString *)localizedFallbackMessage success:(void (^)(BOOL, NSError *))touchBlock {
    
    LAContext  *locontext= [[LAContext alloc] init];
    locontext.localizedFallbackTitle= localizedFallbackTitle;

#warning 后续要加上跳转到账号密码登录
    // 判断设置是否支持指纹解锁功能
    if ([self validateCanUseTouchIdWith:locontext]) {
        
        [locontext  evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                   localizedReason:localizedFallbackMessage
                             reply:^(BOOL success, NSError * error){
                                 
             NSLog(@"开始指纹解锁");

             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (success) {
        
                     touchBlock(success,error);
                     
                 } else {
                     NSLog(@"解锁失败");
                 }
             });

            }];
        
        
    } else {
        
        NSLog(@"此设备不支持指纹解锁功能");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"此设备不支持指纹解锁功能" message:@"只有iOS8或之后的系统才支持指纹解锁功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}



@end
