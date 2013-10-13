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
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}
@end
