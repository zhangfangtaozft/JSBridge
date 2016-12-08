# JSBridge
JS-OC交互，相互传递参数,里面差不多都换成中文了，简单易懂。
使用方法：
1：利用pod集成JSBridge框架：
target “JSBridge”do 
pod 'WebViewJavascriptBridge', '~> 5.0'
end


2：在需要使用JS-OC交互的时候引用：#import <WebViewJavascriptBridge.h>  如果不是用的cocaPods就是用#import "WebViewJavascriptBridge.h"

3：剩下的都在demo里面了，自己看吧。
