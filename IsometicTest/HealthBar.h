//
//  HealthBar.h
//  IsometicTest
//
//  Created by Javiersu on 14/5/13.
//
//
#import "CCLayer.h"
#import "Player.h"
@interface HealthBar : CCLayer

@property int totalHp;
@property int currentHp;
@property (assign,nonatomic) Player* p;
-(id)initWithChar:(Player*)p;

@end
