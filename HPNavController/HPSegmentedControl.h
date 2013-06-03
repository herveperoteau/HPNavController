//
// HPSegmentedControl.h
//
// Based on AKSegmentedControl

@class HPSegmentedControl;

typedef enum : NSUInteger
{
    HPSegmentedControlModeSticky,
    HPSegmentedControlModeButton,
    HPSegmentedControlModeMultipleSelectionable,
} HPSegmentedControlMode;


@interface HPSegmentedControl : UIControl

@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *separatorImage;
@property (nonatomic, strong) NSIndexSet *selectedIndexes;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) HPSegmentedControlMode segmentedControlMode;

- (void)setSelectedIndex:(NSUInteger)index;
- (void)setSelectedIndexes:(NSIndexSet *)indexSet byExpandingSelection:(BOOL)expandSelection;

@end
