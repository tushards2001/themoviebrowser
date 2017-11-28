//
//  ViewController.h
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MovieDetailsViewController.h"


@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *arrayNowPlaying, *arrayTopRated, *arrayPopular, *arrayUpcoming;
    NSOperationQueue *operationQueue;
}


- (IBAction)actionSearchTapped:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *cvNowPlaying;
@property (weak, nonatomic) IBOutlet UICollectionView *cvTopRated;
@property (weak, nonatomic) IBOutlet UICollectionView *cvPopular;
@property (weak, nonatomic) IBOutlet UICollectionView *cvUpcoming;


@end

