//
//  NetworkSpeedMonitor.h
//  App
//
//  Created by diam on 2021/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const NetworkDownloadSpeedNotificationKey;
extern NSString *const NetworkUploadSpeedNotificationKey;
extern NSString *const NetworkSpeedNotificationKey;

@interface NetworkSpeedMonitor : NSObject

@property (nonatomic, copy, readonly) NSString *downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;

- (void)startNetworkSpeedMonitor;
- (void)stopNetworkSpeedMonitor;

@end

NS_ASSUME_NONNULL_END
