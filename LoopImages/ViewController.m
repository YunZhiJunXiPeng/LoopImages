//
//  ViewController.m
//  LoopImages
//
//  Created by 小超人 on 16/9/23.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "ViewController.h"
#import "PP_LoopView.h"
#import "PP_LoadImageManagar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arrray = @[@"http://img.wallpapersking.com/800/2016-3/2016030907204.jpg",@"http://www.k618.cn/ygmp/dzrmp/dwsj/201202/W020120214618884719288.jpg",@"http://img104.mypsd.com.cn/20130910/1/Mypsd_52800_201309100819240065B.jpg"];
   
    
    PP_LoopView *pp_View  = [[PP_LoopView alloc] initWithImageArray:@[@"LoopImg.bundle/伊布0",@"LoopImg.bundle/伊布1",@"LoopImg.bundle/伊布2",@"LoopImg.bundle/伊布3",@"LoopImg.bundle/伊布4",@"LoopImg.bundle/伊布5"]  fram:CGRectMake(100, 100, 200, 300) fromNetWork:NO];
   
    [self.view addSubview:pp_View];
    
    [self.view addSubview:[[PP_LoopView alloc] initWithImageArray:arrray  fram:CGRectMake(100, 400, 200, 300) fromNetWork:YES]];
    
    
   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
