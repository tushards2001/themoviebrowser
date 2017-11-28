//
//  AppConfig.h
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//
//API Key (v3 auth)
//cd4831c9dda179e98c0c9b87fa54d511
//eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjZDQ4MzFjOWRkYTE3OWU5OGMwYzliODdmYTU0ZDUxMSIsInN1YiI6IjVhMWE2ZTI1MGUwYTI2NGNkMDAzOTE4ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.EKGFfnxEpYczxcwh8Z53OzFM4ZhvOMSr9OmEro4oL30

//API Read Access Token (v4 auth)
//
//
//Example API Request
// https://api.themoviedb.org/3/movie/550?api_key=cd4831c9dda179e98c0c9b87


#import <Foundation/Foundation.h>

#define DOMAIN_URL @"https://api.themoviedb.org/3"
#define POSTER_URL_154 @"https://image.tmdb.org/t/p/w154"
#define POSTER_URL_92 @"https://image.tmdb.org/t/p/w92"
#define TMDB_API_KEY @"cd4831c9dda179e98c0c9b87fa54d511"

@interface AppConfig : NSObject
{
    
}

+(AppConfig *)sharedInstance;


- (id)init;

- (NSDate *)getDateFromStringWithDateFormat:(NSString *)dateFormatString dateString:(NSString *)dateString;

@end
