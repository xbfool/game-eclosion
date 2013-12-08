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
#define EC_MAX_SPEED 5
#define RUN_ACTION_TAG 9
#define PUSH_ACTION_TAG 10

static NSString* _filename[ECHeroActionCount] = { @"BombA",@"animation_fly_",
    @"animation_trap_", @"animation_zz_", @"animation_shock_"};

static const int _fileCount[ECHeroActionCount] = { 5, 3, 3, 3, 3};

static const float _fileDelay[ECHeroActionCount] = {0.3,0.3,0.3,0.3,0.3};

@implementation ECHero
@synthesize direction;

- (id)init {
    if ( self = [super init]) {
        self.heroAction = ECHeroActionDefault;
        self.speed = EC_DEFAULT_SPEED;
        self.anchorPoint = ccp(0.5,0.5);
        self.direction = ECDirectionNone;
        self.prototype = TileMapHero;
        self.x = self.position.x;
        self.y = self.position.y;
        self.tileW = ECTileSize;
        self.tileH = ECTileSize;
        [self run];
    }
    return self;
}

- (void)fixUpdate:(ccTime)interval {
    [super fixUpdate:interval];

}

- (void)fpsUpdate:(ccTime)interval {
    [super fpsUpdate:interval];
    
}

- (void)setDirection:(ECDirection)aDirection {
    // Context转向
    if (( direction == ECDirectionLeft || direction == ECDirectionNone ) && ( aDirection == ECDirectionRight )) {
        self.scaleX = -1.f;
    }
    if (( direction == ECDirectionRight || direction == ECDirectionNone ) && ( aDirection == ECDirectionLeft )) {
        self.scaleX = 1.f;
    }
        
    // 逻辑转向
    direction = aDirection;
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

- (void)trap {
    [self stopAllActions];
    self.scaleX = 1.f;
    self.heroAction = ECHeroActionFailure;
    id action = [self getAction:self.heroAction];
    [self runAction:action];
    
    id scale = [CCScaleTo actionWithDuration:0.3 scale:2];
    [self runAction:scale];
}

- (void)fly {
    [self stopAllActions];
    self.scaleX = 1.f;
    self.heroAction = ECHeroActionSuccess;
    id action = [self getAction:self.heroAction];
    [self runAction:action];
    
    id scale = [CCScaleTo actionWithDuration:HERO_ANIM_DUR scale:3];
    [self runAction:scale];
    
    id move = [CCMoveTo actionWithDuration:HERO_ANIM_DUR position:ccp(WINSIZE.width/2, WINSIZE.height/2)];
    [self runAction:move];
}

- (void)dizz {
    [self stopAllActions];
    self.heroAction = ECHeroActionDizz;
    id action = [self getAction:self.heroAction];
    [self runAction:action];
}

- (void)shock {
    [self stopAllActions];
    self.heroAction = ECHeroActionShock;
    id action = [self getAction:self.heroAction];
    [self runAction:action];
}

- (void)callback {
    if ( self.heroAction == ECHeroActionSuccess ) {
        [self removeFromParentAndCleanup:YES];
    }
}

@end
