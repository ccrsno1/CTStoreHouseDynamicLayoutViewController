//
//  CTDynamicPicViewItem.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicImageViewItem.h"
#import "UIView+LayoutMethods.h"

@interface CTDynamicImageViewItem ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *horizontalDragPointView;
@property (nonatomic, strong) UIView *verticalDragPointView;
@property (nonatomic, strong) UIView *cornerDragPointView;

@end

@implementation CTDynamicImageViewItem

#pragma mark - life cycle
- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.imageView.image = image;
        [self addSubview:self.imageView];
        [self addSubview:self.horizontalDragPointView];
        [self addSubview:self.verticalDragPointView];
        [self addSubview:self.cornerDragPointView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedSelf:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.imageView leftInContainer:4 shouldResize:YES];
    [self.imageView rightInContainer:4 shouldResize:YES];
    [self.imageView topInContainer:4 shouldResize:YES];
    [self.imageView bottomInContainer:4 shouldResize:YES];
    
    [self.horizontalDragPointView rightInContainer:0 shouldResize:NO];
    [self.horizontalDragPointView centerYEqualToView:self];
    
    [self.verticalDragPointView bottomInContainer:0 shouldResize:NO];
    [self.verticalDragPointView centerXEqualToView:self];
    
    [self.cornerDragPointView rightInContainer:0 shouldResize:NO];
    [self.cornerDragPointView bottomInContainer:0 shouldResize:NO];
}

#pragma mark - event response
- (void)horizontalPanGestureDidRecognized:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer translationInView:self];
    [panGestureRecognizer setTranslation:CGPointZero inView:self];
    self.frame = CGRectMake(self.x, self.y, self.width + point.x, self.height);
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewItemDidChangedFrame:)]) {
        [self.delegate imageViewItemDidChangedFrame:self];
    }
}

- (void)verticalPanGestureDidRecognized:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer translationInView:self];
    [panGestureRecognizer setTranslation:CGPointZero inView:self];
    self.frame = CGRectMake(self.x, self.y, self.width, self.height + point.y);
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewItemDidChangedFrame:)]) {
        [self.delegate imageViewItemDidChangedFrame:self];
    }
}

- (void)cornerPanGestureDidRecognized:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer translationInView:self];
    [panGestureRecognizer setTranslation:CGPointZero inView:self];
    self.frame = CGRectMake(self.x, self.y, self.width + point.x, self.height + point.y);
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewItemDidChangedFrame:)]) {
        [self.delegate imageViewItemDidChangedFrame:self];
    }
}

- (void)didTappedSelf:(UITapGestureRecognizer *)tapGestureRecognizer
{
    self.isSelected = YES;
}

#pragma mark - getters and setters
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.borderWidth = 0.0f;
        _imageView.layer.borderColor = [[UIColor blueColor] CGColor];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIView *)horizontalDragPointView
{
    if (_horizontalDragPointView == nil) {
        _horizontalDragPointView = [[UIView alloc] init];
        _horizontalDragPointView.size = CGSizeMake(12, 12);
        _horizontalDragPointView.layer.cornerRadius = 6.0f;
        _horizontalDragPointView.backgroundColor = [UIColor blueColor];
        _horizontalDragPointView.alpha = 0.0f;
        _horizontalDragPointView.userInteractionEnabled = NO;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(horizontalPanGestureDidRecognized:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [_horizontalDragPointView addGestureRecognizer:panGestureRecognizer];
    }
    return _horizontalDragPointView;
}

- (UIView *)verticalDragPointView
{
    if (_verticalDragPointView == nil) {
        _verticalDragPointView = [[UIView alloc] init];
        [_verticalDragPointView sizeEqualToView:self.horizontalDragPointView];
        _verticalDragPointView.layer.cornerRadius = self.horizontalDragPointView.layer.cornerRadius;
        _verticalDragPointView.backgroundColor = [UIColor blueColor];
        _verticalDragPointView.alpha = 0.0f;
        _verticalDragPointView.userInteractionEnabled = NO;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(verticalPanGestureDidRecognized:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [_verticalDragPointView addGestureRecognizer:panGestureRecognizer];
    }
    return _verticalDragPointView;
}

- (UIView *)cornerDragPointView
{
    if (_cornerDragPointView == nil) {
        _cornerDragPointView = [[UIView alloc] init];
        [_cornerDragPointView sizeEqualToView:self.horizontalDragPointView];
        _cornerDragPointView.layer.cornerRadius = self.horizontalDragPointView.layer.cornerRadius;
        _cornerDragPointView.backgroundColor = [UIColor blueColor];
        _cornerDragPointView.alpha = 0.0f;
        _cornerDragPointView.userInteractionEnabled = NO;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cornerPanGestureDidRecognized:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [_cornerDragPointView addGestureRecognizer:panGestureRecognizer];
    }
    return _cornerDragPointView;
}

- (void)setIsSelected:(BOOL)isSelected
{
    BOOL shouldDelegate = YES;
    if (_isSelected == isSelected) {
        shouldDelegate = NO;
    }
    _isSelected = isSelected;
    if (isSelected) {
        _imageView.layer.borderWidth = 3.0f;
        self.cornerDragPointView.alpha = 1.0f;
        self.verticalDragPointView.alpha = 1.0f;
        self.horizontalDragPointView.alpha = 1.0f;
        self.cornerDragPointView.userInteractionEnabled = YES;
        self.verticalDragPointView.userInteractionEnabled = YES;
        self.horizontalDragPointView.userInteractionEnabled = YES;
    } else {
        _imageView.layer.borderWidth = 0.0f;
        self.cornerDragPointView.alpha = 0.0f;
        self.verticalDragPointView.alpha = 0.0f;
        self.horizontalDragPointView.alpha = 0.0f;
        self.cornerDragPointView.userInteractionEnabled = NO;
        self.verticalDragPointView.userInteractionEnabled = NO;
        self.horizontalDragPointView.userInteractionEnabled = NO;
    }
    
    if (shouldDelegate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewItemDidChangedSelect:)]) {
            [self.delegate imageViewItemDidChangedSelect:self];
        }
    }
}

@end
