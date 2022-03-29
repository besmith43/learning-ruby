//
//  Observer.m
//  sloop
//
//  Created by Brian Marick on 5/16/08.
//  Copyright 2008 Exampler Consulting. All rights reserved.
//

#import "Observed.h"


@implementation Observed
@dynamic value;

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey { 
  BOOL automatic = NO; 
  return automatic; 
} 


- (NSString *)value {
  return value;
}

- (void)setValue:(NSString *)newValue {
  
  NSMutableArray *arr = [[NSMutableArray alloc] init];
  [arr addObject: @"hi"];
  [arr addObject: [NSNumber numberWithInt: 1]];
  
  NSLog(@"s: %@, %@\n", [arr objectAtIndex: 0], [arr objectAtIndex: 1]);
  
  if (newValue != value) {
    [self willChangeValueForKey:@"value"]; 
    value = [newValue copy];
    [self didChangeValueForKey:@"value"]; 
  }
}

@end
