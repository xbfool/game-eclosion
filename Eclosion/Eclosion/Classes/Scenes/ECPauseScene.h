//
//  ECPauseScene.h
//  Eclosion
//
//  Created by Tsubasa on 13-9-4.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol ECPauseSceneDelegate <NSObject>
@required
-(void) resumeGame;
-(void) restartGame;
-(void) gotoLevelScene;
-(void) gotoMenuScene;
@end

@interface ECPauseScene : CCSprite {
    
}

@property (nonatomic, retain) id delegate;

+(CCScene *) scene;

@end
