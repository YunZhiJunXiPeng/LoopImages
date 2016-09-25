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
 */
- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                              fram:(CGRect)frame;

@end
