//
//  SearchViewController.h
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppConfig.h"
#import "MovieDetailsViewController.h"


@interface SearchViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arraySearch;
}

- (IBAction)actionBack:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *tfSearchField;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;



@end
