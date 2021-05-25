//
//  InfoDetailViewController.m
//  App
//
//  Created by diam on 2021/4/26.
//

#import "InfoDetailViewController.h"

@interface InfoDetailViewController ()
@property NSMutableArray *searchResults;//搜索结果
@end

@implementation InfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"infoId"]){
        NSNumber *infoId = [[NSUserDefaults standardUserDefaults] objectForKey:@"infoId"];
        NSLog(@"获取到的id:%@",infoId);
        NSString *str = infoId.description;
        [self selectResult:str];
    }
    
    
    
}
-(void) initView{
    
    CGFloat marginX = self.view.frame.size.width;
    CGFloat marginY = self.view.frame.size.height;
    CGFloat width = (self.view.frame.size.width)*0.4;
    CGFloat width1 = (self.view.frame.size.width)*0.5;
    CGFloat height = (self.view.frame.size.height)*0.05;
    //客人姓名
    CGRect customerNameRect = CGRectMake(marginX*0.1, marginY*0.11, width, height);
    UILabel *customerNameLabel = [[UILabel alloc]initWithFrame:customerNameRect];
    customerNameLabel.textColor = [UIColor blackColor];
    customerNameLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体大小可以改变
    customerNameLabel.adjustsFontForContentSizeCategory = YES;
    customerNameLabel.text = [self.searchResults[0] objectForKey:@"customerName"];
    [self.view addSubview:customerNameLabel];
    //时间
    CGRect timeRect = CGRectMake(marginX*0.5, marginY*0.11, width1, height);
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:timeRect];
    // 设置字体大小可以改变
    timeLabel.adjustsFontForContentSizeCategory = YES;
    timeLabel.textColor = [UIColor blackColor];
    //NSString转NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date=[formatter dateFromString:[self.searchResults[0] objectForKey:@"newtime"]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter1 stringFromDate:date];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.text = dateStr;
    [self.view addSubview:timeLabel];
    
    //联系方式
    CGRect contactRect = CGRectMake(marginX*0.1, marginY*0.18, width, height);
    UILabel *contactLabel = [[UILabel alloc]initWithFrame:contactRect];
    contactLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体大小可以改变
    contactLabel.adjustsFontForContentSizeCategory = YES;
    contactLabel.text = NSLocalizedString(@"contact", nil);
    contactLabel.textColor = [UIColor blackColor];
    [self.view addSubview:contactLabel];
    
    // 联系方式数据
    CGRect contactDataRect = CGRectMake(marginX*0.5, marginY*0.18, width1, height);
    UILabel *contatcDataLabel = [[UILabel alloc]initWithFrame:contactDataRect];
    contatcDataLabel.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    contatcDataLabel.adjustsFontForContentSizeCategory = YES;
    contatcDataLabel.text = [self.searchResults[0] objectForKey:@"contact"];
    [self.view addSubview:contatcDataLabel];
    
    //设备编号
    CGRect deviceNumberRect = CGRectMake(marginX*0.1, marginY*0.25, width, height);
    UILabel *deviceNumberLabel = [[UILabel alloc]initWithFrame:deviceNumberRect];
    deviceNumberLabel.textAlignment = NSTextAlignmentCenter;
    deviceNumberLabel.text = NSLocalizedString(@"deviceNumber", nil);
    // 设置字体大小可以改变
    deviceNumberLabel.adjustsFontForContentSizeCategory = YES;
    deviceNumberLabel.textColor = [UIColor blackColor];
    [self.view addSubview:deviceNumberLabel];
    
    //设备编号数据
    CGRect deviceDataRect = CGRectMake(marginX*0.5, marginY*0.25, width1, height);
    UILabel *deviceDataLabel = [[UILabel alloc]initWithFrame:deviceDataRect];
    deviceDataLabel.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    deviceDataLabel.adjustsFontForContentSizeCategory = YES;
    deviceDataLabel.text = [self.searchResults[0] objectForKey:@"deviceNumber"];
    [self.view addSubview:deviceDataLabel];
    
    //大瓶编号
    CGRect canRect = CGRectMake(marginX*0.1, marginY*0.32, width, height);
    UILabel *canLabel = [[UILabel alloc]initWithFrame:canRect];
    canLabel.textAlignment = NSTextAlignmentCenter;
    // 设置字体大小可以改变
    canLabel.adjustsFontForContentSizeCategory = YES;
    canLabel.text = NSLocalizedString(@"canNumber", nil);
    [self.view addSubview:canLabel];
    
    
    //大瓶编号数据
    CGRect canDataRect = CGRectMake(marginX*0.5, marginY*0.32, width1, height);
    UILabel *canDataLabel = [[UILabel alloc]initWithFrame:canDataRect];
    canDataLabel.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    canDataLabel.adjustsFontForContentSizeCategory = YES;
    canDataLabel.text = [self.searchResults[0] objectForKey:@"canNumber"];
    [self.view addSubview:canDataLabel];
    
    //小瓶编号
    CGRect bottleRect = CGRectMake(marginX*0.1, marginY*0.39, width, height);
    UILabel *bottleLabel = [[UILabel alloc]initWithFrame:bottleRect];
    bottleLabel.textAlignment = NSTextAlignmentCenter;
    bottleLabel.text = NSLocalizedString(@"bottleNumber", nil);
    // 设置字体大小可以改变
    bottleLabel.adjustsFontForContentSizeCategory = YES;
    [self.view addSubview:bottleLabel];
    
    //小瓶编号数据
    CGRect bottleDataRect = CGRectMake(marginX*0.5, marginY*0.39, width1, height);
    UILabel *bottleDataLabel = [[UILabel alloc]initWithFrame:bottleDataRect];
    bottleDataLabel.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    bottleDataLabel.adjustsFontForContentSizeCategory = YES;
    bottleDataLabel.text = [self.searchResults[0] objectForKey:@"bottleNumber"];
    [self.view addSubview:bottleDataLabel];
    
    //  产品名称
    CGRect productNameRect = CGRectMake(marginX*0.1, marginY*0.46, width, height);
    UILabel *productNameLabel = [[UILabel alloc]initWithFrame:productNameRect];
    productNameLabel.textAlignment = NSTextAlignmentCenter;
    productNameLabel.text = NSLocalizedString(@"productName", nil);
    // 设置字体大小可以改变
    productNameLabel.adjustsFontForContentSizeCategory = YES;
    [self.view addSubview:productNameLabel];
    //产品名称数据
    CGRect productNameDataRect = CGRectMake(marginX*0.5, marginY*0.46, width1, height);
    UILabel *productNameDataLabel = [[UILabel alloc]initWithFrame:productNameDataRect];
    productNameDataLabel.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    productNameDataLabel.adjustsFontForContentSizeCategory = YES;
    productNameDataLabel.text = [self.searchResults[0] objectForKey:@"productName"];
    [self.view addSubview:productNameDataLabel];
    
    //  容量
    CGRect volumeRect = CGRectMake(marginX*0.1, marginY*0.53, width, height);
    UILabel *volumeLabel = [[UILabel alloc]initWithFrame:volumeRect];
    volumeLabel.textAlignment = NSTextAlignmentCenter;
    volumeLabel.text = NSLocalizedString(@"volume", nil);
    // 设置字体大小可以改变
    volumeLabel.adjustsFontForContentSizeCategory = YES;
    [self.view addSubview:volumeLabel];
    
    //容量数据
    CGRect volumeDataRect = CGRectMake(marginX*0.5, marginY*0.53, width1, height);
    UILabel *volumeDataLabel = [[UILabel alloc]initWithFrame:volumeDataRect];
    volumeDataLabel.textAlignment = NSTextAlignmentLeft;
    // 设置字体大小可以改变
    volumeDataLabel.adjustsFontForContentSizeCategory = YES;
    volumeDataLabel.text = [self.searchResults[0] objectForKey:@"volume"];
    [self.view addSubview:volumeDataLabel];
}

- (void)selectResult:(NSString *)infoId {
    @try {
        //1.确定请求路径
        
        NSString *str = [@"http://182.61.134.30:3000/getInfoById?id=" stringByAppendingString:infoId];
        NSString *urlString = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL*url=[NSURL URLWithString:urlString];
        
        //2.创建请求对象
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        //4.创建一个组
        dispatch_group_t group = dispatch_group_create();
        //4.1 将请求加入组中
        dispatch_group_enter(group);
        //4.2.根据会话对象创建一个Task(发送请求）
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if([data length] == 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                });
            }
            
            if (error == nil) {
                //5.解析服务器返回的数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSDictionary *resData = [dict objectForKey:@"data"];
                    if ([resData count] > 0){
                        NSMutableArray *resultArrays = [resData objectForKey:@"result"];
                        if([resultArrays count] > 0){
                            self.searchResults = resultArrays;
                            NSLog(@"根据id解析到的数据为searchResults：%@",self.searchResults);
                        }else{
                            self.searchResults = nil;
                        }
                    }else {
                        self.searchResults = nil;
                    }
                });
            }
            //4.3 离开这个组
            dispatch_group_leave(group);
        }];
        
        //7.执行任务
        [dataTask resume];
        dispatch_group_notify(group, dispatch_get_main_queue(),^{
            //更新UI
            [self initView];
        });
    }@catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
@end
