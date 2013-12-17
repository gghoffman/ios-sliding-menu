//
//  GSMViewController.h
//
//  Created by Gunnar Hoffman on 12/5/13.
//  Copyright (c) 2013 Ball State University.
//

#import <UIKit/UIKit.h>

/*
 CONFIGURATION
 */

/*
 Specifies the swipable area on the right side (in pixels) that allows the menu to be pulled out.
 */
#define RIGHT_SIDE_GUTTER 30

/*
 When the menu is open and you pan to the right, this is the minimum number of pixels you must
 pan to the right in order to trigger the menu close function when you stop the pan.
 */
#define AUTO_CLOSE_TOLERANCE 30

/*
 How many pixels is between the top level view and the left edge of the menu when it is locked
 into the open position.
 */
#define LEFT_PADDING 100

/*
 Percentage of the screen the menu must be drug out in order to trigger an open animation.
 */
#define OPEN_THRESHOLD 0.25

/*
 Time in seconds the open/close animation will take.
 */
#define ANIMATION_DURATION 0.25

/*
 Used as a callback when -(void) dissmissMenu: (menu_hidden_callback) callback; is called.
 */
typedef void(^menu_hidden_callback)(void);

@class GSMViewController;

@protocol GSMViewControllerDelegate

/*
 Whenever the menu starts moving this is called, generally this is triggered by a user
 pan gesture as when we actually know what the menu is doing the more descriptive delegate
 methods will be called.
 */
-(void) slidingMenuControllerDidStartMovingMenu: (GSMViewController *) controller;

/*
 The menu is about to start animating to the closed position.
 */
-(void) slidingMenuControllerWillHideMenu: (GSMViewController *) controller;

/*
 The menu is about to start animating to the open position.
 */
-(void) slidingMenuControllerWillShowMenu: (GSMViewController *) controller;

/*
 The menu did finish animating to the closed position.
 */
-(void) slidingMenuControllerDidHideMenu: (GSMViewController *) controller;

/*
 The menu did finish animating to the open position.
 */
-(void) slidingMenuControllerDidShowMenu: (GSMViewController *) controller;

@end

/*
 Notification keys brocasting from this object. These coorospond to the similarly
 named GSMViewControllerDelegate methods.
 */
extern NSString *const SlidingMenuMoving;
extern NSString *const SlidingMenuHidding;
extern NSString *const SlidingMenuHidden;
extern NSString *const SlidingMenuShowing;
extern NSString *const SlidingMenuShown;

/*
 
 ** Description:
 
 This sliding menu controler modifies a UITabBarController so that instead of a tab
 bar being located at the bottom of the view a pullout menu on the right side is now
 available. This menu's data and actions are populated by the .viewControllers array
 on the UITabBarController. The order you hook child view controllers to the 
 UITabViewController determines the order of text labels on the resulting menu.
 
 ** Authors:
 
 This work was done for internal use at Emerging Technologies, Ball State University
 and is now open sourced to provide value to the greater world.
 
 Gunnar Hoffman - gh@bsu.edu
 Associate Director of Interactive Development
 
 I wrote this in a single night, I know many improvements can be made.
 
 License:
 Apache 2.0 - http://www.apache.org/licenses/LICENSE-2.0.html
 
 ** Installation:
 
 1) Drag a UITabBarController onto your story board.
 2) Change it's class type to GSMViewController.
 3) Provide storyboard title attributes for all direct children of the UITabBarController.
 4) Awesomeness.
 
 */
@interface GSMViewController : UITabBarController

/*
 Assign yourself if you want to receive notifcations when the menu moves about.
 */
@property (weak, nonatomic) id<GSMViewControllerDelegate> slidingMenuDelegate;

/*
 True, if and only if the panel is in the fully out/displayed position.
 */
@property (nonatomic) BOOL hasPanelOut;

/*
 This method will cause the menu to animate to the hidden position calling the provided
 (OPTIONAL) callback if you should feel in need of such.
 */
-(void) dissmissMenu: (menu_hidden_callback) callback;

/*
 Causes the animations to fire that bring the menu into view.
 */
-(void) openMenu;

@end
