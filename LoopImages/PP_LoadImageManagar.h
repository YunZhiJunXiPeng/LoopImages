//
//  PP_LoadImage.h
//  LoopImages
//
//  Created by 小超人 on 16/9/25.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PP_LoadImageManagar;
@protocol PP_LoadImageManagarDelegate <NSObject>

//当获取到UIImage数据的时候，代理对象执行这个方法
- (void)imageDownloader:(PP_LoadImageManagar *)downloader didFinishedLoading:(UIImage *)image;

@end

typedef void(^PP_RturnBlock)(UIImage *returnImage);

@interface PP_LoadImageManagar : NSObject


//请求图片的类，获取到图片代理执行协议方法 或者 Block 传回请求下来的图片
#pragma mark-- 实例初始化方法
- (instancetype)initWithImageUrlString:(NSString *)imageUrlStr
                              delegate:(id<PP_LoadImageManagarDelegate>)dele
                       successfulBlock:(PP_RturnBlock)returnImage;
#pragma mark-- 遍历构造器方法
+ (instancetype)imageDownloaderWithImageUrlString:(NSString *)imageUrlStr
                                         delegate:(id<PP_LoadImageManagarDelegate>)dele
                                  successfulBlock:(PP_RturnBlock)returnImage;

// 单例创建
+ (instancetype)shareImageDownManagar;
/**
 获取照片
 @param imageUrlStr 照片的网址
 @param dele        执行的代理 （可以为空，执行 Block 即可）
 @param returnImage  Block 回调传回需要的照片
 */
- (void)getImageUrlString:(NSString *)imageUrlStr delegate:(id<PP_LoadImageManagarDelegate>)dele successfulBlock:(PP_RturnBlock)returnImage;
// 清除缓存
- (void)clearLoopImageViewCaches;

@end
