//
//  VideoPlayerContainerView.h
//  App
//  iOS 基于AVPlayer的简易播放器
//  Created by diam on 2021/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerContainerView : UIView
@property (nonatomic, strong) NSString *urlVideo;

-(void)dealloc;
@end

NS_ASSUME_NONNULL_END
