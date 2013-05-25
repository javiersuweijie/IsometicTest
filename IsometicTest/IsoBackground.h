//
//  IsoBackground.h
//  IsometicTest
//
//  Created by Javiersu on 7/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GLKit/GLKMatrix3.h>
#import "IsoBox.h"

@interface IsoBackground : CCLayer {

}
-(BOOL)gridDetect:(CGPoint)point;
-(id)initWithLayer:(CCLayer*)parentLayer;
+(CGPoint)coordTransform:(CGPoint)point;
+(CGPoint)coordInvTransform:(CGPoint)point;
+(CGPoint)nearestPoint:(CGPoint)point;
+(void)addObjectToList:(CCSprite*)obj;
+(void)replaceObjectInList:(CCSprite*)obj;
+(BOOL)checkCoordsInList:(CGPoint)point;
+(CGPoint)getTileHeight;
+(void)saveCoords;
+(void)loadCoords;
+(NSArray*)walkableAdjTilesCoord:(CGPoint)point;
+(CGPoint)gridNumber:(CGPoint)nPoint;
+(CGPoint)gridToCoord:(CGPoint)grid;
+(void)autoSpawn;
+(NSMutableArray*)getCharArray;
@end