//
//  MNExchangeRateCountryLoader.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNExchangeRateCountryLoader.h"
#import "MNCountryFlagImageFactory.h"

@implementation MNExchangeRateCountryLoader

static NSMutableArray *countryArr;
static NSMutableDictionary *countryDict;
static NSMutableArray *mainCountryArr;

+ (MNExchangeRateCountryLoader *)sharedInstance
{
    static MNExchangeRateCountryLoader *instance;
    
    if (instance == nil) {
        @synchronized(self)
        {
            if (instance == nil) {
                instance = [[self alloc] init];
            }
        }
    }
    
    return instance;
}

+ (MNExchangeRateCountry *)countryWithCountryCode:(NSString *)code
{
    // load country from file
    if (countryArr == nil)
    {
        @synchronized(countryArr)
        {
            if (countryArr == nil)
            {
                countryArr = [NSMutableArray array];
                countryDict = [NSMutableDictionary dictionary];
                mainCountryArr = [NSMutableArray array];
                
                NSError *error;
                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"exchange_list" ofType:@"txt"];
                NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
                
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                }
                
                NSArray *allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                for (NSString *countryStr in allLinedStrings)
                {
                    NSArray *countryArray = [countryStr componentsSeparatedByString:@"/"];
                    
                    if ([countryArray count] == 4)
                    {
                        MNExchangeRateCountry *tempCountry = [[MNExchangeRateCountry alloc] init];
                        tempCountry.currencyUnitCode = [countryArray objectAtIndex:0];
                        tempCountry.currencyUnitName = [countryArray objectAtIndex:1];
                        tempCountry.countryCode = [countryArray objectAtIndex:2];
                        tempCountry.currencySymbol = [countryArray objectAtIndex:3];
                        tempCountry.flag = [MNCountryFlagImageFactory getImage:tempCountry.countryCode bwImage:YES];
                        
                        [countryArr addObject:tempCountry];
                        [countryDict setObject:tempCountry forKey:tempCountry.currencyUnitCode];
                        
                        if (([tempCountry.currencyUnitCode isEqualToString:@"USD"])
                            || ([tempCountry.currencyUnitCode isEqualToString:@"CAD"])
                            || ([tempCountry.currencyUnitCode isEqualToString:@"EUR"])
                            || ([tempCountry.currencyUnitCode isEqualToString:@"GBP"])
                            || ([tempCountry.currencyUnitCode isEqualToString:@"CNY"])
                            || ([tempCountry.currencyUnitCode isEqualToString:@"JPY"])
                            || ([tempCountry.currencyUnitCode isEqualToString:@"KRW"])
                            || ([tempCountry.currencyUnitCode isEqualToString:@"AUD"])
                            || ([tempCountry.currencyUnitCode isEqualToString:@"TWD"]))
                        {
                            [mainCountryArr addObject:tempCountry];
                        }
                    }
                }
            }
        }
    }
    
    while (countryDict.count != NUM_OF_COUNTRIES) {
        ;
    }
    
    MNExchangeRateCountry *country = [countryDict objectForKey:code];

    return country;
}

+ (NSArray *)getFilteredArrayWithSearchString:(NSString *)searchString fromTimeZoneArray:(NSArray *)allArray {
    // 타임 존이 로딩이 다 되었을 경우에만 검색을 진행
    if (allArray) {
        NSPredicate *startPredicate = [NSPredicate predicateWithFormat:@"currencyUnitName beginsWith[cd] %@", searchString];
        
        // 2. 시작하지 않으면서 포함하는 Country
        NSPredicate *notBeginsWithPredicate = [NSCompoundPredicate notPredicateWithSubpredicate:startPredicate];
        NSPredicate *containPredicate = [NSPredicate predicateWithFormat:@"currencyUnitName contains[cd] %@", searchString]; //, searchString];
        NSPredicate *compoundedContainPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notBeginsWithPredicate, containPredicate]];
        
        NSArray *arrayBeginsWithSearchString = [allArray filteredArrayUsingPredicate:startPredicate];
        NSArray *arrayContainsSearchString = [allArray filteredArrayUsingPredicate:compoundedContainPredicate];
        
        return [arrayBeginsWithSearchString arrayByAddingObjectsFromArray:arrayContainsSearchString];
    }else{
        return nil;
    }
}

+ (MNExchangeRateCountry *)countryWithIndex:(int)i
{
    [self countryWithCountryCode:@"USD"];
    
    return [countryArr objectAtIndex:i];
}

+ (NSMutableDictionary *)countriesDict
{
    // for init dictionary
    [self countryWithCountryCode:@"USD"];
    
    return countryDict;
}

+ (NSMutableArray *)countriesArr
{
    // for init dictionary
    [self countryWithCountryCode:@"USD"];
    
    return countryArr;
}

+ (NSMutableArray *)mainCountriesArr
{
    [self countryWithCountryCode:@"USD"];
    
    return mainCountryArr;
}

@end