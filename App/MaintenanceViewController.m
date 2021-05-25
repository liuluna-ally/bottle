//
//  MaintenanceViewController.m
//  App
//  维修
//  Created by diam on 2021/4/15.
//

#import "MaintenanceViewController.h"

@interface MaintenanceViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property NSMutableArray *searchResults;//总的搜索结果


@end

@implementation MaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"maintenanceAddress", nil);
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    _tabelView.tableFooterView = [UIView new];
    _tabelView.separatorInset = UIEdgeInsetsZero;
    [self selectResult];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                          target:self
                                          action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    //5.下拉刷新
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.tabelView.refreshControl = refreshControl;
    
}

- (void)onClickedOKbtn {
    UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"add"];
        [self.navigationController pushViewController:nextVc animated:YES];
}

//加载数据
-(void)loadData{
    NSLog(@"手动刷新了");
    [self selectResult];
    //停止刷新
    if ([self.tabelView.refreshControl isRefreshing]) {
        [self.tabelView.refreshControl endRefreshing];
    }
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
    return 130;
}


//每一组的每一行中显示什么数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        //indexPath.section  几组    indexPath.row 几行
        UITableViewCell *cell = [self customCellWithOutXib:tableView withIndexPath:indexPath];
        //添加长按手势
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        
        longPressGesture.minimumPressDuration=1.0f;//设置长按 时间
        [cell addGestureRecognizer:longPressGesture];
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    
    
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.tabelView];
        NSIndexPath * indexPath = [self.tabelView indexPathForRowAtPoint:location];
        //可以得到此时你点击的哪一行
        
        // 初始化对话框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"delete", nil) preferredStyle:UIAlertControllerStyleAlert];
        // 确定
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"determine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            NSString *row = [NSString stringWithFormat:@"%@", [self.searchResults[indexPath.row] objectForKey:@"id"]];
            NSLog(@"row:%@",row);
            [self deleteRecord:row];
        }];
        UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
            
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        // 弹出对话框
        [self presentViewController:alert animated:true completion:nil];
        
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
            //国家
            CGFloat marginX = self.view.frame.size.width;
            CGRect countryRect = CGRectMake(10, 10, marginX, 32);
            UILabel *countryLabel = [[UILabel alloc]initWithFrame:countryRect];
            countryLabel.font = [UIFont systemFontOfSize:20];
            countryLabel.tag = countryTag;
            [cell.contentView addSubview:countryLabel];
            
            // 地址图标
            CGRect addressImageRect = CGRectMake(10, 46, 32, 32);
            UIImageView *addressImage = [[UIImageView alloc]initWithFrame:addressImageRect];
            [addressImage setImage:[UIImage imageNamed:@"address"]];
            [cell.contentView addSubview:addressImage];
            // 地址
            CGRect addressRect = CGRectMake(48, 46, marginX-48, 32);
            UILabel *addressLabel = [[UILabel alloc]initWithFrame:addressRect];
            addressLabel.textColor = [UIColor blackColor];
            addressLabel.tag = addressTag;
            [cell.contentView addSubview:addressLabel];
            
            //   电话图标
            CGRect phoneImageRect = CGRectMake(10, 90, 32, 32);
            UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:phoneImageRect];
            [phoneImage setImage:[UIImage imageNamed:@"phone"]];
            [cell.contentView addSubview:phoneImage];
            // 电话
            CGRect phoneRect = CGRectMake(48, 90, marginX-48, 32);
            UILabel *phoneLabel = [[UILabel alloc]initWithFrame:phoneRect];
            phoneLabel.textColor = [UIColor blackColor];
            phoneLabel.tag = phoneTag;
            [cell.contentView addSubview:phoneLabel];
            
        }
        //获得行数
        
        //取得相应行数的数据（
        NSDictionary *dict = self.searchResults[indexPath.row];
        // 设置 国家
        UILabel *countryLabel = (UILabel *)[cell.contentView viewWithTag:countryTag];
       
        countryLabel.text = [dict objectForKey:@"country"];
        // 地址
        UILabel *addressLabel = (UILabel *)[cell.contentView viewWithTag:addressTag];
        NSString *privince = [dict objectForKey:@"province"];
        NSString *address = [dict objectForKey:@"address"];
        NSString *newAddress = [privince stringByAppendingString:address];
        addressLabel.text = newAddress;
        
        // 电话
        UILabel *phoneLabel = (UILabel *)[cell.contentView viewWithTag:phoneTag];
        phoneLabel.text = [dict objectForKey:@"phone"];
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
        NSString *str = @"http://182.61.134.30:3000/queryMaintenance";
        
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
                [self.tabelView reloadData];
            });
        });
    }@catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(void)deleteRecord:(NSString *)row{
    @try {
        //1.url
        NSString *str = [@"http://182.61.134.30:3000/deleteById?id=" stringByAppendingString:row];
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
                [self selectResult];
            });
        });
    }@catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}


@end
