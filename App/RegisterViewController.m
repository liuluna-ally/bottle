//
//  RegisterViewController.m
//  App
//  注册页面
//  Created by diam on 2021/4/29.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property UITextField *idDataText;
@property UITextField *userNameDataText;
@property UITextField *passwordDataText;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"userRegister", nil);
    
    CGFloat marginX = self.view.frame.size.width;
    CGFloat marginY = self.view.frame.size.height;
    CGFloat width = (self.view.frame.size.width)*0.4;
    CGFloat width1 = (self.view.frame.size.width)*0.4;
    CGFloat height = (self.view.frame.size.height)*0.05;
    //  id标签
    CGRect idRect = CGRectMake(marginX*0.1, marginY*0.15, width, height);
    UILabel *idLabel = [[UILabel alloc]initWithFrame:idRect];
    idLabel.textAlignment = NSTextAlignmentLeft;
    idLabel.text = NSLocalizedString(@"idInfo", nil);
    // 设置字体大小可以改变
    idLabel.adjustsFontForContentSizeCategory = YES;
    [self.view addSubview:idLabel];
    
    //ID 数据
    CGRect idDataRect = CGRectMake(marginX*0.5, marginY*0.15, width1, height);
    self.idDataText = [[UITextField alloc]initWithFrame:idDataRect];
    self.idDataText.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    self.idDataText.adjustsFontForContentSizeCategory = YES;
    // 设置边框样式
    self.idDataText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.idDataText.layer.borderWidth = 1;
    self.idDataText.layer.cornerRadius= 20;
    self.idDataText.layer.masksToBounds = YES;
    [self.view addSubview:self.idDataText];
    
    //  username标签
    CGRect userNameRect = CGRectMake(marginX*0.1, marginY*0.25, width, height);
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:userNameRect];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.text = NSLocalizedString(@"userNameRegister", nil);
    // 设置字体大小可以改变
    userNameLabel.adjustsFontForContentSizeCategory = YES;
    [self.view addSubview:userNameLabel];
    
    //username 数据
    CGRect userNameDataRect = CGRectMake(marginX*0.5, marginY*0.25, width1, height);
    self.userNameDataText = [[UITextField alloc]initWithFrame:userNameDataRect];
    self.userNameDataText.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    self.userNameDataText.adjustsFontForContentSizeCategory = YES;
    // 设置边框样式
    self.userNameDataText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.userNameDataText.layer.borderWidth = 1;
    self.userNameDataText.layer.cornerRadius= 20;
    self.userNameDataText.layer.masksToBounds = YES;
    [self.view addSubview:self.userNameDataText ];
    
    //  password标签
    CGRect passwordRect = CGRectMake(marginX*0.1, marginY*0.35, width, height);
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:passwordRect];
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    passwordLabel.text = NSLocalizedString(@"passwordRegister", nil);
    // 设置字体大小可以改变
    passwordLabel.adjustsFontForContentSizeCategory = YES;
    [self.view addSubview:passwordLabel];
    
    //password 数据
    CGRect passwordDataRect = CGRectMake(marginX*0.5, marginY*0.35, width1, height);
    self.passwordDataText = [[UITextField alloc]initWithFrame:passwordDataRect];
    self.passwordDataText.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    self.passwordDataText.adjustsFontForContentSizeCategory = YES;
    // 设置边框样式
    self.passwordDataText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.passwordDataText.layer.borderWidth = 1;
    self.passwordDataText.layer.cornerRadius= 20;
    self.passwordDataText.layer.masksToBounds = YES;
    [self.view addSubview:self.passwordDataText];
    
    //  register标签
    CGRect registerRect = CGRectMake(marginX*0.2, marginY*0.5, marginX*0.6, height);
    UIButton *registerButton = [[UIButton alloc]initWithFrame:registerRect];
    [registerButton setBackgroundColor:[UIColor systemTealColor]];
    registerButton.layer.cornerRadius   = 10;
    registerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [registerButton setTitle: NSLocalizedString(@"registerButton", nil) forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    
    
    //点击注册按钮
    [registerButton addTarget:self action:@selector(clickRegister)
             forControlEvents:UIControlEventTouchUpInside];
}

/**
 点击注册按钮
 */
-(void)clickRegister{
    if([self.idDataText.text length]==0 || [self.userNameDataText.text length] == 0 || [self.passwordDataText.text length] == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil) message: NSLocalizedString(@"usernameEmpty", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"determine", nil) style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:true completion:nil];

        });
        
    }else{
        @try {
            //1.创建会话对象
            NSURLSession *session = [NSURLSession sharedSession];
            //2.根据会话对象创建task
            NSURL *url = [NSURL URLWithString:@"http://182.61.134.30:3000/register"];
            
            //3.创建可变的请求对象
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            //4.修改请求方法为POST
            request.HTTPMethod = @"POST";
            
            //6.设置请求体
            NSString *idcard = [@"idcard=" stringByAppendingString:self.idDataText.text];
            NSString *username = [@"username=" stringByAppendingString:self.userNameDataText.text];
            NSString *password = [@"password=" stringByAppendingString:self.passwordDataText.text];
            NSString *str1 = [idcard stringByAppendingString:@"&"];
            NSString *str2 = [str1 stringByAppendingString:username];
            NSString *str3 = [str2 stringByAppendingString:@"&"];
            NSString *str4 = [str3 stringByAppendingString:password];
            request.HTTPBody = [str4 dataUsingEncoding:NSUTF8StringEncoding];
            
            //7.根据会话对象创建一个Task(发送请求）
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if([data length]==0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                    });
                    
                }else{
                    //8.解析数据
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSLog(@"dict:%@",dict);
                    NSDictionary *meta = [dict objectForKey:@"meta"];
                    NSString *result = [meta objectForKey:@"msg"];
                    NSLog(@"登录结果为:%@",result);
                    if([result isEqual:@"register success"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil) message: NSLocalizedString(@"submitSuccess", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"determine", nil) style:UIAlertActionStyleDefault handler:nil]];
                            [self presentViewController:alert animated:true completion:nil];    });
                    }
                    
                    }
            }];
            
            //7.执行任务
            [dataTask resume];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
    
}
    
@end
