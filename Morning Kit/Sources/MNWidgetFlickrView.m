//
//  MNWidgetFlickrView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetFlickrView.h"
#import "MNTheme.h"
#import "MNFlickrFetcher.h"
#import "MNDefinitions.h"
#import <QuartzCore/QuartzCore.h>
#import "MNFlickrImageProcessor.h"
#import "JLToast.h"
#import "MNFlickrJSONParser.h"
#import "MNFlickrPhotoInfo.h"

@implementation MNWidgetFlickrView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWidgetView {
//    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    // Keyword 로딩
    self.keywordString = [self.widgetDictionary objectForKey:FLICKR_KEYWORD];
    
    
//    self.keywordString = @"Morning";
    if (self.keywordString == nil) {
        NSString *archivedKeywordString = [[NSUserDefaults standardUserDefaults] objectForKey:FLICKR_KEYWORD];
        if (archivedKeywordString) {
            self.keywordString = archivedKeywordString;
        }else{
            self.keywordString = @"Morning";
        }
        [self.widgetDictionary setObject:self.keywordString forKey:FLICKR_KEYWORD];
    }
    
    // imageData 로딩
    self.imageData = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.imageData = [self.widgetDictionary objectForKey:@"imageData"];
        if (self.imageData) {
            self.originalFlickrImage = [UIImage imageWithData:self.imageData];
        }
//        [self getFlickrImagesForOrientations];
    });
    
    // round-rect 처리
    self.flickrImageView.image = nil;
    self.flickrImageView.layer.masksToBounds = YES;
    self.flickrImageView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    
//    self.layer.masksToBounds = YES;
    
    // 총 사진 갯수가 있는지 확인 - 값이 없으면 0
    NSNumber *numberOfPhotos = ((NSNumber *)[self.widgetDictionary objectForKey:FLICKR_TOTAL_NUMBER_OF_PHOTOS]);
    if (numberOfPhotos) {
        self.totalNumberOfPhtos = numberOfPhotos.integerValue;
    } 
//    NSLog(@"totalNumberOfPhtos: %d", self.totalNumberOfPhtos);
    
    self.widgetNameLabel.alpha = 0;
    self.networkFailLabel.alpha = 0;
}

/*
- (void)getFlickrImagesForOrientations {
    // 오리지널 UIImage 얻기
    UIImage *origianlImage = [UIImage imageWithData:self.imageData];
    if (origianlImage) {
        self.portraitImage = [MNFlickrImageProcessor getPortraitImageFromOriginalImage:origianlImage];
        self.landscapeImage = [MNFlickrImageProcessor getLandscapeImageFromOriginalImage:origianlImage];
    }
}
*/


#pragma mark - methods on network available

- (void)doWidgetLoadingInBackground {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.flickrImageView.image = nil;
        self.alpha = 0.0f;  // 커버뷰 관련해서 추가. 위젯 설정에서 새 플리커 위젯으로 바꾸고 나오면 로딩이 안보여서 이렇게 수정해둠.
        [self.loadingDelegate setLoadingViewAlpha:1.0f];
    });
    
    NSString *urlString;
    
    // Flickr 키워드를 받아온다
    NSString *previousString = self.keywordString;
    self.keywordString = [self.widgetDictionary objectForKey:FLICKR_KEYWORD];
    
    if (self.keywordString == nil) {
        NSString *archivedKeywordString = [[NSUserDefaults standardUserDefaults] objectForKey:FLICKR_KEYWORD];
        if (archivedKeywordString) {
            self.keywordString = archivedKeywordString;
        }else{
            self.keywordString = @"Morning";
        }
        [self.widgetDictionary setObject:self.keywordString forKey:FLICKR_KEYWORD];
        
        // 새 키워드의 첫 로딩
        MNFlickrPhotoInfo *flickrPhotoInfo = [MNFlickrJSONParser getFirstFlickrPhotoInfoWithKeyword:self.keywordString];
        
        if (flickrPhotoInfo) {
            urlString = flickrPhotoInfo.photoUrlString;
            
            // 읽어온 총 사진 갯수 저장
            [self.widgetDictionary setObject:@(flickrPhotoInfo.totalNumberOfPhotos) forKey:FLICKR_TOTAL_NUMBER_OF_PHOTOS];
            self.totalNumberOfPhtos = flickrPhotoInfo.totalNumberOfPhotos;
        }
    }else{
        // 이전 스트링과 비교해서, 같지 않으면 첫 로딩, 같으면 기존에 가지고 있던 총 사진 갯수를 가지고 로딩
        if ([self.keywordString isEqualToString:previousString] && (self.totalNumberOfPhtos != 0)) {
            // 기존 로딩
            urlString = [MNFlickrJSONParser getFlickrPhotoUrlStringWithKeyword:self.keywordString withTotalNumberOfPhotos:self.totalNumberOfPhtos];
        }else{
            // 새 키워드의 첫 로딩
            MNFlickrPhotoInfo *flickrPhotoInfo = [MNFlickrJSONParser getFirstFlickrPhotoInfoWithKeyword:self.keywordString];
            
            if (flickrPhotoInfo) {
                urlString = flickrPhotoInfo.photoUrlString;
                
                // 읽어온 총 사진 갯수 저장
                [self.widgetDictionary setObject:@(flickrPhotoInfo.totalNumberOfPhotos) forKey:FLICKR_TOTAL_NUMBER_OF_PHOTOS];
                self.totalNumberOfPhtos = flickrPhotoInfo.totalNumberOfPhotos;
            }
        }
    }
//    NSLog(@"%@", self.keywordString);
    
    // Image를 백그라운드로 얻는다.
//    NSString *urlString = [MNFlickrFetcher urlStringForFlickrPhotoWithKeyword:self.keywordString];
    
    if (urlString) {
        NSData *newImageData;
        newImageData = [MNFlickrFetcher flickrImageDataFromUrlString:urlString];
        
        if (newImageData) {
            self.imageData = newImageData;
        }else{
            // JLToast 로 에러 메시지를 출력한다.
//            dispatch_async(dispatch_get_main_queue(), ^{
////                NSLog(@"new Image Data is nil");
//                JLToast *loadingErrorMessage = [JLToast makeText:MNLocalizedString(@"flickr_not_available_flickr_url", "에러메시지")];
//                [loadingErrorMessage show];
//            });
        }
        
        // 현재 프레임에 해당하는 사진을 얻는다.
        self.originalFlickrImage = [UIImage imageWithData:self.imageData];
        self.croppedFlickrImage = [MNFlickrImageProcessor getCroppedImageFromOriginalImage:self.originalFlickrImage withFrame:self.frame];
        
        // 그레이 스케일 체크
        self.isGrayscaleOn = ((NSNumber *)[self.widgetDictionary objectForKey:FLICKR_GRAY_SCALE_ON]).boolValue;
        if (self.isGrayscaleOn) {
            self.croppedFlickrImage = [MNFlickrImageProcessor getGrayscaledImageFromOriginalImage:self.croppedFlickrImage];
        }
        
        // 이미지를 새로 받아 왔다면 저장하기
        if (newImageData) {
            [self.widgetDictionary setObject:newImageData forKey:@"imageData"];
        }
        
        // 최근 url 저장하기
        [self.widgetDictionary setObject:urlString forKey:@"flickrPhotoUrlString"];
    }
}

// 네트워크가 안되면 이쪽으로 빠지질 않음.
- (void)updateUI{
    
    if (self.croppedFlickrImage) {
        self.flickrImageView.image = self.croppedFlickrImage;
    }else{
        // 네트워크가 될 때에는 키워드 문제일 가능성이 높음, 로딩 뷰의 레이블을 변경할 수 있어야 한다.
        // 용빈이 델리게이트 만들어 주면 아래 메시지를 대입하기. 진짜 네트워크가 안 될 때 다시 레이블 돌아오는 지도 테스트 필요
        [self.loadingDelegate showWidgetErrorMessage:MNLocalizedString(@"flickr_not_available_flickr_url", @"검색 결과 없음")];
//        [self.loadingDelegate showNetworkFail];
    }
    
//    self.imageData = nil;
}

#pragma mark - process when network is not available

- (void)processOnNoNetwork {
//    [self.loadingDelegate setLoadingViewAlpha:0.0f];
//    self.alpha = 1.0f;
//    self.loadingView.alpha = 0;
//    self.flickrImageView.image = nil;
//    self.backgroundColor = [UIColor blueColor];
}


#pragma mark - widget click

- (void)widgetClicked {
    if (self.keywordString) {
        [self.widgetDictionary setObject:self.keywordString forKey:FLICKR_KEYWORD];
    }else{
        [self.widgetDictionary setObject:@"Morning" forKey:FLICKR_KEYWORD];
    }

    if (self.flickrImageView.image != nil) {
        [self.widgetDictionary setObject:self.imageData forKey:FLICKR_IMAGE_DATA];
    }else{
        [self.widgetDictionary removeObjectForKey:FLICKR_IMAGE_DATA];
    }
}


#pragma mark - handling widget click

- (void)initThemeColor {
    [super initThemeColor];
    self.widgetNameLabel.textColor = [MNTheme getMainFontUIColor];
    self.networkFailLabel.textColor = [MNTheme getWidgetSubFontUIColor];
//    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
}


#pragma mark - handling rotation

- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation {
    // 가로/세로에 따라 해당하는 아트를 적용해주기
    // 가로, 세로 전용 사진 추출(폰 비율에 따라)
    // 3.5인치(320*480), 4인치(640*1136)(폰) / 태블릿 (7.9인치, 9.7인치) 1024*768, 2048*1536
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.croppedFlickrImage = [MNFlickrImageProcessor getCroppedImageFromOriginalImage:self.originalFlickrImage withFrame:self.frame];
        if (self.isGrayscaleOn) {
            self.croppedFlickrImage = [MNFlickrImageProcessor getGrayscaledImageFromOriginalImage:self.croppedFlickrImage];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.flickrImageView.image = self.croppedFlickrImage;
        });
    });
    
//    if (orientation == UIInterfaceOrientationPortrait) {
//        self.flickrImageView.image = self.portraitImage;
//    }else{
//        self.flickrImageView.image = self.landscapeImage;
//    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
