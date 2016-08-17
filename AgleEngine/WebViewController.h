//
//  WebViewController.h
//  AgleEngine
//
//  Created by Lesha on 18.08.16.
//  Copyright © 2016 Lesha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) NSURL *url;

@end
