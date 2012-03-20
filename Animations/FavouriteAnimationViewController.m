//
//  FavouriteAnimationViewController.m
//  O2PriorityMoments
//
//  Created by Jeremy Gale on 2011-11-25
//  Copyright 2011 Force Grind Inc. All rights reserved.
//
//  Shamelessly inspried by Ryan Harrison's code
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


#import "FavouriteAnimationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define animationDuration 3.0
#define kFadeInTabDuration 1.5
#define kFadeOutTabDuration 1.5
#define kFavouritesTabIndex 3

@implementation FavouriteAnimationViewController

@synthesize starImageView;
@synthesize bottomView;
@synthesize otherTabsFadeBlackView;
@synthesize favTabBlueStarGlowView;

- (id)init
{
	if ((self = [super initWithNibName:@"FavouriteAnimationViewController" bundle:nil]))
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    otherTabsFadeBlackView.alpha = 0;
    favTabBlueStarGlowView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Need to wait until viewDidAppear to make sure the view has been resized properly
    [self startFavouriteAnimation];
}

- (void)startFavouriteAnimation
{
	//Animate the image shrinking. Include this in the CAAnimationGroup below to get both things to work
//	CABasicAnimation *shrink;
//	shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//	shrink.fromValue = [NSNumber numberWithDouble:1.0];
//	shrink.toValue = [NSNumber numberWithDouble:0.3];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    
    CGPoint fromPoint = starImageView.center;
    // This assumes there is always a UITabBarController 320 pixels wide at the left side of the screen,
    // and we are going to the third out of 4 view controllers
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGPoint toPoint = CGPointMake(320.0 * kFavouritesTabIndex / appDelegate.tabBarController.viewControllers.count + 40, // +40 because each tab bar is currently 80 pixels wide
                                  self.view.frame.size.height - 24); // - 24 because want it to be in the middle of the tab bar which has height of 49
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, fromPoint.x, fromPoint.y);
    CGPathAddCurveToPoint(curvedPath, NULL, toPoint.x, fromPoint.y, toPoint.x, fromPoint.y, toPoint.x, toPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);

    CAAnimationGroup *group = [CAAnimationGroup animation];
    // kCAFillModeForwards The receiver remains visible in 
    // its final state when the animation is completed.
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:/*shrink,*/ pathAnimation, nil]];
    group.duration = animationDuration;
    group.delegate = self;
  
    [starImageView.layer addAnimation:group forKey:@"savingAnimation"];
    
    //Animate the tab bar getting dark
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.toValue = [NSNumber numberWithDouble:1.0];
    fadeIn.fillMode = kCAFillModeForwards;
    fadeIn.removedOnCompletion = NO;
    fadeIn.duration = animationDuration;
    
    [otherTabsFadeBlackView.layer addAnimation:fadeIn forKey:@"tabBarFadeBlack"];
}

// Make the blue star image go from an alpha of 0 to 1.0 making it glow
- (void)makeFavTabGlow
{
    //Hide the yellow star now
    starImageView.hidden = YES;
    
    //Animate the tab bar getting dark
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.toValue = [NSNumber numberWithDouble:1.0];
    fadeIn.fillMode = kCAFillModeForwards;
    fadeIn.removedOnCompletion = NO;
    fadeIn.duration = kFadeInTabDuration;
    fadeIn.delegate = self;
    
    [favTabBlueStarGlowView.layer addAnimation:fadeIn forKey:@"favBlueStarGlowFadeIn"];
}

// Makes the entire bottom view (overlays tab bar) go to alpha 0.0,
// i.e. have it go back to normal.
- (void)fadeOutTabAndGlow
{
    //Animate the meGlow getting dark
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.toValue = [NSNumber numberWithDouble:0.0];
    fadeOut.fillMode = kCAFillModeForwards;
    fadeOut.removedOnCompletion = NO;
    fadeOut.duration = kFadeOutTabDuration;
    fadeOut.delegate = self;
    
    [bottomView.layer addAnimation:fadeOut forKey:@"allFadeOut"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(anim == [starImageView.layer animationForKey:@"savingAnimation"])
    {
        [self makeFavTabGlow];
    }
    else if(anim == [favTabBlueStarGlowView.layer animationForKey:@"favBlueStarGlowFadeIn"])
    {
        [self fadeOutTabAndGlow];
    }
    else if(anim == [bottomView.layer animationForKey:@"allFadeOut"])
    {
        [self.view removeFromSuperview];
    }
}

#pragma mark - Rotation Handling
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.starImageView = nil;
    self.otherTabsFadeBlackView = nil;
    self.favTabBlueStarGlowView = nil;
    self.bottomView = nil;
}

@end
