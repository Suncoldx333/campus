//
//  AlbumListCell.m
//  SWCampus
//
//  Created by 11111 on 2017/3/6.
//  Copyright © 2017年 WanHang. All rights reserved.
//

#import "AlbumListCell.h"

@implementation AlbumListCell

@synthesize albumInfoLabel,firstImage;
@synthesize albumTag;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self initUI];
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

-(void)initUI{
    firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 80, 80)];
    firstImage.contentMode = UIViewContentModeScaleAspectFill;
    firstImage.clipsToBounds = YES;
    [self.contentView addSubview:firstImage];
    
    albumInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 110, 80)];
    albumInfoLabel.numberOfLines = 0;
    [self.contentView addSubview:albumInfoLabel];
}

-(void)setModel:(PhotoAlbumModel *)model{
    _model = model;
    albumTag = _model.ablumName;
    NSString *name = _model.ablumName;
    NSString *count = _model.count;
    albumInfoLabel.attributedText = [self createInfoLabelAttr:name and:count];
    if (_model.firstImage !=nil) {
        firstImage.image  = _model.firstImage;
    }else{
        PHAsset *asset = _model.headImageAsset;
        [[PhotoTool sharePhotoTool] createLittleImageBy:asset In:CGSizeMake(ScreenWidth *.35f, ScreenWidth *.35f) andBlock:^(NSData *data, NSDictionary *info) {
            firstImage.image = [[UIImage alloc] initWithData:data];
            _model.firstImage =firstImage.image;
        }];
        
    }
    
}

-(NSMutableAttributedString *)createInfoLabelAttr:(NSString *)name and:(NSString *)count{
    
    if (count.intValue < 10) {
        count = [NSString stringWithFormat:@"0%@",count];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@\n%@",name,count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSMutableDictionary *font_12 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    NSMutableDictionary *color_33 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:hexColor(0x333333),NSForegroundColorAttributeName, nil];
    NSMutableDictionary *color_b2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:hexColor(0xb2b2b2),NSForegroundColorAttributeName, nil];
    
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.paragraphSpacing = 4.f;
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:para,NSParagraphStyleAttributeName, nil];
    
    [attr addAttributes:font_12 range:NSMakeRange(0, title.length)];
    [attr addAttributes:color_33 range:NSMakeRange(0, name.length)];
    [attr addAttributes:color_b2 range:NSMakeRange(name.length + 1, count.length)];
    [attr addAttributes:paraDic range:NSMakeRange(0, title.length)];
    
    return attr;
}

@end
