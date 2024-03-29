//
// HPSegmentedControl.m
//

#import "HPSegmentedControl.h"

#define kHPButtonSeparatorWidth 1.0

@interface HPSegmentedControl ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation HPSegmentedControl
{
    NSMutableArray *separatorsArray;
}

#pragma mark - Init and Dealloc

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self prepareView];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self prepareView];
    
    return self;
}

- (void)prepareView
{
    separatorsArray = [NSMutableArray array];
    self.selectedIndexes = [NSIndexSet indexSet];
    self.contentEdgeInsets = UIEdgeInsetsZero;
    self.segmentedControlMode = HPSegmentedControlModeSticky;
    self.buttonsArray = [[NSArray alloc] init];
    
    [self addSubview:self.backgroundImageView];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect contentRect = UIEdgeInsetsInsetRect(self.bounds, _contentEdgeInsets);
    
    NSUInteger buttonsCount = _buttonsArray.count;
    NSUInteger separtorsNumber = buttonsCount - 1;
    
    CGFloat separatorWidth = (_separatorImage != nil) ? _separatorImage.size.width : kHPButtonSeparatorWidth;
    CGFloat buttonWidth = floorf((CGRectGetWidth(contentRect) - (separtorsNumber * separatorWidth)) / buttonsCount);
    CGFloat buttonHeight = CGRectGetHeight(contentRect);
    CGSize buttonSize = CGSizeMake(buttonWidth, buttonHeight);
    
    CGFloat dButtonWidth = 0;
    CGFloat spaceLeft = CGRectGetWidth(contentRect) - (buttonsCount * buttonSize.width) - (separtorsNumber * separatorWidth);
    
    CGFloat offsetX = CGRectGetMinX(contentRect);
    CGFloat offsetY = CGRectGetMinY(contentRect);
    
    NSUInteger increment = 0;
    
    for (UIControl *button in _buttonsArray)
    {
        dButtonWidth = buttonSize.width;
        
        if (spaceLeft != 0)
        {
            dButtonWidth++;
            spaceLeft--;
        }
        
        if (increment != 0) offsetX += separatorWidth;
        
        [button setFrame:CGRectMake(offsetX, offsetY, dButtonWidth, buttonSize.height)];
        
        if (increment < separtorsNumber)
        {
            UIImageView *separatorImageView = separatorsArray[increment];
            [separatorImageView setFrame:CGRectMake(CGRectGetMaxX(button.frame),
                                                    offsetY,
                                                    separatorWidth,
                                                    CGRectGetHeight(self.bounds) - _contentEdgeInsets.top - _contentEdgeInsets.bottom)];
        }
        
        increment++;
        offsetX = CGRectGetMaxX(button.frame);
    }
}

#pragma mark - Button Actions

- (void)segmentButtonPressed:(id)sender
{
    UIControl *button = (UIControl *)sender;
//    if (!button || ![button isKindOfClass:[UIButton class]])
//        return;
    
    NSUInteger selectedIndex = button.tag;
    
    NSIndexSet *set = _selectedIndexes;
    
    if (_segmentedControlMode == HPSegmentedControlModeMultipleSelectionable)
    {
        NSMutableIndexSet *mutableSet = [set mutableCopy];
        
        if ([_selectedIndexes containsIndex:selectedIndex])
            [mutableSet removeIndex:selectedIndex];
        else
            [mutableSet addIndex:selectedIndex];
        
        [self setSelectedIndexes:[mutableSet copy]];
    }
    else
    {
        [self setSelectedIndex:selectedIndex];
    }
    
    BOOL willSendAction = (![_selectedIndexes isEqualToIndexSet:set] || _segmentedControlMode == HPSegmentedControlModeButton);
    
    if (willSendAction)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - Setters & Getters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [_backgroundImageView setImage:_backgroundImage];
}

- (void)setButtonsArray:(NSArray *)buttonsArray
{
    [_buttonsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [separatorsArray removeAllObjects];
    
    _buttonsArray = buttonsArray;
    
    [_buttonsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         [self addSubview:(UIControl *)obj];
        [(UIControl *)obj addTarget:self action:@selector(segmentButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [(UIControl *)obj setTag:idx];
    }];
    
    [self rebuildSeparators];
    [self updateButtons];
}

- (void)setSeparatorImage:(UIImage *)separatorImage
{
    _separatorImage = separatorImage;
    [self rebuildSeparators];
}

- (void)setSegmentedControlMode:(HPSegmentedControlMode)segmentedControlMode
{
    _segmentedControlMode = segmentedControlMode;
    [self updateButtons];
}

- (void)setSelectedIndex:(NSUInteger)index
{
    _selectedIndexes = [NSIndexSet indexSetWithIndex:index];
    [self updateButtons];
}

- (void)setSelectedIndexes:(NSIndexSet *)indexSet byExpandingSelection:(BOOL)expandSelection
{
    if (_segmentedControlMode != HPSegmentedControlModeMultipleSelectionable)
        return;
    
    if (!expandSelection)
        _selectedIndexes = [NSIndexSet indexSet];
    
    NSMutableIndexSet *mutableIndexSet = [_selectedIndexes mutableCopy];
    [mutableIndexSet addIndexes:indexSet];
    
    [self setSelectedIndexes:mutableIndexSet];
}

- (void)setSelectedIndexes:(NSIndexSet *)selectedIndexes
{
    _selectedIndexes = [selectedIndexes copy];
    [self updateButtons];
}


#pragma mark - Rearranging

- (void)rebuildSeparators
{
    [separatorsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger separatorsNumber = [_buttonsArray count] - 1;
    
    [_buttonsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < separatorsNumber)
        {
            UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:_separatorImage];
            [self addSubview:separatorImageView];
            [separatorsArray addObject:separatorImageView];
        }
    }];
}

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil)
    {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    
    return _backgroundImageView;
}

- (void)updateButtons
{
    if ([_buttonsArray count] == 0)
        return;
    
    [_buttonsArray makeObjectsPerformSelector:@selector(setSelected:) withObject:nil];
    
    [_selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (_segmentedControlMode != HPSegmentedControlModeButton)
        {
            if (idx >= [_buttonsArray count]) return;
            
            UIControl *button = _buttonsArray[idx];
            button.selected = YES;
        }
    }];
}

@end