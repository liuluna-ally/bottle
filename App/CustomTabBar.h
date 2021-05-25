//
//  CustomTabBar.h
//  App
//
//  Created by diam on 2021/4/16.
//

#import <UIKit/UIKit.h>

@class CustomTabBar;

@protocol CustomTabBarDelegate <NSObject>

- (void)tabBar:(CustomTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag;

@end

@interface CustomTabBar : UIView

@property (nonatomic, weak)id <CustomTabBarDelegate>delegate;

- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem;

@end
