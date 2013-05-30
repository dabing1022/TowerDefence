//
//  Enemy.m
//  TowerDefence
//
//  Created by Kingiol on 13-5-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "PointUtil.h"

@implementation Enemy

@synthesize linePositionArray = _linePositionArray;
@synthesize currentPosition = _currentPosition;
@synthesize nextPosition = _nextPosition;
@synthesize hp = _hp;
@synthesize walkSpeed = _walkSpeed;
@synthesize current_hp = _current_hp;
@synthesize enemySprite = _enemySprite;

@synthesize delegate = _delegate;

+ (id)nodeWithLinePositions:(NSArray *)linePositions {
    return [[self alloc] initWithLinePositions:linePositions];
}

- (id)initWithLinePositions:(NSArray *)linePositions {
    if ((self = [super init])) {
        self.linePositionArray = [NSMutableArray arrayWithArray:linePositions];
        self.hp = 5;
        self.current_hp = 0;
        self.walkSpeed = 1;
        
        CGPoint startPoint = CGPointFromString([self.linePositionArray objectAtIndex:0]);
        self.enemySprite = [CCSprite spriteWithFile:@"enemy.png"];
        self.enemySprite.position = startPoint;
        self.currentPosition = startPoint;
        [self addChild:self.enemySprite];
        
        [self.linePositionArray removeObjectAtIndex:0];
        
        self.nextPosition = CGPointFromString([self.linePositionArray objectAtIndex:0]);
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)delta {
    CGPoint targetPoint = self.nextPosition;
    
    if ([PointUtil circle:self.currentPosition withRadius:1 collsionWithCircle:targetPoint collisionCircleRadius:1]) {
        if ([self.linePositionArray count] > 1) {
            [self.linePositionArray removeObjectAtIndex:0];
            self.nextPosition = CGPointFromString([self.linePositionArray objectAtIndex:0]);
            targetPoint = self.nextPosition;
        }else {
            //achieve the gold, game hp - 1
            [self.enemySprite removeFromParentAndCleanup:YES];
            [self removeFromParentAndCleanup:YES];
            // update gold number
            if ([self.delegate respondsToSelector:@selector(updateMountainHP)]) {
                [self.delegate updateMountainHP];
            }
        }
    }
    
    CGPoint normalized = ccpNormalize(ccp(targetPoint.x - self.currentPosition.x, targetPoint.y - self.currentPosition.y));
    self.enemySprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x));
    
    self.currentPosition = ccp(self.currentPosition.x + normalized.x * self.walkSpeed, self.currentPosition.y + normalized.y * self.walkSpeed);
    self.enemySprite.position = self.currentPosition;
}

@end
