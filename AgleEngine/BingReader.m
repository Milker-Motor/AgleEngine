//
//  BingReader.m
//  AgleEngine
//
//  Created by Lesha on 16.08.16.
//  Copyright © 2016 Lesha. All rights reserved.
//

#import "BingReader.h"
#import "HTMLParser.h"

@implementation BingReader

+ (NSArray *) requestWIthText:(NSString *) string
{
    NSString *path = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Link to bing"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", path, string]];
    
    NSError *error = nil;
    NSStringEncoding encoding;
    NSString *html = [[NSString alloc] initWithContentsOfURL:url usedEncoding:&encoding error:&error];
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error)
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *olNodes = [bodyNode findChildTags:@"ol"];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    if (olNodes.count == 0)
    {
        return nil;
    }
    HTMLNode *postNode = olNodes[0];
    
    NSArray *liNodes = [postNode findChildTags:@"li"];
    for (HTMLNode *liNode in liNodes)
    {
        NSArray *aNodes = [liNode findChildTags:@"a"];
        for (HTMLNode *aNode in aNodes)
        {
            NSString *title = [aNode allContents] ? [aNode allContents] : @"";
            NSString *subTitle = [aNode getAttributeNamed:@"href"] ? [aNode getAttributeNamed:@"href"] : @"";
            
            if (![subTitle containsString:@"http"]) {
                continue;
            }
            [returnArray addObject:@{@"title" : title,
                                     @"subTitle" : subTitle,
                                     @"imagePath" : @""}];
        }
    }
    return returnArray;
}

+ (NSArray *) imageRequestWIthText:(NSString *) string
{
    NSString *path = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Link to bing with Image"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", path, string]];
    NSError *error = nil;
    NSStringEncoding encoding;
    NSString *html = [[NSString alloc] initWithContentsOfURL:url usedEncoding:&encoding error:&error];
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error)
    {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    HTMLNode *bodyNode = [parser body];
    NSArray *divNodes = [bodyNode findChildTags:@"div"];
    int i = 0;
    for (HTMLNode *divNode in divNodes)
    {
        NSArray *aNodes = [divNode findChildTags:@"a"];
        
        if (aNodes.count == 0)
        {
            continue;
        }
        
        HTMLNode *aNode = aNodes[0];
        
        NSString *link = [aNode getAttributeNamed:@"href"];
        NSArray *imageExtensions = @[@"png", @"jpg", @"jpeg", @"gif", @"bmp", @"tif"];
        BOOL isImage = NO;
        for (NSString *png in imageExtensions)
        {
            if ([link containsString:png])
            {
                isImage = YES;
                break;
            }
        }
        if (!isImage) continue;
        i++;
        if (i < 5) continue;
        NSMutableDictionary *addDict = [[NSMutableDictionary alloc] init];
        [addDict setObject:link forKey:@"title"];
        [addDict setObject:link forKey:@"subTitle"];
        [addDict setObject:link forKey:@"imagePath"];
        
        [returnArray addObject:addDict];
        
        
    }
    return returnArray;
}

@end
