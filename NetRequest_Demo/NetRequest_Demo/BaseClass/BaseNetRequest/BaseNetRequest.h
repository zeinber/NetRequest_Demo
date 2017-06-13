//
//  BaseNetRequest.h
//  NetRequest_Demo
//
//  Created by YZL on 17/6/13.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/// 服务器地址
#define API_URL @"http://shuaibo.zertone1.com/app"

// 定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);                  // 返回数据正确
typedef void (^ErrorCodeBlock) (id errorCode);                      // 返回数据错误
typedef void (^FailureBlock)();                                     // 网络请求失败
typedef void (^ProgressBlock) (NSProgress *uploadProgress);         // 进度数据返回
typedef void (^ErrorBlock) (id errorCode);                          // 错误信息返回
typedef void (^SuccessBlock) (id responseObject);                   // 正确数据返回

@interface BaseNetRequest : NSObject
/// 接口地址
@property (nonatomic, copy) NSString *api_url;
/// 请求方式
@property (nonatomic, copy) NSString *httpMethod;

/**
 *  自定义初始化方法
 *
 *  @param api_url 接口地址
 *
 *  @return aaa
 */
- (instancetype)initWithApiUrl:(NSString *)api_url;

#pragma mark - 网络请求
/**
 *  网络请求
 *
 *  @param block        请求成功——正确的block
 *  @param errorBlock   请求成功——错误的block
 *  @param failureBlock 请求失败的block
 */
- (void)NetRequestWithReturnValeuBlock: (ReturnValueBlock) block
                     WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                       WithFailureBlock: (FailureBlock) failureBlock;



@end
