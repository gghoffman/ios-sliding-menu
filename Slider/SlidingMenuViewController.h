//
//  SlidingMenuViewController.h
//
//  Created by Gunnar Hoffman on 12/5/13.
//  Copyright (c) 2013 Ball State University.
//

#import <UIKit/UIKit.h>

/*
 Used as a callback when -(void) dissmissMenu: (menu_hidden_callback) callback; is called.
 */
typedef void(^menu_hidden_callback)(void);

@class SlidingMenuViewController;

@protocol SlidingMenuViewControllerDelegate

/*
 Whenever the menu starts moving this is called, generally this is triggered by a user
 pan gesture as when we actually know what the menu is doing the more descriptive delegate
 methods will be called.
 */
-(void) slidingMenuControllerDidStartMovingMenu: (SlidingMenuViewController *) controller;

/*
 The menu is about to start animating to the closed position.
 */
-(void) slidingMenuControllerWillHideMenu: (SlidingMenuViewController *) controller;

/*
 The menu is about to start animating to the open position.
 */
-(void) slidingMenuControllerWillShowMenu: (SlidingMenuViewController *) controller;

/*
 The menu did finish animating to the closed position.
 */
-(void) slidingMenuControllerDidHideMenu: (SlidingMenuViewController *) controller;

/*
 The menu did finish animating to the open position.
 */
-(void) slidingMenuControllerDidShowMenu: (SlidingMenuViewController *) controller;

@end

/*
 Notification keys brocasting from this object. These coorospond to the similarly
 named SlidingMenuViewControllerDelegate methods.
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
 2) Change it's class type to SlidingMenuViewController.
 3) Provide storyboard title attributes for all direct children of the UITabBarController.
 4) Awesomeness.
 
 */
@interface SlidingMenuViewController : UITabBarController

/*
 Assign yourself if you want to receive notifcations when the menu moves about.
 */
@property (weak, nonatomic) id<SlidingMenuViewControllerDelegate> slidingMenuDelegate;

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
