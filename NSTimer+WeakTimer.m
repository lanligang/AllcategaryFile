//
//  NSTimer+WeakTimer.m
//  CreativeInteraction
//
//  Created by ios2 on 2020/7/7.
//  Copyright © 2020 cy. All rights reserved.
//

#import "NSTimer+WeakTimer.h"

@implementation WeakTimerRun
-(void)timeRun {
	!_run?:_run();
}
-(void)timer:(id)sender
{
	!_runInfo?:_runInfo(sender);
}
-(void)dealloc {
	NSLog(@"正常释放");
}
@end

static const char weakTimer_obj_key = '\0';

@interface NSTimer ()
@property (nonatomic,strong)WeakTimerRun *runObj;
@end

@implementation NSTimer (WeakTimer)

-(void)setRunObj:(WeakTimerRun *)runObj {
	objc_setAssociatedObject(self, &weakTimer_obj_key, runObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(WeakTimerRun *)runObj {
	return  objc_getAssociatedObject(self, &weakTimer_obj_key);
}

+(NSTimer *)weakTimer:(NSTimeInterval)time andIsRepeat:(BOOL)isRepeat andRun:(void(^)(void))run {
	WeakTimerRun * arun = [[WeakTimerRun alloc]init];
	arun.run = run;
	NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:time target:arun selector:@selector(timeRun) userInfo:nil repeats:isRepeat];
	timer.runObj = arun;
	return timer;
}

+(NSTimer *)weakTimer:(NSTimeInterval)time andIsRepeat:(BOOL)isRepeat userInfo:(id)userInfo andRun:(void(^)(id))run {
	WeakTimerRun * arun = [[WeakTimerRun alloc]init];
	arun.runInfo  = run;
	NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:time target:arun selector:@selector(timeRun) userInfo:userInfo repeats:isRepeat];
	return timer;
}

@end


@implementation CADisplayLink (WeakTimer)

+(CADisplayLink *)weakLinkWithRun:(void(^)(void))run{
	WeakTimerRun * arun = [[WeakTimerRun alloc]init];
	arun.run = run;
	CADisplayLink *link = [CADisplayLink displayLinkWithTarget:arun selector:@selector(timeRun)];
	[link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	return link;
}

@end



