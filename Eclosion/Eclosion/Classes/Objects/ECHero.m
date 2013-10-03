//
//  ECHero.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-3.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECHero.h"
#import "CCAnimationHelper.h"


static NSString* _filename[ECHeroActionCount] = {
    @"BombA1",@"BombA1",@"BombA1"};

static const int _fileCount[ECHeroActionCount] = {
    3,3,3};

static const float _fileDelay[ECHeroActionCount] = {
    0.3,0.3,0.3};

@implementation ECHero
@synthesize speed;

- (id)init {
    if ( self = [super init]) {
        
    }
    return self;
}

- (void)loadResource:(int)index {
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    int i = 0;
    while ( i < index - 1 ) {
        [frameCache removeSpriteFramesFromFile:_girlframeName[i++]];
    }
    for ( ; i <= min(index+1, BODY_COUNT - 1); i++ ) {
        [frameCache addSpriteFramesWithFile:_girlframeName[i]];
        NSString *fname = [NSString stringWithFormat:@"%@0.png",_girlfilename[i][0]];
        [CCSprite spriteWithSpriteFrameName:fname];
    }
}

- (void)step {
    if ( animating ) return;
    if ( self.heroAction != ECHeroActionDefault ) {
        self.animating = YES;
        [self stopAllActions];
        id action = [self getAction:self.heroAction];
        [self runAction:action];
    }
}

- (id)getAction:(ECHeroAction)index {
    id seq;
    CCAnimation *anim = [CCAnimation animationWithFrame:_filename[index]
                                             frameCount:_fileCount[index]
                                                  delay:_fileDelay[index]];
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    
    if ( index == ECHeroActionDefault ) {
        seq = [CCRepeatForever actionWithAction:animate];
    } else {
        seq = [CCSequence actions:animate,
               [CCCallFunc actionWithTarget:self selector:@selector(callback)],nil];
    }
    return seq;
}


- (void)runDefaultAction {
    // reset to default action
    [self stopAllActions];
    self.heroAction = ECHeroActionDefault;
    id action = [self getAction:self.heroAction];
    [self runAction:action];
}

- (void)callback {
    self.animating = NO;
    [self runDefaultAction];
}

@end
