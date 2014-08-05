//
//  MNFlickrJSONParser.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 14..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNFlickrJSONParser.h"
#import "JSONKit.h"
#import "MNDefinitions.h"
#import "JLToast.h"

#define FLICKR_FIRST_LOADING_PER_PAGE 20

@implementation MNFlickrJSONParser

#pragma mark - new logic

// 새로 생각한 로직
+ (MNFlickrPhotoInfo *)getFirstFlickrPhotoInfoWithKeyword:(NSString *)keyword {
    
    NSString *escapedKeywordString = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 첫 로딩은 20아이템/1페이지에서
    NSString *queryString = [NSString stringWithFormat:@"&tags=%@&tag_mode=any&per_page=%d&page=1", escapedKeywordString, FLICKR_FIRST_LOADING_PER_PAGE];
    
    // 쿼리가 변경됨
//    NSString *queryURLString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?sort=random&method=flickr.photos.search%@&api_key=%@&format=json&nojsoncallback=1", queryString, FLICKR_API_KEY];
    
    NSString *queryURLString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?sort=random&method=flickr.photos.search%@&api_key=%@&format=json&nojsoncallback=1", queryString, FLICKR_API_KEY];
    
    
//    NSLog(@"%@", queryURLString);
    
    // JSON을 사용해 파싱
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryURLString]];
    //    NSLog(@"%@", jsonData);
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    if (jsonData) {
        NSDictionary *photos = [[jsonKitDecoder objectWithData:jsonData] objectForKey:@"photos"]; // JSONKit
        
        if (photos) {
            // 검색 결과가 있는지 체크
//            if ([photos objectForKey:@"pages"]) {
//                NSInteger pages = ((NSString *)[photos objectForKey:@"pages"]).integerValue;
//                if (pages == 0) {
//                    return nil;
//                }
//            }
            
            if ([[photos objectForKey:@"total"] isKindOfClass:[NSNull class]]) {
//                NSLog(@"total is NSNull");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[JLToast makeText:MNLocalizedString(@"flickr_not_available_flickr_url", "에러메시지")] show];
                });
                return nil;
            }else{
                NSInteger totalNumberOfPhotos = ((NSString *)[photos objectForKey:@"total"]).integerValue;
                if (totalNumberOfPhotos == 0) {
                    // 검색 결과 없음
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[JLToast makeText:MNLocalizedString(@"flickr_not_available_flickr_url", "에러메시지")] show];
                    });
                    return nil;
                }
                
                MNFlickrPhotoInfo *flickrPhotoInfo = [[MNFlickrPhotoInfo alloc] init];
                flickrPhotoInfo.totalNumberOfPhotos = totalNumberOfPhotos;
                
                // 총 사진 갯수가 100 이상이면 100으로 고정, 이하면 그대로 둠
                NSInteger totalNumberOfItemInThisPage = totalNumberOfPhotos;
                if (totalNumberOfItemInThisPage >= FLICKR_FIRST_LOADING_PER_PAGE) {
                    totalNumberOfItemInThisPage = FLICKR_FIRST_LOADING_PER_PAGE;
                }
                
                // 난수 생성
                NSInteger randomIndex = arc4random() % totalNumberOfItemInThisPage;
                
                NSDictionary *photoItem = [[photos objectForKey:@"photo"] objectAtIndex:randomIndex];
                //        NSLog(@"%d", [[photos objectForKey:@"photo"] count]);
                //        NSLog(@"%@", photoItem);
                
                NSString *idString, *secretString, *serverString, *farmString;
                idString = [photoItem objectForKey:@"id"];
                secretString = [photoItem objectForKey:@"secret"];
                serverString = [photoItem objectForKey:@"server"];
                farmString = [photoItem objectForKey:@"farm"];
                
                if (idString && secretString && serverString && farmString) {
                    flickrPhotoInfo.photoUrlString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_z.jpg", farmString, serverString, idString, secretString];
                    
                    return flickrPhotoInfo;
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[JLToast makeText:MNLocalizedString(@"flickr_not_available_flickr_url", "에러메시지")] show];
                    });
                }
                return nil;
            }
        }

    }else{
//        NSLog(@"jsonData is nil");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JLToast makeText:MNLocalizedString(@"flickr_error_access_server", nil)] show]; // @"Error in access to flickr server"] show];
        });
        return nil;
    }
    return nil;
}

+ (NSString *)getFlickrPhotoUrlStringWithKeyword:(NSString *)keyword withTotalNumberOfPhotos:(NSInteger)totalNumberOfPhotos {
    NSString *escapedKeywordString = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 랜덤 페이지 생성
    NSInteger randomPage;
    if (totalNumberOfPhotos >= 4000) {
        totalNumberOfPhotos = 4000;
    }
    randomPage = arc4random() % totalNumberOfPhotos + 1; // 1~40 까지 가능
    
//    NSLog(@"randomPage: %d", randomPage);
    
    
    // 첫 로딩은 100아이템/1페이지에서
    NSString *queryString = [NSString stringWithFormat:@"&tags=%@&tag_mode=any&per_page=1&page=%d", escapedKeywordString, randomPage];
    
    NSString *queryURLString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?sort=random&method=flickr.photos.search%@&api_key=%@&format=json&nojsoncallback=1", queryString, FLICKR_API_KEY];
    
//    NSLog(@"done queryURLString");
    
    // JSON을 사용해 파싱
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryURLString] options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"flickrJSONData error: %@", [error localizedDescription]);
    }
    //    NSLog(@"%@", jsonData);
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    if (jsonData) {
//        NSLog(@"load jsonData");
        NSString *idString, *secretString, *serverString, *farmString;
        
        NSDictionary *photos = [[jsonKitDecoder objectWithData:jsonData] objectForKey:@"photos"]; // JSONKit
        
        if ([[photos objectForKey:@"photo"] count] > 0) {
            NSDictionary *photoItem = [[photos objectForKey:@"photo"] objectAtIndex:0];
            //        NSLog(@"%d", [[photos objectForKey:@"photo"] count]);
            //        NSLog(@"%@", photoItem);
            
            
            idString = [photoItem objectForKey:@"id"];
            secretString = [photoItem objectForKey:@"secret"];
            serverString = [photoItem objectForKey:@"server"];
            farmString = [photoItem objectForKey:@"farm"];
        }
        
        if (idString && secretString && serverString && farmString) {
//            NSLog(@"load photoUrlString");
            return [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_z.jpg", farmString, serverString, idString, secretString];
        }else{
            NSLog(@"error in making photoUrlString");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JLToast makeText:MNLocalizedString(@"flickr_not_available_flickr_url", "에러메시지")] show];
            });
            return nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JLToast makeText:MNLocalizedString(@"flickr_not_available_flickr_url", "에러메시지")] show];
        });
        return nil;
    }else{
//        NSLog(@"fail loading jsonData: %@", queryURLString);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JLToast makeText:MNLocalizedString(@"flickr_error_access_server", nil)] show]; // [[JLToast makeText:@"Error in access to flickr server"] show];
        });
        return nil;
    }
}

@end
