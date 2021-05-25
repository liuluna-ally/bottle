//
//  RecordViewController.m
//  App
//
//  Created by diam on 2021/4/22.
//

#import "RecordViewController.h"

@interface RecordViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *searchResults;//总的搜索结果
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self selectResult];
    
}
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
            timeLabel.font = [UIFont boldSystemFontOfSize:fontSize];
            timeLabel.tag = timeTag;
            [cell.contentView addSubview:timeLabel];
            
            //客人姓名
            CGRect customerNameRect = CGRectMake(10, 30, 128, 64);
            UILabel *customerNameLabel = [[UILabel alloc]initWithFrame:customerNameRect];
            customerNameLabel.textColor = [UIColor blackColor];
            customerNameLabel.tag = customerNameTag;
            [cell.contentView addSubview:customerNameLabel];
            
        }
        //获得行数
        
        //取得相应行数的数据（
        NSDictionary *dict = self.searchResults[indexPath.row];
        // 设置时间
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:timeTag];
        NSString *time = [dict objectForKey:@"createtime"];
        //NSString转NSDate
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *date=[formatter dateFromString:time];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
        [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter1 stringFromDate:date];
        timeLabel.adjustsFontForContentSizeCategory = YES;
        timeLabel.text = dateStr;
        // 客人姓名
        UILabel *customerNameLabel = (UILabel *)[cell.contentView viewWithTag:customerNameTag];
        NSString *name = [dict objectForKey:@"username"];
        customerNameLabel.adjustsFontForContentSizeCategory = YES;
        customerNameLabel.text = name;
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

// MARK: - 设置搜索结果
- (void)selectResult{
    @try {
        //根据输入框内容，搜索匹配到的内容
        
        //1.确定请求路径
        NSString *str = @"http://182.61.134.30:3000/queryRecord";
        
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
                    NSMutableArray *resultArrays = [resData objectForKey:@"result"];
                    self.searchResults = resultArrays;
                    NSLog(@"解析到的数据为searchResults：%@",self.searchResults);
                    
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
                [self.tableView reloadData];
            });
        });
    }@catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

@end
