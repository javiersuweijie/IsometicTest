//
//  ParticleBox.h
//  IsometicTest
//
//  Created by Javiersu on 10/5/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IsoBox.h"

@interface ParticleBox : IsoBox {
}
@property (strong,nonatomic) CCParticleFire* emitter;
- (id)initWithPosition:(CGPoint)point inLayer:(CCLayer *)layer withString:(NSString *)string withPlayer:(NSMutableArray *)charArray;

@end
