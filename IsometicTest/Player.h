//
//  Player.h
//  IsometicTest
//
//  Created by Javiersu on 6/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "IsoBackground.h"
#import "ShortestPathStep.h"

@interface Player : CCSprite <UIGestureRecognizerDelegate> {

        CCLayer *_layer;
    
@private
        NSMutableArray *spOpenSteps;
        NSMutableArray *spClosedSteps;
        NSMutableArray *shortestPath;
        
}

@property float dx;
@property float dy;
@property (nonatomic) int hp;

- (id)initWithPosition:(CGPoint)point andLayer:(CCLayer *)layer;
- (NSMutableArray*)moveToward:(CGPoint)target;
- (void)insertInOpenSteps:(ShortestPathStep*)step;
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord;
- (int)costToMoveFromStep:(ShortestPathStep*)fromStep toAdjacentStep:(ShortestPathStep*)toStep;
- (void)updateSprite:(ccTime)dt;
- (void)cancelStep;
- (void)popStepAndAnimate;
- (void)runPSA:(NSMutableArray*)array;
@end