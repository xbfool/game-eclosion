//
//  ECHero.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-3.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECHero.h"
#import "CCAnimationHelper.h"

#define EC_DEFAULT_SPEED 1
#define EC_MAX_SPEED 0.2
#define RUN_ACTION_TAG 9
#define PUSH_ACTION_TAG 10

static NSString* _filename[ECHeroActionCount] = { @"BombA",@"BombA",@"BombA"};

static const int _fileCount[ECHeroActionCount] = { 3,3,3};

static const float _fileDelay[ECHeroActionCount] = {0.3,0.3,0.3};

@implementation ECHero

- (id)init {
    if ( self = [super init]) {
        self.heroAction = ECHeroActionDefault;
        self.speed = EC_DEFAULT_SPEED;
        self.anchorPoint = ccp(0.5,0.5);
        self.direction = ECDirectionNone;
        self.x = self.position.x;
        self.y = self.position.y;
        self.tileW = ECTileSize;
        self.tileH = ECTileSize;
        
        [self run];
    }
    return self;
}

- (void)fpsUpdate:(ccTime)interval {
}

- (void)fixUpdate:(ccTime)interval {
}

- (void)step:(ccTime)interval {
}


- (id)getAction:(ECHeroAction)index {
    
    id seq;
    CCAnimation *anim = [CCAnimation animationWithFile:_filename[index]
                                             frameCount:_fileCount[index]
                                                  delay:_fileDelay[index]];
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    
    // 默认走路动画
    if ( index == ECHeroActionDefault ) {
        seq = [CCRepeatForever actionWithAction:animate];
        
    } else {
    // 其它特效动画
        seq = [CCSequence actions:animate,
               [CCCallFunc actionWithTarget:self selector:@selector(callback)],nil];
    }
    return seq;
}


- (void)run {
    // reset to default action
    [self stopAllActions];
    self.heroAction = ECHeroActionDefault;
    id action = [self getAction:self.heroAction];
    [self runAction:action];
}

- (void)callback {
    self.animating = NO;
    [self run];
}

@end
