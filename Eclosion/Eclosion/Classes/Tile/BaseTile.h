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
    TileProtoWalkable = 0,
    TileProtoWall     = 1,
    TileProtoJump     = 2,
    TileProtoLadder   = 3,
    TileProtoTrap     = 4,
    TileProtoEnd      = 5,
}TilePrototype;

@interface BaseTile : CCSprite {
    float           _tileWidth;
    float           _tileHeight;
    TilePrototype   _prototype;
}

@property(nonatomic, assign) float          tileWidth;
@property(nonatomic, assign) float          tileHeight;
@property(nonatomic, assign) TilePrototype  prototype;

@end
