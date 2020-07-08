//
//  NSTimer+WeakTimer.h
//  CreativeInteraction
//
//  Created by ios2 on 2020/7/7.
//  Copyright © 2020 cy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakTimerRun : NSObject

@property (nonatomic,copy)void(^run)(void);

@property (nonatomic,copy)void(^runInfo)(id);

-(void)timeRun;

-(void)timer:(id)sender;

@end

//需要在控制器或者使用的地方 dealloc 方法中
/*
	[timer invalidate];
	timer = nil;
*/

@interface NSTimer (WeakTimer)
//不携带参数
+(NSTimer *)weakTimer:(NSTimeInterval)time andIsRepeat:(BOOL)isRepeat andRun:(void(^)(void))run;

//携带参数
+(NSTimer *)weakTimer:(NSTimeInterval)time andIsRepeat:(BOOL)isRepeat userInfo:(id)userInfo andRun:(void(^)(id))run;

@end

@interface CADisplayLink (WeakTimer)
//默认是按照屏幕刷新率进行刷新的
+(CADisplayLink *)weakLinkWithRun:(void(^)(void))run;

@end




NS_ASSUME_NONNULL_END
