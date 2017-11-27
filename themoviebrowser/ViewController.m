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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getUpcomingMovies];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUpcomingMovies
{
    NSLog(@"Getting upcoming movies");
    
    /*NSString *api_key = TMDB_API_KEY;
    NSString *language = @"en-US";
    int page = 1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         api_key, @"api_key",
                         language, @"language",
                         page, @"page",
                         nil];
    
    NSString *postURL = [NSString stringWithFormat:@"%@/movie/upcoming", DOMAIN_URL];
    
    [manager POST:postURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Activation Response = %@", dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //show view activation container content
        NSLog(@"Error: %@", error.description);
        
    }];*/
    
    NSData *postData = [[NSData alloc] initWithData:[@"{}" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.themoviedb.org/3/movie/upcoming?page=1&language=en-US&api_key=cd4831c9dda179e98c0c9b87fa54d511"]
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
                                                                NSLog(@"%@",jsonResponse);
                                                            }
                                                        }  else {
                                                            //Web server is returning an error
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

@end
