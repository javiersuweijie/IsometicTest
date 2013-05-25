//
//  GameScene.m
//  IsometicTest
//
//  Created by Javiersu on 6/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

CCLayer *gameLayer;
CCLayer *boxLayer;
CCLayer *menuLayer;
CCLayer *topLayer;
CCSprite *menuButton;
Menu *menu;
CGSize winSize;

Player * player;
IsoBackground* background;

NSMutableArray* boxArray;

@implementation GameScene

+(CCScene*) scene {
    CCScene* scene = [CCScene node];
    GameScene* layer = [GameScene node];
    [scene addChild:layer];
    
    return scene;
}

-(id) init {
    if (self = [super init]) {
        gameLayer = [[CCLayer alloc]init];
        menuLayer = [[CCLayer alloc]init];
        
        [gameLayer setContentSize:(CGSizeMake(480*2, 320*2))];
        [self addChild:gameLayer];
        
        [self addChild:menuLayer z:1];
        menu = [[Menu alloc]init];
        [menuLayer addChild:menu];
        
        boxLayer = [[CCLayer alloc]init];
        background = [[IsoBackground alloc] initWithLayer:boxLayer];
        
        [gameLayer addChild:background z:1];
        [gameLayer addChild:boxLayer z:2];
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        self.isAccelerometerEnabled = YES;
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        gameLayer.isTouchEnabled = YES;
        
        //! pinch gesture recognizer
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [gameLayer addGestureRecognizer:pinchGestureRecognizer];
        pinchGestureRecognizer.delegate = self;
        [pinchGestureRecognizer release];
        
        UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGestureRecognizer.delegate = self;
        [gameLayer addGestureRecognizer:panGestureRecognizer];
        [panGestureRecognizer release];
        
        
        UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGestureRecognizer.delegate = self;
        [gameLayer addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        boxArray = [[NSMutableArray alloc]init];
        NSLog(@"%f, %f",gameLayer.contentSize.height,gameLayer.contentSize.width);

        
    }
    return self;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)aPinchGestureRecognizer
{
    if (aPinchGestureRecognizer.state == UIGestureRecognizerStateBegan || aPinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if ([aPinchGestureRecognizer numberOfTouches]<2) {
            return;
        }
        CGPoint touch1 = [aPinchGestureRecognizer locationOfTouch:0 inView:[aPinchGestureRecognizer view]];
        CGPoint touch2 = [aPinchGestureRecognizer locationOfTouch:1 inView:[aPinchGestureRecognizer view]];
        touch1 = [[CCDirector sharedDirector] convertToGL:touch1];
        touch2 = [[CCDirector sharedDirector] convertToGL:touch2];
                
        CGPoint mid = ccpMidpoint(touch1, touch2);
        CCNode *node = aPinchGestureRecognizer.node;
        mid=[gameLayer convertToNodeSpace:mid];
        node.anchorPoint = ccp(mid.y/node.contentSize.height, mid.x/node.contentSize.width);
        float scale = [aPinchGestureRecognizer scale];
        if ((scale>1 && node.scale>2.0)||(scale<1 && node.scale<0.8));
        else {
            node.scale *= scale ;
        }
        aPinchGestureRecognizer.scale = 1;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)aPanGestureRecognizer
{
    CCNode *node = aPanGestureRecognizer.node;
    CGPoint translation = [aPanGestureRecognizer translationInView:aPanGestureRecognizer.view];
    translation.y *= -1;
    [aPanGestureRecognizer setTranslation:CGPointZero inView:aPanGestureRecognizer.view];
    
    node.position = ccpAdd(node.position, translation);
//    NSLog(@"%@",NSStringFromCGPoint(node.position));
}

-(void)handleTapGesture:(UITapGestureRecognizer*)aTapGestureRecognizer
{
    CGPoint touchLocation = [aTapGestureRecognizer locationInView:[aTapGestureRecognizer view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [gameLayer convertToNodeSpace:touchLocation]; //convert to nodeSpace of the gameLayer
   
    CGPoint isoCoords = [IsoBackground nearestPoint:touchLocation];
    [player cancelStep];
    [player moveToward:touchLocation];
    if ([IsoBackground checkCoordsInList:isoCoords]) {
//        IsoBox *redbox = [[IsoBox alloc] initWithPosition:ccpAdd(touchLocation, [IsoBackground getTileHeight])];
//        redbox.isTouchEnabled = YES;
//        NSLog(@"%d",-(int)touchLocation.y);
//        NSLog(@"%d",-(int)touchLocation.y-1);
//        [boxLayer addChild:redbox z:-(int)touchLocation.y];
//        [boxArray addObject:redbox];
    }
    else {
        if ([menu currentSelection]) {
            IsoBox *box = [[ParticleBox alloc] initWithPosition:touchLocation inLayer:boxLayer withString:[menu currentSelection] withPlayer:[IsoBackground getCharArray]]; //the nearestpoint is determined by the IsoBox itself
            
            [boxLayer addChild:box z:-(int)touchLocation.y];
            [boxArray addObject:box];
        }
        else {
            NSLog(@"nothing to place");
        }
    
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //! For swipe gesture recognizer we want it to be executed only if it occurs on the main layer, not any of the subnodes ( main layer is higher in hierarchy than children so it will be receiving touch by default )
    if ([gestureRecognizer class] == [UITapGestureRecognizer class]) {
        CGPoint pt = [touch locationInView:touch.view];
        pt = [[CCDirector sharedDirector] convertToGL:pt];
//        pt = [gameLayer convertToNodeSpace:pt];

        if ([menuButton isNodeInTreeTouched:pt]) {
            return YES;
            }
    }
    return YES;
}

@end
