//
//  ViewController.m
//  LoopImages
//
//  Created by 小超人 on 16/9/23.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "ViewController.h"
#import "PP_LoopView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[[PP_LoopView alloc] initWithImageArray:@[@"伊布0",@"伊布1",@"伊布2",@"伊布3",@"伊布4",@"伊布5"] fram:self.view.bounds]];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
