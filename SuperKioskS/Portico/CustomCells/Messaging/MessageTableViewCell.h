//
//  MessageTableViewCell.h
//  Sharecle
//
//  Created by Romulo on 08/04/14.
//  Copyright (c) 2014 Sharecle Inc. All rights reserved.
//
/*
@class Message;
@class BroadcastMessageAPI;
 */
@class MessageTableViewData;

// Table view cell that displays a Message. The message text appears in a
// speech bubble; the sender name and date are shown in a UILabel below that.
@interface MessageTableViewCell : UITableViewCell
@property(nonatomic,strong) UIImageView *photo;
//- (void)setMessage:(ContactMessage*)message;
/*
- (void)setMessage:(Message*)message myPhoto:(UIImage*)myPhoto otherPhoto:(UIImage*)otherPhoto;
- (void)setBroadcastMessage:(BroadcastMessageAPI*)message myPhoto:(UIImage*)myPhoto otherPhoto:(UIImage*)otherPhoto;
 */
- (void)setMessage:(MessageTableViewData*)message;
//- (void)setBroadcastMessageWithMedia:(BroadcastMessageAPI*)message myPhoto:(UIImage*)myPhoto otherPhoto:(UIImage*)otherPhoto mediaImage:(UIImage*)mediaImage;

//- (void)setBroadcastMessage2:(BroadcastMessageAPI*)message myPhoto:(UIImage*)myPhoto otherPhoto:(UIImage*)otherPhoto myImage:(UIImage *)myImage;

@end
