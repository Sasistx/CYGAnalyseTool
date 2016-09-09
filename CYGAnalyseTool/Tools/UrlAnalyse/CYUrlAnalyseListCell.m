//
//  CYUrlAnalyseListCell.m
//  ChunyuClinic
//
//  Created by 高天翔 on 16/9/8.
//  Copyright © 2016年 SpringRain. All rights reserved.
//

#import "CYUrlAnalyseListCell.h"
#import "CYUrlAnalyseManager.h"

@interface CYUrlAnalyseListCell ()

@end

@implementation CYUrlAnalyseListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createCellView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createCellView
{
    _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width - 30, 20)];
    [self.contentView addSubview:_urlLabel];
    
    _methodLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 120, 20)];
    [self.contentView addSubview:_methodLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, 120, 20)];
    [self.contentView addSubview:_statusLabel];
}

- (void)updateListInfo:(NSDictionary*)listInfo
{
    _urlLabel.text = [NSString stringWithFormat:@"URL: %@", listInfo[CYRequestUrl]];
    _methodLabel.text = [NSString stringWithFormat:@"Method: %@", listInfo[CYHttpMethod]];
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Status: %@", listInfo[CYURLStatusCode]]];
    
    [attrString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 8)];
    
    NSInteger code = [listInfo[CYURLStatusCode] integerValue];
    
    
    if (code >= 200 && code < 300) {
        
        [attrString setAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:NSMakeRange(8, [NSString stringWithFormat:@"%ld", code].length)];
    }else {
        [attrString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(8, [NSString stringWithFormat:@"%ld", code].length)];
    }
    
    _statusLabel.attributedText = attrString;
}

@end
