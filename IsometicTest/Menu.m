//
//  Menu.m
//  IsometicTest
//
//  Created by Javiersu on 31/3/13.
//
//

#import "Menu.h"

@implementation Menu
CCSprite *redBox;
CCSprite *blueBox;
NSString* currentSelection;
-(id)init {
    if ([super initWithFile:@"Icons-01.png"]) {
        self.anchorPoint = CGPointMake(1,1);
        self.position =  CGPointMake(480,320);
        redBox = [[CCSprite alloc]initWithFile:@"redbox.png"];
        redBox.scale=2.0;
        redBox.isTouchEnabled=YES;
        redBox.position=ccp(self.contentSize.width/2,self.contentSize.height/5);
        [self addChild:redBox];
        self.isTouchEnabled = YES;
        
        blueBox = [[CCSprite alloc]initWithFile:@"bluebox.png"];
        blueBox.scale=2.0;
        blueBox.isTouchEnabled=YES;
        blueBox.position=ccp(self.contentSize.width/2,self.contentSize.height/5*2);
        [self addChild:blueBox];
        
        UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRedTapGesture:)];
        tapGestureRecognizer.delegate = self;
        [redBox addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        UIGestureRecognizer *blueTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBlueTapGesture:)];
        blueTapGestureRecognizer.delegate = self;
        [blueBox addGestureRecognizer:blueTapGestureRecognizer];
        [blueTapGestureRecognizer release];
        
        CCLabelTTF* saveText = [[CCLabelTTF alloc]initWithString:@"Save" fontName:@"Helvetica" fontSize:20];
        saveText.position = ccp(self.contentSize.width/2,self.contentSize.height/5*3);
        CCSprite* saveBox = [[CCSprite alloc]initWithFile:@"bluebox.png"];
        saveBox.scale=1.0;
        saveBox.isTouchEnabled=YES;
        saveBox.position=ccp(self.contentSize.width/2,self.contentSize.height/5*3);
        [self addChild:saveBox];
        [self addChild:saveText];
        
        UIGestureRecognizer *saveTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSaveTapGesture:)];
        saveTapGestureRecognizer.delegate = self;
        [saveBox addGestureRecognizer:saveTapGestureRecognizer];
        [saveTapGestureRecognizer release];
        
        CCLabelTTF* loadText = [[CCLabelTTF alloc]initWithString:@"Load" fontName:@"Helvetica" fontSize:20];
        loadText.position = ccp(self.contentSize.width/2,self.contentSize.height/5*3.5);
        CCSprite* loadBox = [[CCSprite alloc]initWithFile:@"redbox.png"];
        loadBox.scale=1.0;
        loadBox.isTouchEnabled=YES;
        loadBox.position=ccp(self.contentSize.width/2,self.contentSize.height/5*3.5);
        [self addChild:loadBox];
        [self addChild:loadText];
        
        UIGestureRecognizer *loadTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLoadTapGesture:)];
        loadTapGestureRecognizer.delegate = self;
        [loadBox addGestureRecognizer:loadTapGestureRecognizer];
        [loadTapGestureRecognizer release];
        
        CCLabelTTF* spawnText = [[CCLabelTTF alloc]initWithString:@"Spawn" fontName:@"Helvetica" fontSize:20];
        spawnText.position = ccp(self.contentSize.width/2,self.contentSize.height/5*4);
        CCSprite* spawnBox = [[CCSprite alloc]initWithFile:@"bluebox.png"];
        spawnBox.scale=1.0;
        spawnBox.isTouchEnabled=YES;
        spawnBox.position=ccp(self.contentSize.width/2,self.contentSize.height/5*4);
        [self addChild:spawnBox];
        [self addChild:spawnText];
        
        UIGestureRecognizer *spawnTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpawnTapGesture:)];
        spawnTapGestureRecognizer.delegate = self;
        [spawnBox addGestureRecognizer:spawnTapGestureRecognizer];
        [spawnTapGestureRecognizer release];
        
        currentSelection=nil;
    }
    return self;
}

-(void)handleRedTapGesture:(UITapGestureRecognizer*)tapGesture
{
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    if ([currentSelection isEqualToString:@"redbox"]) {
        currentSelection = nil;
    }
    else {
        currentSelection = @"redbox";
        NSLog(@"red box now");
    }
}
-(void)handleBlueTapGesture:(UITapGestureRecognizer*)tapGesture
{
    CGPoint touchLocation = [tapGesture locationInView:[tapGesture view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    if ([currentSelection isEqualToString:@"bluebox"]) {
        currentSelection = nil;
    }
    else {
        currentSelection = @"bluebox";
        NSLog(@"blue box now");
    }
}

-(void)handleSaveTapGesture:(UITapGestureRecognizer*)tapGesture
{
    [IsoBackground saveCoords];
//    [IsoBackground loadCoords];
    [self.parent.parent removeChildByTag:10 cleanup:YES];
}

-(void)handleLoadTapGesture:(UITapGestureRecognizer*)tapGesture
{
    //    [IsoBackground saveCoords];
    [IsoBackground loadCoords];
    [self.parent.parent removeChildByTag:10 cleanup:YES];
}

-(void)handleSpawnTapGesture:(UITapGestureRecognizer*)tapGesture
{
    [IsoBackground autoSpawn];
}

-(NSString*)currentSelection
{
    if (!currentSelection) {
        return nil;
    }
    else {
        return currentSelection;
    }
}
@end
