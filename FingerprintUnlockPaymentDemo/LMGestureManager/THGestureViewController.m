//
//  THGestureViewController.m
//  
//
//  Created by king kong on 15/10/13.
//
//

#import "THGestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

/**
 *  按钮的tag类型
 */
typedef NS_ENUM(NSUInteger, THButtonTagType) {
    THButtonTagTypeForgetGesturePassword ,  //  忘记手势密码按钮的tagType
    THButtonTagTypeSwitchAccount ,          //  切换账号的按钮的tagType
};


@interface THGestureViewController ()<CircleViewDelegate,UIAlertViewDelegate>

/**
 *  判断是否需要登录 还是 dismiss
 */
@property (nonatomic,assign) BOOL needLogin;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  绘图视图 设置手势密码视图
 */
@property (nonatomic, strong) PCCircleView *drawingInterfaceView;

/**
 *  infoView 1.设置手势密码是：绘制手势密码视图 2.解锁手势密码：用户信息视图
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;


@end

@implementation THGestureViewController

#pragma mark - lifeCycle
- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 禁止系统的侧滑功能
    //self.fd_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    // 请空数据
    [self resetAllDataAndGesture];
    
    // 设置手势密码的内容根据不同的手势密码类型
    [self setContentViewForGesturePasswordType];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    switch (self.gesturePasswordType) {
            
        case THGesturePasswordTypeSet: {
            self.title = @"设置手势密码";
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
            break;
            
        case THGesturePasswordTypeLogin: {
            self.title = nil;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
            break;
            
        default:
            break;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];

}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return NO;
}


#pragma mark - 根据不同的手势密码类型设置手势密码视图及内容

#pragma 清空数据
- (void)resetAllDataAndGesture {
    
    // 1.infoView取消选中
    [self infoViewDeselectedSubviews];
    
    // 2.msgLabel提示文字复位
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    // 3.清除之前存储的密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}

// 设置不同手势密码视图
- (void)setContentViewForGesturePasswordType
{
    
    // 不同类型的手势密码视图共同之处
    [self setCommonContentView];
    
    switch (self.gesturePasswordType) {
            
        case THGesturePasswordTypeSet: {   // 设置手势密码

            [self setSubViewInfoForSetGesturePasswordType];
        }
            break;
            
        case THGesturePasswordTypeLogin: { // 启动程序登录后解锁手势密码

            [self setSubViewInfoForLoginGesturePasswordType];
        }
            break;
        default:
            break;
    }
}

// 不同类型的手势密码视图共同之处
- (void)setCommonContentView
{
    // 绘制手势密码和解锁手势密码界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.drawingInterfaceView = lockView;
    [self.view addSubview:lockView];
    
    if (self.gesturePasswordType== THGesturePasswordTypeSet) { // 设置手势密码时 需做特殊处理
        [lockView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, kScreenH * 1/2)];
    }
    
    // 设置及解锁手势密码时的提示语
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - 设置手势密码界面
- (void)setSubViewInfoForSetGesturePasswordType
{
    [self.drawingInterfaceView setType:CircleViewTypeSetting];
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
}

#pragma mark - 解锁手势密码界面
- (void)setSubViewInfoForLoginGesturePasswordType
{

#warning 可根据不同数据模型设置用户信息
    [self.drawingInterfaceView setType:CircleViewTypeLogin];
    // 获取用户信息
    //THUserModel *useromdel = [THUserModel sharedInstance];
    
    // 设置用户头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    //NSString *url = useromdel.avatarURL;
    //[imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"trPhoto"]];
    imageView.image = [UIImage imageNamed:@"trPhoto.png"];
    [self.view addSubview:imageView];
    
    // 设置用户账号
    NSString *phone = @"13421610231";
    [self.msgLabel showNormalMsg:phone];
    self.msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMaxY(imageView.frame)+20);
    
    
    // 忘记手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CGRectGetMinX(self.drawingInterfaceView.frame)+10, CGRectGetMaxY(self.drawingInterfaceView.frame)+10, 100, 40) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:THButtonTagTypeForgetGesturePassword];
    
    // 登录其他账户
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(CGRectGetMaxX(self.drawingInterfaceView.frame)-100-10, CGRectGetMaxY(self.drawingInterfaceView.frame)+10, 100, 40) title:@"登录其他账户" alignment:UIControlContentHorizontalAlignmentRight tag:THButtonTagTypeSwitchAccount];

}

//  创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


//  button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    //NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
            
        case THButtonTagTypeForgetGesturePassword: // 忘记手势密码
        {
            NSLog(@"点击了管理手势密码按钮");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"忘记手势密码,需要重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
            [alert show];
            
        }
            break;
            
        case THButtonTagTypeSwitchAccount:      // 登录其他账号
        {
            //如果设置了指纹解锁
             NSLog(@"点击了登录其他账户按钮");
             self.needLogin = YES;
            [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
            [self switchAccountButtonClick];
        }
            
            break;
        default:
            break;
    }
}

// 登录其他账号按钮的点击事件
- (void)switchAccountButtonClick {
    
    // 清空手势密码的数据
    [self resetAllDataAndGesture];
    
    // 判断是登录 还是dismiss
    if (self.verifyGestureFinishedBlock){
        self.verifyGestureFinishedBlock(self.needLogin);
    }
   
}

// 弹出忘记密码提示框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"忘记手势密码,需要重新登录"]) {
        
        if (buttonIndex == 1) {
            // 忘记手势密码需要重新登录
            self.needLogin = YES;
            [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
            [self switchAccountButtonClick];
        }
    }
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - 设置手势密码的时候
// 判断设置手势密码是否错误
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    // 获取第一个手势密码
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
    
    // 判断第一个手势密码是否存在
    if ([gestureOne length]) {        // 显示第二个手势密码与第一个手势密码不一致
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {                          // 第一个手势密码输入格式有问题
        
        // NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    
    // 第二次绘制手势密码与infoView手势密码一致
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

#pragma mark 第二次设置手势密码验证
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    //NSLog(@"获得第二个手势密码%@",gesture);
    if (equal) {
        
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        // 手势密码设置成功 保存手势密码
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        
        //设置允许手势密码错误的最大次数
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSNumber numberWithInt:5] forKey:@"gesture_set_error_count"];
        [userDefault synchronize];
        
        // 返回上一页
        if (self.gesturePasswordType == THGesturePasswordTypeSet){
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil]; // dismiss 登录页面
            [self.navigationController popToRootViewControllerAnimated:YES]; // pop 设置页
            
        } else {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else {
        NSLog(@"两次手势不匹配！");
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    }
}

#pragma mark - circleView - delegate - 登录后启动程序验证手势密码
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {   // 手势密码解锁成功
    
            NSLog(@"手势密码解锁成功！");
            //设置允许手势密码错误的最大次数
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[NSNumber numberWithInt:5] forKey:@"gesture_set_error_count"];
            [userDefault synchronize];
            
            // 直接dismisse到首页
            self.needLogin = NO;
            // 判断是登录 还是dismiss
            if (self.verifyGestureFinishedBlock){
                self.verifyGestureFinishedBlock(self.needLogin);
            }
            
        } else {   // 手势密码解锁失败
            
            NSLog(@"手势密码错误！");
            // 手势密码错误提示语
            // 最多错误次数是5次
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            int count = [[userDefault objectForKey:@"gesture_set_error_count"] intValue] - 1;

            NSString *showMessage = [NSString stringWithFormat:@"密码错误，还可以再输入%d次",count];
            [self.msgLabel showWarnMsgAndShake:showMessage];
            
            if (count <= 0) {
                self.needLogin = YES;
                [PCCircleViewConst saveGesture:nil Key:gestureFinalSaveKey];
                [self switchAccountButtonClick];
            }
            
            [userDefault setObject:[NSNumber numberWithInt:count] forKey:@"gesture_set_error_count"];
            [userDefault synchronize];
        }
        
    } else if (type == CircleViewTypeVerify) {
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
        } else {
            NSLog(@"原手势密码输入错误！");
        }
    }
}



#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    for (PCCircle *circle in circleView.subviews) {
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews
{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写父类返回按钮的功能
- (void)backButtonPressed {
    
    //在登录成功之后进入正常设置手势密码时（包括登录和注册）
    if (self.popViewControllerBlock){
        
        // 登录成功时候进入的手势密码，返回上一页时，需要同时释放登录密码和手势密码
        self.popViewControllerBlock();
    }
    
    // 返回上一页（正常设置手势密码）
    [self.navigationController popToRootViewControllerAnimated:YES];

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
