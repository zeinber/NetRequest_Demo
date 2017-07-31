NetRequest_Demo
基于runtime的网络请求封装

---
## usage

```objc
/**
* step1:项目中导入YZL_MessageVerified_Tool工具包
* step2:添加依赖文件
*  libz.dylib
*  libicucore.dylib
*  MessageUI.framework
*  JavaScriptCore.framework
*  libstdc++.dylib
* step3:去mob申请appKey和appSecret
*  appKey 和 appSecret的获取：
* （1）到Mob官网注册成为Mob开发者；
* （2）到应用管理后台新建应用。
步骤网址：http://bbs.mob.com/forum.php?mod=viewthread&tid=8212&extra=page%3D1
* step4:在appdelegate文件头部#import "YZLMessageVerifiedTool.h",在
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions添加
[YZLMessageVerifiedTool registerApp:appKey withSecret:appSecret];
* step5:在需要获取短信验证码或语音验证码的位置调用 （传入method值为YZLGetCodeMethodSMS为短信验证码，YZLGetCodeMethodVoice为语音验证码）
+ (void)getVerificationCodeByMethod:(YZLGetCodeMethod)method
phoneNumber:(NSString *)phoneNumber
zone:(NSString *)zone
customIdentifier:(NSString *)customIdentifier
result:(YZLGetCodeResultHandler)result函数
* step6:在需要验证的地方调用
+ (void)commitVerificationCode:(NSString *)code
phoneNumber:(NSString *)phoneNumber
zone:(NSString *)zone
result:(YZLCommitCodeResultHandler)result函数
*
*/

```
