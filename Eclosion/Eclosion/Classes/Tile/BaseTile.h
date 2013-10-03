//
//  BaseTile.h
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    TileMapWalkable = 0,
    TileMapWall     = 1,
    TileMapJump     = 2,
    TileMapLadder   = 3,
    TileMapTrap     = 4,
    TileMapEnd      = 5,
}TileMaptype;

@interface BaseTile : CCSprite {
    float           _tileWidth;
    float           _tileHeight;
    TileMaptype   _prototype;
}

@property(nonatomic, assign) float          tileWidth;
@property(nonatomic, assign) float          tileHeight;
@property(nonatomic, assign) TileMaptype  prototype;

@end
