//
//  GCD-OC.m
//  GCD-Test
//
//  Created by 宝宝 on 2018/4/17.
//  Copyright © 2018年 宝宝. All rights reserved.
//

#import "GCD-OC.h"

@implementation GCD_OC
- (void)createQUeue {
    dispatch_queue_t queue;
    dispatch_queue_attr_t attr;
    attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0);
    queue = dispatch_queue_create("com.example.myqueue", attr);
}
@end
