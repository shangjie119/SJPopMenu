//
//  SJPopMenuCollectionViewCell.m
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import "SJPopMenuCollectionViewCell.h"

#import "SJPopMenu.h"

@interface SJPopMenuCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *menuImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuNameLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewWidth;

@end

@implementation SJPopMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithItem:(SJPopMenuItem *)item
{
    self.menuNameLabel.text = item.title;
    self.menuImageView.image = [UIImage imageNamed:item.image];
    self.colorViewWidth.constant = 56;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [UIView animateWithDuration:0.2 animations:^{
        if (highlighted) {
            self.colorView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        } else {
            self.colorView.backgroundColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
        }
    }];
}

@end
