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
@class ECTileMap;
@interface ECGameScene : CCSprite {
    ECPauseScene *_pauseScene;
    ECTileMap    *_map;
}

+(CCScene *) scene;
- (void)fpsUpdate:(ccTime)interval;
- (void)fixUpdate:(ccTime)interval;
@end
