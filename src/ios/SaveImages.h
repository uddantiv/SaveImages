//
//  SaveImages.h
//  SnipMe
//
//  Created by Vishwanath on 16/01/15.
//
//

#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface SaveImages : CDVPlugin<NSURLSessionDelegate> {
    NSMutableDictionary *convertedImageDict;
    NSArray *imageArray;
    NSDictionary *imageDict;
    NSString *baseImageStr;
    NSString* callbackId;
}
- (void)downloadImage:(CDVInvokedUrlCommand*)command;
@end
