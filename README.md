NetRequest_Demo
基于runtime的网络请求封装

---
## Introduce

简书地址:[iOS基于runtime的网络请求封装](http://www.jianshu.com/p/cd8d29453b9a)。
```objc
实现原理
runtime有一个方法，就是可以去遍历一个类对象的所有属性。

MyClass *myClass = [[MyClass alloc] init];//创建了类对象
    unsigned int outCount = 0;//记录类对象属性的个数
    Class cls = [myClass class];//获取类名
    objc_property_t* properties = class_copyPropertyList(cls, &outCount);//获取类的所有对象数组properties  outCount表示数组的元素个数
    for(int i = 0; i < outCount; i++) {//遍历properties数组
        objc_property_t property = properties[i];//类对象的每个属性
        const char* char_property_name =  property_getName(property);//转化成char类型
        if (char_property_name) {//判断是否获取成功
            NSString *property_name = [[NSString alloc] initWithCString:char_property_name encoding:NSUTF8StringEncoding];// 转换OC类型的字符串
        }
    }
    free(properties);//释放指针

由此可以得到一个启发：网络请求是可以通过类文件来管理的。

思路

所有网络请求的类文件都继承一个基类BaseNetRequest，然后在子类的.h中写上网络请求中需要的请求参数名，在BaseNetRequest.m文件中，通过上述runtime的方法获取网络请求参数，并在子类的init方法里做统一处理。

优点

1.网络请求可以通过文件的形式统一管理，方便开发者根据文件结构去寻找对应的请求。
2.需要做统一操作时，可以在BaseNetRequest文件中进行处理。
```
