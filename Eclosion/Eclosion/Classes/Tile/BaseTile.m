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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint cur = [touch locationInView:[touch view]];
    cur = [[CCDirector sharedDirector] convertToGL:cur];
    CGPoint pre = [touch previousLocationInView:[touch view]];
    pre = [[CCDirector sharedDirector] convertToGL:pre];
    self.position = ccp(self.position.x + (cur.x - pre.x), self.position.y + (cur.y - pre.y));
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}
@end
