//
//  MNCityInfo.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNLocationInfo.h"

@implementation MNLocationInfo

@synthesize name;
@synthesize alternativeNames;
@synthesize regionCode;
@synthesize countryCode;
@synthesize timezoneCode;
@synthesize latitude;
@synthesize longitude;

- (id)init
{
    self = [super init];
    if( self )
    {
        // initialize code
        name = [[NSString alloc] init];
        countryCode = [[NSString alloc] init];
        timezoneCode = [[NSString alloc] init];
        latitude = 0.0f;
        longitude = 0.0f;
        
        self.woeid = 0;
        self.originalName = nil;
        self.otherNames = nil;
        self.englishName = nil;
        
        self.timestamp = nil;
        
        self.timeOffset = 0;
    }
    
    return self;
}

- (id) initByLanguageCode : (NSString*) _languageCode
{
    self = [super init];
    if( self )
    {
        if( [_languageCode isEqualToString:@"en"] )
        {
            
        }
        else if( [_languageCode isEqualToString:@"ko"] )
        {
            
        }
        else if( [_languageCode isEqualToString:@"ja"] )
        {
            
        }
        else if( [_languageCode isEqualToString:@"zh-Hans"] )
        {
            
        }
        else if( [_languageCode isEqualToString:@"zh-Hant"] )
        {
            
        }
        else
        {
            name = @"";
            alternativeNames = [[NSMutableArray alloc] init];
            regionCode = @"";
            countryCode = @"";
            timezoneCode = @"";
            latitude = 0.0f;
            longitude = 0.0f;
            
            self.woeid = 0;
            self.originalName = nil;
            self.otherNames = nil;
            self.englishName = nil;
            
            self.timestamp = nil;
            
            self.timeOffset = 0;
        }

    }
    return self;
}

#pragma mark - NSCoding Delegate Methods
//
//@property (nonatomic) NSString *name;
//@property (nonatomic) NSMutableArray *alternativeNames;
//@property (nonatomic) NSString *regionCode;
//@property (nonatomic) NSString *countryCode;
//@property (nonatomic) NSString *timezoneCode;
//@property (nonatomic) float     latitude;
//@property (nonatomic) float     longitude;
//

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name               = [aDecoder decodeObjectForKey:@"name"];
        self.alternativeNames   = [aDecoder decodeObjectForKey:@"alternativeNames"];
        self.regionCode         = [aDecoder decodeObjectForKey:@"regionCode"];
        self.countryCode        = [aDecoder decodeObjectForKey:@"countryCode"];
        self.timezoneCode       = [aDecoder decodeObjectForKey:@"timezoneCode"];
        self.latitude           = [aDecoder decodeFloatForKey:@"latitude"];
        self.longitude          = [aDecoder decodeFloatForKey:@"longitude"];
        
        self.woeid              = [aDecoder decodeIntegerForKey:@"woeid"];
        self.englishName        = [aDecoder decodeObjectForKey:@"englishName"];
        self.originalName       = [aDecoder decodeObjectForKey:@"originalName"];
        self.otherNames         = [aDecoder decodeObjectForKey:@"otherNames"];
        
        self.timestamp          = [aDecoder decodeObjectForKey:@"timestamp"];
        
        self.timeOffset         = [aDecoder decodeIntegerForKey:@"timeOffset"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:   self.name                   forKey:@"name"];
    [aCoder encodeObject:   self.alternativeNames       forKey:@"alternativeNames"];
    [aCoder encodeObject:   self.regionCode             forKey:@"regionCode"];
    [aCoder encodeObject:   self.countryCode            forKey:@"countryCode"];
    [aCoder encodeObject:   self.timezoneCode           forKey:@"timezoneCode"];
    [aCoder encodeFloat:    self.latitude               forKey:@"latitude"];
    [aCoder encodeFloat:    self.longitude              forKey:@"longitude"];
    
    [aCoder encodeInteger:  self.woeid                  forKey:@"woeid"];
    [aCoder encodeObject:   self.englishName            forKey:@"englishName"];
    [aCoder encodeObject:   self.originalName           forKey:@"originalName"];
    [aCoder encodeObject:   self.otherNames             forKey:@"otherNames"];
    
    [aCoder encodeObject:   self.timestamp              forKey:@"timestamp"];
    
    [aCoder encodeInteger:  self.timeOffset             forKey:@"timeOffset"];
}

@end
