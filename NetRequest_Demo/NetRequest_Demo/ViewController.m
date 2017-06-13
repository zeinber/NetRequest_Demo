//
//  ViewController.m
//  NetRequest_Demo
//
//  Created by YZL on 17/6/13.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ViewController.h"

#import "TestNetRequest.h"

@interface ViewController ()
///测试请求
@property (nonatomic, strong) TestNetRequest *testNetRequest;
@end

@implementation ViewController

#pragma mark - view Func
- (void)viewDidLoad {
    [super viewDidLoad];
    //发送请求
    [self initTestNetRequest];
}


#pragma mark - net request
///测试请求  这边方法命名规则是 init+XXNetRequest,X要大写
- (void)initTestNetRequest {
    if (!_testNetRequest) {
        _testNetRequest = [[TestNetRequest alloc] initWithApiUrl:@"initAction/getBanner"];//请求接口名字
        _testNetRequest.httpMethod = @"GET";//请求的方式 POST或GET 区分大小写
    }
    //写请求参数
    _testNetRequest.position = @"0";
    _testNetRequest.t = @"1";
    [_testNetRequest NetRequestWithReturnValeuBlock:^(id returnValue) {//成功的回调
        NSLog(@"returnValue:%@",returnValue);
    } WithErrorCodeBlock:^(id errorCode) {//服务器返回成功，但是不是正确的错误码
        NSLog(@"errorCode:%@",errorCode);
    } WithFailureBlock:^{//服务器返回失败
        NSLog(@"请求失败");
    }];
}



@end
