//
//  BaseNetRequest.m
//  NetRequest_Demo
//
//  Created by YZL on 17/6/13.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "BaseNetRequest.h"
#import <objc/runtime.h>

@interface BaseNetRequest()

@property (nonatomic, strong) AFHTTPSessionManager *httpGetManager;
//
@property (nonatomic, strong) AFHTTPSessionManager *httpPostManager;
@end

@implementation BaseNetRequest

#pragma mark - init methods
///自定义初始化方法
- (instancetype)initWithApiUrl:(NSString *)api_url {
    self = [super init];
    if (self) {
        // 保存请求地址
        self.api_url = api_url;
        // 初始化参数
        self.httpMethod = @"POST";
    }
    return self;
}
///初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        // 1.初始化基本数据类型的值为-100
        // 01 获取当前类
        Class myClass = [self class];
        // 02 获取当前类中属性名字的集合
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(myClass, &count);
        // 03 遍历所有的属性
        for (NSInteger i = 0; i < count; i++) {
            // 获取当前属性的名字
            objc_property_t property = properties[i];
            const char *char_property_name = property_getName(property);
            // 如果获取到这个属性的名字
            if (char_property_name) {
                // 转换成字符串
                NSString *property_name = [[NSString alloc] initWithCString:char_property_name encoding:NSUTF8StringEncoding];
                // 获取当前属性对应的内容
                id value = [self valueForKey:property_name];
                // 判断当前对象是数值对象
                if ([value isKindOfClass:[NSValue class]]) {
                    // 设置默认值-100
                    [self setValue:@(-100) forKey:property_name];
                }
            }
        }
    }
    return self;
}

#pragma mark - methods
///获取当前对象已经设置内容的数据名字和对应的内容
- (NSDictionary *)getMyClassAttributeNameAndValue {
    // 1.创建一个可变字典获取当前类的属性和内容
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    // 2.获取当前类中所有的属性名字和内容
    // 01 获取当前类
    Class myClass = [self class];
    // 02 获取当前类中属性名字的集合
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(myClass, &count);
    // 03 遍历所有的属性
    for (NSInteger i = 0; i < count; i++) {
        // 获取当前属性的名字
        objc_property_t property = properties[i];
        const char *char_property_name = property_getName(property);
        // 如果获取到这个属性的名字
        if (char_property_name) {
            // 转换成字符串
            NSString *property_name = [[NSString alloc] initWithCString:char_property_name encoding:NSUTF8StringEncoding];
            // 获取当前属性对应的内容
            id value = [self valueForKey:property_name];
            if (([value isKindOfClass:[NSData class]]) || (value != nil && [value intValue] != -100)) {
                [attributes setValue:value forKey:property_name];
            }
        }
    }
    free(properties);
    return attributes;
}

#pragma - mark 网络请求
- (void)NetRequestWithReturnValeuBlock:(ReturnValueBlock)block
                    WithErrorCodeBlock:(ErrorCodeBlock)errorBlock
                      WithFailureBlock:(FailureBlock)failureBlock {
    // 1.拼接完整的URL
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",API_URL,self.api_url];
    // 2.获取参数
    NSMutableDictionary *finalParam = [NSMutableDictionary dictionaryWithDictionary:[self getMyClassAttributeNameAndValue]];
    NSMutableArray *paramArr = [NSMutableArray new];
    for (int i = 0; i < finalParam.allKeys.count; i++) {
        NSString *valueStr = finalParam[finalParam.allKeys[i]];
        [paramArr addObject:[NSString stringWithFormat:@"%@=%@",finalParam.allKeys[i],valueStr]];
    }
    //打印请求，方便调试 看具体接口的情况写
    if (paramArr.count == 0) {
        NSLog(@"url:%@",urlString);
    }else {
        NSLog(@"url:%@?%@",urlString,[paramArr componentsJoinedByString:@"&"]);
    }
    
    NSDictionary *param = finalParam;
    
    // 3.根据get或者post调用对应方法
    if ([self.httpMethod caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
        [self netRequestGETWithRequestURL:urlString WithParameter:param WithReturnValeuBlock:^(id returnValue) {
            block(returnValue);
        } WithErrorCodeBlock:^(id errorCode) {
            errorBlock(errorCode);
        } WithFailureBlock:^{
            failureBlock();
        }];
    } else if ([self.httpMethod caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
        [self netRequestPOSTWithRequestURL:urlString WithParameter:param WithReturnValeuBlock:^(id returnValue) {
            block(returnValue);
        } WithErrorCodeBlock:^(id errorCode) {
            errorBlock(errorCode);
        } WithFailureBlock:^{
            failureBlock();
        }];
    }
}

///GET请求
- (void)netRequestGETWithRequestURL:(NSString *)requestURLString
                      WithParameter:(NSDictionary *)parameter
               WithReturnValeuBlock:(ReturnValueBlock)block
                 WithErrorCodeBlock:(ErrorCodeBlock)errorBlock
                   WithFailureBlock:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    _httpGetManager = manager;
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;///去掉返回的控制 ep:返回数据中 xx:null这种数据会被去掉
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];//看具体情况而定
    [manager GET:requestURLString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errcode"] integerValue];//根据接口来定
        if (code == 0) {//根据具体的错误码而定 这里0为正确返回值
            block(responseObject);
        }else {
            errorBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock();
    }];
    
}

///POST请求
- (void)netRequestPOSTWithRequestURL:(NSString *)requestURLString
                       WithParameter:(NSDictionary *)parameter
                WithReturnValeuBlock:(ReturnValueBlock)block
                  WithErrorCodeBlock:(ErrorCodeBlock)errorBlock
                    WithFailureBlock:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    _httpPostManager = manager;
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;///去掉返回的控制 ep:返回数据中 xx:null这种数据会被去掉
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];//看具体情况而定
    [manager POST:requestURLString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errcode"] integerValue];
        if (code == 0) {//根据具体的错误码而定 这里0为正确返回值
            block(responseObject);
        }else {
            errorBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock();
    }];
}

@end

