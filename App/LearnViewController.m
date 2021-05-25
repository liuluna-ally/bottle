//
//  LearnViewController.m
//  App
//  学习页面
//  Created by diam on 2021/4/15.
//

#import "LearnViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayerContainerView.h"

@interface LearnViewController ()
// 控制播放器的播放，暂停，播放速度
@property AVPlayer *player;
// 管理资源对象，提供播放数据源
@property AVPlayerItem *playerItem;
// 负责显示视频，如果没有添加该类，只有声音没有画面
@property AVPlayerLayer *playerLayer;
// 监控进度
@property (nonatomic,strong)NSTimer *avTimer;
@end

@implementation LearnViewController

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        VideoPlayerContainerView *vpcView = [[VideoPlayerContainerView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
        [self.view addSubview:vpcView];
            
        vpcView.urlVideo = @"https://www.apple.com/105/media/cn/researchkit/2016/a63aa7d4_e6fd_483f_a59d_d962016c8093/films/carekit/researchkit-carekit-cn-20160321_848x480.mp4";
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
@end
