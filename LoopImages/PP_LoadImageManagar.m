//
//  PP_LoadImage.m
//  LoopImages
//
//  Created by 小超人 on 16/9/25.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PP_LoadImageManagar.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation PP_LoadImageManagar

// 请求的网络照片  并存进本地缓存
+ (instancetype)imageDownloaderWithImageUrlString:(NSString *)imageUrlStr delegate:(id<PP_LoadImageManagarDelegate>)dele successfulBlock:(PP_RturnBlock)returnImage
{
    [[PP_LoadImageManagar shareImageDownManagar] getImageUrlString:imageUrlStr delegate:dele successfulBlock:returnImage];
    return [PP_LoadImageManagar shareImageDownManagar];
}
// 请求的网络照片  并存进本地缓存
- (instancetype)initWithImageUrlString:(NSString *)imageUrlStr delegate:(id<PP_LoadImageManagarDelegate>)dele successfulBlock:(PP_RturnBlock)returnImage
{
    [[PP_LoadImageManagar shareImageDownManagar] getImageUrlString:imageUrlStr delegate:dele successfulBlock:returnImage];
    
    return self;
}


// 创建缓存文件夹
- (NSString *)getLocationImageDataFilePath{
    
    // 获取 Document 路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 拼接一个缓存的文件夹路径
    path = [path stringByAppendingPathComponent:@"PP_LoopViewCache"];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 是否存在文件 没有就创建
    if(![mgr fileExistsAtPath:path]){
        [mgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

// 缓存到本地文件夹
- (void)writToCacheWithData:(NSData *)data subPath:(NSString *)subPath
{
    // 直接写入本地
    subPath = [self getMD5String:subPath];
    [data writeToFile:[[self getLocationImageDataFilePath] stringByAppendingPathComponent:subPath] atomically:YES];
}
// 清除缓存的照片
- (void)clearLoopImageViewCaches
{
    NSFileManager *managar = [NSFileManager defaultManager];
    [managar removeItemAtPath:[self getLocationImageDataFilePath] error:nil];
}

// 获取图片从本地
- (UIImage *)getImageFromSubPath:(NSString *)subPath
{
    subPath = [self getMD5String:subPath];
    NSData *data = [NSData dataWithContentsOfFile:[[self getLocationImageDataFilePath] stringByAppendingPathComponent:subPath]];
    return [UIImage imageWithData:data];
}

// 把字符串转化成 MD5字符串 去掉特殊的标记
- (NSString *)getMD5String:(NSString *)string
{
// 转成 C 语言的字符串
    const char *mdData = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(mdData, (CC_LONG)strlen(mdData), result);
    
// 化成 OC 不可变 字符串
    NSMutableString *mdString  = [NSMutableString new];
    for (int i =0 ; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [mdString appendFormat:@"%02X",result[i]];
    }
    return mdString;
}

// 单例创建方法
+ (instancetype)shareImageDownManagar
{
    static PP_LoadImageManagar *managar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managar = [PP_LoadImageManagar new];
    });
    return managar;
}
// 获取照片  缓存有的话就从  缓存中去取到  否则网络请求
- (void)getImageUrlString:(NSString *)imageUrlStr delegate:(id<PP_LoadImageManagarDelegate>)dele successfulBlock:(PP_RturnBlock)returnImage
{
      UIImage *image = [self getImageFromSubPath:imageUrlStr];
        if (image)
        {
            // 6.代理执行协议中的方法，将图片作为参数传过去
            dispatch_async(dispatch_get_main_queue(), ^{
                
                dele != nil ? [dele imageDownloader:self didFinishedLoading:image] : nil;
            // 6.用Block回调传递数据
                returnImage != nil ? returnImage(image) : nil ;
            });
        }else
        {
            __weak  typeof(PP_LoadImageManagar) * downloader = self;
            //1.准备url对象
            NSURL * url = [NSURL URLWithString:imageUrlStr];
            //2.创建request请求对象
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            //3.创建会话
            NSURLSession *session = [NSURLSession sharedSession];
            //4.创建请求任务
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                // 获取数据写入本地
                UIImage *image = nil;
                if (!data)
                {
                    image = [UIImage imageNamed:@"LoopImg.bundle/占位"];
                    
                }else
                {
                //5.将图片传值
                image = [UIImage imageWithData:data];
                [self writToCacheWithData:UIImageJPEGRepresentation(image, 1) subPath:imageUrlStr];
                }
                //6.代理执行协议中的方法，将图片作为参数传过去
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    dele != nil ? [dele imageDownloader:downloader didFinishedLoading:image] : nil;
                    // 6.用Block回调传递数据
                    returnImage != nil ? returnImage(image) : nil ;
                });
            }];
            //执行任务
            [task resume];
        }
}

















@end
