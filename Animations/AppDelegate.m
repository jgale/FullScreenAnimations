//
//  AppDelegate.m
//  Animations
//
//  Created by Jeremy Gale on 2012-03-19.
//  Copyright (c) 2012 Force Grind Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "BasicViewController.h"
#import "MGSplitViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    FirstViewController *firstVC = [[FirstViewController alloc] initWithNibName:nil bundle:nil];
    firstVC.tabBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:0];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstVC];
    
    BasicViewController *secondVC = [[BasicViewController alloc] init];
    secondVC.tabBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    BasicViewController *thirdVC = [[BasicViewController alloc] init];
    thirdVC.tabBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2];
    BasicViewController *fourthVC = [[BasicViewController alloc] init];
    fourthVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favourites"
                                                        image:[UIImage imageNamed:@"Favourite.png"]
                                                          tag:3];
    self.tabBarController = [[UITabBarController alloc] init];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:firstNav, secondVC, thirdVC, fourthVC, nil];
        self.window.rootViewController = self.tabBarController;
    }
    else
    {
        BasicViewController *replacementFirstVC = [[BasicViewController alloc] init];
        replacementFirstVC.tabBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:0];
        UINavigationController *replacementNavFirstVC = [[UINavigationController alloc] initWithRootViewController:replacementFirstVC];
        
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:replacementNavFirstVC, secondVC, thirdVC, fourthVC, nil];

        // To my surprise, MGSplitViewController was the only one that allowed me to do the manual splash screen
        // rotation inside SplashViewController. It didn't work with a regular UISplitViewController, though
        // I didn't try for very long
        self.splitViewController = [[MGSplitViewController alloc] init];
        self.splitViewController.delegate = firstVC;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.tabBarController, firstNav, nil];
        
        // Always show the the split view even in portrait mode
        self.splitViewController.showsMasterInPortrait = YES;
        
        self.window.rootViewController = self.splitViewController;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
