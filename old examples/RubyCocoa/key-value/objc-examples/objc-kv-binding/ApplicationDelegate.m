//
//  ApplicationDelegate.m
//  sloop
//
//  Created by Brian Marick on 5/16/08.
//  Copyright 2008 Exampler Consulting. All rights reserved.
//

#import "ApplicationDelegate.h"
#import "Observed.h"
#import "Watcher.h"

@implementation ApplicationDelegate

- (void) awakeFromNib
{
  printf("Hello, world.\n");
  Observed *observed = [[Observed alloc] init];
  Watcher *watcher = [[Watcher alloc] initWatching: observed];
  NSLog(@"Setting directly.");
  observed.value = @"new value";
  
  NSLog(@"Setting kvcly.");
  [observed setValue: @"newer value" forKey: @"value"];
}



@end
