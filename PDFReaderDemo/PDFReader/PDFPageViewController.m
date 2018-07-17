//
//  PDFPageViewController.m
//  PDFReaderDemo
//
//  Created by litianqi on 2018/7/10.
//  Copyright © 2018年 tqUDown. All rights reserved.
//

#import "PDFPageViewController.h"
#import "PDFItem_ViewController.h"
#import "PDFDocumentTools.h"
#import "PDFShareTools.h"
#import "PDFReaderFileManager.h"
#import "PDFOtherViewTools.h"
@interface PDFPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
/** _pageTotal */
@property (nonatomic, assign) NSInteger pageTotal;
@property (assign, nonatomic) CGPDFDocumentRef  pdfRef;
@property (strong, nonatomic) NSMutableArray  *visibleVCArray;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation PDFPageViewController
- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    
    [PDFReaderFileManager setFileScanPercent:@(0) withUrl:self.filePath currentPage:_currentPage];
    
//    UIDeviceOrientation  currentOrientation = [[UIDevice currentDevice] orientation];
//    if (currentOrientation != UIDeviceOrientationPortrait) {
//        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
//
//        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
//
//    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.currentPage = [PDFReaderFileManager getFileScanHistoryPageWithUrl:self.filePath];
    if (_currentPage > 1) {
        PDFItem_ViewController * vc1 = [self viewControllerAtIndex:_currentPage-1 current:_currentPage];
        
        [self setViewControllers:@[vc1] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        }];
    }
  
    [PDFOtherViewTools loadHistoryView:self.view withCurrentPage:_currentPage];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _visibleVCArray = @[].mutableCopy;
    self.delegate = self;
    self.dataSource = self;
    if (!_filePath) {
        NSLog(@"文件为空");
    }
    NSString * nameFile = self.filePath.lastPathComponent;
    if (self.title.length == 0) {
        self.title = nameFile;
    }

     _pdfRef = [PDFDocumentTools pdfRefByFilePath:self.filePath];
    size_t count = CGPDFDocumentGetNumberOfPages(_pdfRef);
    _pageTotal = count;
    
    PDFItem_ViewController * vc1 = [self viewControllerAtIndex:0 current:-1];
    NSMutableArray *array = @[].mutableCopy;
    if (vc1) {
        [array addObject:vc1];
        [_visibleVCArray addObject:vc1];
    }
  
    [self setViewControllers:array.copy direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
    }];
    
     [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(enableRightShare)]];
}

- (void)enableRightShare{
    [[PDFShareTools class] shareViewController:self filePath:self.filePath shareBlock:nil];
    return;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PDFItem_ViewController *)viewControllerAtIndex:(NSUInteger)index current:(NSUInteger)currentIndex
{
    //Return the PDFViewController for the given index.
    
    if ((index > _pageTotal) ) {
        return nil;
    }
    _currentPage = index;
    PDFItem_ViewController *dataViewController = nil;
    //Create a new view controller and pass suitable data.
    if (self.visibleVCArray.count > 0) {
        for (PDFItem_ViewController *validVC in self.visibleVCArray) {
            if (validVC.pageIndex != currentIndex) {
                dataViewController = validVC;
                NSLog(@"复用了");
            }
        }
    }
    if (!dataViewController) {
        dataViewController = [[PDFItem_ViewController alloc]init];
        dataViewController.view.frame = self.view.bounds;
        [self.visibleVCArray addObject:dataViewController];
    }
    dataViewController.pageIndex = index;
    dataViewController.pageRef = CGPDFDocumentGetPage(_pdfRef, index+1);
    return dataViewController;
}


#pragma mark UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    PDFItem_ViewController * itemVC = (PDFItem_ViewController *)viewController;
    NSInteger index = itemVC.pageIndex;
    index--;
    return [self viewControllerAtIndex:index current:itemVC.pageIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    PDFItem_ViewController * itemVC = (PDFItem_ViewController *)viewController;
    NSInteger index = itemVC.pageIndex;
    index ++;
    return [self viewControllerAtIndex:index current:itemVC.pageIndex];
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
