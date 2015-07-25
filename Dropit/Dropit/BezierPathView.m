//
//  BezierPathView.m
//  Dropit
//
//  Created by Gang Wu on 7/23/15.
//  Copyright (c) 2015 Gang Wu. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

-(void)setPath:(UIBezierPath *)path{
    _path = path;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    [self.path stroke];
}

@end
