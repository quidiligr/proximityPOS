/*
 Copyright (c) 2012-2014, Pierre-Olivier Latour
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * The name of Pierre-Olivier Latour may not be used to endorse
 or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#if !__has_feature(objc_arc)
#error GCDWebHome requires ARC
#endif

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <SystemConfiguration/SystemConfiguration.h>
#endif

#import "GCDWebHome.h"

#import "GCDWebServerDataRequest.h"
#import "GCDWebServerMultiPartFormRequest.h"
#import "GCDWebServerURLEncodedFormRequest.h"

#import "GCDWebServerDataResponse.h"
#import "GCDWebServerErrorResponse.h"
#import "GCDWebServerFileResponse.h"
#import "InventoryModel.h"
#import "InventoryItem.h"
#import "Product.h"
#import "AppDelegate.h"
#import "defs.h"


@interface GCDWebHome () {
@private
  NSString* _uploadDirectory;
  NSArray* _allowedExtensions;
  BOOL _allowHidden;
  NSString* _title;
  NSString* _header;
  NSString* _prologue;
  NSString* _epilogue;
  NSString* _footer;

}

@end

@implementation GCDWebHome (Methods)

// Must match implementation in GCDWebDAVServer
- (BOOL)_checkSandboxedPath:(NSString*)path {
  return [[path stringByStandardizingPath] hasPrefix:_uploadDirectory];
}

- (BOOL)_checkFileExtension:(NSString*)fileName {
  if (_allowedExtensions && ![_allowedExtensions containsObject:[[fileName pathExtension] lowercaseString]]) {
    return NO;
  }
  return YES;
}

- (NSString*) _uniquePathForPath:(NSString*)path {
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    NSString* directory = [path stringByDeletingLastPathComponent];
    NSString* file = [path lastPathComponent];
    NSString* base = [file stringByDeletingPathExtension];
    NSString* extension = [file pathExtension];
    int retries = 0;
    do {
      if (extension.length) {
        path = [directory stringByAppendingPathComponent:[[base stringByAppendingFormat:@" (%i)", ++retries] stringByAppendingPathExtension:extension]];
      } else {
        path = [directory stringByAppendingPathComponent:[base stringByAppendingFormat:@" (%i)", ++retries]];
      }
    } while ([[NSFileManager defaultManager] fileExistsAtPath:path]);
  }
  return path;
}

- (GCDWebServerResponse*)listDirectory:(GCDWebServerRequest*)request {
  NSString* relativePath = [[request query] objectForKey:@"path"];
  NSString* absolutePath = [_uploadDirectory stringByAppendingPathComponent:relativePath];
  BOOL isDirectory = NO;
  if (![self _checkSandboxedPath:absolutePath] || ![[NSFileManager defaultManager] fileExistsAtPath:absolutePath isDirectory:&isDirectory]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"\"%@\" does not exist", relativePath];
  }
  if (!isDirectory) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_BadRequest message:@"\"%@\" is not a directory", relativePath];
  }


  
  NSString* directoryName = [absolutePath lastPathComponent];
  if (!_allowHidden && [directoryName hasPrefix:@"."]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Listing directory name \"%@\" is not allowed", directoryName];
  }
  
  NSError* error = nil;
  NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:absolutePath error:&error];
  if (contents == nil) {
    return [GCDWebServerErrorResponse responseWithServerError:kGCDWebServerHTTPStatusCode_InternalServerError underlyingError:error message:@"Failed listing directory \"%@\"", relativePath];
  }
  
  NSMutableArray* array = [NSMutableArray array];
  for (NSString* item in [contents sortedArrayUsingSelector:@selector(localizedStandardCompare:)]) {
    if (_allowHidden || ![item hasPrefix:@"."]) {
      NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[absolutePath stringByAppendingPathComponent:item] error:NULL];
      NSString* type = [attributes objectForKey:NSFileType];
      if ([type isEqualToString:NSFileTypeRegular] && [self _checkFileExtension:item]) {
        [array addObject:@{
                           @"path": [relativePath stringByAppendingPathComponent:item],
                           @"name": item,
                           @"size": [attributes objectForKey:NSFileSize]
                           }];
      } else if ([type isEqualToString:NSFileTypeDirectory]) {
        [array addObject:@{
                           @"path": [[relativePath stringByAppendingPathComponent:item] stringByAppendingString:@"/"],
                           @"name": item
                           }];
      }
    }
  }
  return [GCDWebServerDataResponse responseWithJSONObject:array];
}


//- (void)postStripeToken:(NSString* )token {
//this is for the server side payment processing only
-(NSDictionary *)charge:(NSString *)requestString{
    AppDelegate *_appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(!_appDelegate.appConfig.paymentSecretKey)
        return nil;
    /*NSString* stripeAmount = [request.arguments objectForKey:@"stripeAmount"];
     NSString* stripeCurrency = [request.arguments objectForKey:@"stripeCurrency"];
     NSString* stripeToken = [request.arguments objectForKey:@"stripeToken"];
     NSString* stripeDescription = [request.arguments objectForKey:@"stripeDescription"];
     */
    
    
    //NSString *STRIPE_POST_URL=@"https://api.stripe.com/v1/charges";
    //NSString *STRIPE_API_KEY=@"***REMOVED***";
    
    //NSData *nsdata=[STRIPE_API_KEY dataUsingEncoding:NSUTF8StringEncoding];
    NSData *nsdata=[NSData dataWithBytes:[_appDelegate.appConfig.paymentSecretKey UTF8String] length:[_appDelegate.appConfig.paymentSecretKey length]];
    
    
    NSString *base64EncodedAPIKEY=[nsdata base64EncodedStringWithOptions:0];
    
    //NSLog([NSString stringWithFormat:@"base64EncodedAPIKEY: %@",base64EncodedAPIKEY]);
    
    //1
    NSURL *postURL = [NSURL URLWithString:_appDelegate.appConfig.paymentPostUrl];
    
    NSError* err = nil;
    
    //NSString *requestString=[NSString stringWithFormat:@"amount=%@&currency=%@&source=%@&description=%@",stripeAmount,stripeCurrency,stripeToken,@"description..."];
    
    //NSLog([NSString stringWithFormat:@"requestString: %@",requestString]);
    
    NSData *requestData=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *postRequest=[[NSMutableURLRequest alloc] initWithURL:postURL];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:[NSString stringWithFormat: @"Basic %@",base64EncodedAPIKEY] forHTTPHeaderField:@"Authorization"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //[postRequest setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    
    
    
    [postRequest setHTTPBody:requestData];
    
    NSURLResponse *response;
    //NSError *err;
    NSData *jsonData=[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    
    //we will use json instead: NSString *content=[NSString stringWithUTF8String:[jsonData bytes]];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&err];
    
    if(err==nil){
        
        return JSON;//[GCDWebServerDataResponse responseWithJSONObject:JSON];
    }
    else
        return nil;
    
    
}

- (GCDWebServerResponse*)postStripeToken:(GCDWebServerURLEncodedFormRequest*)request {
 
    NSString* stripeAmount = [request.arguments objectForKey:@"stripeAmount"];
    NSString* stripeCurrency = [request.arguments objectForKey:@"stripeCurrency"];
    NSString* stripeToken = [request.arguments objectForKey:@"stripeToken"];
    NSString* stripeDescription = [request.arguments objectForKey:@"stripeDescription"];
    
    NSString *requestString=[NSString stringWithFormat:@"amount=%@&currency=%@&source=%@&description=%@",stripeAmount,stripeCurrency,stripeToken,stripeDescription];
    
    NSDictionary *jsonResult= [self charge:requestString];
    
    /*NSString *STRIPE_POST_URL=@"https://api.stripe.com/v1/charges";
    NSString *STRIPE_API_KEY=@"***REMOVED***";
    
    //NSData *nsdata=[STRIPE_API_KEY dataUsingEncoding:NSUTF8StringEncoding];
    NSData *nsdata=[NSData dataWithBytes:[STRIPE_API_KEY UTF8String] length:[STRIPE_API_KEY length]];

    
    NSString *base64EncodedAPIKEY=[nsdata base64EncodedStringWithOptions:0];
    
    //NSLog([NSString stringWithFormat:@"base64EncodedAPIKEY: %@",base64EncodedAPIKEY]);
    
    //1
    NSURL *postURL = [NSURL URLWithString:STRIPE_POST_URL];
    
    NSError* err = nil;
   
    NSString *requestString=[NSString stringWithFormat:@"amount=%@&currency=%@&source=%@&description=%@",stripeAmount,stripeCurrency,stripeToken,@"description..."];
    
    NSLog([NSString stringWithFormat:@"requestString: %@",requestString]);
    
    NSData *requestData=[NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *postRequest=[[NSMutableURLRequest alloc] initWithURL:postURL];
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:[NSString stringWithFormat: @"Basic %@",base64EncodedAPIKEY] forHTTPHeaderField:@"Authorization"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //[postRequest setValue:@"text/json" forHTTPHeaderField:@"Accept"];
    
   
    
    [postRequest setHTTPBody:requestData];
    
    NSURLResponse *response;
    //NSError *err;
    NSData *jsonData=[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    
    //we will use json instead: NSString *content=[NSString stringWithUTF8String:[jsonData bytes]];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:kNilOptions
                                                               error:&err];
    */
    if(jsonResult!=nil){
   //chargeDidSucceed
      //  NSDictionary *menu_dict=@{@"stripeAmount":stripeAmount,@"stripeCurrency":stripeCurrency,@"stripeToken":stripeToken,@"stripeDescription":stripeDescription};
       return [GCDWebServerDataResponse responseWithJSONObject:jsonResult];
    }
    else
        return nil;
    
   
   
    
}

- (GCDWebServerResponse*)inventoryDirectory:(GCDWebServerRequest*)request {
    /*NSString* relativePath = [[request query] objectForKey:@"path"];
    NSString* absolutePath = [_uploadDirectory stringByAppendingPathComponent:relativePath];
    BOOL isDirectory = NO;
    if (![self _checkSandboxedPath:absolutePath] || ![[NSFileManager defaultManager] fileExistsAtPath:absolutePath isDirectory:&isDirectory]) {
        return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"\"%@\" does not exist", relativePath];
    }
    if (!isDirectory) {
        return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_BadRequest message:@"\"%@\" is not a directory", relativePath];
    }
    
    
    
    NSString* directoryName = [absolutePath lastPathComponent];
    if (!_allowHidden && [directoryName hasPrefix:@"."]) {
        return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Listing directory name \"%@\" is not allowed", directoryName];
    }
    
    NSError* error = nil;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:absolutePath error:&error];
    if (contents == nil) {
        return [GCDWebServerErrorResponse responseWithServerError:kGCDWebServerHTTPStatusCode_InternalServerError underlyingError:error message:@"Failed listing directory \"%@\"", relativePath];
    }
    */
 
   /* NSArray* jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kInventoryAddress]]
                                                             options:kNilOptions
                                                               error:&err];*/
    
    /*NSString *jsonString=  @"[{\"Name\":\"Hamburger\",\"Price\":0.99,\"Image\":\"food_hamburger.png\"},{\"Name\":\"Cheeseburger\",\"Price\":1.2,\"Image\":\"food_cheeseburger.png\"},{\"Name\":\"Fries\",\"Price\":0.69,\"Image\":\"food_fries.png\"},{\"Name\":\"Onion Rings\",\"Price\":0.69,\"Image\":\"food_onion-rings.png\"},{\"Name\":\"Soda\",\"Price\":0.75,\"Image\":\"food_soda.png\"},{\"Name\":\"Shake\",\"Price\":1.2,\"Image\":\"food_milkshake.png\"}]";
    
    NSData *jsonData=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
     NSError* error = nil;
    
    NSArray* contents = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    */
    
    /*NSMutableArray* array = [NSMutableArray array];
    [array addObject:@{
                       @"Name": @"Hamburger",
                       @"Price": @0.99,
                       @"Image": @"food_hamburger.png"
                       }];
    [array addObject:@{
                       @"Name": @"Cheeseburger",
                       @"Price": @1.2,
                       @"Image": @"food_cheeseburger.png"
                       }];
    [array addObject:@{
                       @"Name": @"Fries",
                       @"Price": @0.69,
                       @"Image": @"food_fries.png"
                       }];
    [array addObject:@{
                       @"Name": @"Onion Rings",
                       @"Price": @1.2,
                       @"Image": @"food_onion-rings.png"
                       }];
    [array addObject:@{
                       @"Name": @"Soda",
                       @"Price": @0.75,
                       @"Image": @"food_soda.png"
                       }];
    [array addObject:@{
                       @"Name": @"Shake",
                       @"Price": @1.2,
                       @"Image": @"food_milkshake.png"
                       }];
     */
  
   // InventoryModel *_inventoryModel =[InventoryModel sharedInstance];// [[InventoryModel alloc] init];
    //[_inventoryModel loadInventory];
    /*
    NSMutableArray* array=[NSMutableArray new];
    for(Product *item in _inventoryModel.products){
        [array addObject:@{@"Name":item.name,@"Price":[NSNumber numberWithFloat:item.price ],@"Image":item.pictureFile}];
        
    }
    */
    AppDelegate *_appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    InventoryModel *inventoryModel=[InventoryModel sharedInstance];
    
    InventoryItem *activeInventory=inventoryModel.inventory;
    NSDictionary *menu_dict=[activeInventory toMenuDictionary:_appDelegate.appConfig];
//    for (NSString* item in [contents sortedArrayUsingSelector:@selector(localizedStandardCompare:)]) {
//        if (_allowHidden || ![item hasPrefix:@"."]) {
//            /*NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[absolutePath stringByAppendingPathComponent:item] error:NULL];
//            NSString* type = [attributes objectForKey:NSFileType];
//            if ([type isEqualToString:NSFileTypeRegular] && [self _checkFileExtension:item]) {
//                [array addObject:@{
//                                   @"path": [relativePath stringByAppendingPathComponent:item],
//                                   @"name": item,
//                                   @"size": [attributes objectForKey:NSFileSize]
//                                   }];
//            } else if ([type isEqualToString:NSFileTypeDirectory]) {
//                [array addObject:@{
//                                   @"path": [[relativePath stringByAppendingPathComponent:item] stringByAppendingString:@"/"],
//                                   @"name": item
//                                   }];
//            }*/
//            [array addObject:@{
//                               @"Name": [relativePath stringByAppendingPathComponent:item],
//                               @"Price": item,
//                               @"Image": [attributes objectForKey:NSFileSize]
//                               }];
//        }
//    }
    
   
    
   // return [GCDWebServerDataResponse responseWithJSONObject:array];
     return [GCDWebServerDataResponse responseWithJSONObject:menu_dict];
}


- (GCDWebServerResponse*)downloadFile:(GCDWebServerRequest*)request {
  NSString* relativePath = [[request query] objectForKey:@"path"];
  NSString* absolutePath = [_uploadDirectory stringByAppendingPathComponent:relativePath];
  BOOL isDirectory = NO;
  if (![self _checkSandboxedPath:absolutePath] || ![[NSFileManager defaultManager] fileExistsAtPath:absolutePath isDirectory:&isDirectory]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"\"%@\" does not exist", relativePath];
  }
  if (isDirectory) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_BadRequest message:@"\"%@\" is a directory", relativePath];
  }
  
  NSString* fileName = [absolutePath lastPathComponent];
  if (([fileName hasPrefix:@"."] && !_allowHidden) || ![self _checkFileExtension:fileName]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Downlading file name \"%@\" is not allowed", fileName];
  }
  
  if ([self.delegate respondsToSelector:@selector(webUploader:didDownloadFileAtPath:  )]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate webUploader:self didDownloadFileAtPath:absolutePath];
    });
  }
  return [GCDWebServerFileResponse responseWithFile:absolutePath isAttachment:YES];
}

- (GCDWebServerResponse*)uploadFile:(GCDWebServerMultiPartFormRequest*)request {
  NSRange range = [[request.headers objectForKey:@"Accept"] rangeOfString:@"application/json" options:NSCaseInsensitiveSearch];
  NSString* contentType = (range.location != NSNotFound ? @"application/json" : @"text/plain; charset=utf-8");  // Required when using iFrame transport (see https://github.com/blueimp/jQuery-File-Upload/wiki/Setup)
  
  GCDWebServerMultiPartFile* file = [request firstFileForControlName:@"files[]"];
  if ((!_allowHidden && [file.fileName hasPrefix:@"."]) || ![self _checkFileExtension:file.fileName]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Uploaded file name \"%@\" is not allowed", file.fileName];
  }
  NSString* relativePath = [[request firstArgumentForControlName:@"path"] string];
  NSString* absolutePath = [self _uniquePathForPath:[[_uploadDirectory stringByAppendingPathComponent:relativePath] stringByAppendingPathComponent:file.fileName]];
  if (![self _checkSandboxedPath:absolutePath]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"\"%@\" does not exist", relativePath];
  }
  
  if (![self shouldUploadFileAtPath:absolutePath withTemporaryFile:file.temporaryPath]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Uploading file \"%@\" to \"%@\" is not permitted", file.fileName, relativePath];
  }
  
  NSError* error = nil;
  if (![[NSFileManager defaultManager] moveItemAtPath:file.temporaryPath toPath:absolutePath error:&error]) {
    return [GCDWebServerErrorResponse responseWithServerError:kGCDWebServerHTTPStatusCode_InternalServerError underlyingError:error message:@"Failed moving uploaded file to \"%@\"", relativePath];
  }
  
  if ([self.delegate respondsToSelector:@selector(webUploader:didUploadFileAtPath:)]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate webUploader:self didUploadFileAtPath:absolutePath];
    });
  }
  return [GCDWebServerDataResponse responseWithJSONObject:@{} contentType:contentType];
}

- (GCDWebServerResponse*)moveItem:(GCDWebServerURLEncodedFormRequest*)request {
  NSString* oldRelativePath = [request.arguments objectForKey:@"oldPath"];
  NSString* oldAbsolutePath = [_uploadDirectory stringByAppendingPathComponent:oldRelativePath];
  BOOL isDirectory = NO;
  if (![self _checkSandboxedPath:oldAbsolutePath] || ![[NSFileManager defaultManager] fileExistsAtPath:oldAbsolutePath isDirectory:&isDirectory]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"\"%@\" does not exist", oldRelativePath];
  }
  
  NSString* newRelativePath = [request.arguments objectForKey:@"newPath"];
  NSString* newAbsolutePath = [self _uniquePathForPath:[_uploadDirectory stringByAppendingPathComponent:newRelativePath]];
  if (![self _checkSandboxedPath:newAbsolutePath]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"\"%@\" does not exist", newRelativePath];
  }
  
  NSString* itemName = [newAbsolutePath lastPathComponent];
  if ((!_allowHidden && [itemName hasPrefix:@"."]) || (!isDirectory && ![self _checkFileExtension:itemName])) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Moving to item name \"%@\" is not allowed", itemName];
  }
  
  if (![self shouldMoveItemFromPath:oldAbsolutePath toPath:newAbsolutePath]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Moving \"%@\" to \"%@\" is not permitted", oldRelativePath, newRelativePath];
  }
  
  NSError* error = nil;
  if (![[NSFileManager defaultManager] moveItemAtPath:oldAbsolutePath toPath:newAbsolutePath error:&error]) {
    return [GCDWebServerErrorResponse responseWithServerError:kGCDWebServerHTTPStatusCode_InternalServerError underlyingError:error message:@"Failed moving \"%@\" to \"%@\"", oldRelativePath, newRelativePath];
  }
  
  if ([self.delegate respondsToSelector:@selector(webUploader:didMoveItemFromPath:toPath:)]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate webUploader:self didMoveItemFromPath:oldAbsolutePath toPath:newAbsolutePath];
    });
  }
  return [GCDWebServerDataResponse responseWithJSONObject:@{}];
}

- (GCDWebServerResponse*)deleteItem:(GCDWebServerURLEncodedFormRequest*)request {
  NSString* relativePath = [request.arguments objectForKey:@"path"];
  NSString* absolutePath = [_uploadDirectory stringByAppendingPathComponent:relativePath];
  BOOL isDirectory = NO;
  if (![self _checkSandboxedPath:absolutePath] || ![[NSFileManager defaultManager] fileExistsAtPath:absolutePath isDirectory:&isDirectory]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"\"%@\" does not exist", relativePath];
  }
  
  NSString* itemName = [absolutePath lastPathComponent];
  if (([itemName hasPrefix:@"."] && !_allowHidden) || (!isDirectory && ![self _checkFileExtension:itemName])) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Deleting item name \"%@\" is not allowed", itemName];
  }
  
  if (![self shouldDeleteItemAtPath:absolutePath]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Deleting \"%@\" is not permitted", relativePath];
  }
  
  NSError* error = nil;
  if (![[NSFileManager defaultManager] removeItemAtPath:absolutePath error:&error]) {
    return [GCDWebServerErrorResponse responseWithServerError:kGCDWebServerHTTPStatusCode_InternalServerError underlyingError:error message:@"Failed deleting \"%@\"", relativePath];
  }
  
  if ([self.delegate respondsToSelector:@selector(webUploader:didDeleteItemAtPath:)]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate webUploader:self didDeleteItemAtPath:absolutePath];
    });
  }
  return [GCDWebServerDataResponse responseWithJSONObject:@{}];
}

- (GCDWebServerResponse*)createDirectory:(GCDWebServerURLEncodedFormRequest*)request {
  NSString* relativePath = [request.arguments objectForKey:@"path"];
  NSString* absolutePath = [self _uniquePathForPath:[_uploadDirectory stringByAppendingPathComponent:relativePath]];
  if (![self _checkSandboxedPath:absolutePath]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_NotFound message:@"\"%@\" does not exist", relativePath];
  }
  
  NSString* directoryName = [absolutePath lastPathComponent];
  if (!_allowHidden && [directoryName hasPrefix:@"."]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Creating directory name \"%@\" is not allowed", directoryName];
  }
  
  if (![self shouldCreateDirectoryAtPath:absolutePath]) {
    return [GCDWebServerErrorResponse responseWithClientError:kGCDWebServerHTTPStatusCode_Forbidden message:@"Creating directory \"%@\" is not permitted", relativePath];
  }
  
  NSError* error = nil;
  if (![[NSFileManager defaultManager] createDirectoryAtPath:absolutePath withIntermediateDirectories:NO attributes:nil error:&error]) {
    return [GCDWebServerErrorResponse responseWithServerError:kGCDWebServerHTTPStatusCode_InternalServerError underlyingError:error message:@"Failed creating directory \"%@\"", relativePath];
  }
  
  if ([self.delegate respondsToSelector:@selector(webUploader:didCreateDirectoryAtPath:)]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate webUploader:self didCreateDirectoryAtPath:absolutePath];
    });
  }
  return [GCDWebServerDataResponse responseWithJSONObject:@{}];
}

@end

@implementation GCDWebHome
@synthesize delegate;
@synthesize uploadDirectory=_uploadDirectory, allowedFileExtensions=_allowedExtensions, allowHiddenItems=_allowHidden,
            title=_title, header=_header, prologue=_prologue, epilogue=_epilogue, footer=_footer;

- (instancetype)initWithUploadDirectory:(NSString*)path {
  if ((self = [super init])) {
      //_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSBundle* siteBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"GCDWebHome" ofType:@"bundle"]];
    if (siteBundle == nil) {
      return nil;
       
    }
    _uploadDirectory = [[path stringByStandardizingPath] copy];
    GCDWebHome* __unsafe_unretained server = self;
    
    // Resource files
    /*[self addGETHandlerForBasePath:@"/" directoryPath:[siteBundle resourcePath] indexFilename:nil cacheAge:3600 allowRangeRequests:NO];
    */
      
    // Web page
       NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
      [self addGETHandlerForBasePath:@"/" directoryPath:documentsPath indexFilename:nil cacheAge:3600 allowRangeRequests:YES];

      
//    [self addHandlerForMethod:@"GET" path:@"/" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
//      
//#if TARGET_OS_IPHONE
//      NSString* device = [[UIDevice currentDevice] name];
//#else
//      NSString* device = CFBridgingRelease(SCDynamicStoreCopyComputerName(NULL, NULL));
//#endif
//      NSString* title = server.title;
//      if (title == nil) {
//        title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
//        if (title == nil) {
//          title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
//        }
//#if !TARGET_OS_IPHONE
//        if (title == nil) {
//          title = [[NSProcessInfo processInfo] processName];
//        }
//#endif
//      }
//      NSString* header = server.header;
//      if (header == nil) {
//        header = title;
//      }
//      NSString* prologue = server.prologue;
//      if (prologue == nil) {
//        prologue = [siteBundle localizedStringForKey:@"PROLOGUE" value:@"" table:nil];
//      }
//      NSString* epilogue = server.epilogue;
//      if (epilogue == nil) {
//        epilogue = [siteBundle localizedStringForKey:@"EPILOGUE" value:@"" table:nil];
//      }
//      NSString* footer = server.footer;
//      if (footer == nil) {
//        NSString* name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
//        NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//#if !TARGET_OS_IPHONE
//        if (!name && !version) {
//          name = @"OS X";
//          version = [[NSProcessInfo processInfo] operatingSystemVersionString];
//        }
//#endif
//        footer = [NSString stringWithFormat:[siteBundle localizedStringForKey:@"FOOTER_FORMAT" value:@"" table:nil], name, version];
//      }
//      return [GCDWebServerDataResponse responseWithHTMLTemplate:[siteBundle pathForResource:@"index" ofType:@"html"]
//                                                      variables:@{
//                                                                  @"device": device,
//                                                                  @"title": title,
//                                                                  @"header": header,
//                                                                  @"prologue": prologue,
//                                                                  @"epilogue": epilogue,
//                                                                  @"footer": footer
//                                                                  }];
//      
//    }];
    
    // File listing
    [self addHandlerForMethod:@"GET" path:@"/list" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
      return [server listDirectory:request];
    }];
    
    // File download
    [self addHandlerForMethod:@"GET" path:@"/download" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
      return [server downloadFile:request];
    }];
    
    // File upload
    [self addHandlerForMethod:@"POST" path:@"/upload" requestClass:[GCDWebServerMultiPartFormRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
      return [server uploadFile:(GCDWebServerMultiPartFormRequest*)request];
    }];
    
    // File and folder moving
    [self addHandlerForMethod:@"POST" path:@"/move" requestClass:[GCDWebServerURLEncodedFormRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
      return [server moveItem:(GCDWebServerURLEncodedFormRequest*)request];
    }];
    
     /*doesnt work //ROM stripe post asynch
      [self addHandlerForMethod:@"POST" path:@"/stripe" requestClass:[GCDWebServerURLEncodedFormRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
          return [server postStripeToken:(GCDWebServerURLEncodedFormRequest*)request];
      }];
      */
      [self addHandlerForMethod:@"GET"
                                path:@"/stripe"
                        requestClass:[GCDWebServerRequest class]
                        processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
NSString* html = @" \
    <html><body> \
    <form name=\"stripe\" action=\"/stripe\" method=\"post\" enctype=\"application/x-www-form-urlencoded\"> \
        Value: <input type=\"text\" name=\"stripeAmount\"> \
        Value: <input type=\"text\" name=\"stripeCurrency\"> \
        Value: <input type=\"text\" name=\"stripeToken\"> \
        Value: <input type=\"text\" name=\"stripeDescription\"> \
        <input type=\"submit\" value=\"Submit\"> \
    </form> \
    </body></html> \
    ";
return [GCDWebServerDataResponse responseWithHTML:html];
                            
    }];
      
/*[self addHandlerForMethod:@"POST"
    path:@"/stripe"
    requestClass:[GCDWebServerURLEncodedFormRequest class]
    processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        return [server postStripeToken:(GCDWebServerURLEncodedFormRequest*)request];
                            
                        }];
  */
      [self addHandlerForMethod:@"POST"
                                path:@"/stripe"
                        requestClass:[GCDWebServerURLEncodedFormRequest class]
                        processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                            
                            /*NSString* value = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"value"];
                            NSString* html = [NSString stringWithFormat:@"<html><body><p>%@</p></body></html>", value];
                            return [GCDWebServerDataResponse responseWithHTML:html];*/
                            return [server postStripeToken:(GCDWebServerURLEncodedFormRequest*)request];
                        }];
      
    // File and folder deletion
    [self addHandlerForMethod:@"POST" path:@"/delete" requestClass:[GCDWebServerURLEncodedFormRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
      return [server deleteItem:(GCDWebServerURLEncodedFormRequest*)request];
    }];
    
    // Directory creation
    [self addHandlerForMethod:@"POST" path:@"/create" requestClass:[GCDWebServerURLEncodedFormRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
      return [server createDirectory:(GCDWebServerURLEncodedFormRequest*)request];
    }];
    
      // Inventory
      [self addHandlerForMethod:@"GET" path:@"/inventory" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
          return [server inventoryDirectory:request];
      }];

    
  }
  return self;
}

@end

@implementation GCDWebHome (Subclassing)

- (BOOL)shouldUploadFileAtPath:(NSString*)path withTemporaryFile:(NSString*)tempPath {
  return YES;
}

- (BOOL)shouldMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
  return YES;
}

- (BOOL)shouldDeleteItemAtPath:(NSString*)path {
  return YES;
}

- (BOOL)shouldCreateDirectoryAtPath:(NSString*)path {
  return YES;
}

@end
