//
//  ViewController.m
//  JHProgressViewDemo
//
//  Created by xingjiehai on 16/8/18.
//  Copyright © 2016年 xingjiehai. All rights reserved.
//

#import "ViewController.h"
#import "JHProgressView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet JHProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressView setProgress:1.0 animated:YES duration:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
