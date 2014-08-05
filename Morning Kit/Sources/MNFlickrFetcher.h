//
//  MNFlickrFetcher.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

// 해당 키워드에 해당하는 url을 얻거나, 이미지를 얻어오는 네트워크 API. 가장 바깥쪽에서 인터페이스처럼 활용.
@interface MNFlickrFetcher : NSObject

+ (NSData *)flickrImageDataFromUrlString:(NSString *)urlString;

@end
