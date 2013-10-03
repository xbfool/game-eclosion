//
//  BaseTile.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "BaseTile.h"


@implementation BaseTile
@synthesize tileHeight = _tileHeight;
@synthesize tileWidth  = _tileWidth;
@synthesize prototype  = _prototype;

- (id)init {
    if ( self = [super init]) {
        self.anchorPoint = ccp(0,0);
    }
    return self;
}

@end
