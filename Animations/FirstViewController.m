//
//  FirstViewController.m
//  Animations
//
//  Created by Jeremy Gale on 2012-03-20.
//  Copyright (c) 2012 Force Grind Inc. All rights reserved.
//
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

#import "FirstViewController.h"
#import "AppDelegate.h"
#import "FavouriteAnimationViewController.h"
#import "SplashViewController.h"

@interface FirstViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation FirstViewController

@synthesize masterPopoverController = _masterPopoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
            
    _favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_favButton setImage:[UIImage imageNamed:@"NavBarFavouriteNonActive.png"] forState:UIControlStateNormal];
    [_favButton setImage:[UIImage imageNamed:@"NavBarFavouriteActive.png"] forState:UIControlStateSelected];
    _favButton.frame = CGRectMake(0.0, 0.0, 35.0, 35.0);
    [_favButton addTarget:self action:@selector(favouriteTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *star = [[UIBarButtonItem alloc] initWithCustomView:_favButton]; 
    self.navigationItem.rightBarButtonItem = star;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.text = @"Includes “MGSplitViewController” code by Matt Gemmell.";
    [self.view addSubview:label];
    
    SplashViewController *splashScreen = [[SplashViewController alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Hack for iOS 6 on iPad. Need this to get the split view to display properly on iOS 6 when opened in Landscape
    // https://github.com/mattgemmell/MGSplitViewController/issues/69
    [appDelegate.splitViewController setSplitPosition:appDelegate.splitViewController.splitPosition - 1];
    [appDelegate.splitViewController setSplitPosition:appDelegate.splitViewController.splitPosition + 1];
    
    // This will never let me see the view underneath :(
    //[appDelegate.window.rootViewController presentModalViewController:splashScreen animated:NO];    
    [appDelegate.window addSubview:splashScreen.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Actions

- (IBAction)favouriteTapped:(id)sender
{
    _favButton.selected = !_favButton.selected;

    if (_favButton.selected)
    {
        FavouriteAnimationViewController *favAnimationView = [[FavouriteAnimationViewController alloc] init];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            // This is unfortunate, but because are are dealing with this view in a non-standard way,
            // we need code to handle iPhone 5 resolution it will just load the view as a 480-pixel tall view
            favAnimationView.view.frame = appDelegate.window.frame;
            
            [appDelegate.window addSubview:favAnimationView.view];
        }
        else
        {
            // Need to add it to the top-most view controller's view, or else it won't properly rotate to landscape
            [appDelegate.splitViewController.view addSubview:favAnimationView.view];
        }
    }
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
