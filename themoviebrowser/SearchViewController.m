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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search Movie..." attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    self.tfSearchField.attributedPlaceholder = str;
    
    self.tfSearchField.delegate = self;
    
    
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
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        //NSLog(@"%@", httpResponse);
                                                        NSLog(@"status code = %ld", (long)httpResponse.statusCode);
                                                        
                                                        if ([response isKindOfClass:[NSHTTPURLResponse class]])
                                                        {
                                                            NSError *jsonError;
                                                            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                                            
                                                            if (jsonError)
                                                            {
                                                                // Error Parsing JSON
                                                                
                                                            } else {
                                                                // Success Parsing JSON
                                                                // Log NSDictionary response:
                                                                //NSLog(@"%@",jsonResponse);
                                                                NSLog(@"Page %@", [jsonResponse objectForKey:@"page"]);
                                                                NSLog(@"Total Pages %@", [jsonResponse objectForKey:@"total_pages"]);
                                                                NSLog(@"Total Results %@", [jsonResponse objectForKey:@"total_results"]);
                                                                NSArray *array = [jsonResponse objectForKey:@"results"];
                                                                //NSLog(@"results[%lu]\n===========\n%@", (unsigned long)[array count], array);
                                                                arraySearch = [[NSMutableArray alloc] initWithArray:array];
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [self.searchTableView reloadData];;
                                                                });
                                                            }
                                                        }  else {
                                                            //Web server is returning an error
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
    cell.textLabel.text = [dictionary objectForKey:@"original_title"];
    
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

@end
