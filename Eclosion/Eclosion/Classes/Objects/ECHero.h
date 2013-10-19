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
    
}

@property(nonatomic, assign) int             speed;
@property(nonatomic, assign) bool            animating;
@property(nonatomic, assign) bool            running;
@property(nonatomic, assign) ECHeroAction    heroAction;
@property(nonatomic, assign) ECDirection     direction;

- (void)run;
- (void)step:(ccTime)interval;
@end
