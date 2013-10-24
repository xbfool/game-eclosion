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

typedef enum {
    ECDirectionNone     = 0,
    ECDirectionRight    = 0x00000001,
    ECDirectionLeft     = 0x00000010,
    ECDirectionUp       = 0x00000100,
    ECDirectionDown     = 0x00001000,
} ECDirection;

@interface BaseTile : CCSprite<CCTargetedTouchDelegate> {
    float           _tileWidth;
    float           _tileHeight;
    CGPoint         _beginPoint;
    TileMaptype     _prototype;
    ECDirection     _forceDirection;
}

@property(nonatomic, assign) float          tileWidth;
@property(nonatomic, assign) float          tileHeight;
@property(nonatomic, assign) TileMaptype    prototype;
@property(nonatomic, assign) ECDirection    forceDirection;
@property(nonatomic, assign) ECDirection    direction;
@property(nonatomic, assign) BOOL           animating;
@property(nonatomic, assign) BOOL           movebal;
@property(nonatomic, assign) int            alowingDirection;

- (void)pushByStep:(int)step;

@end
