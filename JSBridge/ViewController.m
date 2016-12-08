//
//  ViewController.m
//  JSBridge
//
//  Created by 张芳涛 on 2016/12/8.
//  Copyright © 2016年 张芳涛. All rights reserved.
//

#import "ViewController.h"
#import <WebViewJavascriptBridge.h>
@interface ViewController ()<UIWebViewDelegate>
@property WebViewJavascriptBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    //开启日志
    [WebViewJavascriptBridge enableLogging];
    //给乃一个webView建立JS与OC的沟通的桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.bridge setWebViewDelegate:self];
    [self addBtn:webView];
    // JS主动调用OjbC的方法
    // 这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
    // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
    // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
[self.bridge registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
    NSLog(@"JS 调用了getuserInfo这个方法，从js回来的数据是：%@",data);
    if (responseCallback) {
        //反馈给JS
        responseCallback(@{@"userId":@"123456",@"username":@"张芳涛",@"age":@"18"});
        
    }
}];
[self.bridge registerHandler:@"getBlockName" handler:^(id data, WVJBResponseCallback responseCallback) {

    if (responseCallback) {
    //反馈给JS
        NSMutableDictionary *dict = data;
        NSMutableDictionary *option = [NSMutableDictionary dictionary];
        [option setValue:dict[@"商品名称"] forKey:@"商品名称"];
        [option setValue:dict[@"商品价格"] forKey:@"商品价格"];
        [option setValue:@"张芳涛" forKey:@"付款人"];
        [option setValue:@"优点互动" forKey:@"收款人"];
        responseCallback(option);
    }
}];
    [self.bridge callHandler:@"getuserInfomications" data:@{@"名字":@"彪哥",@"年龄":@"12"} responseCallback:^(id responseData) {
        NSLog(@"from js :%@",responseData);
    }];



}

-(void)addBtn:(UIWebView *)webView
{
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 400, 150, 30)];
    [btn1 setTitle:@"打开一个博客" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(150, 400, 100, 30)];
    [btn2 setTitle:@"刷新按钮" forState:UIControlStateNormal];
    [btn2  setBackgroundColor:[UIColor blueColor]];
    [btn2 addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(250, 400, 100, 30)];
    btn3.backgroundColor = [UIColor orangeColor];
    [btn3 setTitle:@"获取用户信息" forState:UIControlStateNormal];
    [btn3  addTarget:self action:@selector(btn3Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
}
-(void)btn1Click:(id)sender
{
    [self.bridge callHandler:@"openWebviewBridgeArticle" data:@"用OC打开一个网页"];
}
-(void) btn3Click:(id)sender
{
    [self.bridge callHandler:@"getUserInfos" data:@{@"我是谁":@"我是张芳涛"} responseCallback:^(id responseData) {
        NSLog(@"用户信息时：%@",responseData);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
