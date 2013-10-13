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
#define RUN_ACTION_TAG 9

static NSString* _filename[ECHeroActionCount] = { @"BombA",@"BombA",@"BombA"};

static const int _fileCount[ECHeroActionCount] = { 3,3,3};

static const float _fileDelay[ECHeroActionCount] = {0.3,0.3,0.3};

@implementation ECHero
@synthesize speed, animating, heroAction, running;

- (id)init {
    if ( self = [super init]) {
        self.heroAction = ECHeroActionDefault;
        self.speed = EC_DEFAULT_SPEED;
        self.anchorPoint = ccp(0,0);
    }
    return self;
}

- (void)step:(ccTime)interval {
    if ( self.animating ) return;
    if ( self.heroAction != ECHeroActionDefault ) {
        self.animating = YES;
        [self stopAllActions];
        id action = [self getAction:self.heroAction];
        [self runAction:action];
    } else {
        // 移动
        if ( !self.running ) {
            self.running = YES;
            [self moveHero];
        }
    }
}

- (void)setDirection:(ECDirection)aDirection {
    _direction = aDirection;
    [self stopActionByTag:RUN_ACTION_TAG];
    self.running = NO;
    [self moveHero];
}

- (void)moveHero {
    CGPoint position = ccp(0,0);
    switch (self.direction) {
        case ECDirectionRight:
            position = ccp(speed,0);
            break;
        case ECDirectionLeft:
            position = ccp(-1*speed,0);
            break;
        case ECDirectionUp:
            position = ccp(0,speed);
            break;
        case ECDirectionDown:
            position = ccp(0,-1*speed);
            break;
        default:
            break;
    }
    CCMoveBy *moveAction = [CCMoveBy actionWithDuration:0.1 position:position];
    CCSequence *squence = [CCSequence actions:moveAction,
                  [CCCallBlock actionWithBlock:^{ self.running = NO; }], nil];
    squence.tag = RUN_ACTION_TAG;
    [self runAction:squence];
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
