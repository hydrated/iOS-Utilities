//
//  CustomSwitchView.m
//
//  Created by hydra on 2016/7/1.
//

#import "CustomSwitchView.h"
#import <PureLayout/ALView+PureLayout.h>
#import <ChameleonFramework/UIColor+Chameleon.h>

@interface CustomSwitchView()

@property(nonatomic, strong, readonly, nonnull)UIView * switchView;
@property(nonatomic, strong, readonly, nonnull)NSLayoutConstraint *leftPadding;
@property(nonatomic, strong, readonly, nonnull)NSLayoutConstraint *rightPadding;

@end

static NSString *const offColor = @"93979a";
static NSString *const onColor = @"89bccf";


@implementation CustomSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUi];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUi];
    }
    return self;
}

- (void)setupUi
{
    self.backgroundColor = [UIColor colorWithHexString:onColor];
    
    UIView *const switchView = [UIView newAutoLayoutView];
    [self addSubview:switchView];
    [switchView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:1.0f];
    [switchView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:1.0f];
    [switchView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self];
    _leftPadding = [switchView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:1.0f];
    _switchView = switchView;
    switchView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSwitch:)];
    [self addGestureRecognizer:tap];
}
#pragma mark - Properties methods

#pragma mark - UI events
- (IBAction)onSwitch:(id)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        
        [self removeConstraint:_leftPadding];
        _rightPadding = [_switchView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:1.0f];
        
        [self layoutIfNeeded];
    }];
}

@end
