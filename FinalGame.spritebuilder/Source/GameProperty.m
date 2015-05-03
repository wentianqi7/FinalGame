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

+ (NSString *)getMaterial {
	return _material;
}

+ (void)setMaterial:(NSString *)name {
	_material = name;
}

@end
