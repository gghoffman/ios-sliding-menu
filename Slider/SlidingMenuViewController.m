//
//  SlidingMenuViewController.h
//
//  Created by Gunnar Hoffman on 12/5/13.
//  Copyright (c) 2013 Ball State University.
//

#import "SlidingMenuViewController.h"

// Notification key
NSString *const SlidingMenuMoving = @"SlidingMenuMoving";
NSString *const SlidingMenuHidding = @"SlidingMenuHiding";
NSString *const SlidingMenuHidden = @"SlidingMenuHidden";
NSString *const SlidingMenuShowing = @"SlidingMenuShowing";
NSString *const SlidingMenuShown = @"SlidingMenuShown";

@interface SlidingMenuViewController () <UITabBarControllerDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

// Instance State
@property (strong, nonatomic) NSMutableDictionary *controllersSetup;
@property (strong, nonatomic) UIView *blackPanel;

// Settings
@property (nonatomic) NSUInteger leftPadding;
@property (nonatomic) float threshold;
@property (nonatomic) float speed;
@property (nonatomic) NSUInteger autoCloseTolerance;
@property (strong, nonatomic) UIColor *slidingViewBackgroundColor;
@property (strong, nonatomic) UIColor *slidingViewTextColor;

@end

@implementation SlidingMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setControllersSetup:[NSMutableDictionary dictionary]];
    
    [self setAutoCloseTolerance:20];
    [self setLeftPadding:100];
    [self setThreshold:0.75];
    [self setSpeed:0.25];
    [self setSlidingViewBackgroundColor:[UIColor darkGrayColor]];
    [self setSlidingViewTextColor:[UIColor whiteColor]];
    
    [self.tabBar removeFromSuperview];
    [self setDelegate:self];
}

-(void) viewDidAppear:(BOOL)animated
{
    // Triggers setup for the first view
    [self registerSwipeListenerFor:self.selectedViewController];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [self.viewControllers objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell.textLabel setText:viewController.title];
    [cell.textLabel setTextColor:self.slidingViewTextColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != self.selectedIndex){
        [self dissmissMenu:^{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self setSelectedIndex:indexPath.row];
            [self registerSwipeListenerFor:self.selectedViewController];
        }];
    }else{
        [self dissmissMenu:^{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }
}

#pragma mark Sliding Setup

-(UIView *) blackPanel
{
    if(!_blackPanel){
        _blackPanel = [[UIView alloc] initWithFrame:self.selectedViewController.view.frame];
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouldDissmissMenu)];
        [_blackPanel addGestureRecognizer:tapGest];
        [_blackPanel setAlpha:0];
        [_blackPanel setBackgroundColor:[UIColor blackColor]];
        
        _blackPanel.clipsToBounds = NO;
        _blackPanel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _blackPanel.layer.shadowOffset = CGSizeMake(2, 0);
        _blackPanel.layer.shadowOpacity = 0.9;
        
        [self.selectedViewController.view addSubview:_blackPanel];
    }
    
    return _blackPanel;
}

-(void) registerSwipeListenerFor: (UIViewController *) controller
{
    UIPanGestureRecognizer *gest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [gest setDelegate:self];
    [controller.view addGestureRecognizer:gest];
    
    CGRect frame = CGRectMake(controller.view.frame.size.width, 0, controller.view.frame.size.width, controller.view.frame.size.height);
    UIView *slidingView = [[UIView alloc] initWithFrame:frame];
    [slidingView setBackgroundColor:self.slidingViewBackgroundColor];
    [controller.view addSubview:slidingView];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, slidingView.frame.size.width, slidingView.frame.size.height - 60)];
    [table setBackgroundColor:[UIColor clearColor]];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [table setDataSource:self];
    [table setDelegate:self];
    [table setScrollEnabled:NO];
    [slidingView addSubview:table];
    
    [self.controllersSetup setObject:slidingView forKey:controller.title];
}

#pragma mark UITabBarControllerDelegate

/* Used to setup all views after the first one. */
- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    [self registerSwipeListenerFor:viewController];
}

#pragma mark Sliding Animation

CGPoint startingPoint;
CGPoint startingCenter;

-(void) shouldDissmissMenu
{
    [self dissmissMenu:nil];
}

-(void) dissmissMenu: (menu_hidden_callback) callback
{
    [self.slidingMenuDelegate slidingMenuControllerWillHideMenu:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuHidding object:self];
    
    UIView *slidingView = [self.controllersSetup objectForKey:self.selectedViewController.title];
    [UIView animateWithDuration:self.speed animations:^{
        slidingView.center = CGPointMake(self.view.frame.size.width * 1.5, slidingView.center.y);
        self.blackPanel.center = self.view.center;
        self.blackPanel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.blackPanel removeFromSuperview];
        self.blackPanel = nil;
        if(callback){
            callback();
        }
        [self.slidingMenuDelegate slidingMenuControllerDidHideMenu:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuHidden object:self];
    }];
}

-(void) openMenu
{
    [self.slidingMenuDelegate slidingMenuControllerWillShowMenu:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuShowing object:self];
    
    UIView *slidingView = [self.controllersSetup objectForKey:self.selectedViewController.title];
    [UIView animateWithDuration:self.speed animations:^{
        slidingView.center = CGPointMake(self.view.center.x + self.leftPadding, slidingView.center.y);
        self.blackPanel.center = CGPointMake((-self.view.center.x) + self.leftPadding, self.blackPanel.center.y);
        self.blackPanel.alpha = 1.0 - (self.leftPadding / self.blackPanel.frame.size.width);
    } completion:^(BOOL finished) {
        [self.slidingMenuDelegate slidingMenuControllerDidShowMenu:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuShown object:self];
    }];
}

-(void) didPan: (UIGestureRecognizer *) gest
{
    UIView *slidingView = [self.controllersSetup objectForKey:self.selectedViewController.title];
    CGPoint point = [gest locationInView:gest.view];
    
    if(gest.state == UIGestureRecognizerStateBegan){
        
        [self.slidingMenuDelegate slidingMenuControllerDidStartMovingMenu:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:SlidingMenuMoving object:self];
        
        startingPoint = point;
        startingCenter = slidingView.center;
        
        [self.blackPanel setCenter:CGPointMake(slidingView.center.x - slidingView.frame.size.width, slidingView.center.y)];
        
    }else if(gest.state == UIGestureRecognizerStateEnded){
        
        if(slidingView.frame.origin.x > (self.view.frame.size.width * self.speed)
           && (point.x - self.autoCloseTolerance) > startingPoint.x){
            [self dissmissMenu:nil];
            
        }else if(slidingView.frame.origin.x < (self.view.frame.size.width * self.threshold)){
            [self openMenu];
            
        }else{
            [self dissmissMenu:nil];
        }
        
    }else{
        
        // Move the menu according to user touch
        NSInteger newX = startingCenter.x - (startingPoint.x - point.x);
        NSInteger leftPaddingCenterAdjusted = self.leftPadding + (slidingView.bounds.size.width / 2);
        
        if(newX < leftPaddingCenterAdjusted){
            newX = leftPaddingCenterAdjusted;
        }
        
        [slidingView setCenter:CGPointMake(newX, slidingView.center.y)];
        [self.blackPanel setCenter:CGPointMake(slidingView.center.x - slidingView.frame.size.width, slidingView.center.y)];
        [self.blackPanel setAlpha:(1.0 - ((float)slidingView.frame.origin.x) / (float)self.view.frame.size.width)]; // TODO This for everything
    }
}

@end
