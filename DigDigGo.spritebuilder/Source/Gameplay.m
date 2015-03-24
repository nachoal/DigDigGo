//
//  Gameplay.m
//  DigDigGo
//
//  Created by Ignacio Alonso on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Obstacle.h"
#import "gameOverPop.h"
#import "Collectable.h"


             CGFloat _scrollingSpeed = 200.f;
static const CGFloat firstObstaclePos = 280.f;
static const CGFloat firstCollectablePos = 0.f;
static const CGFloat distanceBetweenObstacles = 160.f;
static const CGFloat distanceBetweenCollectables = 290.f;



BOOL _gameOver;





@implementation Gameplay {
    
    CCSprite *_mole;
    CCPhysicsNode *_physicsNode;
    
    //--- grounds --- //
    CCNode *_ground1;
    CCNode *_ground2;
    CCNode *_ground3;
    CCNode *_ground4;
    CCNode *_ground5;
    CCNode *_ground6;
    CCNode *_ground7;
    CCNode *_ground8;
    CCNode *_ground9;
    CCNode *_ground10;
    
    //--- Scenes --- //
    CCNode *_scene1;
    CCNode *_scene2;
    
  
    CCButton *_restartButton;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_goldLabel;
    CCLabelTTF *_highscoreLabel;
    
    
    
    NSArray *_scenes;
    NSArray *_grounds;
    NSMutableArray *_obstacles;
    NSMutableArray *_collectables;
    
    NSArray *_obstacleYPosition;
    NSInteger _points;
    NSInteger _goldPoints;
    
    UISwipeGestureRecognizer * swipeUp, *swipeDown;
   
    
}


-(void)didLoadFromCCB {
    
    
    
    // variable declaration for the scrolling speed
    
    _scrollingSpeed = 300.f;
    
    self.userInteractionEnabled = TRUE;
    
    // Array for the scenery
    
    _scenes = @[_scene1,_scene2];

    
    // array of the different sprites for the grounds that are  in the level
    
    _grounds = @[_ground1,_ground2, _ground3, _ground4,_ground5,_ground6,_ground7,_ground8,_ground9,_ground10];
    
    
        
    _physicsNode.collisionDelegate = self;
    
    // set the collision type
    
    _mole.physicsBody.collisionType = @"mole";
    

    
    
    // load the swipe up gesture recognizer
    
    swipeUp =
    
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp; [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    
    // load the swipe down gesture recognizer
    
    swipeDown =
    
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown; [[[CCDirector sharedDirector]view] addGestureRecognizer:swipeDown];
 

    
    // spawn 3 obstacles at the beginning
    _obstacles = [NSMutableArray array];
    [self ObstacleGeneration];
    [self ObstacleGeneration];
    [self ObstacleGeneration];
    
    //Spawn the collectables 
    _collectables = [NSMutableArray array];
    [self collectableGeneration];
    [self collectableGeneration];
    
    
    
    
   
}


// ---- Gesture and controll methods ----- //

- (void)swipeUp {
    
    
    if (_mole.position.y <= 500.0)
    
    {
        
        _mole.position = ccp(_mole.position.x + 2.f, _mole.position.y + 120.5);
        
        CCParticleSystem *diggingUp = (CCParticleSystem *) [CCBReader load: @"Digging"];
        
        // Remove the animation when finishing playing
        
        diggingUp.autoRemoveOnFinish = TRUE;
        
        // make the animation load in te position of the mole
        
        diggingUp.position = _mole.position;
        
        // make the mole the parent of the animation
        
        [_mole.parent addChild:diggingUp];
    }
    
  
}

- (void)swipeDown {
    
    
    if (_mole.position.y >= 120.0) {
        
        _mole.position = ccp(_mole.position.x + 2.f, _mole.position.y - 115.5);
        
        CCParticleSystem * diggingDown = (CCParticleSystem *) [CCBReader load:@"Digging"];
        
        diggingDown.autoRemoveOnFinish = TRUE;
        
        diggingDown.position = _mole.position;
        
        [_mole.parent addChild:diggingDown];
    }
    

    
}



#pragma mark - gameplay movement

-(void)update:(CCTime)delta
{
    
    
    _mole.position = ccp(_mole.position.x + delta * _scrollingSpeed, _mole.position.y);

    _physicsNode.position = ccp(_physicsNode.position.x - (delta * _scrollingSpeed), _physicsNode.position.y);
    
    for (CCNode *ground in _grounds)
    {
        
        ground.positionType = CCPositionTypePoints;
        
        CGPoint groundWorldPosition = [ _physicsNode convertToWorldSpace:ground.position];
        
       
        
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width))
        {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    

    
     }
    
    
    for (CCNode *scene in _scenes)
    {
        scene.positionType = CCPositionTypePoints;
        
        CGPoint sceneWorldPosition = [_physicsNode convertToWorldSpace:scene.position];
        
        CGPoint sceneScreenPosition = [self convertToNodeSpace:sceneWorldPosition];
        
        if (sceneScreenPosition.x <=  ( -1 * scene.contentSize.width))
        {
            scene.position = ccp(scene.position.x+ 2 * scene.contentSize.width, scene.position.y);
        }
    }
    
    
   
    // Obstacle elimination and respawing
   
    NSMutableArray *offscreenObstacles = nil;
    for (CCNode *obstacle in _obstacles) {
        CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:obstacle.position];
        
        CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];
        
        if (obstacleScreenPosition.x < -obstacle.contentSize.width) {
            if (!offscreenObstacles) {
                offscreenObstacles = [NSMutableArray array];
            }
            
            [offscreenObstacles addObject:obstacle];
            
            
        }
    }
    
    for (CCNode *obstacleToRemove in offscreenObstacles) {
        [obstacleToRemove removeFromParent];
        [_obstacles removeObject:obstacleToRemove];
        [self ObstacleGeneration];
    }
    
    
    // Collectables to respawn
    
    NSMutableArray *offscreenCollectables = nil;
    for (CCNode *collectable in _collectables) {
        
        CGPoint collectableWorldPosition = [_physicsNode convertToWorldSpace:collectable.position];
        
        CGPoint collectableScreenPosition = [self convertToNodeSpace:collectableWorldPosition];
        
        if (collectableScreenPosition.x < -collectable.contentSize.width) {
            if (!offscreenCollectables) {
                offscreenCollectables = [NSMutableArray array];
            }
            
            [offscreenCollectables addObject:collectable];
        }
    }
  
    for (CCNode *collectableToRemove in offscreenCollectables) {
        [collectableToRemove removeFromParent];
        [_collectables removeObject:collectableToRemove];
        [self collectableGeneration];
    }
}


- (void) ObstacleGeneration

{
    
    CCNode *previousObstacle = [_obstacles lastObject];
    CGFloat previousObstacleXPosition = previousObstacle.position.x;
    if (!previousObstacle) {
        previousObstacleXPosition = firstObstaclePos;
        
    }
    
    Obstacle *obstacle = (Obstacle *)[CCBReader load:@"Obstacle"];
    obstacle.position = ccp(previousObstacleXPosition + distanceBetweenObstacles, 0);
    [obstacle setupRandomPosition];
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
    
    
    
    
    
}


// -------- Method that handles collectable generation ---------- //


- (void) collectableGeneration {
    
    
    CCNode *previousCollectable = [_collectables lastObject];
    CGFloat previousCollectableXposition = previousCollectable.position.x;
    
    if (!previousCollectable) {
        previousCollectableXposition = firstCollectablePos;
    }
     
    
    int randomM = arc4random_uniform(4)+1;
    Collectable *goldC = (Collectable * ) [CCBReader load: [NSString stringWithFormat:@"Collectable%d",randomM]];
   
    goldC.position = ccp(previousCollectableXposition + distanceBetweenCollectables, 0);
    [_physicsNode addChild:goldC];
    [_collectables addObject:goldC];

    
    
}



- (void)gameOver {
    if (!_gameOver) {
        _scrollingSpeed = 0.f;
        _gameOver = TRUE;
        _restartButton.visible = TRUE;
        _mole.rotation = 90.f;
        _mole.physicsBody.allowsRotation = FALSE;
        [_mole   stopAllActions];
        self.userInteractionEnabled = FALSE;
        swipeDown.enabled = NO;
        swipeUp.enabled = NO;
        CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.2f position:ccp(-2, 2)];
        CCActionInterval *reverseMovement = [moveBy reverse];
        CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
        [self runAction:bounce];
        
        
        
        
    }
    
}

- (void)updateHighscore {
    NSNumber *newHighscore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    if (newHighscore) {
        _highscoreLabel.string = [NSString stringWithFormat:@"%d", [newHighscore intValue]];
    }
}


// collision handler for the player and the obstacles, when the player touches an obstacle the game is over

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair mole:(CCNode *)mole obstacle:(CCNode *)obstacle {
    
    
    [self gameOver];
    return  TRUE;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair mole:(CCNode *)mole goal:(CCNode *)goal {
    
    [goal removeFromParent];
    _points++;
    _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    
    return TRUE;
    
}


// Collision handler for the collectables

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair mole:(CCNode *)mole gold:(CCNode *)gold {
    
    _goldPoints++;
    _goldLabel.string = [NSString stringWithFormat:@"%ld", (long)_goldPoints];
    [gold removeFromParent];
    
    CCParticleSystem *coinAnimation = (CCParticleSystem *) [CCBReader load: @"coinAnim"];
    
    // Remove the animation when finishing playing
    
    coinAnimation.autoRemoveOnFinish = TRUE;
    
    // make the animation load in te position of the mole
    
    coinAnimation.position = _mole.position;
    
    // make the mole the parent of the animation
    
    [_mole.parent addChild:coinAnimation];

    
    return TRUE;
}

// method to restart the game

-(void) restart {
    
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
    _gameOver = FALSE;
    
}






@end