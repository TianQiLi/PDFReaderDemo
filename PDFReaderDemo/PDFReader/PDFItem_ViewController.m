//
//  PDFItem_ViewController.m
//  PDFReaderDemo
//
//  Created by litianqi on 2018/7/10.
//  Copyright © 2018年 tqUDown. All rights reserved.
//

#import "PDFItem_ViewController.h"

@interface PDFView:UIView
@property (nonatomic) CGPDFPageRef pageRef;
/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation PDFView
- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)setPageRef:(CGPDFPageRef)pageRef{
    _pageRef = pageRef;
    [self setNeedsDisplay];
//    [self setScalesPageToFit:YES];
}

-(void)drawInContext:(CGContextRef)context {
    //Quartz坐标系和UIView坐标系不一样所致，调整坐标系，使pdf正立
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //创建一个仿射变换，该变换基于将PDF页的BOX映射到指定的矩形中。
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(_pageRef, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    //将pdf绘制到上下文中
    CGContextDrawPDFPage(context, _pageRef);
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //    [super drawRect:rect];
    if (!_pageRef) {
        return;
    }
    [self drawInContext:UIGraphicsGetCurrentContext()];
    return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect mediaRect = CGPDFPageGetBoxRect(_pageRef, kCGPDFCropBox);//pdf内容的rect
    
    CGContextRetain(context);
    CGContextSaveGState(context);
    
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);//填充背景色，否则为全黑色；
    CGFloat rectScale = rect.size.width / rect.size.height;
    CGFloat mediaScale = mediaRect.size.width/ mediaRect.size.height;
    CGFloat scalePdf = 0.0;
    if (mediaScale >= rectScale ) {
        scalePdf = rect.size.width / mediaRect.size.width;
    }
    else
        scalePdf = rect.size.height / mediaRect.size.height;
    
    NSInteger heightScale = mediaRect.size.height * scalePdf;
    
    CGContextTranslateCTM(context, 0, heightScale);//设置位移，x，y;
    CGContextScaleCTM(context, scalePdf, -scalePdf);//缩放倍数--x轴和y轴
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    CGContextDrawPDFPage(context, _pageRef);//绘制pdf
    
    CGContextRestoreGState(context);
    CGContextRelease(context);
}

@end


@interface PDFItem_ViewController ()<UIScrollViewDelegate>
/** scrvc */
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation PDFItem_ViewController
- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeZero;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 3.0f;
    [self.scrollView setAlwaysBounceHorizontal:NO];
    [self.view addSubview:_scrollView];
    
    _pdfView = [[PDFView alloc] initWithFrame:self.view.bounds];
    _pdfView.backgroundColor = self.view.backgroundColor;
    [self.scrollView addSubview:_pdfView];
    
    UITapGestureRecognizer * oneTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesHandleEvent:)];
    oneTapG.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:oneTapG];
    
    UITapGestureRecognizer * doubleG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesHandleEvent:)];
    doubleG.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleG];
    [oneTapG requireGestureRecognizerToFail:doubleG];

    
}

- (void)tapGesHandleEvent:(UITapGestureRecognizer *)ges{
    if (ges.numberOfTapsRequired ==2) {
        CGFloat currentZoom =  _scrollView.zoomScale;
        if (currentZoom > 1.00) {
            [_scrollView setZoomScale:1.00 animated:YES];
        }
        else
            [_scrollView setZoomScale:1.5 animated:YES];
        
    }
    else{
        BOOL statusHidden = self.navigationController.navigationBarHidden;
        [self.navigationController setNavigationBarHidden:!statusHidden animated:YES];
    }
    
}
#pragma mark --UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.pdfView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPageRef:(CGPDFPageRef)pageRef{
    _pageRef = pageRef;
    self.pdfView.pageRef = _pageRef;
    [_scrollView setZoomScale:1.00 animated:YES];
    
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
