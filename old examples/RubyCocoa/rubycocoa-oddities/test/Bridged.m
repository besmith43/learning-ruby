#import <Foundation/Foundation.h>

@interface Bridged : NSObject
@end

//START:base
@implementation Bridged

- (BOOL)hasEvenLength: (NSString *)string   // <callout id="co.decl.return.value"/> 
{
    int length = [string length];
    int remainder = length % 2;
    if (remainder == 0) 
      return YES;
    else
      return NO;
}

@end
//END:base

void Init_Bridged(){
  // dummy initializer for ruby's `require'
}
