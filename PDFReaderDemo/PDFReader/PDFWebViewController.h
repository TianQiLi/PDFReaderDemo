//
//  PDFWebViewController.h
//  PDFReaderDemo
//
//  Created by litianqi on 2018/7/10.
//  Copyright © 2018年 tqUDown. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareBlock)(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError);

typedef void(^OpenErrorBlock)(NSError * __nullable error);

@interface PDFWebViewController : UIViewController
/** filePath */
@property (nonatomic, copy) NSString *filePath;
/** openErrorBlock */
@property (nonatomic, copy) OpenErrorBlock openErrorBlock;

/** shareBlock */
@property (nonatomic, copy) ShareBlock shareBlock;
/** 分享 */
@property (nonatomic, assign) BOOL enableShare;//默认是NO
/*采用title of vc*/
@property (nonatomic, assign) BOOL enableShareFileRename;//默认是NO

@end
