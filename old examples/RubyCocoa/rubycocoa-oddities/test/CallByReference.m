#import <Foundation/Foundation.h>


@interface CallByReference : NSObject
@end

@implementation CallByReference

- (BOOL)putString: (NSString *)s inResult: (NSString **)result
{
    if (result == NULL) return NO;

    *result = s;
    return YES;
}
//END:retval

// This takes one string argument and returns it in both of the 
// by-reference arguments. It returns no value. (That's what the 
// keyword (void) means.)
- (void) putString: (NSString *)s 
         inFirstResult: (NSString **)result1
         andSecondResult: (NSString **)result2
{
    *result1 = s;
    *result2 = s;
}


//START:nil
- (BOOL)fillResult: (NSString **)result withString: (NSString *)s
        when: (BOOL)choice
{
    if (choice) *result = s;
    return choice;
}
//END:nil


// This code sets the value of each non-nil by-reference
// argument to the value of the following argument. If a
// by-reference argument is nil, it does nothing.
// The method always returns Objective-C true.
- (BOOL)fillResult: (id *)result1 withObject: (id)o1
        andFill: (id *)result2 with: (id)o2
{
    if (result1) *result1 = o1;
    if (result2) *result2 = o2;
    return YES;
}
//END:order


@end

void Init_CallByReference(){
  // dummy initializer for ruby's `require'
}
