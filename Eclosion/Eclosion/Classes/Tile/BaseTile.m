//
//  BaseTile.m
//  Eclosion
//
//  Created by Tsubasa on 13-10-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "BaseTile.h"

#define RUN_ACTION_TAG 9
#define ITEM_SPEED 4 // 每帧移动的距离

@implementation BaseTile

- (id)init {
    if ( self = [super init]) {
        self.anchorPoint = ccp(0.5,0.5);
        self.forceDirection = ECDirectionNone;
        self.movebal = NO;
        self.walkball = YES;
        self.direction = ECDirectionNone;
        self.speed = ITEM_SPEED;
    }
    return self;
}

- (void)setMyTexture:(CCTexture2D *)texture {
    // Set texture
    [self setTexture: texture];
    CGRect rect = CGRectZero;
    rect.size = texture.contentSize;
    [self setTextureRect:rect];
}

- (void)setTextureFile:(NSString *)file highlight:(NSString *)highlightFile {
    _texture = [[[CCTextureCache sharedTextureCache] addImage:file] retain];
    _highlightTexture = [[[CCTextureCache sharedTextureCache] addImage:highlightFile] retain];
    [self setMyTexture:_texture];
}

- (void)dealloc {
    [_texture release];
    [_highlightTexture release];
    [super dealloc];
}

- (void)fpsUpdate:(ccTime)interval {
    
}

- (void)fixUpdate:(ccTime)interval {
    self.tileX = _x / ECTileSize;
    self.tileY = _y / ECTileSize;
}

bool CCRectContainsPoint(CGRect rect, CGPoint point) {
    return ((point.x >= rect.origin.x ) && ( point.x <= ( rect.origin.x + rect.size.width )) &&
             (point.y >= rect.origin.y ) && ( point.y <= ( rect.origin.y + rect.size.height )));
}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if ( [self.parent isKindOfClass:[CCSprite class]] ) {
        location.x -= ((CCSprite *)self.parent).position.x;
        location.y -= ((CCSprite *)self.parent).position.y;
    }
    
    CGRect myRect = CGRectMake(_x - _tileW/2, _y - _tileH/2, self.contentSize.width, self.contentSize.height);
    return CCRectContainsPoint(myRect, location);
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


#pragma Touch Delegate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([self containsTouchLocation:touch]) {
        _beginPoint = [touch locationInView:[touch view]];
        _beginPoint = [[CCDirector sharedDirector] convertToGL:_beginPoint];
        
        [self setMyTexture:_highlightTexture];
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
    [self setMyTexture:_texture];
}
@end
