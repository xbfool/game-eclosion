//
//  ECHero.h
//  Eclosion
//
//  Created by Tsubasa on 13-10-3.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BaseTile.h"

typedef enum {
    ECHeroActionDefault = 0,
    ECHeroActionJump,
    ECHeroActionSuccess,
    ECHeroActionFailure,
    ECHeroActionCount // MUST be last one
} ECHeroAction;

@interface ECHero : CCSprite {
    float _x;
    float _y;
}

@property(nonatomic, assign) float             speed; // 像素 / 秒
@property(nonatomic, assign) bool            animating;
@property(nonatomic, assign) bool            running; // 移动
@property(nonatomic, assign) bool            pushing; // 被推
@property(nonatomic, assign) ECHeroAction    heroAction;
@property(nonatomic, assign) ECDirection     direction;
@property(nonatomic, assign) ECDirection     pushDirection;

- (void)run;
- (void)fpsUpdate:(ccTime)interval;
- (void)fixUpdate:(ccTime)interval;

@end
