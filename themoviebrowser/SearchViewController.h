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
    int currentPage;
    int totalPages;
    
    NSString *lastSearchedQuery;
}

- (IBAction)actionBack:(UIButton *)sender;
- (IBAction)actionSort:(UIButton *)sender;
- (IBAction)actionPreviousPage:(UIButton *)sender;
- (IBAction)actionNextPage:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *tfSearchField;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchResultStats;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIView *viewPagination;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalResults;
@property (weak, nonatomic) IBOutlet UIButton *btnSort;


@end
