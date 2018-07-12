//
//  PDFReader.h
//  Pods
//
//  Created by litianqi on 2018/6/25.
//

#ifndef PDFReader_h
#define PDFReader_h


//设备 Screen
#define PDFReader_Screen_Bounds [UIScreen mainScreen].bounds
#define PDFReader_Screen_Height PDFReader_Screen_Bounds.size.height
#define PDFReader_Screen_Width PDFReader_Screen_Bounds.size.width

//防止屏幕旋转
#define PDFReader_Screen_width_Seat  MIN(PDFReader_Screen_Width, PDFReader_Screen_Height)
#define PDFReader_Screen_height_Seat  MAX(PDFReader_Screen_Width, PDFReader_Screen_Height)
#define  PDFReader_Screen_widthScale  PDFReader_Screen_width_Seat/375.0

#endif /* PDFReader_h */
