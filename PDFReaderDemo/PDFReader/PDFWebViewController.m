//
//  PDFWebViewController.m
//  PDFReaderDemo
//
//  Created by litianqi on 2018/7/10.
//  Copyright © 2018年 tqUDown. All rights reserved.
//

#import "PDFWebViewController.h"
#import "PDFShareTools.h"
#import "PDFReaderFileManager.h"
#import "PDFOtherViewTools.h"
#define kPDFScanViewController_Device_is_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )

@interface PDFWebViewController ()<UIWebViewDelegate>
/** webView */
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *cacheFilePath;

@end

@implementation PDFWebViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (void)setFilePath:(NSString *)filePath{
    if ([filePath hasPrefix:@"http"]) {
           _filePath = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else
        _filePath = filePath;
 
    [self loadFile];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSNumber * offsetY = [PDFReaderFileManager getFileScanPercentWithUrl:_filePath];
    _webView.scrollView.contentOffset = CGPointMake(0, offsetY.floatValue);
    
    [PDFOtherViewTools loadHistoryView:self.webView withCurrentPage:[PDFReaderFileManager getFileScanHistoryPageWithUrl:_filePath]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [PDFReaderFileManager setFileScanPercent:@(_webView.scrollView.contentOffset.y) withUrl:_filePath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    [self loadFile];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(enableRightShare)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateScreen:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}

- (void)enableRightShare{
    [[PDFShareTools class] shareViewController:self filePath:self.filePath shareBlock:nil];
    return;
}

- (void)rotateScreen:(NSNotification *)noti{
    self.webView.frame = self.view.bounds;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        NSLog(@"竖屏");
    } else {
        //横屏
        NSLog(@"横屏");
    }
}

- (void)loadFile{
    if ([self.filePath hasPrefix:@"http"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.filePath]]];
    }else if(self.filePath.length > 0){
        NSString * nameFile = self.filePath.lastPathComponent;
        if (self.title.length == 0) {
            self.title = nameFile;
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.filePath]]];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    
}

#pragma mark -- 分享
- (NSString *)getFileCopyPath:(NSString *)filePath{
    if (!self.enableShareFileRename) {
        return filePath;
    }
    NSFileManager * fileManager = [NSFileManager defaultManager];
    // 获取Caches目录路径
    NSString *cachesDir = NSTemporaryDirectory();
    
    NSString * cachaPathFile = [cachesDir stringByAppendingPathComponent:@"Ebook"];
    BOOL isDir = FALSE;
    if (![fileManager fileExistsAtPath:cachaPathFile isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:cachaPathFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * suffix = filePath.pathExtension;
    cachaPathFile = [cachaPathFile stringByAppendingFormat:@"/%@.%@",self.title,suffix];
    NSError * error = nil;
    if (![fileManager fileExistsAtPath:filePath]) {
        return filePath;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachaPathFile]) {
        if([[NSFileManager defaultManager] copyItemAtPath:filePath toPath:cachaPathFile error:&error]){
            self.cacheFilePath = cachaPathFile;
        }else{
            NSLog(@"%s%@",__func__,error);
            cachaPathFile = filePath;
        }
        
    }else
        self.cacheFilePath = cachaPathFile;
    
    return cachaPathFile;
}

- (void)removeTmpFile{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.cacheFilePath) {
            NSFileManager * fileM = [NSFileManager defaultManager];
            if ([fileM fileExistsAtPath:self.cacheFilePath]) {
                [fileM removeItemAtPath:self.cacheFilePath error:nil];
                self.cacheFilePath = nil;
            }
        }
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
