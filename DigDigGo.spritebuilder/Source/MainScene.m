//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"


@implementation MainScene

- (void) startPlaying {
    
    CCScene *gameStart = [ CCBReader loadAsScene:@"Gameplay"];
    
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1.0f];
    [[CCDirector sharedDirector] presentScene:gameStart withTransition:transition];
}



@end
