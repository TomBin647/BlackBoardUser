//
//  ViewController.m
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/1.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import "ViewController.h"
#import "KDBlackBoardViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * button = [UIButton new];
    button.frame = CGRectMake(0, 0, 150, 50);
    button.center = self.view.center;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:@"板书" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)clickButton:(UIButton *)sender {
    KDBlackBoardViewController * kdbb = [KDBlackBoardViewController new];
    [self.navigationController pushViewController:kdbb animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
