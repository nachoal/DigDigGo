//
//  gameOverPop.m
//  DigDigGo
//
//  Created by Ignacio Alonso on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "gameOverPop.h"

@implementation gameOverPop {
    
    
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highscoreLabel;
}

-(void) newGame {
    CCScene *gameplay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplay];
    
}

@end
