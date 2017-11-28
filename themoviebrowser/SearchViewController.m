//
//  SearchViewController.m
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize tfSearchField;
@synthesize searchTableView;
@synthesize lblMessage;
@synthesize HUD;
@synthesize lblSearchResultStats;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Enter movie name..." attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    self.tfSearchField.attributedPlaceholder = str;
    
    self.tfSearchField.delegate = self;
    
    // lblMessage
    [self.lblMessage setText:@"Search for a movie you would like to read more."];
    
    // search table view
    self.searchTableView.hidden = YES;
    
    // search result stats label
    [self.lblSearchResultStats setText:@""];
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

- (IBAction)actionSort:(UIButton *)sender
{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Sort By"      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleDestructive
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Popularity"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Highest Voted"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                              }];
    
    
    [alert addAction:button1];
    [alert addAction:button2];
    [alert addAction:button0];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tfSearchField resignFirstResponder];
    if (self.tfSearchField.text.length > 0)
    {
        [self searchMovieByName:[self.tfSearchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    return YES;
}

- (void)searchMovieByName:(NSString *)movieName
{
    NSLog(@"Searching Movie \"%@\".....", movieName);
    
    //------------------ HUD - BEGIN -------------------
    if (HUD)
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setRemoveFromSuperViewOnHide:YES];
    //------------------ HUD - END -------------------
    
    // lblMessage hide
    self.lblMessage.hidden = YES;
    
    if (arraySearch) {
        [arraySearch removeAllObjects];
        arraySearch = nil;
    }
    
    NSString *api_key = TMDB_API_KEY;
    NSString *language = @"en-US";
    NSString *query = [movieName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    NSString *postURL = [NSString stringWithFormat:@"%@/search/movie?api_key=%@&language=%@&query=%@", DOMAIN_URL, api_key, language, query];
    
    
    NSData *postData = [[NSData alloc] initWithData:[@"{}" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error)
                                                    {
                                                        NSLog(@"%@", error);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            if (HUD)
                                                            {
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                            }
                                                            
                                                            self.lblMessage.hidden = NO;
                                                            [self.lblMessage setText:[NSString stringWithFormat:@"%@", error.localizedDescription]];
                                                            
                                                            self.searchTableView.hidden = YES;
                                                            
                                                            [self.lblSearchResultStats setText:@""];
                                                        });
                                                    }
                                                    else
                                                    {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        //NSLog(@"%@", httpResponse);
                                                        NSLog(@"status code = %ld", (long)httpResponse.statusCode);
                                                        
                                                        if ([response isKindOfClass:[NSHTTPURLResponse class]])
                                                        {
                                                            NSError *jsonError;
                                                            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                                            
                                                            if (jsonError)
                                                            {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    if (HUD)
                                                                    {
                                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                    }
                                                                    
                                                                    // Error Parsing JSON
                                                                    self.lblMessage.hidden = NO;
                                                                    [self.lblMessage setText:@"Unknown error occured. Please try again."];
                                                                    
                                                                    self.searchTableView.hidden = YES;
                                                                    
                                                                    [self.lblSearchResultStats setText:@""];
                                                                });
                                                            }
                                                            else
                                                            {
                                                                // Success Parsing JSON
                                                                // Log NSDictionary response:
                                                                //NSLog(@"%@",jsonResponse);
                                                                NSLog(@"Page %@", [jsonResponse objectForKey:@"page"]);
                                                                NSLog(@"Total Pages %@", [jsonResponse objectForKey:@"total_pages"]);
                                                                NSLog(@"Total Results %@", [jsonResponse objectForKey:@"total_results"]);
                                                                NSArray *array = [jsonResponse objectForKey:@"results"];
                                                                //NSLog(@"results[%lu]\n===========\n%@", (unsigned long)[array count], array);
                                                                arraySearch = [[NSMutableArray alloc] initWithArray:array];
                                                                if (arraySearch.count > 0)
                                                                {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        if (HUD)
                                                                        {
                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                        }
                                                                        
                                                                        self.searchTableView.hidden = NO;
                                                                        [self.searchTableView reloadData];
                                                                        
                                                                        [self.lblSearchResultStats setText:[NSString stringWithFormat:@"Showing %lu of %@", (unsigned long)arraySearch.count, [jsonResponse objectForKey:@"total_results"]]];
                                                                    });
                                                                }
                                                                else
                                                                {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        if (HUD)
                                                                        {
                                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                        }
                                                                        
                                                                        self.searchTableView.hidden = YES;
                                                                        self.lblMessage.hidden = NO;
                                                                        [self.lblMessage setText:[NSString stringWithFormat:@"No movies found by the name \"%@\"", movieName]];
                                                                        [self.lblSearchResultStats setText:@""];
                                                                    });
                                                                    
                                                                }
                                                                
                                                            }
                                                        }
                                                        else
                                                        {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                // hide progress hud
                                                                if (HUD)
                                                                {
                                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                }
                                                                
                                                                //Web server is returning an error
                                                                self.lblMessage.hidden = NO;
                                                                [self.lblMessage setText:@"Unknown error occured. Please try again."];
                                                                
                                                                self.searchTableView.hidden = YES;
                                                            });
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue_movie_details"])
    {
        MovieDetailsViewController *vc = [segue destinationViewController];
        vc.dictionaryMovie = (NSDictionary *)sender;
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary = [arraySearch objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"segue_movie_details" sender:dictionary];
}

#pragma mark - TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tvCell"];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary = [arraySearch objectAtIndex:indexPath.row];
    //cell.textLabel.text = [dictionary objectForKey:@"original_title"];
    
    // poster
    UIImageView *imageViewPosterThumbnail = (UIImageView *)[cell viewWithTag:1];
    
    NSURL *posterURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", POSTER_URL_92, [dictionary objectForKey:@"poster_path"]]];
    
    [imageViewPosterThumbnail sd_setImageWithURL:posterURL
                                placeholderImage:[UIImage imageNamed:@"placeholder_poster"]];
    
    // title
    UILabel *lblMovieTitle = (UILabel *)[cell viewWithTag:2];
    [lblMovieTitle setText:[NSString stringWithFormat:@"%@", [dictionary objectForKey:@"original_title"]]];
    
    // year
    UILabel *lblYear = (UILabel *)[cell viewWithTag:3];
    
    NSString *dateString = [dictionary objectForKey:@"release_date"];
    if (dateString.length > 0)
    {
        NSDate *date = [[AppConfig sharedInstance] getDateFromStringWithDateFormat:@"yyyy-mm-dd" dateString:[dictionary objectForKey:@"release_date"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        [lblYear setText:[NSString stringWithFormat:@"(%@)", [dateFormatter stringFromDate:date]]];
    }
    else
    {
        [lblYear setText:[NSString stringWithFormat:@"-NA-"]];
    }
    
    // vote count
    UIView *viewVoteCount = (UIView *)[cell viewWithTag:4];
    [viewVoteCount.layer setCornerRadius:2.0];
    [viewVoteCount.layer setMasksToBounds:YES];
    
    UILabel *lblVoteCount = (UILabel *)[cell viewWithTag:5];
    [lblVoteCount setText:[NSString stringWithFormat:@"%@", [dictionary objectForKey:@"vote_average"]]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arraySearch)
    {
        return arraySearch.count;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0;
}

@end
