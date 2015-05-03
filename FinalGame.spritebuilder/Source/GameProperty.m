//
//  GameProperty.m
//  FinalGame
//
//  Created by Rainy Yang on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameProperty.h"

@implementation GameProperty
static NSString *_material = @"Bones";
static float enemyDensity  = 10.f;
static int price = 300;

+ (NSString *)getMaterial {
	return _material;
}

+ (void)setMaterial:(NSString *)name {
	_material = name;
}

+ (float)getEnemyInterval {
	return enemyDensity;
}

+ (void)setEnemyInterval:(float)density {
	enemyDensity = density;
}

+ (int)getPrice {
	return price;
}

+ (void)setPrice:(int)amount {
	price = amount;
}

@end
