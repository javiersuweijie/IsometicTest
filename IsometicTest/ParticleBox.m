//
//  ParticleBox.m
//  IsometicTest
//
//  Created by Javiersu on 10/5/13.
//
//

#import "ParticleBox.h"

@implementation ParticleBox

@synthesize emitter;

Player* player1;
NSMutableArray* array;

-(id)initWithPosition:(CGPoint)point inLayer:(CCLayer *)layer withString:(NSString *)string withPlayer:(NSMutableArray*)charArray
{
    emitter=[[CCParticleFire alloc]init];
    [emitter stopSystem];
    [super initWithPosition:point inLayer:layer withString:string];
    emitter.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    emitter.posVar = ccp(0,0);
    emitter.startSize = 5;
    emitter.totalParticles = 50;
    emitter.life = 1;
    emitter.speed = 50;
    emitter.positionType = kCCPositionTypeGrouped;
    array=charArray; //Passing a pointer to the array so it dynamically changes
    
    [self addChild:emitter];
    [self schedule:@selector(updateAngle:)];
    player1 = nil;
    return self;
}

-(void)updateAngle:(ccTime)dt
{
    if ([array count]>0) {
        player1=[array objectAtIndex:0];
        
        if (ccpDistance(self.position,player1.position)<75) {
            if (!emitter.active)[emitter resetSystem];
            player1.hp--;
        }
            else if (emitter.active) {
                [emitter stopSystem];
            }
            else;
        emitter.gravity = ccpSub(player1.position,self.position);
        emitter.angle = CC_RADIANS_TO_DEGREES(ccpAngleSigned(ccp(1,0),ccpSub(player1.position,self.position)));
    }
    else if (emitter.active) {
        [emitter stopSystem];
        player1=nil;
    }

}
//-(void)update:(ccTime)dt  CCParticleSystemQuad does not have update method
//{
//    NSLog(@"update");
//    [super update];
//}
@end
