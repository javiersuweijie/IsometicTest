//
//  Player.m
//  IsometicTest
//
//  Created by Javiersu on 6/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "HealthBar.h"

@interface Player()
@property (nonatomic,retain) NSMutableArray *spOpenSteps;
@property (nonatomic,retain) NSMutableArray *spClosedSteps;
@property (nonatomic,strong) NSMutableArray *shortestPath;

@end

@implementation Player

//NSMutableArray* frontRightFrame;
//NSMutableArray* frontLeftFrame;
//NSMutableArray* backRightFrame;
//NSMutableArray* backLeftFrame;

CCAnimation *frontRightAnimation;
CCAnimation *frontLeftAnimation;
CCAnimation *backRightAnimation;
CCAnimation *backLeftAnimation;

CGPoint cartPosition;
CGPoint pTarget;

@synthesize dx,dy,spClosedSteps,spOpenSteps,shortestPath,hp;

-(id)initWithPosition:(CGPoint)point andLayer:(CCLayer*)layer {
    if (self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"isoplayer_default.plist"];
        NSMutableArray* frontRightFrame = [NSMutableArray array];
        for (int i=1;i<=4;i++) {
            [frontRightFrame addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"frontright_%d.png",i]]];
        }
        
        frontRightAnimation = [CCAnimation animationWithSpriteFrames:frontRightFrame delay:0.5f];
        [frontRightAnimation retain];
        
        NSMutableArray* frontLeftFrame = [NSMutableArray array];
        for (int i=1;i<=4;i++) {
            [frontLeftFrame addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"frontleft_%d.png",i]]];
        }
        
        frontLeftAnimation = [CCAnimation animationWithSpriteFrames:frontLeftFrame delay:0.5f];
        [frontLeftAnimation retain];
        
        NSMutableArray* backRightFrame = [NSMutableArray array];
        for (int i=1;i<=3;i++) {
            [backRightFrame addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"backright_%d.png",i]]];
        }
        
        backRightAnimation = [CCAnimation animationWithSpriteFrames:backRightFrame delay:0.5f];
        [backRightAnimation retain];
        
        NSMutableArray* backLeftFrame = [NSMutableArray array];
        for (int i=1;i<=4;i++) {
            [backLeftFrame addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"backleft_%d.png",i]]];
        }
        
        backLeftAnimation = [CCAnimation animationWithSpriteFrames:backLeftFrame delay:0.5f];
        [backLeftAnimation retain];
        self.shortestPath = nil;
        self.position = point;
        self.anchorPoint = ccp(0.5,0);
        self.hp = 1000;
        cartPosition = [IsoBackground coordInvTransform:point];
        
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"frontleft_1.png"]];
        _layer = layer;
        [super onEnter];
        HealthBar* hpBar = [[HealthBar alloc]initWithChar:self];
        [self addChild:hpBar];
        [self schedule:@selector(updateZ:)];
        
        
    }
    return self;
    
}

-(void)updateZ:(ccTime)dt
{
    [_layer reorderChild:self z:-self.position.y];
    if (self.hp<0) {
    
        [[IsoBackground getCharArray] removeObject:self];
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)onExit {
//    [backLeftAnimation release];
//    [backRightAnimation release];
//    [frontLeftAnimation release];
//    [frontRightAnimation release];
}

-(NSMutableArray*)moveToward:(CGPoint)target
{
    CGPoint toGrid = [IsoBackground gridNumber:target];
    CGPoint fromGrid = [IsoBackground gridNumber:self.position];
    
    if ([IsoBackground checkCoordsInList:toGrid]) {
        NSLog(@"Not valid point");
        return nil;
    }
    spClosedSteps = [[NSMutableArray alloc]init];
    spOpenSteps = [[NSMutableArray alloc]init];
    int numberOfSteps=0;
    [self insertInOpenSteps:[[ShortestPathStep alloc]initWithPosition:fromGrid]];
    ShortestPathStep* currentStep;
    do {
        if ([spOpenSteps count]>3) {
//            NSLog(@"%@,%@,%@",[[spOpenSteps objectAtIndex:0] description],[[spOpenSteps objectAtIndex:1] description],[[spOpenSteps objectAtIndex:2]description]);
        }
        currentStep=[spOpenSteps objectAtIndex:0];
        [spOpenSteps removeObjectAtIndex:0];
        numberOfSteps++;
//        NSLog(@"NoS:%d Target:%@ Point:%@ gScore:%d, hScore:%d",numberOfSteps,NSStringFromCGPoint(toGrid),NSStringFromCGPoint(currentStep.position),currentStep.gScore,currentStep.hScore);
        CGPoint currentGrid = currentStep.position;
        [spClosedSteps addObject:currentStep];
        [spOpenSteps removeAllObjects];

        if (CGPointEqualToPoint(currentStep.position,toGrid)) {
            NSLog(@"foundPath");
            spOpenSteps = nil;
            spClosedSteps = nil;
//            NSLog(@"%@",[currentStep description]);
            return [self constructPathAndStartAnimationFromStep:currentStep];
            break;
        }
        
        else {
            NSArray* array = [IsoBackground walkableAdjTilesCoord:currentGrid];
            for (NSValue* x in array) {
                ShortestPathStep* adjStep = [[ShortestPathStep alloc]initWithPosition:[x CGPointValue]];
                if ([spClosedSteps containsObject:adjStep]) {
                    adjStep = nil;
                    continue;
                }
                adjStep.hScore = [self computeHScoreFromCoord:adjStep.position toCoord:toGrid];
                adjStep.gScore = currentStep.gScore + [self costToMoveFromStep:currentStep toAdjacentStep:adjStep];
                adjStep.parent = currentStep;
                [self insertInOpenSteps:adjStep];
                adjStep=nil;
            }
            array=nil;
        }
    } while (TRUE);
}

-(void)insertInOpenSteps:(ShortestPathStep *)step
{
    int stepFScore = [step fScore]; // Compute the step's F score
	int count = [self.spOpenSteps count];
	int i = 0; // This will be the index at which we will insert the step
	for (; i < count; i++) {
		if (stepFScore <= [[self.spOpenSteps objectAtIndex:i] fScore]) { // If the step's F score is lower or equals to the step at index i
			// Then we found the index at which we have to insert the new step
            // Basically we want the list sorted by F score
			break;
		}
	}
	// Insert the new step at the determined index to preserve the F score ordering
	[self.spOpenSteps insertObject:step atIndex:i];
}
// Compute the H score from a position to another (from the current position to the final desired position
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord
{
	// Here we use the Manhattan method, which calculates the total number of step moved horizontally and vertically to reach the
	// final desired step from the current step, ignoring any obstacles that may be in the way
//    NSLog(@"%@       %@",NSStringFromCGPoint(fromGrid),NSStringFromCGPoint(toGrid));
//    NSLog(@"%i",abs(toGrid.x - fromGrid.x) + abs(toGrid.y - fromGrid.y));
	return 10*max(abs(toCoord.x - fromCoord.x),abs(toCoord.y - fromCoord.y));
}

- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep
{
	// Because we can't move diagonally and because terrain is just walkable or unwalkable the cost is always the same.
	// But it have to be different if we can move diagonally and/or if there is swamps, hills, etc...
	return ((fromStep.position.x != toStep.position.x) && (fromStep.position.y != toStep.position.y)) ? 20 : 10;
}

- (NSMutableArray*)constructPathAndStartAnimationFromStep:(ShortestPathStep *)step
{
	NSMutableArray* sp = [[NSMutableArray alloc]init];
    
	do {
		if (step.parent != nil) { // Don't add the last step which is the start position (remember we go backward, so the last one is the origin position ;-)
			[sp insertObject:step atIndex:0]; // Always insert at index 0 to reverse the path
		}
		step = step.parent; // Go backward
	} while (step != nil); // Until there is no more parents
    
//    for (ShortestPathStep *s in self.shortestPath) {
//        NSLog(@"%@", s);
//    }
    return sp;
}

- (void)runPSA:(NSMutableArray*)array;
{
    if (self.shortestPath == nil) {
        self.shortestPath = [array mutableCopy];
        [self popStepAndAnimate];
    }
}

- (void)popStepAndAnimate;
{
	// Check if there remains path steps to go through
    if ([self.shortestPath count] == 0) {
		self.shortestPath = nil;
		return;
	}
    
	// Get the next step to move to
	ShortestPathStep *ss = [self.shortestPath objectAtIndex:0];
    CGPoint s = [IsoBackground gridToCoord:ss.position];
    float timetaken=ccpDistance(self.position, s)/30;
    
	id moveAction = [CCMoveTo actionWithDuration:timetaken position:s];
	id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(popStepAndAnimate)]; // set the method itself as the callback
    
	// Remove the step
	[self.shortestPath removeObjectAtIndex:0];
//    [self runAction:[self animate:s.position]];
	[self runAction:[CCSequence actions:moveAction, moveCallback, nil]];
}

- (void)cancelStep
{
    [self stopAllActions];
    if ([self.shortestPath count] != 0) {
		self.shortestPath = nil;
		return;
	}
    return;
}

-(CCAnimate*)animate:(CGPoint)toPoint
{
    if (self.position.x>toPoint.x) {
        if (self.position.y>toPoint.y){
            return [CCAnimate actionWithAnimation:frontLeftAnimation];
        }
        else return [CCAnimate actionWithAnimation:backLeftAnimation];
    }
    else if (self.position.x<toPoint.x) {
        if (self.position.y>toPoint.y) {
            return [CCAnimate actionWithAnimation:frontRightAnimation];
        }
        else return [CCAnimate actionWithAnimation:backRightAnimation];
    }
    else return [self animate:pTarget];
}
@end
