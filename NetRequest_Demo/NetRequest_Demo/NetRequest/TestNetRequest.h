//
//  TestNetRequest.h
//  NetRequest_Demo
//
//  Created by YZL on 17/6/13.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "BaseNetRequest.h"

///需要的网络请求需要继承 BaseNetRequest
@interface TestNetRequest : BaseNetRequest
/* 这里写请求需要的参数 **/

@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *t;
@end
