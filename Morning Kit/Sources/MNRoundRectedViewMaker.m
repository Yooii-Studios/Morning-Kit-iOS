//
//  MNRoundedRectMaker.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 21..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNRoundRectedViewMaker.h"
#import <QuartzCore/QuartzCore.h>
#import "MNDefinitions.h"
#import "MNTheme.h"
#import "SKInnerShadowLayer.h"
#import "MNTranslucentFont.h"

#define SHADOW_RADIUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2.7f : 1.3f)
#define SHADOW_OPACITY ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.4f : 0.7f)

#define BORDER_WIDTH_TRANSLUCENT 0.15f
#define BORDER_WIDTH_TRANSLUCENT_NON_RETINA 0.3f

@implementation MNRoundRectedViewMaker

+ (void)makeRoundRectedViewFromOriginalView:(UIView *)originalView inSuperView:(UIView *)superView isLeftBoundary:(BOOL)isLeftBoundary isTopBoundary:(BOOL)isTopBoundary isRightBoundary:(BOOL)isRightBoundary isBottomBoundary:(BOOL)isBottomBoundary {
    
    // 뷰 자체는 masksToBounds 설정을 안해줘도 되고, 최상위 컨테이너에서 설정을 해 줘야 할듯
    originalView.layer.masksToBounds = NO;
    superView.layer.masksToBounds = NO;
    
    CGFloat leftPadding, rightPadding, topPadding, bottomPadding;
    
    // 방향에 따른 패딩 조정
    if (isLeftBoundary)
        leftPadding = PADDING_BOUNDARY;
    else
        leftPadding = PADDING_INNER;
    
    if (isRightBoundary)
        rightPadding = PADDING_BOUNDARY;
    else
        rightPadding = PADDING_INNER;
    
    if (isTopBoundary)
        topPadding = PADDING_BOUNDARY;
    else
        topPadding = PADDING_INNER;
    
    if (isBottomBoundary)
        bottomPadding = PADDING_BOUNDARY;
    else
        bottomPadding = PADDING_INNER;
    
    // Round Rect
    originalView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    
    // adjust Frame
    CGRect newFrame = originalView.bounds;
    newFrame.origin.x = leftPadding;
    newFrame.origin.y = topPadding;
    newFrame.size.width = superView.frame.size.width - (leftPadding + rightPadding);
    newFrame.size.height = superView.frame.size.height - (topPadding + bottomPadding);
    originalView.frame = newFrame;
    
    // adjust Bounds
//    originalView.bounds = newFrame; // 이 부분은 없었지만 어긋나는 shadow를 위해 bound도 같이 조정. 나중에 어떤 효과가 생기는지 확인 필요
    
//    NSLog(@"%@", NSStringFromCGRect(newFrame));
    
    // 투명뷰이고, 컨피크 탭에 있지 않으면 그림자 그리기 않기
    if ([MNTheme getCurrentlySelectedTheme] == MNThemeTypeMirror || [MNTheme getCurrentlySelectedTheme] == MNThemeTypeScenery || [MNTheme getCurrentlySelectedTheme] == MNThemeTypePhoto || [MNTheme getCurrentlySelectedTheme] == MNThemeTypeWaterLily) {
        if ([MNTheme sharedTheme].isThemeForConfigure == NO) {
            
            // 기존: 그림자가 아예 없음
            originalView.layer.shadowOpacity = 0;
            originalView.layer.shadowPath = nil;
            originalView.layer.shadowRadius = 0;
            
            if ([UIScreen mainScreen].scale == 2.0f) {
                originalView.layer.borderWidth = BORDER_WIDTH_TRANSLUCENT;
            }else{
                originalView.layer.borderWidth = BORDER_WIDTH_TRANSLUCENT_NON_RETINA;
            }
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeBlack || [MNTheme getCurrentlySelectedTheme] == MNThemeTypeWaterLily) {
                originalView.layer.borderColor = [UIColor blackColor].CGColor;
            }else{
                originalView.layer.borderColor = [UIColor whiteColor].CGColor;
            }
            
            /*
            // 수정: Inner Glow 효과
            // InnerShadow 씌우기 - 새 코드
            SKInnerShadowLayer *innerShadowLayer = [[SKInnerShadowLayer alloc] init];
            innerShadowLayer.colors = (@[(id)[UIColor whiteColor].CGColor]);
            innerShadowLayer.frame = originalView.bounds;
            innerShadowLayer.cornerRadius = ROUNDED_CORNER_RADIUS;
            
//            innerShadowLayer.opacity = 0.3f;
            innerShadowLayer.innerShadowOpacity = 0.7f; // 0.3f;
            innerShadowLayer.innerShadowColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5f].CGColor;
            //    shadowLayer.innerShadowColor = [UIColor whiteColor].CGColor;
            innerShadowLayer.innerShadowOffset = CGSizeMake(0, 0);
            innerShadowLayer.innerShadowRadius = 40;
            innerShadowLayer.rasterizationScale = [[UIScreen mainScreen] scale];    // 래스터라이즈는 성능 향상
            innerShadowLayer.shouldRasterize = YES;
            innerShadowLayer.masksToBounds = YES;   // 이너 쉐도우는 바깥으로 빠질 필요없음
            [innerShadowLayer setValue:@"innerGlow" forKey:@"kTag"];
            
//            for (CALayer *layer in originalView.layer.sublayers) {
//                if ([[layer valueForKey:@"kTag"] isEqualToString:@"innerGlow"]) {
//                    NSLog(@"remove innerGlowLayer");
//                    [layer removeFromSuperlayer];
//                }
//            }
            
            [originalView.layer addSublayer:innerShadowLayer];
            */
            
            // 수정: 그림자 효과 넣기
            // Drop Shadow 효과 내기
            /*
            CALayer *shadowLayer = [[CALayer alloc] init];
            shadowLayer.frame = originalView.bounds;
            shadowLayer.cornerRadius = ROUNDED_CORNER_RADIUS;
            shadowLayer.backgroundColor = RGBA(255, 255, 255, 1).CGColor; // 안을 채워주고 나중에 reverse mask로 비워야 그림자 적용이 됨.
            //    shadowLayer.shadowOpacity = 0;
            shadowLayer.shadowOpacity = 0.4f;
            //    shadowLayer.shadowOpacity = 1;
            shadowLayer.shadowColor = [UIColor blackColor].CGColor;
            shadowLayer.shadowOffset = CGSizeMake(0, 0);
            //    shadowLayer.shadowRadius = 15.0f;
            shadowLayer.shadowRadius = 1.3f;
            shadowLayer.rasterizationScale = [[UIScreen mainScreen] scale];
            shadowLayer.shouldRasterize = YES;
            shadowLayer.masksToBounds = NO;
            [shadowLayer setValue:@"kTag" forKey:@"kTag"];
            
            // Drop Shadow 안쪽 마스크의 리버스 처리해 안쪽 모두 지우기
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = originalView.bounds;
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:maskLayer.frame cornerRadius:ROUNDED_CORNER_RADIUS].CGPath;
            
            // got to make it a bit bigger if your original path reaches to the edge
            // since the shadow needs to stretch "outside" the frame:
            CGFloat shadowBorder = 3.0; // 50만큼 퍼지게 되는 것. 이 값이 작으면, 멀리 퍼져나가지 않고 잘린다.
            // CGRectInset 은 dx, dy만큼 상하좌우 작은 CGRect를 반환
            maskLayer.frame = CGRectInset( maskLayer.frame, - shadowBorder, - shadowBorder );
            // CGRectOffset 은 크기를 바꾸지 않고, dx, dy 만큼 위치를 바꾼 CGRect를 변환
            maskLayer.frame = CGRectOffset( maskLayer.frame, shadowBorder/2.0, shadowBorder/2.0 );
            maskLayer.fillColor = [UIColor redColor].CGColor;
            maskLayer.lineWidth = 0.0;
            maskLayer.fillRule = kCAFillRuleEvenOdd;
            maskLayer.shouldRasterize = YES;
            maskLayer.rasterizationScale = [[UIScreen mainScreen] scale];
            
            CGMutablePathRef pathMasking = CGPathCreateMutable();
            CGPathAddPath(pathMasking, NULL, [UIBezierPath bezierPathWithRect:maskLayer.frame].CGPath);
            CGAffineTransform catShiftBorder = CGAffineTransformMakeTranslation( shadowBorder/2.0, shadowBorder/2.0);
            CGPathAddPath(pathMasking, NULL, CGPathCreateCopyByTransformingPath(maskLayer.path, &catShiftBorder ) );
            maskLayer.path = pathMasking;
            
            // 그림자 레이어에 리버스 마스킹하기
            shadowLayer.mask = maskLayer;
//            NSLog(@"%@", originalView.layer.sublayers);
//            originalView.layer.sublayers = nil;
            for (CALayer *layer in originalView.layer.sublayers) {
                if ([[layer valueForKey:@"kTag"] isEqualToString:@"kTag"]) {
                    NSLog(@"kTag Layer");
                    [layer removeFromSuperlayer];
                }
            }
//            [originalView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            [originalView.layer addSublayer:shadowLayer];
             */
//            NSLog(@"make shadowLayer");
            return;
        }
    }
    // Drop shadow - 투명 모드일 경우는 그림자가 없든지 아주 옅어야 한다.
    originalView.layer.shadowColor = [[UIColor blackColor] CGColor];
    // 아래 수치는 계속 조정중
    originalView.layer.shadowOpacity = SHADOW_OPACITY;
    originalView.layer.shadowRadius = SHADOW_RADIUS;
    originalView.layer.shadowOffset = CGSizeMake(0, 0);
    
    // shadowPath 수정: 미리 rounded-rect 쉐도우를 그려주고, radius를 1로 두어 조금만 그려주기
    //    originalView.layer.shadowPath = [UIBezierPath bezierPathWithRect:originalView.bounds].CGPath;
    originalView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:originalView.bounds cornerRadius:ROUNDED_CORNER_RADIUS].CGPath;
    
    // rasterize 추가: 벡터를 비트맵으로 변환하는데, iOS 5 이상부터 메모리를 더 써서 퍼포먼스를 증가시킬 수 있음
    originalView.layer.shouldRasterize = YES;
    originalView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // border 없애주기
    originalView.layer.borderColor = [UIColor clearColor].CGColor;
    originalView.layer.borderWidth = 0;
}

+ (void)makeRoundRectedView:(UIView *)originalView {
    originalView.layer.masksToBounds = NO;
    
    // Round Rect
    originalView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    
    // 투명뷰이고, 컨피크 탭에 있지 않으면 그림자 그리기 않기
    if ([MNTheme getCurrentlySelectedTheme] == MNThemeTypeMirror || [MNTheme getCurrentlySelectedTheme] == MNThemeTypeScenery || [MNTheme getCurrentlySelectedTheme] == MNThemeTypePhoto || [MNTheme getCurrentlySelectedTheme] == MNThemeTypeWaterLily) {
        if ([MNTheme sharedTheme].isThemeForConfigure == NO) {
            originalView.layer.shadowOpacity = 0;
            originalView.layer.shadowPath = nil;
            originalView.layer.shadowRadius = 0;
            
//            originalView.layer.borderWidth = BORDER_WIDTH_TRANSLUCENT;
            if ([UIScreen mainScreen].scale == 2.0f) {
                originalView.layer.borderWidth = BORDER_WIDTH_TRANSLUCENT;
            }else{
                originalView.layer.borderWidth = BORDER_WIDTH_TRANSLUCENT_NON_RETINA;
            }
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeBlack || [MNTheme getCurrentlySelectedTheme] == MNThemeTypeWaterLily) {
                originalView.layer.borderColor = [UIColor blackColor].CGColor;
            }else{
                originalView.layer.borderColor = [UIColor whiteColor].CGColor;
            }
            return;
        }
    }
    // Drop shadow - 투명 모드일 경우는 그림자가 없든지 아주 옅어야 한다.
    originalView.layer.shadowColor = [[UIColor blackColor] CGColor];
    // 아래 수치는 계속 조정중
    originalView.layer.shadowOpacity = SHADOW_OPACITY;
    originalView.layer.shadowRadius = SHADOW_RADIUS;
    originalView.layer.shadowOffset = CGSizeMake(0, 0);
    
    // shadowPath 수정: 미리 rounded-rect 쉐도우를 그려주고, radius를 1로 두어 조금만 그려주기
    //    originalView.layer.shadowPath = [UIBezierPath bezierPathWithRect:originalView.bounds].CGPath;
    originalView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:originalView.bounds cornerRadius:ROUNDED_CORNER_RADIUS].CGPath;
    
    // rasterize 추가: 벡터를 비트맵으로 변환하는데, iOS 5 이상부터 메모리를 더 써서 퍼포먼스를 증가시킬 수 있음
    originalView.layer.shouldRasterize = YES;
    originalView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

+ (void)makeRoundRectedViewWithoutShadowFromOriginalView:(UIView *)originalView inSuperView:(UIView *)superView isLeftBoundary:(BOOL)isLeftBoundary isTopBoundary:(BOOL)isTopBoundary isRightBoundary:(BOOL)isRightBoundary isBottomBoundary:(BOOL)isBottomBoundary {
    
    // 뷰 자체는 masksToBounds 설정을 안해줘도 되고, 최상위 컨테이너에서 설정을 해 줘야 할듯
    originalView.layer.masksToBounds = NO;
    superView.layer.masksToBounds = NO;
    
    CGFloat leftPadding, rightPadding, topPadding, bottomPadding;
    
    // 방향에 따른 패딩 조정
    if (isLeftBoundary)
        leftPadding = PADDING_BOUNDARY;
    else
        leftPadding = PADDING_INNER;
    
    if (isRightBoundary)
        rightPadding = PADDING_BOUNDARY;
    else
        rightPadding = PADDING_INNER;
    
    if (isTopBoundary)
        topPadding = PADDING_BOUNDARY;
    else
        topPadding = PADDING_INNER;
    
    if (isBottomBoundary)
        bottomPadding = PADDING_BOUNDARY;
    else
        bottomPadding = PADDING_INNER;
    
    // Round Rect
    originalView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    
    // adjust Frame
    CGRect newFrame = originalView.bounds;
    newFrame.origin.x = leftPadding;
    newFrame.origin.y = topPadding;
    newFrame.size.width = superView.frame.size.width - (leftPadding + rightPadding);
    newFrame.size.height = superView.frame.size.height - (topPadding + bottomPadding);
    originalView.frame = newFrame;
    
    // rasterize 추가: 벡터를 비트맵으로 변환하는데, iOS 5 이상부터 메모리를 더 써서 퍼포먼스를 증가시킬 수 있음
    originalView.layer.shouldRasterize = YES;
    originalView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // border 없애주기
    originalView.layer.borderColor = [UIColor clearColor].CGColor;
    originalView.layer.borderWidth = 0;
}

+ (CGRect)getRectFromOriginalView:(UIView *)originalView inSuperView:(UIView *)superView isLeftBoundary:(BOOL)isLeftBoundary isTopBoundary:(BOOL)isTopBoundary isRightBoundary:(BOOL)isRightBoundary isBottomBoundary:(BOOL)isBottomBoundary {
    
    CGFloat leftPadding, rightPadding, topPadding, bottomPadding;
    
    // 방향에 따른 패딩 조정
    if (isLeftBoundary)
        leftPadding = PADDING_BOUNDARY;
    else
        leftPadding = PADDING_INNER;
    
    if (isRightBoundary)
        rightPadding = PADDING_BOUNDARY;
    else
        rightPadding = PADDING_INNER;
    
    if (isTopBoundary)
        topPadding = PADDING_BOUNDARY;
    else
        topPadding = PADDING_INNER;
    
    if (isBottomBoundary)
        bottomPadding = PADDING_BOUNDARY;
    else
        bottomPadding = PADDING_INNER;
    
    // Round Rect
    originalView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    
    // adjust Frame
    CGRect newFrame = originalView.bounds;
    newFrame.origin.x = leftPadding;
    newFrame.origin.y = topPadding;
    newFrame.size.width = superView.frame.size.width - (leftPadding + rightPadding);
    newFrame.size.height = superView.frame.size.height - (topPadding + bottomPadding);
    
    return newFrame;
}


@end
