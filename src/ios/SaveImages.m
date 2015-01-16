//
//  SaveImages.m
//  SnipMe
//
//  Created by Vishwanath on 16/01/15.
//
//

#import "SaveImages.h"

@interface SaveImages()
- (void)downloadImages;
- (void)saveImagesInMyDocumentsFolder:(NSString *)imgPathString;
- (void)doneWithDownloadingImage;
- (void)errorDownloadingImage;
@end

@implementation SaveImages

- (void)downloadImage:(CDVInvokedUrlCommand*)command {
    callbackId = command.callbackId;
    imageDict = [command argumentAtIndex:0];//[abc objectForKey:@"assets"];
    [self performSelectorInBackground:@selector(downloadImages) withObject:nil];
}

- (void)downloadImages {
    imageArray = [[NSArray alloc] initWithObjects:[imageDict objectForKey:@"bottom-overlay-1"],
                                                  [imageDict objectForKey:@"bottom-overlay-2"],
                                                  [imageDict objectForKey:@"splash-screen"],
                                                  [imageDict objectForKey:@"top-overlay"],
                                                  [imageDict objectForKey:@"end-screen"], nil];
    convertedImageDict = [[NSMutableDictionary alloc] init];
    for (int i=0; i<[imageArray count]; i++) {
        [self saveImagesInMyDocumentsFolder:[imageArray objectAtIndex:i]];
    }
}

-(void)saveImagesInMyDocumentsFolder:(NSString *)imgPathString {
    @autoreleasepool {
        NSURL *imgURL = [NSURL URLWithString:imgPathString];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if ( !error )
                                   {
                                       @autoreleasepool {
                                           UIImage *image = [UIImage imageWithData:data];
                                           NSData* saveImagedata = nil;
                                           saveImagedata = [NSData dataWithData:UIImagePNGRepresentation(image)];
                                           NSLog(@"yes done");
                                           NSString *documentsDirectoryPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",[response.URL lastPathComponent]];
                                           if(![fileManager fileExistsAtPath:documentsDirectoryPath]){
                                               NSLog(@"writable path = %@",documentsDirectoryPath);
                                               // file doesn't exist
                                               NSLog(@"file doesn't exist");
                                               //save Image From URL
                                               NSError *error = nil;
                                               [saveImagedata writeToFile:documentsDirectoryPath options:NSAtomicWrite error:&error];
                                               if (error) {
                                                   NSLog(@"Error Writing File : %@",error);
                                               }
                                               else{
                                                   NSLog(@"Image %@ Saved SuccessFully",[response.URL lastPathComponent]);
                                                   [convertedImageDict setObject:documentsDirectoryPath
                                                                          forKey:[[response.URL lastPathComponent] stringByReplacingOccurrencesOfString:@".png" withString:@""]];
                                                   if ([convertedImageDict count]==[imageArray count]) {
                                                       NSLog(@"yes all the four images are done");
                                                       [self doneWithDownloadingImage];
                                                   }
                                               }
                                           }
                                           else{
                                               // file exist
                                               NSLog(@"file exist");
                                           }
                                       }
                                   }
                                   else{
                                       NSLog(@"no done");
                                   }
                               }];
    }
    
    
}


- (void)doneWithDownloadingImage {
    
    /*
    set the following to nil
    
    imageArray
    convertedImageDict
    
    */
    
    
    for (NSString *key in [convertedImageDict allKeys]) {
        NSLog(@"key = %@",key);
    }
    CDVPluginResult* result = nil;
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:convertedImageDict];
    //result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:baseImageStr];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    
}

- (void)errorDownloadingImage {
    CDVPluginResult* result = nil;
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error"];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

@end
