//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Gang Wu on 7/22/15.
//  Copyright (c) 2015 Gang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)recognizer;

@end
