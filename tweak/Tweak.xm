#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CAFilter : NSObject
+ (id)filterWithType:(NSString *)type;
- (void)setValue:(id)value forKey:(NSString *)key;
@end

@interface SBIconView : UIView
@end
@interface SBDockView : UIView
@end

#define ICON_RADIUS_RATIO 0.225f
#define DOCK_INSET_X 12.0f
#define DOCK_INSET_Y 6.0f

static void applyGlass(CALayer *layer, CGFloat radius, CGFloat corner) {
    layer.cornerRadius = corner;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.16].CGColor;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.45].CGColor;

    Class cf = NSClassFromString(@"CAFilter");
    if (cf) {
        id blur = [cf filterWithType:@"gaussianBlur"];
        [blur setValue:@(radius) forKey:@"inputRadius"];
        layer.backgroundFilters = @[blur];
    }
}

%hook SBDockView
- (void)layoutSubviews {
    %orig;
    UIView *bg = nil;
    @try { bg = [self valueForKey:@"_backgroundView"]; } @catch (NSException *e) {}
    if (bg && bg.layer.cornerRadius == 0) {
        bg.frame = CGRectInset(bg.frame, DOCK_INSET_X, DOCK_INSET_Y);
        applyGlass(bg.layer, 5.0, 24.0);
    }
}
%end

%hook SBIconView
- (void)layoutSubviews {
    %orig;
    UIView *img = nil;
    @try { img = [self valueForKey:@"_iconImageView"]; } @catch (NSException *e) {}
    if (img) {
        CGFloat w = img.bounds.size.width;
        img.layer.cornerRadius = w * ICON_RADIUS_RATIO;
        img.layer.shadowColor = [UIColor blackColor].CGColor;
        img.layer.shadowOpacity = 0.22;
        img.layer.shadowRadius = 3.0;
        img.layer.shadowOffset = CGSizeMake(0, 2);
        img.layer.shouldRasterize = YES;
        img.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
}
%end
