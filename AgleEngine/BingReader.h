//
//  BingReader.h
//  AgleEngine
//
//  Created by Lesha on 16.08.16.
//  Copyright © 2016 Lesha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BingReader : NSObject

+ (NSArray *) requestWIthText:(NSString *) string;
+ (NSArray *) imageRequestWIthText:(NSString *) string;

@end
