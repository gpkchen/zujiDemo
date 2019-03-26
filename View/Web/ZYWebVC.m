//
//  ZYWebVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/13.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYWebVC.h"
#import "ZYQuotaService.h"
#import "ZYJsMessageHandler.h"

#define POST_JS @"function my_post(path, params) {\
var method = \"POST\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
form.setAttribute(\"accept-charset\", \"UTF-8\");\
for(var key in params){\
if (params.hasOwnProperty(key)) {\
var hiddenFild = document.createElement(\"input\");\
hiddenFild.setAttribute(\"type\", \"hidden\");\
hiddenFild.setAttribute(\"name\", key);\
hiddenFild.setAttribute(\"value\", JSON.stringify(params[key]));\
}\
form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"

@interface ZYWebVC ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic , strong) WKWebView *wkWebView;
@property (nonatomic , strong) ZYJsMessageHandler *messageHandler;

@property (nonatomic , assign) BOOL isLoadSuccess; //当前页面是否加载成功

@property (nonatomic , assign) BOOL isSetWebInset; //是否设置过视图偏移量
@property (nonatomic , assign) BOOL isSetProgressViewY; //是否设置过指示器Y坐标
@property (nonatomic , assign) BOOL isSetRefreshEnable; //是否设置过下拉刷新
@property (nonatomic , assign) BOOL isSetAlwaysBounceVertical; //是否设置过Y方向弹簧效果
@property (nonatomic , assign) BOOL isSetAlwaysBounceHorizontal; //是否设置过X方向弹簧效果

@end

@implementation ZYWebVC

- (void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    self.wkWebView.UIDelegate = nil;
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.scrollView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [UIView new];
    self.view.backgroundColor = VIEW_COLOR;
    
    [self initWeb];
}

- (void)systemBackButtonClicked{
    if(self.wkWebView.canGoBack){
        if(self.voidBack){
            [super systemBackButtonClicked];
        }else{
            [self.wkWebView goBack];
        }
    }else{
        [super systemBackButtonClicked];
    }
}

- (void)leftBarItemsAction:(int)index{
    if(0 == index){
        if(self.wkWebView.canGoBack){
            if(self.voidBack){
                [super systemBackButtonClicked];
            }else{
                [self.wkWebView goBack];
            }
        }else{
            [super systemBackButtonClicked];
        }
    }else if(1 == index){
        [super systemBackButtonClicked];
    }
}

#pragma mark - 设置网页视图
- (void)initWeb{
    // 配置网页的配置文件
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    if (@available(iOS 9.0, *)) {
        // 允许视频播放
        configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许图片播放
        configuration.allowsPictureInPictureMediaPlayback = YES;
    }
    // 允许与网页交互，选择视图
    configuration.selectionGranularity = YES;
    // 允许在线播放
    configuration.allowsInlineMediaPlayback = YES;
    // 是否支持记忆读取
    configuration.suppressesIncrementalRendering = YES;
    
    for(NSString *name in ZYJsMessageHandler.messageNames){
        [configuration.userContentController addScriptMessageHandler:self.messageHandler name:name];
    }
    
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    //修改useragent
    __weak __typeof(self) weakSelf = self;
    [_wkWebView evaluateJavaScript:@"navigator.userAgent"completionHandler:^(id result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *userAgent = result;
        if([userAgent rangeOfString:UserAgent].location == NSNotFound){
            NSString *newUserAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@" %@",UserAgent]];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent,@"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            //                [[NSUserDefaults standardUserDefaults] synchronize];
            strongSelf.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        }
        strongSelf.wkWebView.backgroundColor = VIEW_COLOR;
        strongSelf.wkWebView.scrollView.backgroundColor = VIEW_COLOR;
        //        _wkWebView.allowsBackForwardNavigationGestures = YES;
        if (@available(iOS 11.0, *)) {
            strongSelf.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        strongSelf.wkWebView.UIDelegate = strongSelf;
        strongSelf.wkWebView.navigationDelegate = strongSelf;
        [strongSelf.wkWebView addObserver:strongSelf forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [strongSelf.wkWebView addObserver:strongSelf forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        if(strongSelf.isSetRefreshEnable){
            if(strongSelf.refreshEnable){
                [strongSelf.webView.scrollView addRefreshHeaderWithBlock:^{
                    if(weakSelf.isLoadSuccess){
                        [weakSelf.webView reload];
                    }else{
                        if(weakSelf.webView.canGoBack){
                            [weakSelf.webView goBack];
                        }else{
                            [weakSelf loadPage];
                        }
                    }
                }];
            }
        }
        if(strongSelf.isSetAlwaysBounceVertical){
            strongSelf.webView.scrollView.alwaysBounceVertical = strongSelf.alwaysBounceVertical;
        }else{
            strongSelf.webView.scrollView.alwaysBounceVertical = YES;
        }
        if(strongSelf.isSetAlwaysBounceHorizontal){
            strongSelf.webView.scrollView.alwaysBounceHorizontal = strongSelf.alwaysBounceHorizontal;
        }else{
            strongSelf.webView.scrollView.alwaysBounceHorizontal = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.view addSubview:strongSelf.wkWebView];
            if(strongSelf.isSetWebInset){
                [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).mas_offset(strongSelf.webViewInsets);
                }];
            }else{
                [strongSelf.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(strongSelf.view).mas_offset(NAVIGATION_BAR_HEIGHT);
                    make.left.right.equalTo(strongSelf.view);
                    make.height.mas_equalTo(SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT);
                }];
            }
            
            !strongSelf.webInitComplete ? : strongSelf.webInitComplete();
            
            [strongSelf.view addSubview:strongSelf.progressView];
            if(strongSelf.isSetProgressViewY){
                [strongSelf.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(strongSelf.view);
                    make.top.equalTo(strongSelf.view).mas_offset(strongSelf.progressViewY);
                }];
            }else{
                [strongSelf.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(strongSelf.view);
                    make.top.equalTo(strongSelf.view).mas_offset(NAVIGATION_BAR_HEIGHT);
                }];
            }
            
            if(!strongSelf.url){
                strongSelf.url = strongSelf.dicParam[@"url"];
            }
//            strongSelf.url = @"https://fintechdown.oss-cn-hangzhou.aliyuncs.com/apolloapp/test.html";
            if(strongSelf.url){
                [strongSelf loadPage];
            }
        });
    }];
}

#pragma mark - 加载网页
- (void)loadPage{
    if(!self.wkWebView){
        return;
    }
    if(!_url){
        return;
    }
    if(![_url hasPrefix:@"http://"] && ![_url hasPrefix:@"https://"]){
        _url = [@"http://" stringByAppendingString:_url];
    }

    NSString *json = [ZYH5Utils formatJson];
    _url = [_url stringByReplacingOccurrencesOfString:@"{}" withString:json];
    _url = [_url stringByReplacingOccurrencesOfString:@"%7b%7d" withString:json];
    _url = [_url stringByReplacingOccurrencesOfString:@"%7B%7D" withString:json];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [self.wkWebView loadRequest:request];
}

#pragma mark - post
- (void)post:(NSDictionary *)dict{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // 最终要执行的JS代码
    NSString * js = [NSString stringWithFormat:@"%@my_post(\"%@\", %@)",POST_JS,_url,dataStr];
    // 执行JS代码
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
}

#pragma mark - public
- (BOOL)catchProtocol:(ZYProtocol *)protocol{
    return NO;
}

- (void)reload{
    [self loadPage];
}

#pragma mark - WKUIDelegate
//处理警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//处理确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//处理弹出输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
    _isLoadSuccess = NO;
    ZYLog(@"WKWebView开始加载内容...");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    _isLoadSuccess = NO;
    ZYLog(@"WKWebView内容加载失败！");
    if(_refreshEnable){
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    ZYLog(@"WKWebView内容开始返回...");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    ZYLog(@"WKWebView内容加载完成。");
    _isLoadSuccess = YES;
    if(_refreshEnable){
        [self.webView.scrollView.mj_header endRefreshing];
    }
    
    //如果导航器中webview是第一个，那么要显示出返回按钮
    if(self.wkWebView.canGoBack){
        if(self.navigationController.viewControllers.count == 1){
            self.leftBarItems = @[[UIImage imageNamed:@"zy_navigation_back_btn"]];
        }else{
            self.leftBarItems = @[[UIImage imageNamed:@"zy_navigation_back_btn"],[UIImage imageNamed:@"zy_item_detail_menu_close_btn"]];
        }
    }else{
        if(self.navigationController.viewControllers.count == 1){
            self.leftBarItems = nil;
        }else{
            self.leftBarItems = @[[UIImage imageNamed:@"zy_navigation_back_btn"]];
        }
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    _isLoadSuccess = NO;
    ZYLog(@"WKWebView内容加载失败！");
    if(_refreshEnable){
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    ZYLog(@"WKWebView接收到服务器跳转请求。");
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSString *URL = [navigationResponse.response.URL absoluteString];
    URL = [URL stringByRemovingPercentEncoding];
    ZYLog(@"WKWebView收到响应：%@",URL);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *URL = [navigationAction.request.URL absoluteString];
    URL = [URL stringByRemovingPercentEncoding];
    ZYLog(@"WKWebView即将发送请求：%@",URL);
    //链接为内部协议
    if ([ZYRouter checkUrl:URL]) {
        ZYProtocol *protocol = [[ZYProtocol alloc]initWithOutUrl:URL];
        if([@"back" isEqualToString:protocol.target]){
            [super systemBackButtonClicked];
        } else if ([@"operator" isEqualToString:protocol.target]) {
            [ZYQuotaService startAuthing:nil success:^{
                [ZYToast showWithTitle:@"运营商数据提交成功！"];
                [super systemBackButtonClicked];
            }];
        } else if ([@"taobao" isEqualToString:protocol.target]) {
            if(_shouldAuthAlfterTaobao){
                [ZYQuotaService startAuthing:nil success:^{
                    [ZYToast showWithTitle:@"淘宝数据提交成功！"];
                    [super systemBackButtonClicked];
                }];
            }else{
                [ZYToast showWithTitle:@"淘宝认证提交成功！"];
                [super systemBackButtonClicked];
            }
        } else if(![self catchProtocol:protocol]){
            [[ZYRouter router] goProtocol:protocol withCallBack:^(){
            }];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView ){
        if([keyPath isEqualToString:@"estimatedProgress"]){
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1){
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            }else{
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
            }
        }else if ([keyPath isEqualToString:@"title"]){
            NSString *title = self.wkWebView.title;
            if(title && ![title isEqualToString:@""]){
                self.navigationItem.title = title;
            }
        }
    }
}

#pragma mark - getter
- (WKWebView *)webView{
    return _wkWebView;
}

- (UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [UIProgressView new];
        _progressView.tintColor = MAIN_COLOR_GREEN;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (ZYJsMessageHandler *)messageHandler{
    if(!_messageHandler){
        _messageHandler = [ZYJsMessageHandler new];
    }
    return _messageHandler;
}

#pragma mark - setter
- (void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical{
    _alwaysBounceVertical = alwaysBounceVertical;
    self.webView.scrollView.alwaysBounceVertical = alwaysBounceVertical;
}

- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal{
    _alwaysBounceHorizontal = alwaysBounceHorizontal;
    self.webView.scrollView.alwaysBounceHorizontal = alwaysBounceHorizontal;
}

- (void)setRefreshEnable:(BOOL)refreshEnable{
    _refreshEnable = refreshEnable;
    if(refreshEnable){
        __weak __typeof__(self) weakSelf = self;
        [self.webView.scrollView addRefreshHeaderWithBlock:^{
            if(weakSelf.isLoadSuccess){
                [weakSelf.webView reload];
            }else{
                if(weakSelf.webView.canGoBack){
                    [weakSelf.webView goBack];
                }else{
                    [weakSelf loadPage];
                }
            }
        }];
    }
}

- (void)setWebViewInsets:(UIEdgeInsets)webViewInsets{
    _webViewInsets = webViewInsets;
    _isSetWebInset = YES;
    if(self.wkWebView.superview){
        [self.wkWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(webViewInsets);
        }];
    }
}

- (void)setWebViewFrame:(CGRect)webViewFrame{
    _webViewFrame = webViewFrame;
    self.wkWebView.frame = webViewFrame;
}

- (void)setProgressViewY:(CGFloat)progressViewY{
    _progressViewY = progressViewY;
    _isSetProgressViewY = YES;
    if(self.progressView.superview){
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).mas_offset(progressViewY);
        }];
    }
}

- (void)setUrl:(NSString *)url{
    _url = url;
    if(self.isViewLoaded){
        [self loadPage];
    }
}

@end
