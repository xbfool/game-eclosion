//
//  ECMacros.m
//  BBYaoTang
//
//  Created by Tsubasa on 13-1-2.
//
//

#import "ECMacros.h"

//**judge if the rect contains a point

bool __cc_rect_contains_point(CGRect rect, CGPoint point) {
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y - rect.size.height);
    if (( point.x >= startPoint.x ) && ( point.x <= endPoint.x )
        && ( point.y <= startPoint.y ) && ( point.y >= endPoint.y )) {
        return YES;
    }
    return NO;
}

NSDictionary * __getDataFile(NSString *filename) {
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* plistPath = [bundle pathForResource:filename ofType:@"plist"];
    NSDictionary* propsDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return propsDic;
}