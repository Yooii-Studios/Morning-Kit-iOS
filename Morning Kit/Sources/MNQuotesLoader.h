//
//  MNQuotesLoader.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNWidgetQuotesView.h"

@interface MNQuotesLoader : NSObject

+ (NSArray *)loadQuotesAndAuthorsWithLanguage:(MNQuotesLanguage)currentLanguage;
+ (NSArray *)loadAllQuotesData;

@end
