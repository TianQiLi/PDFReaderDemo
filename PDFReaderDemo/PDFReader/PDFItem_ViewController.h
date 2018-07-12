//
//  PDFItem_ViewController.h
//  PDFReaderDemo
//
//  Created by litianqi on 2018/7/10.
//  Copyright © 2018年 tqUDown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFView;
@interface PDFItem_ViewController : UIViewController
@property (nonatomic) CGPDFPageRef pageRef;
/** pageIndex */
@property (nonatomic, assign) NSInteger pageIndex;

/** viewpdf */
@property (nonatomic, strong) PDFView * pdfView;
@end
