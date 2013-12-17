//
//  RedViewController.m
//  Slider
//
//  Created by Gunnar Hoffman on 12/5/13.
//  Copyright (c) 2013 Ball State University. All rights reserved.
//

#import "RedViewController.h"

#import "GSMViewController.h"

@interface RedViewController ()

@end

@implementation RedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GSMViewController *slidingMenu = (GSMViewController *) self.tabBarController;
    [[NSNotificationCenter defaultCenter] addObserverForName:nil
                                                      object:slidingMenu
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
        
                                                      NSLog(@"note: %@", note.name);
    }];
    
    
}

- (IBAction)calloutMenuButtonWasPressed:(id)sender
{
    GSMViewController *slidingController = (GSMViewController *)self.tabBarController;
    [slidingController openMenu];
}

@end
