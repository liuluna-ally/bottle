//
//  HomeViewController.m
//  App
//  选择功能页面
//  Created by diam on 2021/4/15.
//
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "LearnViewController.h"
#import "MaintenanceViewController.h"
#import "SearchViewController.h"

@interface HomeViewController()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property NSMutableArray *arrays;
@property UIView *views;

@end

@implementation HomeViewController 

- (void)viewDidLoad {
    @try {
        //1.获取文本内容
        NSString *infoAdd = NSLocalizedString(@"infoAdd", nil);
        NSString *e_learning = NSLocalizedString(@"e-learning", nil);
        NSString *maintenanceStr = NSLocalizedString(@"maintenance", nil);
        NSString *searchStr = NSLocalizedString(@"search", nil);
        NSString *recordStr = NSLocalizedString(@"record", nil);
        
        //2.设置数据
        _arrays = [[NSMutableArray alloc]init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict[@"image"] = @"add";
        dict[@"name"] = infoAdd;
        [_arrays addObject:dict];

        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        dict1[@"image"] = @"learn";
        dict1[@"name"] = e_learning;
        [_arrays addObject:dict1];

        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
        dict2[@"image"] = @"maintenance";
        dict2[@"name"] = maintenanceStr;
        [_arrays addObject:dict2];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"authority"]){
            NSString *authority = [[NSUserDefaults standardUserDefaults] objectForKey:@"authority"];
            if([authority isEqual:@"0"]){
                NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
                dict3[@"image"] = @"search";
                dict3[@"name"] = searchStr;
                [_arrays addObject:dict3];
                NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
                dict4[@"image"] = @"record";
                dict4[@"name"] = recordStr;
                [_arrays addObject:dict4];
            }
        }
        
        //3.设置uiview
        CGFloat screenW = self.view.frame.size.width;
        CGFloat functionW = 75;
        CGFloat functionH = 90;
        CGFloat marginTop = 120;
        int column = 3;
        CGFloat marginX = (screenW - functionW*column)/(column+1);
        CGFloat marginY = marginX;
        for(int i = 0; i < [_arrays count]; i++){
            UIView *functionView = [[UIView alloc]init];
            functionView.frame = CGRectMake(marginX + (functionW+marginX)*(i%column), marginTop+(marginY+functionH)*(i/column), functionW, functionH);
            [self.view addSubview:functionView];
            //创建uibutton
            UIButton *button = [[UIButton alloc]init];
            CGFloat buttonW = 32;
            CGFloat buttonH = 32;
            button.frame = CGRectMake((functionView.frame.size.width-buttonW)*0.5, 0, buttonW, buttonH);
            NSDictionary *dict =  _arrays[i];
            NSString *imageName = [dict valueForKey:@"image"];
            [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            //设置tag
            button.tag = i;
            //添加点击事件
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [functionView addSubview:button];
            //创建lable
            UILabel *lable = [[UILabel alloc]init];
            CGFloat lableW = functionView.frame.size.width;
            CGFloat lableH = 20;
            CGFloat lableX = 0;
            CGFloat lableY = buttonH+10;
            NSString *name = [dict valueForKey:@"name"];
            // 设置字体大小可以改变
            lable.adjustsFontForContentSizeCategory = YES;
            lable.frame = CGRectMake(lableX, lableY, lableW, lableH);
            // 居中对齐
            lable.textAlignment = NSTextAlignmentCenter;
            lable.text = name;
            [functionView addSubview:lable];
        }
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,  (self.views.frame.size.height)* ([self.arrays count]));
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

/**
 点击事件
 */
-(void)click:(UIButton *)btn{
    @try {
        NSLog(@"点击了  %ld",btn.tag);
        
        if(btn.tag == 0){
            //进入下一页面 信息录入
            UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"info"];
                [self.navigationController pushViewController:nextVc animated:YES];
            
        }else if(btn.tag == 1){
            //进入下一页面 在线学习
            UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"learn"];
                [self.navigationController pushViewController:nextVc animated:YES];
            
            
        }else if(btn.tag == 2){
            //进入下一页面 维修
            UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"maintenance"];
                [self.navigationController pushViewController:nextVc animated:YES];
            
            
        }else if(btn.tag == 3){
            //进入下一页面 搜索
            UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"search"];
                [self.navigationController pushViewController:nextVc animated:YES];
            
        }else if(btn.tag == 4){
            //进入下一页面 搜索
            UIViewController* nextVc=[self.storyboard instantiateViewControllerWithIdentifier:@"record"];
                [self.navigationController pushViewController:nextVc animated:YES];
            
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
@end
