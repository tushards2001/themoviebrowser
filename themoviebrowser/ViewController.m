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

@synthesize cvNowPlaying;
@synthesize cvPopular;
@synthesize cvTopRated;
@synthesize cvUpcoming;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //------------------------------ operation queue - begin ----------------------
    operationQueue = [NSOperationQueue new];
    
    // now playing
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(getNowPlaying)
                                                                              object:nil];
    [operationQueue addOperation:operation];
    
    // top rated
    operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                     selector:@selector(getTopRated)
                                                       object:nil];
    [operationQueue addOperation:operation];
    
    // popular
    operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                     selector:@selector(getPopular)
                                                       object:nil];
    [operationQueue addOperation:operation];
    
    // upcoming
    operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                     selector:@selector(getUpcoming)
                                                       object:nil];
    [operationQueue addOperation:operation];
    //------------------------------ operation queue - end ----------------------
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)downloadConfiguration
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
                                                                NSArray *array = [jsonResponse objectForKey:@"results"];
                                                                NSLog(@"results[%lu]\n> %@", (unsigned long)[array count], array);
                                                            }
                                                        }
                                                        else
                                                        {
                                                            //Web server is returning an error
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}*/

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

/*- (void)getMovieDetailsWithId:(NSString *)movieId
{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/1271?language=en-US&api_key=cd4831c9dda179e98c0c9b87fa54d511"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
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
    [dataTask resume];
}*/


- (IBAction)actionSearchTapped:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"segue_search" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue_movie_details"])
    {
        MovieDetailsViewController *vc = [segue destinationViewController];
        vc.dictionaryMovie = (NSDictionary *)sender;
    }
}

- (void)getNowPlaying
{
    if (arrayNowPlaying)
    {
        [arrayNowPlaying removeAllObjects];
        arrayNowPlaying = nil;
    }
    
    NSString *postURL = [NSString stringWithFormat:@"%@/movie/now_playing?api_key=%@&language=en-US", DOMAIN_URL, TMDB_API_KEY];
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
                                                                //NSLog(@"------ jsonResponse -------\n%@",jsonResponse);
                                                                arrayNowPlaying = [[NSMutableArray alloc] init];
                                                                arrayNowPlaying = [jsonResponse objectForKey:@"results"];
                                                                if (arrayNowPlaying.count > 0)
                                                                {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [self.cvNowPlaying reloadData];
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
}

- (void)getTopRated
{
    if (arrayTopRated)
    {
        [arrayTopRated removeAllObjects];
        arrayTopRated = nil;
    }
    
    NSString *postURL = [NSString stringWithFormat:@"%@/movie/top_rated?api_key=%@&language=en-US", DOMAIN_URL, TMDB_API_KEY];
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
                                                                //NSLog(@"------ jsonResponse -------\n%@",jsonResponse);
                                                                arrayTopRated = [[NSMutableArray alloc] init];
                                                                arrayTopRated = [jsonResponse objectForKey:@"results"];
                                                                if (arrayTopRated.count > 0)
                                                                {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [self.cvTopRated reloadData];
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
}

- (void)getPopular
{
    if (arrayPopular)
    {
        [arrayPopular removeAllObjects];
        arrayPopular = nil;
    }
    
    NSString *postURL = [NSString stringWithFormat:@"%@/movie/popular?api_key=%@&language=en-US", DOMAIN_URL, TMDB_API_KEY];
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
                                                                //NSLog(@"------ jsonResponse -------\n%@",jsonResponse);
                                                                arrayPopular = [[NSMutableArray alloc] init];
                                                                arrayPopular = [jsonResponse objectForKey:@"results"];
                                                                if (arrayPopular.count > 0)
                                                                {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [self.cvPopular reloadData];
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
}

- (void)getUpcoming
{
    if (arrayUpcoming)
    {
        [arrayUpcoming removeAllObjects];
        arrayUpcoming = nil;
    }
    
    NSString *postURL = [NSString stringWithFormat:@"%@/movie/upcoming?api_key=%@&language=en-US", DOMAIN_URL, TMDB_API_KEY];
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
                                                                //NSLog(@"------ jsonResponse -------\n%@",jsonResponse);
                                                                arrayUpcoming = [[NSMutableArray alloc] init];
                                                                arrayUpcoming = [jsonResponse objectForKey:@"results"];
                                                                if (arrayUpcoming.count > 0)
                                                                {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [self.cvUpcoming reloadData];
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
}

/*- (void)getMoviesForCategory:(NSInteger)mCategory
{
    switch (mCategory) {
        case MBMovieCategoryNowPlaying:
            if (arrayTopRated)
            {
                [arrayTopRated removeAllObjects];
                arrayTopRated = nil;
            }
            break;
            
        default:
            return;
            break;
    }
}*/

#pragma mark - CollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.cvNowPlaying && arrayNowPlaying)
    {
        return arrayNowPlaying.count;
    }
    else if (collectionView == self.cvTopRated && arrayTopRated)
    {
        return arrayTopRated.count;
    }
    if (collectionView == self.cvPopular && arrayPopular)
    {
        return arrayPopular.count;
    }
    else if (collectionView == self.cvUpcoming && arrayUpcoming)
    {
        return arrayUpcoming.count;
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    
    UIImageView *imageViewPosterThumbnail = (UIImageView *)[cell viewWithTag:1];
    
    NSString *posterImage;
    
    if (collectionView == self.cvNowPlaying && arrayNowPlaying)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [arrayNowPlaying objectAtIndex:indexPath.row];
        posterImage = [dictionary objectForKey:@"poster_path"];
    }
    else if (collectionView == self.cvTopRated && arrayTopRated)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [arrayTopRated objectAtIndex:indexPath.row];
        posterImage = [dictionary objectForKey:@"poster_path"];
    }
    if (collectionView == self.cvPopular && arrayPopular)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [arrayPopular objectAtIndex:indexPath.row];
        posterImage = [dictionary objectForKey:@"poster_path"];
    }
    else if (collectionView == self.cvUpcoming && arrayUpcoming)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [arrayUpcoming objectAtIndex:indexPath.row];
        posterImage = [dictionary objectForKey:@"poster_path"];
    }
    /*else
    {
        posterImage = @""; //@"/kqjL17yufvn9OVLyXYpvtyrFfak.jpg";
    }
    
    if (posterImage.length > 0)
    {
        NSURL *posterURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", POSTER_URL_92, posterImage]];
        
        [imageViewPosterThumbnail sd_setImageWithURL:posterURL
                                    placeholderImage:[UIImage imageNamed:@"placeholder_poster"]];
    }
    else
    {
        [imageViewPosterThumbnail setImage:[UIImage imageNamed:@"placeholder_poster"]];
    }*/
    
    NSURL *posterURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", POSTER_URL_92, posterImage]];
    
    [imageViewPosterThumbnail sd_setImageWithURL:posterURL
                                placeholderImage:[UIImage imageNamed:@"placeholder_poster"]];
    
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.cvNowPlaying && arrayNowPlaying)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [arrayNowPlaying objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"segue_movie_details" sender:dictionary];
    }
    else if (collectionView == self.cvTopRated && arrayTopRated)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [arrayTopRated objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"segue_movie_details" sender:dictionary];
    }
    else if (collectionView == self.cvPopular && arrayPopular)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [arrayPopular objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"segue_movie_details" sender:dictionary];
    }
    else if (collectionView == self.cvUpcoming && arrayUpcoming)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [arrayUpcoming objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"segue_movie_details" sender:dictionary];
    }
}

@end
