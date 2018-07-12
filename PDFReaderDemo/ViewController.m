//
//  ViewController.m
//  PDFReaderDemo
//
//  Created by litianqi on 2018/7/10.
//  Copyright © 2018年 tqUDown. All rights reserved.
//

#import "ViewController.h"
#import "PDFWebViewController.h"
#import "PDFPageViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)clickWebViewNetWork:(id)sender {
    NSString * fileUrl = @"http://edu100hqvideo.bs2dl.yy.com/纯文字pdf讲义_b37db6c88b1f0c65bf067a5fbde47bd2388a57a1.pdf";
    PDFWebViewController * webVC = [[PDFWebViewController alloc] init];
    webVC.view.frame = self.view.bounds;
    webVC.filePath = fileUrl;
    [self.navigationController pushViewController:webVC animated:YES];
    
}
- (IBAction)clickWebViewLocal:(id)sender {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"摄影初级教程" ofType:@"pdf"];
    PDFWebViewController * webVC = [[PDFWebViewController alloc] init];
    webVC.view.frame = self.view.bounds;
    webVC.filePath = filePath;
    [self.navigationController pushViewController:webVC animated:YES];
    
}
- (IBAction)clickPageVC:(id)sender {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"摄影初级教程" ofType:@"pdf"];
    
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:10] forKey:UIPageViewControllerOptionInterPageSpacingKey];
    PDFPageViewController *pageVC = [[PDFPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
    pageVC.filePath = filePath;
    pageVC.view.frame = self.view.bounds;
    
    [self.navigationController pushViewController:pageVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
