//
//  IsoBackground.m
//  IsometicTest
//
//  Created by Javiersu on 7/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "IsoBackground.h"
#import "ParticleBox.h"
#include <stdlib.h>

@implementation IsoBackground


float tileHeight;
float tileWidth;
float winHeight;
float winWidth;
CGPoint vert[4];
NSString* objectListFileName;
static kmMat4 transform;
static kmMat4 invTransform;
static NSMutableArray* objectList;
static NSMutableArray* mapArray;
bool clicked = NO;
CCLayer* parentLayer;
static NSMutableArray* array=nil;
static NSMutableArray* charArray;

-(id)initWithLayer:(CCLayer*)parent {
    [super init];

    winWidth = [[CCDirector sharedDirector] winSize].width;
    tileWidth = winWidth/5;
    winHeight = [[CCDirector sharedDirector] winSize].height;
    tileHeight = winHeight/15;
    parentLayer = parent;
    charArray = [[NSMutableArray alloc]init];
    
    kmMat4 scale;
    kmMat4 rotate;
    kmMat4 translate;
    kmMat4Identity(&transform);
    kmMat4Translation(&translate, 0, 0.8f, 0);
    kmMat4Scaling(&scale, sqrtf(2.0)/2.0, sqrtf(2.0)/4.0, 1.0f);
    kmMat4RotationZ(&rotate, CC_DEGREES_TO_RADIANS(-45));
    kmMat4Multiply(&transform, &scale, &rotate);
    
    kmMat4Inverse(&invTransform, &transform);
//    [self showGridNumber];
    return self;
}

+(NSMutableArray*)getCharArray
{
    return charArray;
}
//-(void)draw {
//    [super draw];
//    if (clicked) {
//        ccDrawSolidPoly(vert, 4, ccc4f(255, 0, 0, 1));
//    }
//    for (int i = 0; i<=2*winHeight; i+=tileHeight) {
//        CGPoint startPoint = ccp(0,i);
//        CGPoint endPoint = ccp(winWidth*3,i);
//        
//        startPoint=[IsoBackground coordTransform:startPoint];
//        endPoint=[IsoBackground coordTransform:endPoint];
//        
//        ccDrawLine(startPoint, endPoint);
//
////        kmVec3 startVector= {
////            0,i,0
////        };
////        kmVec3 endVector = {
////            winWidth*3,i,0
////        };
////        [IsoBackground coordTransform:&startVector];
////        [IsoBackground coordTransform:&endVector];
////        kmVec3Transform(&startVector, &startVector, &transform);
////        kmVec3Transform(&endVector, &endVector, &transform);
////        ccDrawLine(ccp(startVector.x,startVector.y), ccp(endVector.x, endVector.y));
//    }
//    for (int i = 0; i<=3*winWidth; i+=tileHeight) {
////        kmVec3 startVector= {
////            i,0,0
////        };
////        
////        kmVec3 endVector = {
////            i,winHeight*3,0
////        };
//        CGPoint startPoint = ccp(i,0);
//        CGPoint endPoint = ccp(i,winHeight*3);
//        
//        startPoint=[IsoBackground coordTransform:startPoint];
//        endPoint=[IsoBackground coordTransform:endPoint];
//
//        ccDrawLine(startPoint, endPoint);
//    }
//
//}

-(void)showGridNumber {
    for (int i=0;i<10;i++) {
        for (int j=0;j<10;j++) {
            CCLabelTTF* label = [[CCLabelTTF alloc]initWithString:NSStringFromCGPoint(ccp(i,j)) fontName:@"Helvetica" fontSize:5];
            label.position = [IsoBackground gridToCoord:ccp(i,j)];
            [parentLayer addChild:label];
        }
    }
}

-(BOOL)gridDetect:(CGPoint)point {
    clicked = YES;
    //rounding down
    
    CGPoint xypoint = [IsoBackground coordInvTransform:point];
    
    if (xypoint.x<0||xypoint.y<0) {
        return NO;
    }
    
    else {
    int x = xypoint.x/tileHeight;
    int y = xypoint.y/tileHeight;
    x*=tileHeight;
    y*=tileHeight;
    
//    kmVec3 poly1 = {
//       x,y,0
//    };
//    kmVec3 poly2 = {
//        x,y+tileHeight,0
//    };
//    kmVec3 poly3 = {
//        x+tileHeight,y+tileHeight,0
//    };
//    kmVec3 poly4 = {
//        x+tileHeight,y,0
//    };
    
    vert[0]=[IsoBackground coordTransform:ccp(x,y)];
    vert[1]=[IsoBackground coordTransform:ccp(x,y+tileHeight)];
    vert[2]=[IsoBackground coordTransform:ccp(x+tileHeight,y+tileHeight)];
    vert[3]=[IsoBackground coordTransform:ccp(x+tileHeight,y)];
    
    return YES;
    }
}

+(CGPoint)nearestPoint:(CGPoint)point {
    CGPoint xypoint = [IsoBackground coordInvTransform:ccp(point.x,point.y)];
    int x = xypoint.x;
    int y = xypoint.y;
    if (x%32==0 && y%32==0) {
        return [IsoBackground coordTransform:ccp(x,y)];
    }

    else {
        x = xypoint.x/tileHeight;
        y = xypoint.y/tileHeight;
        x*=tileHeight;
        y*=tileHeight;
        return [IsoBackground coordTransform:ccp(x+tileHeight,y)];
    }
}

+(CGPoint)gridNumber:(CGPoint)nPoint{
    CGPoint xypoint = [IsoBackground coordInvTransform:nPoint];
    int x = xypoint.x/tileHeight;
    int y = xypoint.y/tileHeight;
    
    return ccp(x,y);
}

+(CGPoint)gridToCoord:(CGPoint)grid {

        float x=grid.x*tileHeight;
        float y=grid.y*tileHeight;
        return [IsoBackground coordTransform:ccp(x,y)];
}

+(CGPoint)coordTransform:(CGPoint)point {
    kmVec3 vPoint = {
        point.x,point.y,0
    };
    kmVec3 translation = {
        0,0,0
    };
    
    kmVec3Transform(&vPoint, &vPoint, &transform);
    kmVec3Add(&vPoint, &vPoint, &translation);
    
    return ccp(roundf(vPoint.x),roundf(vPoint.y));
}

+(CGPoint)coordInvTransform:(CGPoint)point {
    kmVec3 vPoint = {
        point.x,point.y,0
    };
    
    kmVec3 translation = {
        0,0,0
    };
    
    kmVec3Add(&vPoint, &vPoint, &translation);
    kmVec3Transform(&vPoint, &vPoint, &invTransform);

    return ccp(vPoint.x,vPoint.y);
}

+(void)addObjectToList:(IsoBox *)obj
{
    if (!objectList) {
        objectList = [[NSMutableArray alloc]init];
    }
    NSArray* objArray=[[NSArray alloc]initWithObjects:[NSValue valueWithCGPoint:[IsoBackground gridNumber:obj.position]],obj, nil];
    [objectList addObject:objArray];
    NSLog(@"%d",[objectList count]);
    
}

+(void)replaceObjectInList:(IsoBox *)obj
{

    for (NSArray* array in objectList) {
        if (array[1]== obj) {
            [objectList removeObject:array];
            NSArray* objArray=[[NSArray alloc]initWithObjects:[NSValue valueWithCGPoint:[IsoBackground gridNumber:obj.position]],obj, nil];
            [objectList addObject:objArray];
            break;
        }
    }

}

+(BOOL)checkCoordsInList:(CGPoint)point
{
    for (NSArray* array in objectList)
    {
        if (CGPointEqualToPoint([array[0] CGPointValue],point)) {
            return YES;
        }
    }
    return NO;

//    NSEnumerator *enumerator = [objectDict objectEnumerator];
//    NSValue *object;
//    
//    while ((object = [enumerator nextObject])) {
//        if (CGPointEqualToPoint([object CGPointValue],point)) {
//            NSLog(@"hit %p",&object);
//            return YES;
//            }
//    }
//    return NO;
}

+(CGPoint)getTileHeight
{
    CGPoint returntileh = CGPointMake(0, 16);
    return returntileh;
}

+(void)saveCoords
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    
    mapArray = [[NSMutableArray alloc]init];
    for (NSArray* array in objectList)
    {
        [mapArray addObject:[NSString stringWithFormat:@"%@",array[1]]];
        NSLog(@"%@",array[1]);
    }
    NSLog(@"Done saving");
    NSLog(@"%@",documentsDirectory);
    
    [mapArray writeToFile:[documentsDirectory stringByAppendingPathComponent:@"test.plist"] atomically:YES];
//    
//    NSMutableDictionary *dict1=[[NSMutableDictionary alloc]init];
//    
//    [dict1 setValue:mapArray forKey:@"Result"];
//    NSLog(@"%d",[dict1 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"test.plist"] atomically:YES]);
//    [dict1 release];
//    
}

+(void)loadCoords
{

//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *documentsDirectory = [path objectAtIndex:0];
//    mapArray = [NSMutableArray arrayWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"test.plist"]];
    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    mapArray = [NSMutableArray arrayWithContentsOfFile:file];
    for (NSString* coords in mapArray) {
        NSArray* coordArray = [coords componentsSeparatedByString:@","];
//        NSLog([NSString stringWithFormat:@"%f,%f,%@",[coordArray[0] floatValue],[coordArray[1] floatValue],coordArray[2]]);
        IsoBox*box = [[ParticleBox alloc] initWithPosition:ccp([coordArray[0] floatValue],[coordArray[1] floatValue]) inLayer:parentLayer withString:coordArray[2] withPlayer:charArray]; //passing in the pointer to the array
        [parentLayer addChild:box z:-[coordArray[1] integerValue]];
    }
    
    NSLog(@"%@",[IsoBackground isValidTile:ccp(256.000000,160.000000)] ? @"YES" : @"NO");
}


+(void)autoSpawn
{
    CGPoint randomPoint = [IsoBackground nearestPoint: ccp(arc4random_uniform(200),arc4random_uniform(200))];
    if ([IsoBackground isValidTile:randomPoint]) {
        Player*p=[[Player alloc] initWithPosition:[IsoBackground gridNumber:ccp(-3,7)] andLayer:parentLayer];
        [parentLayer addChild:p];
    
        if (!array) array = [p moveToward:ccp(256.000000,160.000000)];
        [charArray addObject:p];
        [p runPSA:array];
    }
    else NSLog(@"Can't place");
    //    CGPoint testRound = ccp(40,2);
    //    CCLabelTTF* label = [[CCLabelTTF alloc]initWithString:@"X" fontName:@"Helvetica" fontSize:40];
    //    label.color = ccRED;
    //    label.position = testRound;
    //    [parentLayer addChild:label];
    //    NSLog(@"test0:%@",NSStringFromCGPoint(testRound));
    //    NSLog(@"test1:%@",NSStringFromCGPoint(testRound));
    //
    //    testRound = [IsoBackground nearestPoint:testRound];
    //    NSLog(@"nearestTest:%@",NSStringFromCGPoint(testRound));
    //    NSLog(@"nearestTest:%@",NSStringFromCGPoint([IsoBackground nearestPoint:ccp(40,2)]));
    
}


+(BOOL)isValidTile:(CGPoint)point //takes in a rounded point
{
    if ([IsoBackground checkCoordsInList:point]) {
//        NSLog(@"You clicked on a block");
        return NO;
    }
    else return YES;

}
+(NSArray*)walkableAdjTilesCoord:(CGPoint)point
{
    NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:8];
    CGPoint invPoint = point;
    
    // Top
	CGPoint top = ccp(invPoint.x,invPoint.y+1);
	if ([IsoBackground isValidTile:top])
    {
		[tmpArray addObject:[NSValue valueWithCGPoint:top]];

    }
    // Bottom
    CGPoint bottom = ccp(invPoint.x,invPoint.y-1);
    if ([IsoBackground isValidTile:bottom])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:bottom]];
        
    }
	// Left
    CGPoint left = ccp(invPoint.x-1,invPoint.y);
    if ([IsoBackground isValidTile:left])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:left]];
        if ([IsoBackground isValidTile:top]) {
            CGPoint topleft = ccp(invPoint.x-1,invPoint.y+1);
            if ([IsoBackground isValidTile:topleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topleft]];
            }
        }
        if ([IsoBackground isValidTile:bottom]) {
            CGPoint bottomleft = ccp(invPoint.x-1,invPoint.y-1);
            if ([IsoBackground isValidTile:bottomleft]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomleft]];
            }
        }
    }

	// Right
    CGPoint right = ccp(invPoint.x+1,invPoint.y);
    if ([IsoBackground isValidTile:right])
    {
        [tmpArray addObject:[NSValue valueWithCGPoint:right]];
        if ([IsoBackground isValidTile:top]) {
            CGPoint topright = ccp(invPoint.x+1,invPoint.y+1);
            if ([IsoBackground isValidTile:topright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:topright]];
            }
        }
        if ([IsoBackground isValidTile:bottom]) {
            CGPoint bottomright = ccp(invPoint.x+1,invPoint.y-1);
            if ([IsoBackground isValidTile:bottomright]) {
                [tmpArray addObject:[NSValue valueWithCGPoint:bottomright]];
            }
        }
    }
    
    
	return [NSArray arrayWithArray:tmpArray];
    
}
-(void)dealloc
{
    [objectList dealloc];
    [super dealloc];
}
@end
