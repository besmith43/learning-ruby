//
//  ApplicationDelegate.m
//  sloop
//
//  Created by Brian Marick on 5/16/08.
//  Copyright 2008 Exampler Consulting. All rights reserved.
//

#import "ApplicationDelegate.h"
#import "SomeView.h"
#import "SomeModel.h"

@implementation ApplicationDelegate

- (void) awakeFromNib
{
  printf("Hello, world.\n");
  SomeView *view = [[SomeView alloc] init];
  SomeModel *model = [[SomeModel alloc] init];
  NSObjectController *controller = [[NSObjectController alloc] initWithContent: model];
  
  view.value = @"initial view value; should not be seen";
  model.value = @"initial model value; should not be seen";
  
  [view bind: @"value"
          toObject: controller
 withKeyPath: @"content.value"
     options: nil];
  
  NSLog(@"%@", [view infoForBinding: @"value"]);
  
  NSLog(@"Setting view.");
  [view setValue: @"view value setting, should be copied to model"];
  NSLog(@"model value is '%@'.", [model value]);
  
  NSLog(@"Setting model.");
  model.value = @"model value set, should be copied to view";
  NSLog(@"view value is '%@'.", view.value);
}



@end
