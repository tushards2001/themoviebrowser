//
//  ViewController.m
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self getUpcomingMovies];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self downloadConfiguration];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadConfiguration
{
    NSString *postURL = [NSString stringWithFormat:@"%@/configuration?api_key=%@", DOMAIN_URL, TMDB_API_KEY];
    
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
                                                                // Error Parsing JSON
                                                                
                                                            }
                                                            else
                                                            {
                                                                // Success Parsing JSON
                                                                // Log NSDictionary response:
                                                                NSLog(@"%@",jsonResponse);
                                                                /*NSArray *array = [jsonResponse objectForKey:@"results"];
                                                                NSLog(@"results[%lu]\n> %@", (unsigned long)[array count], array);*/
                                                            }
                                                        }
                                                        else
                                                        {
                                                            //Web server is returning an error
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

- (void)getUpcomingMovies
{
    NSLog(@"Getting upcoming movies");
    
    NSString *api_key = TMDB_API_KEY;
    NSString *language = @"en-US";
    int page = 1;
    
    NSString *postURL = [NSString stringWithFormat:@"%@/movie/upcoming?api_key=%@&language=%@&page=%d", DOMAIN_URL, api_key, language, page];
    
    
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
                                                                NSArray *array = [jsonResponse objectForKey:@"results"];
                                                                NSLog(@"results[%lu]\n> %@", (unsigned long)[array count], array);
                                                            }
                                                        }  else {
                                                            //Web server is returning an error
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}


- (IBAction)actionSearchTapped:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"segue_search" sender:nil];
}
@end
