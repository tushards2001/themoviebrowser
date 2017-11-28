//
//  MovieDetailsViewController.h
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"


@interface MovieDetailsViewController : UIViewController <UIGestureRecognizerDelegate>
{
    
}

@property (weak, nonatomic)NSDictionary *dictionaryMovie;

- (IBAction)actionBack:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblReleaseDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgPoster;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblMovieTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *lblLanguage;
@property (weak, nonatomic) IBOutlet UIView *viewAvgVoteContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblAvgVote;
@property (weak, nonatomic) IBOutlet UILabel *lblRuntime;
@property (weak, nonatomic) IBOutlet UILabel *lblOverview;
@property (weak, nonatomic) IBOutlet UILabel *lblVoteCount;


@end
