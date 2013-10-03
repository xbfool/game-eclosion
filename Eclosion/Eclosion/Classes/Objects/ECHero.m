//
//  ECHero.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-3.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECHero.h"
#import "CCAnimationHelper.h"

#define EC_DEFAULT_SPEED 1;
static NSString* _filename[ECHeroActionCount] = { @"BombA",@"BombA",@"BombA"};

static const int _fileCount[ECHeroActionCount] = { 3,3,3};

static const float _fileDelay[ECHeroActionCount] = {0.3,0.3,0.3};

@implementation ECHero
@synthesize speed, animating, heroAction;

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
        [self moveHero:interval];
    }
}

- (void)moveHero:(ccTime)interval {
    CGPoint position = ccp(0,0);
    switch (self.heroDirection) {
        case ECHeroDirectionRight:
            position = ccp(1,0);
            break;
        case ECHeroDirectionLeft:
            position = ccp(-1,0);
            break;
        case ECHeroDirectionUp:
            position = ccp(0,1);
            break;
        case ECHeroDirectionDown:
            position = ccp(0,-1);
            break;
        default:
            break;
    }
    CCMoveBy *moveAction = [CCMoveBy actionWithDuration:interval position:position];
    [self runAction:moveAction];
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
