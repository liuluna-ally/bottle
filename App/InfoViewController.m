//
//  InfoViewController.m
//  App
//  信息录入页面
//  Created by diam on 2021/4/14.
//

#import "InfoViewController.h"
#import "XDSDropDownMenu.h"


@interface InfoViewController ()<XDSDropDownMenuDelegate>
@property UITextField *tv_deviceNumber;
@property UIButton *btnDeviceNumber;
@property UITextField *tv_canNumber;
@property UIButton *btnCanNumber;
@property UITextField *tv_bottleNumber;
@property UIButton *btnBottleNumber;
@property UILabel *lb_productName;
@property UILabel *lb_volume;
@property UILabel *lb_customerName;
@property UILabel *lb_contact;
@property UITextField *tv_productName;
@property UITextField *tv_volume;
@property UITextField *tv_customerName;
@property UITextField *tv_contact;
@property UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong)  NSArray *textArray;
@property (nonatomic, strong)  NSArray *dropDownMenuArray;
@property NSString *unreachNetwork;
@property NSString *unserver;
@property NSString *tips;
@property NSString *determine;
@property NSString *empty;
@property NSMutableArray *result;
@property NSString *submitError;
@property NSString *submitSuccess;

@end

@implementation InfoViewController{
    XDSDropDownMenu *selectProductNameDropDownMenu;
    XDSDropDownMenu *selectVolumeDropDownMenu;
}

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.title = NSLocalizedString(@"infoAdd", nil);
        // 1.初始化ui
        [self initView];
        
        //2.设置样式
        [self setStyle];
        
        //3.点击提交
        [_btnSubmit addTarget:self action:@selector(clickSubmit)
                 forControlEvents:UIControlEventTouchUpInside];
        
        // 4.配置buttonArray和dropDownMenuArray
        [self setArrays];
        
        // 5.点击选择产品名称
        [_tv_productName addTarget:self action:@selector(clickProductName)
                 forControlEvents:UIControlEventTouchDownRepeat];
        
        // 6.点击选择容量
        [_tv_volume addTarget:self action:@selector(clickVolume)
                 forControlEvents:UIControlEventTouchDownRepeat];
        
        // 7..点击scan
        [_btnDeviceNumber addTarget:self action:@selector(clickBtnDeviceNumber)
                 forControlEvents:UIControlEventTouchUpInside];
        [_btnCanNumber addTarget:self action:@selector(clickBtnCanNumber)
                 forControlEvents:UIControlEventTouchUpInside];
        [_btnBottleNumber addTarget:self action:@selector(clickBtnBottleNumber)
                 forControlEvents:UIControlEventTouchUpInside];
        //获取设备编号
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"deviceNumber"]){
            NSString *deviceNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceNumber"];
            self.tv_deviceNumber.text = deviceNumber;
        }
        if([userDefaults objectForKey:@"canNumber"]){
            NSString *canNumber= [[NSUserDefaults standardUserDefaults] objectForKey:@"canNumber"];
            self.tv_canNumber.text = canNumber;
        }
        if([userDefaults objectForKey:@"bottleNumber"]){
            NSString *bottleNumber= [[NSUserDefaults standardUserDefaults] objectForKey:@"bottleNumber"];
            self.tv_bottleNumber.text = bottleNumber;
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

#pragma mark - 初始化ui
-(void)initView{
    //  设备编号输入框
    CGFloat marginX = self.view.frame.size.width;
    CGFloat marginY = self.view.frame.size.height;
    CGRect deviceNumberRect = CGRectMake(marginX*0.1, marginY*0.15, marginX*0.6, marginY*0.05);
    _tv_deviceNumber = [[UITextField alloc]initWithFrame:deviceNumberRect];
    [self.view addSubview:_tv_deviceNumber];
    
    // 设备编号扫码按钮
    CGRect btnDeviceNumberRect = CGRectMake(marginX*0.85, marginY*0.15, marginX*0.05, marginY*0.05);
    _btnDeviceNumber = [[UIButton alloc]initWithFrame:btnDeviceNumberRect];
    [self.view addSubview:_btnDeviceNumber];
    
    //  大瓶编号输入框
    CGRect canNumberRect = CGRectMake(marginX*0.1, marginY*0.23, marginX*0.6, marginY*0.05);
    _tv_canNumber = [[UITextField alloc]initWithFrame:canNumberRect];
    [self.view addSubview:_tv_canNumber];
    
    // 大瓶编号扫码按钮
    CGRect btnCanNumberRect = CGRectMake(marginX*0.85, marginY*0.23, marginX*0.05, marginY*0.05);
    _btnCanNumber = [[UIButton alloc]initWithFrame:btnCanNumberRect];
    [self.view addSubview:_btnCanNumber];
    
    //  小瓶编号输入框
    CGRect bottleNumberRect = CGRectMake(marginX*0.1, marginY*0.31, marginX*0.6, marginY*0.05);
    _tv_bottleNumber = [[UITextField alloc]initWithFrame:bottleNumberRect];
    [self.view addSubview:_tv_bottleNumber];
    
    // 小瓶编号扫码按钮
    CGRect btnBottleNumberRect = CGRectMake(marginX*0.85, marginY*0.31, marginX*0.05, marginY*0.05);
    _btnBottleNumber = [[UIButton alloc]initWithFrame:btnBottleNumberRect];
    [self.view addSubview:_btnBottleNumber];
    
    //产品名称标签
    CGRect productNameRect = CGRectMake(marginX*0.1, marginY*0.4, marginX*0.3, marginY*0.05);
    _lb_productName = [[UILabel alloc]initWithFrame:productNameRect];
    [self.view addSubview:_lb_productName];
    
    //产品名称框
    CGRect productNameTextRect = CGRectMake(marginX*0.6, marginY*0.4, marginX*0.3, marginY*0.05);
    _tv_productName = [[UITextField alloc]initWithFrame:productNameTextRect];
    [self.view addSubview:_tv_productName];
    
    //容量标签
    CGRect volumeRect = CGRectMake(marginX*0.1, marginY*0.48, marginX*0.3, marginY*0.05);
    _lb_volume = [[UILabel alloc]initWithFrame:volumeRect];
    [self.view addSubview:_lb_volume];
    
    //容量框
    CGRect volumeTextRect = CGRectMake(marginX*0.6, marginY*0.48, marginX*0.3, marginY*0.05);
    _tv_volume = [[UITextField alloc]initWithFrame:volumeTextRect];
    [self.view addSubview:_tv_volume];
    
    //客人姓名标签
    CGRect customerNameRect = CGRectMake(marginX*0.1, marginY*0.56, marginX*0.3, marginY*0.05);
    _lb_customerName = [[UILabel alloc]initWithFrame:customerNameRect];
    [self.view addSubview:_lb_customerName];
    
    //客人框
    CGRect customerNameTextRect = CGRectMake(marginX*0.6, marginY*0.56, marginX*0.3, marginY*0.05);
    _tv_customerName= [[UITextField alloc]initWithFrame:customerNameTextRect];
    [self.view addSubview:_tv_customerName];
    
    //联系方式标签
    CGRect contactRect = CGRectMake(marginX*0.1, marginY*0.64, marginX*0.3, marginY*0.05);
    _lb_contact = [[UILabel alloc]initWithFrame:contactRect];
    [self.view addSubview:_lb_contact];
    
    //联系方式框
    CGRect contatcTextRect = CGRectMake(marginX*0.6, marginY*0.64, marginX*0.3, marginY*0.05);
    _tv_contact = [[UITextField alloc]initWithFrame:contatcTextRect];
    [self.view addSubview:_tv_contact];
    
    // 提交
    CGRect submitRect = CGRectMake(marginX*0.1, marginY*0.75, marginX*0.8, marginY*0.05);
    _btnSubmit = [[UIButton alloc]initWithFrame:submitRect];
    [self.view addSubview:_btnSubmit];
}

#pragma mark - 设置样式
- (void)setStyle{
    _tv_deviceNumber.placeholder = NSLocalizedString(@"deviceNumber", nil);
    _tv_deviceNumber.layer.borderColor = [[UIColor grayColor] CGColor];
    _tv_deviceNumber.layer.borderWidth = 1;
    _tv_deviceNumber.layer.cornerRadius = 5;
    _tv_deviceNumber.layer.masksToBounds = YES;
    [_btnDeviceNumber setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    
    _tv_canNumber.placeholder = NSLocalizedString(@"canNumber", nil);
    _tv_canNumber.layer.borderColor = [[UIColor grayColor] CGColor];
    _tv_canNumber.layer.borderWidth = 1;
    _tv_canNumber.layer.cornerRadius = 5;
    _tv_canNumber.layer.masksToBounds = YES;
    [_btnCanNumber setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    
    _tv_bottleNumber.placeholder = NSLocalizedString(@"bottleNumber", nil);
    _tv_bottleNumber.layer.borderColor = [[UIColor grayColor] CGColor];
    _tv_bottleNumber.layer.borderWidth = 1;
    _tv_bottleNumber.layer.cornerRadius = 5;
    _tv_bottleNumber.layer.masksToBounds = YES;
    [_btnBottleNumber setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    
    _lb_productName.text = NSLocalizedString(@"productName", nil);
    _tv_productName.placeholder = NSLocalizedString(@"select", nil);
    _tv_productName.layer.borderColor = [[UIColor grayColor] CGColor];
    _tv_productName.layer.borderWidth = 1;
    _tv_productName.layer.cornerRadius = 5;
    _tv_productName.layer.masksToBounds = YES;
    
    _lb_volume.text = NSLocalizedString(@"volume", nil);
    _tv_volume.placeholder = NSLocalizedString(@"select", nil);
    _tv_volume.layer.borderColor = [[UIColor grayColor] CGColor];
    _tv_volume.layer.borderWidth = 1;
    _tv_volume.layer.cornerRadius = 5;
    _tv_volume.layer.masksToBounds = YES;
    
    _lb_customerName.text = NSLocalizedString(@"customerName", nil);
    _tv_customerName.layer.borderColor = [[UIColor grayColor] CGColor];
    _tv_customerName.layer.borderWidth = 1;
    _tv_customerName.layer.cornerRadius = 5;
    _tv_customerName.layer.masksToBounds = YES;
    
    _lb_contact.text = NSLocalizedString(@"contact", nil);
    _tv_contact.layer.borderColor = [[UIColor grayColor] CGColor];
    _tv_contact.layer.borderWidth = 1;
    _tv_contact.layer.cornerRadius = 5;
    _tv_contact.layer.masksToBounds = YES;
    
    _btnSubmit.layer.cornerRadius = 5;
    [_btnSubmit setBackgroundColor:[UIColor systemTealColor]];
    _btnSubmit.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnSubmit setTitle: NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    
}

#pragma mark - 信息提交
- (void)clickSubmit {
    @try {
        if([self.tv_deviceNumber.text isEqual:@""] || [self.tv_contact.text isEqual:@""]){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"empty", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"determine", nil) style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
            
        }else{
            //1.创建会话对象
            NSURLSession *session = [NSURLSession sharedSession];
            //2.根据会话对象创建task
            NSURL *url = [NSURL URLWithString:@"http://182.61.134.30:3000/submitInfo"];
            
            //3.创建可变的请求对象
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            //4.修改请求方法为POST
            request.HTTPMethod = @"POST";
            
            //5.设置请求体
            NSString *deviceNumber = [@"deviceNumber=" stringByAppendingString:self.tv_deviceNumber.text];
            NSString *canNumber = [@"canNumber=" stringByAppendingString:self.tv_canNumber.text];
            NSString *bottleNumber = [@"bottleNumber=" stringByAppendingString:self.tv_bottleNumber.text];
            NSString *productName = [@"productName=" stringByAppendingString:self.tv_productName.text];
            NSString *volume = [@"volume=" stringByAppendingString:self.tv_volume.text];
            NSString *customerName = [@"customerName=" stringByAppendingString:self.tv_customerName.text];
            NSString *contact = [@"contact=" stringByAppendingString:self.tv_contact.text];
            
            NSString *str1 = [deviceNumber stringByAppendingString:@"&"]; //deviceNumber=11&
            NSString *str2 = [str1 stringByAppendingString:canNumber];//deviceNumber=11&canNumber=11
            NSString *str3 = [str2 stringByAppendingString:@"&"];//deviceNumber=11&canNumber=11&
            NSString *str4 = [str3 stringByAppendingString:bottleNumber];//deviceNumber=11&canNumber=11&bottleNumber=111
            NSString *str5 = [str4 stringByAppendingString:@"&"];//deviceNumber=11&canNumber=11&bottleNumber=111&
            NSString *str6 = [str5 stringByAppendingString:productName];//deviceNumber=11&canNumber=11&bottleNumber=111&productName=450
            NSString *str7 = [str6 stringByAppendingString:@"&"];//deviceNumber=11&canNumber=11&bottleNumber=111&productName=450&
            NSString *str8 = [str7 stringByAppendingString:volume];//deviceNumber=11&canNumber=11&bottleNumber=111&productName=450&volume=450
            NSString *str9 = [str8 stringByAppendingString:@"&"];//deviceNumber=11&canNumber=11&bottleNumber=111&productName=450&volume=450&
            NSString *str10 = [str9 stringByAppendingString:customerName];//deviceNumber=11&canNumber=11&bottleNumber=111&productName=450&volume=450&customerName=123
            NSString *str11 = [str10 stringByAppendingString:@"&"];//deviceNumber=11&canNumber=11&bottleNumber=111&productName=450&volume=450&customerName=123&
            NSString *str12 = [str11 stringByAppendingString:contact];//deviceNumber=11&canNumber=11&bottleNumber=111&productName=450&volume=450&customerName=123&contact=1231
            
            request.HTTPBody = [str12 dataUsingEncoding:NSUTF8StringEncoding];
            
            //6 根据会话对象创建一个Task(发送请求）
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if([data length] == 0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"unserver", nil) preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"determine", nil) style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alert animated:true completion:nil];
                        
                    });
                }
                
                if (error == nil) {
                    //6.解析服务器返回的数据
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSDictionary *meta = [dict objectForKey:@"meta"];
                    NSString *result = [meta objectForKey:@"msg"];
                    NSLog(@"登录结果为:%@",result);
                    if([result isEqual:@"信息录入成功"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"submitSuccess", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"determine", nil) style:UIAlertActionStyleDefault handler:nil]];
                            [self presentViewController:alert animated:true completion:nil];
                            
                        });
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"submitError", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"determine", nil) style:UIAlertActionStyleDefault handler:nil]];
                            [self presentViewController:alert animated:true completion:nil];
                            
                        });
                    }
                    
                }
            }];
            
            //7.执行任务
            [dataTask resume];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

#pragma mark - 配置buttonArray和dropDownMenuArray
- (void)setArrays{
    
    //将所有按钮加入buttonArray数组
    self.textArray = @[self.tv_productName,self.tv_volume];
    
    //初始化所有DropDownMenu下拉菜单
    selectProductNameDropDownMenu = [[XDSDropDownMenu alloc] init];
    selectVolumeDropDownMenu = [[XDSDropDownMenu alloc] init];
    
    //将所有DropDownMenu加入dropDownMenuArray数组
    self.dropDownMenuArray = @[selectProductNameDropDownMenu,selectVolumeDropDownMenu];
    
    //将所有dropDownMenu的初始tag值设为1000
    for (__strong XDSDropDownMenu *nextDropDownMenu in self.dropDownMenuArray) {
        nextDropDownMenu.tag = 1000;
    }
}
#pragma mark - 按钮
- (void)clickProductName {
    NSArray *arr = @[@"ELIXIR"];
    
    selectProductNameDropDownMenu.delegate = self;//设置代理
    
    //调用方法判断是显示下拉菜单，还是隐藏下拉菜单
    [self setupDropDownMenu:selectProductNameDropDownMenu withTitleArray:arr andText:_tv_productName andDirection:@"down"];
    
    //隐藏其它的下拉菜单
    [self hideOtherDropDownMenu:selectProductNameDropDownMenu];
}
- (void)clickVolume {
    NSArray *arr = @[@"30ML",@"50ML",@"75ML",@"100ML"];
    
    selectVolumeDropDownMenu.delegate = self;//设置代理
    
    //调用方法判断是显示下拉菜单，还是隐藏下拉菜单
    [self setupDropDownMenu:selectVolumeDropDownMenu withTitleArray:arr andText:_tv_volume andDirection:@"down"];
    
    //隐藏其它的下拉菜单
    [self hideOtherDropDownMenu:selectVolumeDropDownMenu];
}


/**
 点击设备编号扫码
 */
- (void)clickBtnDeviceNumber {
    //保存点击的扫描按钮
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"scanButton"];
    [defaults synchronize];
    //进入下一页面
    UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"scan"];
        [self.navigationController pushViewController:nextVc animated:YES];
}

/**
 点击大瓶编号
 */
- (void)clickBtnCanNumber {
    //保存点击的扫描按钮
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"scanButton"];
    [defaults synchronize];
    //进入下一页面
    UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"scan"];
        [self.navigationController pushViewController:nextVc animated:YES];
}
/**
 点击瓶子编号
 */
- (void)clickBtnBottleNumber{
    //保存点击的扫描按钮
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"2" forKey:@"scanButton"];
    [defaults synchronize];
    //进入下一页面
    UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"scan"];
        [self.navigationController pushViewController:nextVc animated:YES];
}


#pragma mark - 设置dropDownMenu

/*
 判断是显示dropDownMenu还是收回dropDownMenu
 */

- (void)setupDropDownMenu:(XDSDropDownMenu *)dropDownMenu withTitleArray:(NSArray *)titleArray andText:(UITextField *)text andDirection:(NSString *)direction{
    
    CGRect textFrame = text.frame; //如果按钮在UIIiew上用这个
    
    //  CGRect btnFrame = [self getBtnFrame:button];//如果按钮在UITabelView上用这个
    
    
    if(dropDownMenu.tag == 1000){
        
        /*
         如果dropDownMenu的tag值为1000，表示dropDownMenu没有打开，则打开dropDownMenu
         */
        
        //初始化选择菜单
        [dropDownMenu showDropDownMenu:text withTextFrame:textFrame arrayOfTitle:titleArray arrayOfImage:nil animationDirection:direction];
        
        //添加到主视图上
        [self.view addSubview:dropDownMenu];
        
        //将dropDownMenu的tag值设为2000，表示已经打开了dropDownMenu
        dropDownMenu.tag = 2000;
        
    }else {
        
        /*
         如果dropDownMenu的tag值为2000，表示dropDownMenu已经打开，则隐藏dropDownMenu
         */
        
        [dropDownMenu hideDropDownMenuWithBtnFrame:textFrame];
        dropDownMenu.tag = 1000;
    }
}

#pragma mark - 隐藏其它DropDownMenu
/*
 在点击按钮的时候，隐藏其它打开的下拉菜单（dropDownMenu）
 */
- (void)hideOtherDropDownMenu:(XDSDropDownMenu *)dropDownMenu{
    
    for ( int i = 0; i < self.dropDownMenuArray.count; i++ ) {
        
        if( self.dropDownMenuArray[i] !=  dropDownMenu){
            
            XDSDropDownMenu *dropDownMenuNext = self.dropDownMenuArray[i];
            
            CGRect textFrame = ((UILabel *)self.textArray[i]).frame;//如果按钮在UIIiew上用这个
            
            //          CGRect btnFrame = [self getBtnFrame:self.buttonArray[i]];//如果按钮在UITabelView上用这个
            
            [dropDownMenuNext hideDropDownMenuWithBtnFrame:textFrame];
            dropDownMenuNext.tag = 1000;
        }
    }
}
#pragma mark - 下拉菜单代理
/*
 在点击下拉菜单后，将其tag值重新设为1000
 */

- (void) setDropDownDelegate:(XDSDropDownMenu *)sender{
    sender.tag = 1000;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
