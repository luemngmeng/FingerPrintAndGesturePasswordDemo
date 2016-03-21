//
//  THGestureViewController.h
//  
//
//  Created by king kong on 15/10/13.
/*
 *  设置手势密码和验证手势密码
 *  可用到的地方：登录成功，注册成功，在设置页面进入的设置手势密码，进入App手势密码验证
 */

#import <UIKit/UIKit.h>

/**
 *  手势密码的类型
 */
typedef NS_ENUM(NSUInteger, THGesturePasswordType) {
    THGesturePasswordTypeLogin ,  //  登录后的启动手势密码
    THGesturePasswordTypeSet ,    //  设置手势密码
};

/**
 *  验证码手势后回调的操作
 *  isLogin是否需要登录
 */
typedef void(^THVerifyGestureFinishedBlock)(BOOL needLogin);


/**
 *  点击返回上一页操作
 */
typedef void(^THPopViewControllerBlock)( );


@interface THGestureViewController : UIViewController


/**
 *   手势密码的类型
 */
@property (nonatomic, assign) THGesturePasswordType gesturePasswordType;

/**
 *  验证手势密码后的操作（验证成功，验证失败：忘记手势密码， 切换账号）
 */
@property (nonatomic,strong) THVerifyGestureFinishedBlock verifyGestureFinishedBlock;


/**
 *  返回上一页操作（登录成功之后设置手势密码，返回上一页时调用）
 */
@property (nonatomic,strong) THPopViewControllerBlock popViewControllerBlock;


@end
