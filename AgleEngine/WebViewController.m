//
//  WebViewController.m
//  AgleEngine
//
//  Created by Lesha on 18.08.16.
//  Copyright © 2016 Lesha. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:_url]];
}

@end
