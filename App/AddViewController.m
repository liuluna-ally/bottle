//
//  AddViewController.m
//  App
//
//  Created by diam on 2021/5/8.
//

#import "AddViewController.h"

@interface AddViewController ()
    @property UIPickerView *pickView;
    @property NSMutableArray *dataArray;
    @property NSMutableArray *citiesArray;
    @property UITextField *addressDataText;
    @property UILabel *addressLabel;
    @property UITextField *phoneDataText;
    @property UILabel *phoneLabel;
    @property UIButton *btnSubmit;
    @property NSString *country;
    @property NSString *province;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"addMaintenance", nil);
    //[self loadData];
    //判断系统语言
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog(@"当前语言：%@",currentLanguage);
    if([currentLanguage containsString:@"en"]){
        [self loadDataEn];
    }else if([currentLanguage containsString:@"zh"]){
        [self loadData];
    }else if([currentLanguage containsString:@"fr"]){
        [self loadDataFr];
    }
    CGFloat marginX = self.view.frame.size.width;
    CGFloat marginY = self.view.frame.size.height;
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(marginX*0.1, marginY*0.05, marginX*0.8, marginY*0.3)];
    _pickView.dataSource = self;
    _pickView.delegate = self;
    [self.view addSubview:_pickView];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX*0.1, marginY*0.35, marginX*0.8, marginY*0.05)];
    [_addressLabel setText:NSLocalizedString(@"address", nil)];
    [self.view addSubview:_addressLabel];
    
    _addressDataText = [[UITextField alloc] initWithFrame:CGRectMake(marginX*0.1, marginY*0.4, marginX*0.8, marginY*0.1)];
    _addressDataText.layer.borderColor = [[UIColor grayColor] CGColor];
    _addressDataText.layer.borderWidth = 1;
    _addressDataText.layer.cornerRadius= 5;
    _addressDataText.layer.masksToBounds = YES;
    [self.view addSubview:_addressDataText];
    
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX*0.1, marginY*0.5, marginX*0.8, marginY*0.05)];
    [_phoneLabel setText:NSLocalizedString(@"phone", nil)];
    [self.view addSubview:_phoneLabel];
    
    _phoneDataText = [[UITextField alloc] initWithFrame:CGRectMake(marginX*0.1, marginY*0.55, marginX*0.8, marginY*0.05)];
    _phoneDataText.layer.borderColor = [[UIColor grayColor] CGColor];
    _phoneDataText.layer.borderWidth = 1;
    _phoneDataText.layer.cornerRadius= 5;
    _phoneDataText.layer.masksToBounds = YES;
    [self.view addSubview:_phoneDataText];
    
    _btnSubmit = [[UIButton alloc]initWithFrame: CGRectMake(marginX*0.1, marginY*0.65, marginX*0.8, marginY*0.06)];
    [_btnSubmit setBackgroundColor:[UIColor systemTealColor]];
    _btnSubmit.layer.cornerRadius= 5;
    [_btnSubmit setTitle:NSLocalizedString(@"submit", nil) forState:normal];
    [self.view addSubview: _btnSubmit];
    
    //点击提交按钮
    [_btnSubmit addTarget:self action:@selector(clickSubmit)
             forControlEvents:UIControlEventTouchUpInside];
    
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

-(void)clickSubmit{
    @try {
        //1.创建会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        //2.根据会话对象创建task
        NSURL *url = [NSURL URLWithString:@"http://182.61.134.30:3000/addMaintenance"];
        
        //3.创建可变的请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //4.修改请求方法为POST
        request.HTTPMethod = @"POST";
        
        //6.设置请求体
        NSString *country = [@"country=" stringByAppendingString:self.country];
        NSString *province = [@"province=" stringByAppendingString:self.province];
        NSString *address = [@"address=" stringByAppendingString:_addressDataText.text];
        NSString *phone = [@"phone=" stringByAppendingString:_phoneDataText.text];
        NSString *str1 = [country stringByAppendingString:@"&"];
        NSString *str2 = [str1 stringByAppendingString:province];
        NSString *str3 = [str2 stringByAppendingString:@"&"];
        NSString *str4 = [str3 stringByAppendingString:address];
        NSString *str5 = [str4 stringByAppendingString:@"&"];
        NSString *str6 = [str5 stringByAppendingString:phone];
        request.HTTPBody = [str6 dataUsingEncoding:NSUTF8StringEncoding];
        
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
                if([result isEqual:@"录入成功"]){
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
#pragma mark - loadData
- (void)loadData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    _citiesArray = _dataArray[0][@"cities"];
}

- (void)loadDataEn {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"cityEn" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    _citiesArray = _dataArray[0][@"cities"];
}
- (void)loadDataFr {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"cityFr" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    _citiesArray = _dataArray[0][@"cities"];
}
#pragma mark - dataSource
//注意这里是几列的意思。我刚刚开始学得时候也在这里出错，没理解
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _dataArray.count;
    }else {
        return _citiesArray.count;
    }
}

#pragma mark - delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 150;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

//返回每行显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%@",_dataArray[row][@"state"]];
    }else {
        return [NSString stringWithFormat:@"%@",_citiesArray[row]];
    }
}

//当改变省份时，重新加载第2列的数据，部分加载
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _citiesArray = _dataArray[row][@"cities"];
        [_pickView reloadComponent:1];
    }else {
        NSString *result = [NSString stringWithFormat:@"%@%@",self.dataArray[[self.pickView selectedRowInComponent:0]][@"state"],self.citiesArray[[self.pickView selectedRowInComponent:1]]];//如果选中第二个
        NSLog(@"选中的：%@",result);
        _country = self.dataArray[[self.pickView selectedRowInComponent:0]][@"state"];
        _province　 = self.citiesArray[[self.pickView selectedRowInComponent:1]];
        
    }
    
}

//补充说明~有时候我们需要显示的是view，若实现了一下方法，那么        @selector(pickerView:attributedTitleForRow:forComponent:)就不会调用了，因此如果选择器既有文字又有图片，可以选择文字区域返回UILabel。（我的解决方案~可能有更好的~）
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
