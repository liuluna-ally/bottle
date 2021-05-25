//
//  VideoPlayerToolsView.h
//  App
//
//  Created by diam on 2021/4/22.
//

#import <UIKit/UIKit.h>
@protocol VideoPlayerToolsViewDelegate <NSObject>

-(void)playButtonWithStates:(BOOL)state;

@end
NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerToolsView : UIView
@property (nonatomic, strong) UIButton *bCheck;//播放暂停按钮
@property (nonatomic, strong) UISlider *progressSr;//进度条
@property (nonatomic, strong) UIProgressView *bufferPV;//缓冲条
@property (nonatomic, strong) UILabel *lTime;//时间进度和总时长
@property (nonatomic, weak) id<VideoPlayerToolsViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
