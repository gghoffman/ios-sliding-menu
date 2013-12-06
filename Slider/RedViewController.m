//
//  RedViewController.m
//  Slider
//
//  Created by Gunnar Hoffman on 12/5/13.
//  Copyright (c) 2013 Ball State University. All rights reserved.
//

#import "RedViewController.h"

#import "SlidingMenuViewController.h"

@interface RedViewController ()

@end

@implementation RedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)calloutMenuButtonWasPressed:(id)sender
{
    SlidingMenuViewController *slidingController
        = (SlidingMenuViewController *)self.tabBarController;
    [slidingController openMenu];
}

@end
