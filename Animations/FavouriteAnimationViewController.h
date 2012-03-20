//
//  FavouriteAnimationViewController.h
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


#import <UIKit/UIKit.h>


@interface FavouriteAnimationViewController : UIViewController
{
    UIImageView *starImageView;
    UIView *otherTabsFadeBlackView;
    UIView *favTabBlueStarGlowView;
    UIView *bottomView;
}

@property (nonatomic, retain) IBOutlet UIImageView *starImageView;
@property (nonatomic, retain) IBOutlet UIView *otherTabsFadeBlackView;
@property (nonatomic, retain) IBOutlet UIView *favTabBlueStarGlowView;
@property (nonatomic, retain) IBOutlet UIView *bottomView;

- (id)init;

- (void)startFavouriteAnimation;

- (void)makeFavTabGlow;
- (void)fadeOutTabAndGlow;

@end
