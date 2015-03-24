//
//  Obstacle.m
//  DigDigGo
//
//  Created by Ignacio Alonso on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Obstacle.h"


@implementation Obstacle {
    
    CCNode *_skull;
    

}


#define ARC4RANDOM_MAX      0x100000000


// The obstacle minimum height position
static const CGFloat obstacleMinY = 40.f;

// The obstacle maximum height position 
static const CGFloat  obstacleMaxY= 501.f;


// random placement for the obstacles
- (void)setupRandomPosition {
    // value between 0.f and 1.f
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    // a range between the max and min possible obstacle positions
    CGFloat range =  obstacleMaxY - obstacleMinY;
    _skull.position = ccp(_skull.position.x, obstacleMinY + (random * range) - 10.f);
   
}


//activating collisions for the obstacles

-(void)didLoadFromCCB {
    
    _skull.physicsBody.collisionType = @"obstacle";
    _skull.physicsBody.sensor = TRUE;
}
@end
    
    
   
    




