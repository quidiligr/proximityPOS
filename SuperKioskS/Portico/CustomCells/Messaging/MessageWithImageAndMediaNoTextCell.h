//
//  MessageTableViewCell.h
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//
@class MessageTableViewData;
//@class Message;
//@class BroadcastMessageAPI;
// Table view cell that displays a Message. The message text appears in a
// speech bubble; the sender name and date are shown in a UILabel below that.
@interface MessageWithImageAndMediaNoTextCell : UITableViewCell
@property(nonatomic,strong) UIImageView *photo;
@property(nonatomic,strong) UIImageView *imageAttach;
@property(nonatomic,strong) UIImageView *imgPlayer;
- (void)setMessage:(MessageTableViewData*)message;

//- (void)setBroadcastMessage:(BroadcastMessageAPI*)message myPhoto:(UIImage*)myPhoto otherPhoto:(UIImage*)otherPhoto myImage:(UIImage *)myImage  myMedia:(UIButton *)myMedia;

@end
