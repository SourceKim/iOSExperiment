////  ViewController.m
//  NSSet_Empty_Crash
//
//  Created by Su Jinjin on 2020/6/19.
//  Copyright © 2020 苏金劲. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 一个 set
    NSMutableSet *set = [NSMutableSet set];
    [set addObject: @"5"];
    [set addObject: @"6"];
    
    // 放入 NSMtableDictionary，不 crash
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setObject: set forKey: @"key"];
    
    // 放入 NSMutableArray，不 crash
    NSMutableArray *mArr = [NSMutableArray array];
    [mArr addObject: set];
    
    // 放入 NSUserdfaults，crash !!
    [[NSUserDefaults standardUserDefaults] setObject: set forKey: @"key"];
    
    /* Crash log:
     *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Attempt to insert non-property list object {(
     )} for key key'
     */
    
    NSLog(@"Fin");
}


@end
