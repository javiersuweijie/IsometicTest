//
//  ShortestPathStep.h
//  IsometicTest
//
//  Created by Javiersu on 4/4/13.
//
//

#import <Foundation/Foundation.h>

@interface ShortestPathStep : NSObject
{
    CGPoint position;
    int gScore;
    int hScore;
    ShortestPathStep *parent;
}

@property (nonatomic,assign)CGPoint position;
@property (nonatomic,assign)int gScore;
@property (nonatomic,assign)int hScore;
@property (nonatomic,assign)ShortestPathStep *parent;

-(id)initWithPosition:(CGPoint)pos;
-(int)fScore;


@end
