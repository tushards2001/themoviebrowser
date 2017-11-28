//
//  MovieDetailsViewController.m
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

@synthesize dictionaryMovie;
@synthesize lblReleaseDate;
@synthesize imgPoster;
@synthesize imgBackground;
@synthesize lblMovieTitle;
@synthesize scrollViewContainer;
@synthesize container;
@synthesize lblLanguage;
@synthesize viewAvgVoteContainer;
@synthesize lblAvgVote;
@synthesize lblRuntime;
@synthesize lblOverview;
@synthesize lblVoteCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"dictionaryMovie: %@", self.dictionaryMovie);
    
    //release date
    NSString *dateString = [self.dictionaryMovie objectForKey:@"release_date"];
    if (dateString.length > 0)
    {
        NSDate *date = [[AppConfig sharedInstance] getDateFromStringWithDateFormat:@"yyyy-mm-dd" dateString:[self.dictionaryMovie objectForKey:@"release_date"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        [self.lblReleaseDate setText:[NSString stringWithFormat:@"(%@)", [dateFormatter stringFromDate:date]]];
    }
    else
    {
        [self.lblReleaseDate setText:[NSString stringWithFormat:@"-NA-"]];
    }
    
    // poster
    NSURL *posterURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", POSTER_URL_154, [self.dictionaryMovie objectForKey:@"poster_path"]]];
    
    [self.imgPoster sd_setImageWithURL:posterURL
                      placeholderImage:[UIImage imageNamed:@"placeholder_poster"]
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                 [self.imgBackground setImage:image];
                             }];
    
    self.imgPoster.layer.cornerRadius = 8.0f;
    self.imgPoster.layer.masksToBounds = YES;
    
    //background
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.imgBackground addSubview:blurEffectView];
    }
    else
    {
        self.imgBackground.backgroundColor = [UIColor blackColor];
    }
    
    // movie title
    [self.lblMovieTitle setText:[self.dictionaryMovie objectForKey:@"original_title"]];
    
    // language
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    [self.lblLanguage setText:[locale displayNameForKey:NSLocaleIdentifier value:[self.dictionaryMovie objectForKey:@"original_language"]]];
    
    // avg vote
    self.viewAvgVoteContainer.layer.cornerRadius = 3.0f;
    self.viewAvgVoteContainer.layer.masksToBounds = YES;
    [self.lblAvgVote setText:[NSString stringWithFormat:@"%@", [self.dictionaryMovie objectForKey:@"vote_average"]]];
    
    // vote count
    int voteCount = [[self.dictionaryMovie objectForKey:@"vote_count"] intValue];
    if (voteCount == 1)
    {
        [self.lblVoteCount setText:[NSString stringWithFormat:@"%@ Vote", [self.dictionaryMovie objectForKey:@"vote_count"]]];
    }
    else
    {
        [self.lblVoteCount setText:[NSString stringWithFormat:@"%@ Votes", [self.dictionaryMovie objectForKey:@"vote_count"]]];
    }
    
    
    // runtime
    //[self.lblRuntime setText:[NSString stringWithFormat:@"%@ Minutes", [self.dictionaryMovie objectForKey:@"runtime"]]];
    [self.lblRuntime setText:[NSString stringWithFormat:@"-NA-"]];
    
    
    
    // plot
    NSString *overview = [self.dictionaryMovie objectForKey:@"overview"];
    if (overview.length > 0)
    {
        [self.lblOverview setText:[NSString stringWithFormat:@"%@", [self.dictionaryMovie objectForKey:@"overview"]]];
    }
    else
    {
        [self.lblOverview setText:[NSString stringWithFormat:@"-NA-"]];
    }
    
    
    //CGSize size = CGSizeMake(self.container.frame.size.width, self.container.frame.size.height * 2);
    [scrollViewContainer setContentSize:self.container.frame.size];
    
    //self.container.translatesAutoresizingMaskIntoConstraints = NO;
    
    // get movie details
    [self getMovieDetails:(NSString *)[self.dictionaryMovie objectForKey:@"id"]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getMovieDetails:(NSString *)mId
{
    NSString *postURL = [NSString stringWithFormat:@"%@/movie/%@?api_key=%@&language=en-US", DOMAIN_URL, mId, TMDB_API_KEY];
    NSLog(@"postURL : %@", postURL);
    //NSString *postURL = @"https://api.themoviedb.org/3/movie/53182?api_key=cd4831c9dda179e98c0c9b87fa54d511&language=en-US";
    
    NSURL *url = [NSURL URLWithString:postURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (error)
                                                    {
                                                        NSLog(@"Error,%@", [error localizedDescription]);
                                                    }
                                                    else
                                                    {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"status code = %ld", (long)httpResponse.statusCode);
                                                        
                                                        if ([response isKindOfClass:[NSHTTPURLResponse class]])
                                                        {
                                                            NSError *jsonError;
                                                            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                                            
                                                            if (jsonError)
                                                            {
                                                                NSLog(@"jsonError,%@", [jsonError localizedDescription]);
                                                            }
                                                            else
                                                            {
                                                                // Success Parsing JSON
                                                                // Log NSDictionary response:
                                                                NSLog(@"%@",jsonResponse);
                                                                NSLog(@"runtime %@", [jsonResponse objectForKey:@"runtime"]);
                                                                if ([jsonResponse objectForKey:@"runtime"] && [[jsonResponse objectForKey:@"runtime"] intValue] > 0)
                                                                {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [self.lblRuntime setText:[NSString stringWithFormat:@"%@ Minutes", [jsonResponse objectForKey:@"runtime"]]];
                                                                    });
                                                                }
                                                            }
                                                        }
                                                        else
                                                        {
                                                            NSLog(@"Error");
                                                        }
                                                    }
                                                }];
    [dataTask resume];
    
    //-------- option B - begin -------------
    /*NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:postURL]];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (error) {
                                                        NSLog(@"Error,%@", [error localizedDescription]);
                                                    }
                                                    else {
                                                        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                                                    }
                                                }];
    [dataTask resume];*/
    //-------- option B - end -------------
}
@end
