//
//  MNRoundedRectMaker.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 21..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNRoundRectedViewMaker : NSObject

// 일정 패딩을 두고 라운드 효과, 쉐도우 효과를 준다. 이 효과를 제대로 사용하기 위해서는, 기본의 View Hierarchy 위에 한 겹의 View를 더 만들고, 그 View를 이 메서드를 사용해 효과를 낸다. 테이블뷰의 기본 View같은 경우 frame 크기가 조절이 안되기 때문이고, 최상위 뷰는 이 효과를, 그 아래 뷰는 Backward Background Color를 적용해야 하기 때문이다. 
//+ (void)makeRoundRectedViewFromOriginalView:(UIView *)originalView inSuperView:(UIView *)superView;

// 바깥쪽 방향은 3픽셀, 안쪽 방향은 1.5픽셀을 줘야 하기 때문에 이 메서드를 사용해 각 방향을 잡아줄 수 있다. 이것만 사용하면 됨.
+ (void)makeRoundRectedViewFromOriginalView:(UIView *)originalView inSuperView:(UIView *)superView isLeftBoundary:(BOOL)isLeftBoundary isTopBoundary:(BOOL)isTopBoundary isRightBoundary:(BOOL)isRightBoundary isBottomBoundary:(BOOL)isBottomBoundary;

// 이 메서드는 특수한 경우에만 사용한다. 메인 화면이 아닐 경우에는 사용하는 것이 편하기도 하다.
+ (void)makeRoundRectedView:(UIView *)originalView;

+ (void)makeRoundRectedViewWithoutShadowFromOriginalView:(UIView *)originalView inSuperView:(UIView *)superView isLeftBoundary:(BOOL)isLeftBoundary isTopBoundary:(BOOL)isTopBoundary isRightBoundary:(BOOL)isRightBoundary isBottomBoundary:(BOOL)isBottomBoundary;

+ (CGRect)getRectFromOriginalView:(UIView *)originalView inSuperView:(UIView *)superView isLeftBoundary:(BOOL)isLeftBoundary isTopBoundary:(BOOL)isTopBoundary isRightBoundary:(BOOL)isRightBoundary isBottomBoundary:(BOOL)isBottomBoundary;

@end
