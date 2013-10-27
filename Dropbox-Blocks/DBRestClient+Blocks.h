//
//  DBRestClient+Blocks.h
//  BabyGrow
//
//  Created by Andy Molloy on 12/20/11.
//  Copyright (c) 2011 Andy Molloy. All rights reserved.
//

#import "DropboxSDK.h"

typedef void(^BGDBRestClientCompletionHandler)(DBMetadata*);
typedef void(^BGDBRestClientFailedHandler)(NSError*);
typedef void(^BGDBRestClientMetadataUnchangedHandler)(NSString*);
typedef void(^BGDBRestClientSearchCompletionHandler)(NSArray*, NSString*, NSString*);
typedef void(^BGDBRestClientSearchFailedHandler)(NSError*);
typedef void(^BGDBRestClientFinallyBlock)();

@interface DBRestClient (BabyGrowBlocks) <DBRestClientDelegate>

-(void)loadMetadata:(NSString *)path 
withCompletionHandler:(BGDBRestClientCompletionHandler)completionHandler
      failedHandler:(BGDBRestClientFailedHandler)failedHandler;

-(void)loadMetadata:(NSString *)path 
withCompletionHandler:(BGDBRestClientCompletionHandler)completionHandler
      failedHandler:(BGDBRestClientFailedHandler)failedHandler
   unchangedHandler:(BGDBRestClientMetadataUnchangedHandler)unchangedHandler;

-(void)searchPath:(NSString*)path 
       forKeyword:(NSString*)keyword
withCompletionHandler:(BGDBRestClientSearchCompletionHandler)completionHandler
    failedHandler:(BGDBRestClientSearchFailedHandler)failedHandler;

-(void)searchPath:(NSString*)path 
       forKeyword:(NSString*)keyword
withCompletionHandler:(BGDBRestClientSearchCompletionHandler)completionHandler
    failedHandler:(BGDBRestClientSearchFailedHandler)failedHandler
   finallyHandler:(BGDBRestClientFinallyBlock)finallyHandler;

@end
