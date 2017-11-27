//
//  AppConfig.m
//  themoviebrowser
//
//  Created by MacBookPro on 11/27/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

static AppConfig *sharedHelper = nil;


+(AppConfig *) sharedInstance
{
    
    if (!sharedHelper)
    {
        sharedHelper = [[AppConfig alloc] init];
    }
    
    return sharedHelper;
}

-(id)init
{
    if( (self=[super init]))
    {
        NSLog(@"AppConfig init()");
    }
    
    return self;
}

- (NSDate *)getDateFromStringWithDateFormat:(NSString *)dateFormatString dateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormatString];
    //NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:[[NSTimeZone localTimeZone] name]];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:dateString];
    
    return date;
}

@end
