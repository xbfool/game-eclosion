//
//  BaseTile.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "BaseTile.h"

#define RUN_ACTION_TAG 9
#define ITEM_SPEED 0.2 // 道具移动一格需要的时间

@implementation BaseTile

- (id)init {
    if ( self = [super init]) {
        self.anchorPoint = ccp(0.5,0.5);
        self.forceDirection = ECDirectionNone;
        self.movebal = NO;
        self.direction = ECDirectionNone;
    }
    return self;
}

- (void)fpsUpdate:(ccTime)interval {

}

- (void)fixUpdate:(ccTime)interval {

}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGRect myRect = CGRectMake(self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
                                                                
    return CGRectContainsPoint(myRect, location);
}

- (void)setForceDirection:(ECDirection)aForceDirection {
    if ( ! _movebal ) return;
    
    if ( (_forceDirection != ECDirectionNone) && (aForceDirection != ECDirectionNone) ) return;

    if ((aForceDirection == ECDirectionNone ) || (self.alowingDirection & aForceDirection)) {
        _forceDirection = aForceDirection;
    }
}

- (void)setMovebal:(BOOL)amovebal {
    _movebal = amovebal;
    if ( _movebal ) {
        [[[CCDirector sharedDirector] touchDispatcher]
         addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
}

// 获取四个角的坐标
- (NSArray *)getCorners {
    return nil;
}

// 获取移动方向单位向量
- (CGPoint)getVectorForDirection:(ECDirection)direction {
    CGPoint vector = ccp(0,0);
    switch (direction) {
        case ECDirectionRight:
            vector = ccp (1, 0);
            break;
        case ECDirectionLeft:
            vector = ccp (-1, 0);
            break;
        case ECDirectionUp:
            vector = ccp (0, 1);
            break;
        case ECDirectionDown:
            vector = ccp (0, -1);
            break;
        default:
            break;
    }
    return vector;
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
