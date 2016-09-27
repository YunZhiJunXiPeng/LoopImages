//
//  LoopView.h
//  LoopImages
//
//  Created by 小超人 on 16/9/23.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PP_LoopView : UIView



/**
 创建方法
 @param imageArray 存放照片名称的数组
 @param frame      位置
 @param fromNetWork 是否是网络照片
 */
- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                              fram:(CGRect)frame
                       fromNetWork:(BOOL)fromNetwork;
/**
 更改图片数据的方法
 @param newArray    新的数据数组  存储的是照片的信息
 @param fromNetWork 是否是网络照片
 */
- (void)changeImageArray:(NSArray *)newArray fromNetWork:(BOOL)fromNetWork;


@end
