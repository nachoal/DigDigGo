//
//  Collectable.m
//  DigDigGo
//
//  Created by Ignacio Alonso on 7/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Collectable.h"

@implementation Collectable {

CCNode *_golden;

}

-(void)didLoadFromCCB

{
    
   
        
        _golden.physicsBody.collisionType = @"gold";
        _golden.physicsBody.sensor = TRUE;

}



@end
