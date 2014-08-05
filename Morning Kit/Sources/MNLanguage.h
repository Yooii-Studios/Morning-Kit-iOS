//
//  MNLanguage.h
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 19..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MNLanguageType) {
    MNLanguageTypeEnglish = 0,
    MNLanguageTypeJapanese,
    MNLanguageTypeKorean,
    MNLanguageTypeSimplified,
    MNLanguageTypeTraditional,
    MNLanguageTypeDefault = 100,
};

@interface MNLanguage : NSObject

// 처음 앱 실행시 혹은 기본 언어일 시 기기의 언어를 체크해 설정해주기, 그 외에는 체크하지 않기
+ (NSString *)getCurrentLanguage;
+ (void)checkCurrentLanguage;
+ (NSInteger)getLanguageIndexFromCodeString:(NSString *)codeString;
+ (NSString *)languageCodeStringAtIndex:(int)index;
+ (NSString *)languageStringFromCodeString:(NSString *)codeString;
+ (void)setLocalizedTitleLabel:(UILabel *)titleLabel withSummaryLabel:(UILabel *)summaryLabel AtIndex:(int)index;

@end
