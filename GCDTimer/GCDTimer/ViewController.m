////  ViewController.m
//  GCDTimer
//
//  Created by Su Jinjin on 2020/5/26.
//  Copyright © 2020 苏金劲. All rights reserved.
//

#import "ViewController.h"

#import<libkern/OSAtomic.h>

@interface ViewController ()

@end

@implementation ViewController {
    
    dispatch_source_t timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t timerQueue = dispatch_queue_create("com.kedc.timerQueue", DISPATCH_QUEUE_CONCURRENT);
    
    __block int cnt = 0;

    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"hi");
        if (cnt == 5) {
            [self stop];
        }
        cnt++;
    });
    dispatch_resume(timer);
}

- (void)stop {
    dispatch_source_cancel(timer);
//    dispatch_suspend(timer);
    timer = nil;
}


@end
