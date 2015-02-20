//
//  MenuPressedDelegate.h
//  Stack Overflow Client
//
//  Created by John Leonard on 2/18/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MenuPressedDelegate <NSObject>

- (void) menuOptionSelected: (NSInteger) selectedRow;

@end
