//
//  ECGameScene
//  Blocks_Cocos
//
//  Created by Tsubasa on 13-9-1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class ECPauseScene;
@interface ECGameScene : CCSprite {
    ECPauseScene *_pauseScene;
}

+(CCScene *) scene;

@end
