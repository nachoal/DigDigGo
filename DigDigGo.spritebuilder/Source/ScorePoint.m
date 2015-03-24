//
//  ScorePoint.m
//  DigDigGo
//
//  Created by Ignacio Alonso on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ScorePoint.h"

@implementation ScorePoint


-(void)didLoadFromCCB {
    
    self.physicsBody.collisionType = @"goal";
    self.physicsBody.sensor = TRUE;
}

@end
