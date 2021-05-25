//
//  ViewController.m
//  App
//  登录界面
//  Created by diam on 2021/4/13.
//

#import "ViewController.h"
#import "Reachability.h"
#import "MD5Util.h"
#import "HomeViewController.h"
#import <Foundation/Foundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tv_username;
@property (weak, nonatomic) IBOutlet UITextField *tv_password;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;
@property (weak, nonatomic) IBOutlet UIImageView *iv_logo;
@property (weak, nonatomic) IBOutlet UIButton *btn_register;

@property NSString *tips;
@property NSString *usernameEmpty;
@property NSString *passwordEmpty;
@property NSString *determine;
@property NSString *error;
@property NSString *unreachNetwork;
@property NSString *unserver;
@property NSString *remPassword;
@property NSString *cancel;

@property (strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) UIAlertAction *cancelAction;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置控件内容
    NSString *username = NSLocalizedString(@"username", nil);
    // 设置字体大小可以改变
    self.tv_username.adjustsFontForContentSizeCategory = YES;
    self.tv_password.adjustsFontForContentSizeCategory = YES;
    self.tv_username.placeholder = username;
    NSString *password = NSLocalizedString(@"password", nil);
    self.tv_password.placeholder = password;
    //获取文本内容
    _tips = NSLocalizedString(@"Tips", nil);
    _usernameEmpty = NSLocalizedString(@"usernameEmpty", nil);
    _passwordEmpty = NSLocalizedString(@"passwordEmpty", nil);
    _determine = NSLocalizedString(@"determine", nil);
    _error = NSLocalizedString(@"usernameError", nil);
    _unreachNetwork = NSLocalizedString(@"unreachNetwork", nil);
    _unserver = NSLocalizedString(@"unserver", nil);
    _remPassword = NSLocalizedString(@"remPassword", nil);
    _cancel = NSLocalizedString(@"cancel", nil);
    [self.btn_register setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
    self.btn_register.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    //设置密码输入样式
    self.tv_password.secureTextEntry = true;
    // 设置边框样式
    self.tv_username.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tv_username.layer.borderWidth = 1;
    self.tv_username.layer.cornerRadius= 20;
    self.tv_username.layer.masksToBounds = YES;
    self.tv_password.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tv_password.layer.borderWidth = 1;
    self.tv_password.layer.cornerRadius = 20;
    self.tv_password.layer.masksToBounds = YES;
    self.btn_login.layer.cornerRadius = 48;
    [self.btn_login setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    //获取记住的密码
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"username"]){
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.tv_username.text = username;
    }
    if([userDefaults objectForKey:@"password"]){
        NSString *password= [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        self.tv_password.text = password;
    }
    
    //添加手势

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
}
/**
 键盘唤回
 */
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{

[self.view endEditing:YES];

}

- (IBAction)clickRegister:(id)sender {
    UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"register"];
        [self.navigationController pushViewController:nextVc animated:YES];
}


- (IBAction)login:(id)sender {
    NSString *username = self.tv_username.text;
    NSString *password = self.tv_password.text;
    NSLog(@"username:%@",username);
    NSLog(@"password:%@",password);
    
    //判断用户名密码是否为空
    if ([username length] == 0){
        [self showError:_usernameEmpty];
        
    }
    else if ([password length] == 0){
        [self showError:_passwordEmpty];
        
    }else{
        //1.检查网络状况
        //1.1 设置网络监测的主机地址
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        reach.reachableBlock = ^(Reachability*reach)
        {
            //2.请求服务器，实现登录功能
            [self loginWithUsername:username andPassword:password];
            
        };
        
        reach.unreachableBlock = ^(Reachability*reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.tips message:self.unreachNetwork preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:self.determine style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:true completion:nil];
            });
        };
        [reach startNotifier];
    }
}

//请求服务器
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password{
    @try {
        //1.创建会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        //2.根据会话对象创建task
        NSURL *url = [NSURL URLWithString:@"http://182.61.134.30:3000/login"];
        
        //3.创建可变的请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //4.修改请求方法为POST
        request.HTTPMethod = @"POST";
        
        //6.设置请求体
        NSString *name = [@"username=" stringByAppendingString:username];
        NSString *pwd = [@"password=" stringByAppendingString:password];
        NSString *str1 = [name stringByAppendingString:@"&"];
        NSString *str2 = [str1 stringByAppendingString:pwd];
        NSString *str3 = [str2 stringByAppendingString:@"&"];
        NSString *str4 = [str3 stringByAppendingString:@"type=JSON"];
        request.HTTPBody = [str4 dataUsingEncoding:NSUTF8StringEncoding];
        
        //7.根据会话对象创建一个Task(发送请求）
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if([data length]==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.tips message:self.unserver preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:self.determine style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:true completion:nil];
                    
                });
                
            }else{
                //8.解析数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"dict:%@",dict);
                NSDictionary *meta = [dict objectForKey:@"meta"];
                NSString *result = [meta objectForKey:@"msg"];
                NSLog(@"登录结果为:%@",result);
                if([result isEqual:@"登录成功"]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //保存用户权限 分类到本地
                        NSDictionary *data = [dict objectForKey:@"data"];
                        NSArray *user = [data objectForKey:@"user"];
                        NSDictionary *u = [user objectAtIndex:0];
                        NSString *authority = [u objectForKey:@"authority"];
                        NSLog(@"用户权限：%@",authority);
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:authority forKey:@"authority"];
                        [defaults synchronize];
                        //是否记住的密码
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        if(![userDefaults objectForKey:@"username"] && ![userDefaults objectForKey:@"password"]){
                            
                            // 初始化对话框
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.tips message:self.remPassword preferredStyle:UIAlertControllerStyleAlert];
                            // 确定注销
                            self.okAction = [UIAlertAction actionWithTitle:self.determine style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                                // 用户名、密码的存储
                                //将用户名和密码保存到UserDefault中
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                [userDefaults setObject:username forKey:@"username"];
                                [userDefaults setObject:password forKey:@"password"];
                                [userDefaults synchronize];
                                //进入下一页面
                                UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                                    [self.navigationController pushViewController:nextVc animated:YES];
                                
                            }];
                            self.cancelAction =[UIAlertAction actionWithTitle:self.cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
                                //进入下一页面
                                UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                                    [self.navigationController pushViewController:nextVc animated:YES];
                                
                            }];
                            
                            [alert addAction:self.okAction];
                            [alert addAction:self.cancelAction];
                            
                            // 弹出对话框
                            [self presentViewController:alert animated:true completion:nil];
                        }
                        if(![[userDefaults objectForKey:@"username"] isEqual:username] ||
                           ![[userDefaults objectForKey:@"password"] isEqual:password]){
                            // 初始化对话框
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.tips message:self.remPassword preferredStyle:UIAlertControllerStyleAlert];
                            // 确定注销
                            self.okAction = [UIAlertAction actionWithTitle:self.determine style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                                // 用户名、密码的存储
                                //将用户名和密码保存到UserDefault中
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                [userDefaults setObject:username forKey:@"username"];
                                [userDefaults setObject:password forKey:@"password"];
                                [userDefaults synchronize];
                                //进入下一页面
                                UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                                    [self.navigationController pushViewController:nextVc animated:YES];
                                
                            }];
                            self.cancelAction =[UIAlertAction actionWithTitle:self.cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
                                //进入下一页面
                                UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                                    [self.navigationController pushViewController:nextVc animated:YES];
                            }];
                            
                            [alert addAction:self.okAction];
                            [alert addAction:self.cancelAction];
                            
                            // 弹出对话框
                            [self presentViewController:alert animated:true completion:nil];
                            
                        }
                        //进入下一页面
                        UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];
                            [self.navigationController pushViewController:nextVc animated:YES];
                    });
                }else if([result isEqual:@"登录失败"]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.tips message:self.error preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:self.determine style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alert animated:true completion:nil];
                        
                    });
                }
            }
        }];
        
        //7.执行任务
        [dataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

//消息弹窗
-(void)showError:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_tips message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:_determine style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}


@end
