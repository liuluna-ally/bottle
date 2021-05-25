//
//  SearchViewController.m
//  App
//   搜索页面
//  Created by diam on 2021/4/15.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *searchResults;//总的搜索结果
//获取文本
@property NSString *unreachNetwork;
@property NSString *unserver;
@property NSString *tips;
@property NSString *determine;
@property NSString *search;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.searchBar.placeholder = NSLocalizedString(@"input", nil);
        _unreachNetwork = NSLocalizedString(@"unreachNetwork", nil);
        _unserver = NSLocalizedString(@"unserver", nil);
        _tips = NSLocalizedString(@"Tips", nil);
        _determine = NSLocalizedString(@"determine", nil);
        _search = NSLocalizedString(@"search", nil);
        _searchBar.delegate = self;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsZero;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

// MARK: - 设置数据源

#pragma mark -/*****************显示数据源方法****************************/
//默认显示1组数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每组显示几行数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @try {
        return [self.searchResults count];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}

//修改行高度的位置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


//每一组的每一行中显示什么数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        //indexPath.section  几组    indexPath.row 几行
        UITableViewCell *cell = [self customCellWithOutXib:tableView withIndexPath:indexPath];
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}

//通过代码自定义cell
-(UITableViewCell *)customCellWithOutXib:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    @try {
        //定义标识符
        static NSString *customCellIndentifier = @"CustomCellIndentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellIndentifier];
        
        //定义新的cell
        if(cell == nil){
            //使用默认的UITableViewCell,但是不使用默认的image与text，改为添加自定义的控件
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellIndentifier];
            //时间
            CGRect timeRect = CGRectMake(2, 0, 280, 32);
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:timeRect];
            timeLabel.textColor = [UIColor systemGray2Color];
            timeLabel.tag = timeTag;
            [cell.contentView addSubview:timeLabel];
            
            //客人姓名
            CGFloat marginX = self.view.frame.size.width;
            CGRect customerNameRect = CGRectMake(marginX*0.02, 30, marginX*0.3, 64);
            UILabel *customerNameLabel = [[UILabel alloc]initWithFrame:customerNameRect];
            customerNameLabel.textColor = [UIColor blackColor];
            customerNameLabel.tag = customerNameTag;
            [cell.contentView addSubview:customerNameLabel];
            
            //设备编号
            CGRect deviceNumberRect = CGRectMake(marginX*0.15, 25, marginX*0.35, 24);
            UILabel *deviceNumberLabel = [[UILabel alloc]initWithFrame:deviceNumberRect];
            deviceNumberLabel.text = NSLocalizedString(@"deviceNumber", nil);
            deviceNumberLabel.textColor = [UIColor blackColor];
            [cell.contentView addSubview:deviceNumberLabel];
            
            //设备编号数据
            CGRect deviceDataRect = CGRectMake(marginX*0.5, 25, marginX*0.3, 24);
            UILabel *deviceDataLabel = [[UILabel alloc]initWithFrame:deviceDataRect];
            deviceDataLabel.tag = deviceTag;
            [cell.contentView addSubview:deviceDataLabel];
            
            //大瓶编号
            CGRect canRect = CGRectMake(marginX*0.15, 75, marginX*0.35, 24);
            UILabel *canLabel = [[UILabel alloc]initWithFrame:canRect];
            canLabel.text = NSLocalizedString(@"canNumber", nil);
            [cell.contentView addSubview:canLabel];
            
            //大瓶编号数据
            CGRect canDataRect = CGRectMake(marginX*0.5, 75, marginX*0.3, 24);
            UILabel *canDataLabel = [[UILabel alloc]initWithFrame:canDataRect];
            canDataLabel.tag = canTag;
            [cell.contentView addSubview:canDataLabel];
            
            //容量
            CGRect volumeDataRect = CGRectMake(marginX*0.8, 40, marginX*0.2, 24);
            UILabel *volumeDataLabel = [[UILabel alloc]initWithFrame:volumeDataRect];
            volumeDataLabel.tag = volumeTag;
            [cell.contentView addSubview:volumeDataLabel];
        }
        //获得行数
        
        //取得相应行数的数据（
        if ([self.searchResults count] > 0){
            NSDictionary *dict = self.searchResults[indexPath.row];
            NSLog(@"每一行的数据%@",dict);
            // 设置时间
            UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:timeTag];
            NSString *time = [dict objectForKey:@"newtime"];
            NSLog(@"获取到的string类型的时间：%@",time);
            if(![time isEqual:@"<null>"] && time !=nil){
                //NSString转NSDate
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                NSDate *date=[formatter dateFromString:time];
                NSLog(@"date111 %@",date);
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
                [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateStr = [formatter1 stringFromDate:date];
                NSLog(@"date222 %@",dateStr);
                timeLabel.text = dateStr;
            }
            
            
            // 客人姓名
            UILabel *customerNameLabel = (UILabel *)[cell.contentView viewWithTag:customerNameTag];
            NSString *name = [dict objectForKey:@"customerName"];
            customerNameLabel.text = name;
            //设置设备编号
            UILabel *deviceNumberLabel = (UILabel *)[cell.contentView viewWithTag:deviceTag];
            NSString *deviceNumber = [dict objectForKey:@"deviceNumber"];
            deviceNumberLabel.text = deviceNumber;
            //设置大瓶编号
            UILabel *canNumberLabel = (UILabel *)[cell.contentView viewWithTag:canTag];
            NSString *canNumber = [dict objectForKey:@"canNumber"];
            canNumberLabel.text = canNumber;
            //设置容量
            UILabel *volumeLabel = (UILabel *)[cell.contentView viewWithTag:volumeTag];
            NSString *volume = [dict objectForKey:@"volume"];
            volumeLabel.text = volume;
            
            //设置右侧箭头
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else {
            return  nil;
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        //保存当前位置信息
        NSString *infoId = [self.searchResults[indexPath.row] objectForKey:@"id"];
        NSLog(@"id为%@",infoId);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:infoId forKey:@"infoId"];
        [defaults synchronize];
        //跳转到下一页面
        UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
            [self.navigationController pushViewController:nextVc animated:YES];
        [self.searchBar endEditing:YES];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

// MARK: - UISearchBarDelegate

//监听输入框输入
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    @try {
        if (searchText.length) {
            
            //2.请求服务器，实现自动匹配功能
            [self selectResult:searchText];
        }
    } @catch (NSException *exception) {
        NSLog(@"搜索异常：%@",exception);
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    @try {
        [searchBar endEditing:YES];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

// MARK: - 设置搜索结果
- (void)selectResult:(NSString *)searchText {
    @try {
        //根据输入框内容，搜索匹配到的内容
        
        //1.确定请求路径
        NSString *keyword = [@"keyword=" stringByAppendingString:searchText];
        NSString *str1 = [keyword stringByAppendingString:@"&"];
        NSString *str2 = [str1 stringByAppendingString:@"type=JSON"];
        NSString *str3 = [@"http://182.61.134.30:3000/search?" stringByAppendingString:str2];
        
        NSString *urlString = [str3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
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
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.tips message:self.unserver preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:self.determine style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:true completion:nil];
                    
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
                            NSLog(@"解析到的数据为searchResults：%@",self.searchResults);
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
            dispatch_async(dispatch_get_main_queue(), ^{
                if([self.searchResults count] >= 0){
                    [self.tableView reloadData];
                }
            });
        });
    }@catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
@end
