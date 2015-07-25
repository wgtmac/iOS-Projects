//
//  DropitBehavior.h
//  Dropit
//
//  Created by Gang Wu on 7/22/15.
//  Copyright (c) 2015 Gang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

-(void)addItem:(id <UIDynamicItem>)item;
-(void)removeItem:(id <UIDynamicItem>)item;

@end
