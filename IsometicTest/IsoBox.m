
//
//  IsoBox.m
//  IsometicTest
//
//  Created by Javiersu on 15/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
#import "IsoBox.h"
@implementation IsoBox
@synthesize name;
CCLayer* parentLayer;

@synthesize temp;

-(id)initWithPosition:(CGPoint)point inLayer:(CCLayer*)layer withString:(NSString*)string{
    if ([super initWithFile:[NSString stringWithFormat:@"%@.png",string]]) {
        parentLayer = layer;
        self.anchorPoint = ccp(0.5,0);
        name = string;
        self.position = [IsoBackground nearestPoint:point];
        UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        [panGestureRecognizer release];
        [IsoBackground addObjectToList:self];
        temp = self.position;
        self.isTouchEnabled = YES;
        NSLog(@"%@",NSStringFromCGPoint([IsoBackground gridNumber:self.position]));
    }
    return self;
}
-(id)initFromSave:(CGPoint)point withString:(NSString*)string{
    if ([super initWithFile:[NSString stringWithFormat:@"%@.png",string]]) {

        self.anchorPoint = ccp(0.5,0);
        name = string;
        self.position = [IsoBackground nearestPoint:ccp(point.x,point.y)];
        UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        [panGestureRecognizer release];
        [IsoBackground addObjectToList:self];
        temp = self.position;
        self.isTouchEnabled = YES;
        NSLog(@"%@",NSStringFromCGPoint([IsoBackground gridNumber:self.position]));
    }
    return self;
}
- (void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{
    CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
    translation.y *= -1;
//    NSLog(@"%f,%f",translation.x,translation.y);
    [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
//    NSLog(@"%f,%f",[IsoBackground nearestPoint:temp].x,[IsoBackground nearestPoint:temp].y);
    temp = ccpAdd(temp, translation);
    if (!CGPointEqualToPoint([IsoBackground nearestPoint:temp],self.position)) {
        self.position = [IsoBackground nearestPoint:temp];
        [parentLayer reorderChild:self z:-self.position.y];
    }
    if(aPanGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [IsoBackground replaceObjectInList:self];
    }
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%f,%f,%@",self.position.x,self.position.y,name];
}
@end
