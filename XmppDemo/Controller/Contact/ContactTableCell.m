//
//  ContactTableCell.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/10/29.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "ContactTableCell.h"
#import "AddressbookObject.h"

@implementation ContactTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [ToolMethods layerViewCorner:_logoLabel withRadiu:_logoLabel.width/2 color:nil];
    
}

-(void)setDataItem:(id)item{
    if ([item isKindOfClass:[ContactModel class]]) {
        ContactModel *model = (ContactModel *)item;
        
        NSString *tmpName = model.name;
        if ([model.firstNameChar isEqualToString:@"#"]) {
            tmpName = model.firstPhone;
        }
        [self.nameLabel setText:tmpName];
        
        if (tmpName.length >1) {
            [self.logoLabel setText:[tmpName substringFromIndex:tmpName.length-2]];
        }else{
            [self.logoLabel setText:tmpName];
        }
        self.logoLabel.backgroundColor = model.logoColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
