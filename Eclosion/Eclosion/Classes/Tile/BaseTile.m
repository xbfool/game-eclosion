//
//  BaseTile.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "BaseTile.h"

#define RUN_ACTION_TAG 9
#define ITEM_SPEED 0.1 // 道具移动一格需要的时间

@implementation BaseTile
@synthesize tileHeight = _tileHeight;
@synthesize tileWidth  = _tileWidth;
@synthesize prototype  = _prototype;
@synthesize forceDirection = _forceDirection;
@synthesize direction;
@synthesize animating;
@synthesize movebal;

- (id)init {
    if ( self = [super init]) {
        self.anchorPoint = ccp(0,0);
        self.forceDirection = ECDirectionNone;
        self.movebal = NO;
        self.direction = ECDirectionNone;
    }
    return self;
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGRect myRect = CGRectMake(self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
                                                                
    return CGRectContainsPoint(myRect, location);
}

- (void)setForceDirection:(ECDirection)aForceDirection {
    if ( ! movebal ) return;
    
    if ( (_forceDirection != ECDirectionNone) && (aForceDirection != ECDirectionNone) ) return;

    if ((aForceDirection == ECDirectionNone ) || (self.alowingDirection & aForceDirection)) {
        _forceDirection = aForceDirection;
    }
}

- (void)setMovebal:(BOOL)amovebal {
    movebal = amovebal;
    if ( movebal ) {
        [[[CCDirector sharedDirector] touchDispatcher]
         addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
}

- (void)pushByStep:(int)step {
    if ( self.animating ) return;
    self.animating = YES;
    
    CGPoint position = ccp(0,0);
    switch (self.forceDirection) {
        case ECDirectionRight:
            position = ccp( step * ECTileSize, 0);
            break;
        case ECDirectionLeft:
            position = ccp(-1 * step * ECTileSize, 0);
            break;
        case ECDirectionUp:
            position = ccp(0, step * ECTileSize);
            break;
        case ECDirectionDown:
            position = ccp(0, -1 * step * ECTileSize);
            break;
        default:
            break;
    }
    CCMoveBy *moveAction = [CCMoveBy actionWithDuration:ITEM_SPEED * step position:position];
    CCSequence *squence = [CCSequence actions:moveAction,
                           [CCCallBlock actionWithBlock:^{ self.animating = NO; self.direction = ECDirectionNone; }], nil];
    squence.tag = RUN_ACTION_TAG;
    self.direction = self.forceDirection;
    [self runAction:squence];
}

#pragma Touch Delegate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([self containsTouchLocation:touch]) {
        _beginPoint = [touch locationInView:[touch view]];
        _beginPoint = [[CCDirector sharedDirector] convertToGL:_beginPoint];
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_forceDirection != ECDirectionNone) return;
    
    CGPoint endPoint = [touch locationInView:[touch view]];
    endPoint = [[CCDirector sharedDirector] convertToGL:endPoint];
    //self.position = ccp(self.position.x + (cur.x - pre.x), self.position.y + (cur.y - pre.y));
    float x = endPoint.x - _beginPoint.x;
    float y = endPoint.y - _beginPoint.y;
    if ( x*x > y*y ) {
        if ( x > 0 ) {
            self.forceDirection = ECDirectionRight;
        } else {
            self.forceDirection = ECDirectionLeft;
        }
    } else {
        if ( y > 0 ) {
            self.forceDirection = ECDirectionUp;
        } else {
            self.forceDirection = ECDirectionDown;
        }
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}
@end
