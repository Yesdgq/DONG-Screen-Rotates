//
//  ViewController.m
//  DONGScreenRotates
//
//  Created by yesdgq on 2017/7/5.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "ViewControllerA.h"
#import "ViewControllerB.h"
#import "AppDelegate.h"
#import "FullScreenVC.h"


@interface ViewControllerA ()

@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIDevice currentDevice];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

- (IBAction)clickBtnA:(id)sender {
    ViewControllerB *vcB = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewControllerB"];
//    [self presentViewController:vcB animated:YES completion:nil];
    [self.navigationController pushViewController:vcB animated:YES];
}

- (IBAction)pushFullScreen:(id)sender {
    FullScreenVC *vcB = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FullScreenVC"];
//    [self.navigationController pushViewController:vcB animated:YES];
    [self presentViewController:vcB animated:YES completion:nil];
}



@end
