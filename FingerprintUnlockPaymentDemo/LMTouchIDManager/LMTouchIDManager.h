//
//  LMTouchIDManager.h
//  FingerprintUnlockPaymentDemo
//
//  Created by mengmenglu on 3/21/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface LMTouchIDManager : NSObject


/**
 *  判断手机是否支持使用TouchId
 */
@property(nonatomic,readonly,assign)BOOL isCanUseTouchId;


/**
 * 初始化方法
 *
 *  @return return 单利
 */
+ (instancetype)sharedManager;

/**
 *  手机是否可以使用touchid
 *
 *  @return YES 可以使用
 */
- (BOOL)validateCanUseTouchIdWith:(LAContext *)locontext;


/**
 *    指纹验证解锁的主要方法
 *
 *  @param localizedFallbackTitle  指纹解锁
 *  @param localizedReason    指纹解锁弹出框副标题
 *  @param touchBlock
 */
-(void)touchIDWithlocalizedFallbackTitle:(NSString *)localizedFallbackTitle localizedFallbackMessage:(NSString*)localizedFallbackMessage success:(void(^)(BOOL success,NSError *error))touchBlock;


@end
