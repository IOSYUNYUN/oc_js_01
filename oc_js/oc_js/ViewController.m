//
//  ViewController.m
//  oc_js
//
//  Created by 刘云 on 2016/11/26.
//  Copyright © 2016年 YouLing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *useNameText;
@property (weak, nonatomic) IBOutlet UITextField *userPassWord;
@property (weak, nonatomic) IBOutlet UIButton *synchronizationBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"YouLing0809" ofType:@".html"]]]];
    self.webView.delegate = self;
}
#pragma mark 调用js中的方法实现OC同步到js
- (IBAction)synchronizationJS:(id)sender {
    NSString* js = [NSString stringWithFormat:@"oc_synchronization_to_js('%@','%@')",self.useNameText.text,self.userPassWord.text];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}
#pragma mark 调用js的方法实现OC清空js
- (IBAction)clearJs:(id)sender {
    NSString *js = [NSString stringWithFormat:@"clear_js();"];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}
#pragma mark 用于js调用清空OC的接口
-(void) clearOC
{
    self.userPassWord.text = @"";
    self.useNameText.text = @"";
}
#pragma mark 用于设置js同步到OC的接口
-(void) setName:(NSString*) name withPassWord:(NSString*) password
{
    self.useNameText.text = name;
    self.userPassWord.text = password;
}
#pragma mark  webview的代理  这里只需要处理start

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* urlStr = request.URL.absoluteString;
    //对数据的进行处理
    //[urlStr ]
    //[urlStr rangeOfString:@"ios://clearOC"];
    if([urlStr hasPrefix:@"youling0809://clearOC"])
    {
        [self clearOC];
        return NO;
    }
    else if([urlStr hasPrefix:@"youling0809://js_synchronization_to_oc"])
    {
        NSString* urlstrTemp = [[NSMutableString alloc] initWithFormat:urlStr,nil];
       urlstrTemp =  [urlstrTemp stringByReplacingOccurrencesOfString:@"youling0809://js_synchronization_to_oc" withString:@""];
        NSArray* array = [urlstrTemp componentsSeparatedByString:@"__________"];
        [self setName:array[0] withPassWord:array[1]];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
