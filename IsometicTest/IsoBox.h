//
//  IsoBox.h
//  IsometicTest
//
//  Created by Javiersu on 15/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface IsoBox : CCSprite <UIGestureRecognizerDelegate> {
}
@property CGPoint temp;
@property NSString* name;

-(id)initWithPosition:(CGPoint)point inLayer:(CCLayer*)layer withString:(NSString*)string;
-(id)initFromSave:(CGPoint)point withString:(NSString*)string;
    
@end
