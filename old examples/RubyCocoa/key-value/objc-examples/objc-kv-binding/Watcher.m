//
//  Watcher.m
//  sloop
//
//  Created by Brian Marick on 5/16/08.
//  Copyright 2008 Exampler Consulting. All rights reserved.
//

#import "Watcher.h"
#import "Observed.h"


@implementation Watcher

- (id) initWatching: (id) observed
{
  [observed addObserver: self
             forKeyPath: @"value"
                options: NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                context: NULL];
  return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  NSLog(@"observed %@: %@\n", keyPath, change);
}

@end
