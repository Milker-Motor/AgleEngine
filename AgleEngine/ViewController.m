//
//  ViewController.m
//  AgleEngine
//
//  Created by Lesha on 16.08.16.
//  Copyright © 2016 Lesha. All rights reserved.
//

#import "ViewController.h"
#import "BingReader.h"
#import "TableViewCell.h"
#import "WebViewController.h"

@implementation ViewController
{
    NSTimer *timer;
    NSArray *objects;
    NSArray *objectsWithImages;
}

- (IBAction)mainSegment:(id)sender
{
    [self refresh];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(TableViewCell *)sender
{
    if ([[segue identifier] isEqual:@"showWebView"] || [[segue identifier] isEqual:@"showWebView2"])
    {
        WebViewController *vc = (WebViewController *)[segue destinationViewController];
        vc.url = [NSURL URLWithString:sender.subTitle.text];
    }
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_mainSegmentedControl.selectedSegmentIndex == 0 )
    {
        if (objects.count == 0)
        {
            return 1;
        }
        return objects.count;
    }
    else
    {
        if (objectsWithImages.count == 0)
        {
            return 1;
        }
        return objectsWithImages.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    TableViewCell *cell;
    NSString *title;
    NSString *subTitle;
    NSString *pathImage;
    UIImage *image;
    if ((_mainSegmentedControl.selectedSegmentIndex == 0 && objects.count == 0) || (_mainSegmentedControl.selectedSegmentIndex == 1 && objectsWithImages.count == 0))
    {
        identifier = @"CellNoResult";
        UITableViewCell *cellNoResult = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        return cellNoResult;
    }
    
    if (_mainSegmentedControl.selectedSegmentIndex == 0)
    {
        identifier = @"Cell";
        title = objects[indexPath.row][@"title"] ? objects[indexPath.row][@"title"] : @"";
        subTitle = objects[indexPath.row][@"subTitle"] ? objects[indexPath.row][@"subTitle"] : @"";
        pathImage = @"";
    }
    else
    {
        identifier = @"CellImage";
        title = objectsWithImages[indexPath.row][@"title"] ? objectsWithImages[indexPath.row][@"title"] : @"";
        subTitle = objectsWithImages[indexPath.row][@"subTitle"] ? objectsWithImages[indexPath.row][@"subTitle"] : @"";
        pathImage = objectsWithImages[indexPath.row][@"imagePath"] ? objectsWithImages[indexPath.row][@"imagePath"] : @"";
        if (objectsWithImages[indexPath.row][@"image"])
             image = objectsWithImages[indexPath.row][@"image"];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.title.text = title;
    cell.subTitle.text = subTitle;
    cell.previewImage.image = nil;
    if (image)
        cell.previewImage.image = image;
    else if (pathImage.length)
    {
        [self downloadImageWithURL:[NSURL URLWithString:subTitle] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                cell.previewImage.image = image;
                [cell setNeedsLayout];
                if (image) {
                    [objectsWithImages[indexPath.row] setObject:image forKey:@"image"];
                }
                
            }
        }];
    }
    
    return cell;
}

#pragma mark - Search bar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    objects = nil;
    objectsWithImages = nil;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (timer)
    {
        [timer invalidate];
    }
    if (!searchBar.text.length)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        objects = [BingReader requestWIthText:_mainSearchBar.text];
        objectsWithImages = [BingReader imageRequestWIthText:_mainSearchBar.text];
    });

    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refresh) userInfo:nil repeats:NO];
}

- (void)refresh
{
    [_mainSearchBar resignFirstResponder];
    [_mainTableView reloadData];
}

@end
