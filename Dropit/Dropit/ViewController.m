//
//  ViewController.m
//  Dropit
//
//  Created by Gang Wu on 7/22/15.
//  Copyright (c) 2015 Gang Wu. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehavior.h"
#import "BezierPathView.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet /*UIView*/BezierPathView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;    // animator container
//@property (strong, nonatomic) UIGravityBehavior *gravity;
//@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) DropitBehavior *dropitBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppingView;
@end

@implementation ViewController

static const CGSize DROP_SIZE = { 40, 40 };


-(UIDynamicAnimator *)animator{
    if (!_animator) {
        // animator is attached to a view
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        
        // IMPORTANT
        _animator.delegate = self;
    }
    return _animator;
}


-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    [self removeCompletedRows];
}

-(BOOL)removeCompletedRows{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    // bottom-up, try each center
    for (CGFloat y = self.gameView.bounds.size.height - DROP_SIZE.height / 2; y > 0; y -= DROP_SIZE.height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width - DROP_SIZE.width / 2; x += DROP_SIZE.width)
        {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if([hitView superview] == self.gameView){
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        if(![dropsFound count]) break;  // early termination
        if(rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    
    if([dropsToRemove count]){
        for(UIView *drop in dropsToRemove){
            [self.dropitBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    
    return NO;
}

-(void)animateRemovingDrops:(NSArray *)dropsToRemove{
    [UIView animateWithDuration:1.0
                     animations:^{
                         for(UIView *drop in dropsToRemove) {
                             int x = (arc4random()%(int)self.gameView.bounds.size.width*5) - (int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height;
                             drop.center = CGPointMake(x, -y);
                         }
                     }
                     completion:^(BOOL finished) {
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

//-(UIGravityBehavior *)gravity{
//    if(!_gravity) {
//        _gravity = [[UIGravityBehavior alloc] init];
//        _gravity.magnitude = 0.9;
//        [self.animator addBehavior:_gravity];
//    }
//    return _gravity;
//}
//
//-(UICollisionBehavior *)collider{
//    if(!_collider) {
//        _collider = [[UICollisionBehavior alloc] init];
//        _collider.translatesReferenceBoundsIntoBoundary = YES;
//        [self.animator addBehavior:_collider];
//    }
//    return _collider;
//}

-(DropitBehavior *)dropitBehavior{
    if (!_dropitBehavior) {
        _dropitBehavior = [[DropitBehavior alloc] init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if(sender.state == UIGestureRecognizerStateBegan){
        [self attachDroppingViewToPoint:gesturePoint];
    } else if(sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = gesturePoint;
    } else if(sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}

-(void)attachDroppingViewToPoint:(CGPoint)anchorPoint{
    if(self.droppingView){
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView  attachedToAnchor:anchorPoint];
        
        UIView *droppingView = self.droppingView; // avoid nil pointer
        __weak ViewController *weakSelf = self;   // avoid memory cycle
        self.attachment.action=^{
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.gameView.path = path;   // Once set, redraw
        };

        self.droppingView = nil;    // only one try
        [self.animator addBehavior:self.attachment];
    }
}

-(void)drop{
    // create frame ==> define a region (size & location)
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random() % (int)self.gameView.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    // create a view
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    // current dropping view (latest one)
    //////////////////////////////////////////////////
    self.droppingView = dropView;
    //////////////////////////////////////////////////
    
    // add view to a gravity behavior
//    [self.gravity addItem:dropView];
//    [self.collider addItem:dropView];
    [self.dropitBehavior addItem:dropView];
}

-(UIColor *)randomColor{
    switch (arc4random()%5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blackColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
