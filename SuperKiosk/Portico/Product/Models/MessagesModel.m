//
//  IODOrder.m
//  iOSDiner
//
//  Created by Romulo Quidilig on 3/19/15.
//  Copyright (c) 2015 Sharecle Inc. All rights reserved.
//

#import "MessagesModel.h"
#import "BroadcastMessageAPI.h"
//#import "Product.h"
/*#import "OrderHistory.h"
#import "StoreHistory.h"
#import "StoreInfo.h"
 */
#import "defs.h"
//#import "ProductCategory.h"
//#import "NSData+Conversion.h"

@implementation MessagesModel



- (id)init {
    self = [super init];
    if (self) {
       
        self.messages=[NSMutableArray new];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.messages=[decoder decodeObjectForKey:MESSAGES_KEY];
     
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder*)encoder
{
    
    [encoder encodeObject:self.messages forKey:MESSAGES_KEY];
    
}



+ (MessagesModel *)sharedInstance {
    static MessagesModel*  _shared;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shared = [[MessagesModel alloc] init];
        [_shared loadMessages];
        
      
    });
    
    return _shared;
}

- (NSString*)messagesPath//:(NSString *)withTitle
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = paths[0];
    
    NSString *filename=@"messages.plist";
    
   
    return [documentsDirectory stringByAppendingPathComponent:filename];
}




- (void)loadMessages
{
    
    NSString* path = [self messagesPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
         NSData* data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
       
        NSArray *arr=[unarchiver decodeObjectForKey:MESSAGES_KEY];
        if(arr!=nil)
            self.messages = [arr mutableCopy];

       
        [unarchiver finishDecoding];
    }
    else
    {
        if(self.messages==nil)
            self.messages = [NSMutableArray new];
      
    }
}

- (void)saveMessages
{
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.messages forKey:MESSAGES_KEY];
   
    [archiver finishEncoding];
    [data writeToFile:[self messagesPath] atomically:YES];
}



- (void)addMessage:(BroadcastMessageAPI *)message
{
  
    if(self.messages==nil){
        self.messages=[NSMutableArray new];
      
    }
    
    [self.messages addObject:message];
    [self saveMessages];
   
}



@end
