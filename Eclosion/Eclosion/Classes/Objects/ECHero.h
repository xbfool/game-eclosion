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

#define HERO_ANIM_DUR 2

typedef enum {
    ECHeroActionDefault = 0,
    ECHeroActionSuccess,
    ECHeroActionFailure,
    ECHeroActionDizz,
    ECHeroActionShock,
    ECHeroActionCount // MUST be last one
} ECHeroAction;

@interface ECHero : BaseTile {

}

@property(nonatomic, assign) bool            pushing; // 被推
@property(nonatomic, assign) ECHeroAction    heroAction;

- (void)run;
- (void)trap;
- (void)fly;
- (void)dizz;
- (void)shock;
@end
