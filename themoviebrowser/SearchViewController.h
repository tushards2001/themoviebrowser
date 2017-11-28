//
//  SearchViewController.h
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "AppConfig.h"
#import "MovieDetailsViewController.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface SearchViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>
{
    NSMutableArray *arraySearch;
}

- (IBAction)actionBack:(UIButton *)sender;
- (IBAction)actionSort:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *tfSearchField;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchResultStats;


@end
