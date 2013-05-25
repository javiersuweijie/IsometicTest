//
//  GameScene.h
//  IsometicTest
//
//  Created by Javiersu on 6/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "IsoBackground.h"
#import "Menu.h"
#import "ParticleBox.h"
#import "ShortestPathStep.h"
#import "IsoBox.h"

@interface GameScene : CCLayer <UIGestureRecognizerDelegate> {
    
}
+(CCScene*) scene;
@end
