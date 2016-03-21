//
//  FingerprintNnlockPaymentViewController.m
//  FingerprintUnlockPaymentDemo
//
//  Created by mengmenglu on 3/21/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "FingerprintNnlockPaymentViewController.h"

#import "LMTouchIDManager.h"
#import "THGestureViewController.h"

@interface FingerprintNnlockPaymentViewController ()

@end

@implementation FingerprintNnlockPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"指纹手势密码的Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 指纹密码
     UIButton *fingerprintUnlockButton = [UIButton buttonWithType:UIButtonTypeSystem];
     fingerprintUnlockButton.frame = CGRectMake(50, 100, 200, 40);
     fingerprintUnlockButton.layer.borderColor = [[UIColor grayColor] CGColor];
     fingerprintUnlockButton.layer.borderWidth = 0.5f;
     fingerprintUnlockButton.layer.cornerRadius = 4.0f;
     fingerprintUnlockButton.layer.masksToBounds = YES;
     [fingerprintUnlockButton setTitle:@"测试指纹密码" forState:UIControlStateNormal];
     [fingerprintUnlockButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     [fingerprintUnlockButton addTarget:self action:@selector(fingerprintUnlockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:fingerprintUnlockButton];
    
    
    // 手势密码
    UIButton *gestureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    gestureButton.frame = CGRectMake(50, 200, 200, 40);
    gestureButton.layer.borderColor = [[UIColor grayColor] CGColor];
    gestureButton.layer.borderWidth = 0.5f;
    gestureButton.layer.cornerRadius = 4.0f;
    gestureButton.layer.masksToBounds = YES;
    [gestureButton setTitle:@"测试手势密码" forState:UIControlStateNormal];
    [gestureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [gestureButton addTarget:self action:@selector(gestureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gestureButton];
}

#pragma mark - Private Method
#pragma mark 指纹密码
- (void)fingerprintUnlockButtonClick:(id)button {
    
    NSLog(@"指纹密码");
    [[LMTouchIDManager sharedManager] touchIDWithlocalizedFallbackTitle:@"" localizedFallbackMessage:@"通过Home键验证已有手机指纹" success:^(BOOL success, NSError *error) {
        
        if (success) {
            //指纹解锁登录密码成功
            NSLog(@"指纹解锁登录密码成功 ====");
            
            
        } else{
            //其他原因导致指纹解锁失败
            NSLog(@"指纹解锁登录密码失败 ====%@",error);
        }
        
    }];
}

#pragma mark 手势密码
- (void)gestureButtonClick:(id)button {
    NSLog(@"手势密码");
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isGestureSetFinished = [userDefault boolForKey:@"gesture_set_finished_password"];
    if (isGestureSetFinished) {  // 手势密码解锁
        
        // 显示指纹密码解锁页面
        [self showGesturePasswordView];
        
    } else {  // 设置手势密码
        
        THGestureViewController *gestureViewController = [[THGestureViewController alloc] init];
        gestureViewController.gesturePasswordType = THGesturePasswordTypeSet;
        [self.navigationController pushViewController:gestureViewController animated:YES];
        
        // 保存已经设置手势密码
        [userDefault setBool:YES forKey:@"gesture_set_finished_password"];
        [userDefault synchronize];
    }
}

#pragma mark 显示指纹解锁页面
- (void)showGesturePasswordView {
    
    THGestureViewController *gestureViewController = [[THGestureViewController alloc] init];
    gestureViewController.gesturePasswordType = THGesturePasswordTypeLogin;
    gestureViewController.verifyGestureFinishedBlock = ^(BOOL needLogin) {
        
        if (needLogin){
            // 解锁失败需要登录(忘记手势密码和切换登录用户)
            NSLog(@"跳转到登录页面");
            [self.navigationController dismissViewControllerAnimated:YES completion:nil]; // 暂时都跳转到根目录
            
            // 重新设置手势密码
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:@"gesture_set_finished_password"];
            [userDefault synchronize];

        } else {
            
            // 解锁成功 进入程序
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];  // 暂时都跳转到根目录
            
        }
    };
    
    // 显示手势密码
    [self.navigationController presentViewController:gestureViewController animated:YES completion:nil];
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
