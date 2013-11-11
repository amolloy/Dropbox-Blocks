//
//  DBRestClient+Blocks.m
//  BabyGrow
//
//  Created by Andy Molloy on 12/20/11.
//  Copyright (c) 2011 Andy Molloy. All rights reserved.
//

#import "DBRestClient+Blocks.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface DBRestClient (BabyGrowBlocksPrivate)
@property (nonatomic, readonly) NSMutableDictionary* handlers;
@end

@implementation DBRestClient (BabyGrowBlocks)

static char* kDBRestClientBlockDictionaryKey = "DBRestClientBlockDictionaryKey";
static NSString* kDBRestClientLoadMetadataCompletionBlockKey = @"DBRestClientLoadMetadataCompletionBlockKey";
static NSString* kDBRestClientLoadMetadataFailedBlockKey = @"DBRestClientLoadMetadataFailedBlockKey";
static NSString* kDBRestClientLoadMetadataUnchangedBlockKey = @"DBRestClientLoadMetadataFailedBlockKey";
static NSString* kDBRestClientSearchCompletionBlockKey = @"DBRestClientSearchCompletionBlockKey";
static NSString* kDBRestClientSearchFailedBlockKey = @"DBRestClientSearchFailedBlockKey";
static NSString* kDBRestClientFinallyBlockKey = @"DBRestClientFinallyBlockKey";

-(void)loadMetadata:(NSString *)path 
withCompletionHandler:(BGDBRestClientCompletionHandler)completionHandler
      failedHandler:(BGDBRestClientFailedHandler)failedHandler
{
   [self loadMetadata:path
withCompletionHandler:completionHandler
        failedHandler:failedHandler
     unchangedHandler:^(NSString* unused){}];
}

-(void)loadMetadata:(NSString *)path 
withCompletionHandler:(BGDBRestClientCompletionHandler)completionHandler
      failedHandler:(BGDBRestClientFailedHandler)failedHandler
   unchangedHandler:(BGDBRestClientMetadataUnchangedHandler)unchangedHandler
{
   if (!self.delegate)
   {
      self.delegate = self;
   }
   NSAssert([self.delegate isEqual:self], @"A DBRestClient cannot load metadata with blocks when the delegate isn't self");
   
   completionHandler = [completionHandler copy];
   failedHandler = [failedHandler copy];
   unchangedHandler = [unchangedHandler copy];
   
   if (nil != completionHandler)
   {
      [self.handlers setObject:completionHandler
                        forKey:kDBRestClientLoadMetadataCompletionBlockKey];
   }
   
   if (nil != failedHandler)
   {
      [self.handlers setObject:failedHandler
                        forKey:kDBRestClientLoadMetadataFailedBlockKey];
   }
   
   if (nil != unchangedHandler)
   {
      [self.handlers setObject:unchangedHandler
                        forKey:kDBRestClientLoadMetadataUnchangedBlockKey];
   }
   
   [self loadMetadata:path];
}

-(void)searchPath:(NSString*)path 
       forKeyword:(NSString*)keyword
withCompletionHandler:(BGDBRestClientSearchCompletionHandler)completionHandler
    failedHandler:(BGDBRestClientSearchFailedHandler)failedHandler
{
   [self searchPath:path
         forKeyword:keyword
withCompletionHandler:completionHandler
      failedHandler:failedHandler
     finallyHandler:^{}];
}

-(void)searchPath:(NSString*)path 
       forKeyword:(NSString*)keyword
withCompletionHandler:(BGDBRestClientSearchCompletionHandler)completionHandler
    failedHandler:(BGDBRestClientSearchFailedHandler)failedHandler
   finallyHandler:(BGDBRestClientFinallyBlock)finallyHandler
{
   if (!self.delegate)
   {
      self.delegate = self;
   }
   NSAssert([self.delegate isEqual:self], @"A DBRestClient cannot load metadata with blocks when the delegate isn't self");
   
   completionHandler = [completionHandler copy];
   failedHandler = [failedHandler copy];
   finallyHandler = [finallyHandler copy];
   
   if (nil != completionHandler)
   {
      [self.handlers setObject:completionHandler
                        forKey:kDBRestClientSearchCompletionBlockKey];
   }
   
   if (nil != failedHandler)
   {
      [self.handlers setObject:failedHandler
                        forKey:kDBRestClientSearchFailedBlockKey];
   }
   
   if (nil != finallyHandler)
   {
      [self.handlers setObject:finallyHandler
                        forKey:kDBRestClientFinallyBlockKey];
   }
   
   [self searchPath:path
         forKeyword:keyword];
}

#pragma mark Properties

-(NSMutableDictionary*)handlers
{
   NSMutableDictionary* handlers = objc_getAssociatedObject(self, kDBRestClientBlockDictionaryKey);
   if (!handlers) 
   {
      handlers = [NSMutableDictionary dictionary];
	  objc_setAssociatedObject(self, kDBRestClientBlockDictionaryKey, handlers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   }

   return handlers;
}

-(BGDBRestClientCompletionHandler)loadMetadataCompletionBlock
{
   BGDBRestClientCompletionHandler block = [self.handlers
                                            objectForKey:kDBRestClientLoadMetadataCompletionBlockKey];
   return [block copy];
}

-(BGDBRestClientFailedHandler)loadMetadataFailedBlock
{
   BGDBRestClientFailedHandler block = [self.handlers
                                        objectForKey:kDBRestClientLoadMetadataFailedBlockKey];
   return [block copy];
}

-(BGDBRestClientMetadataUnchangedHandler)loadMetadataUnchangedBlock
{
   BGDBRestClientMetadataUnchangedHandler block = [self.handlers
                                                   objectForKey:kDBRestClientLoadMetadataUnchangedBlockKey];
   return [block copy];
}

-(BGDBRestClientSearchCompletionHandler)searchCompletionBlock
{
   BGDBRestClientSearchCompletionHandler block = [self.handlers
                                                  objectForKey:kDBRestClientSearchCompletionBlockKey];
   
   return [block copy];
}

-(BGDBRestClientSearchFailedHandler)searchFailedBlock
{
   BGDBRestClientSearchFailedHandler block = [self.handlers
                                              objectForKey:kDBRestClientSearchFailedBlockKey];
   
   return [block copy];
}

-(BGDBRestClientFinallyBlock)finallyBlock
{
   BGDBRestClientFinallyBlock block = [self.handlers
                                       objectForKey:kDBRestClientFinallyBlockKey];
   
   return [block copy];
}

#pragma mark Delegates

-(void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
   BGDBRestClientCompletionHandler block = [self loadMetadataCompletionBlock];
   if (block)
   {
      block(metadata);
   }
}

-(void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
   BGDBRestClientFailedHandler block = [self loadMetadataFailedBlock];
   if (block)
   {
      block(error);
   }
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
{
   BGDBRestClientMetadataUnchangedHandler block = [self loadMetadataUnchangedBlock];
   if (block)
   {
      block(path);
   }
}

-(void)restClient:(DBRestClient*)restClient loadedSearchResults:(NSArray*)results 
           forPath:(NSString*)path keyword:(NSString*)keyword
{
   BGDBRestClientSearchCompletionHandler block = [self searchCompletionBlock];
   if (block)
   {
      block(results, path, keyword);
   }
   
   BGDBRestClientFinallyBlock finally = [self finallyBlock];
   if (finally)
   {
      finally();
   }
}

-(void)restClient:(DBRestClient*)restClient searchFailedWithError:(NSError*)error
{
   BGDBRestClientSearchFailedHandler block = [self searchFailedBlock];
   if (block)
   {
      block(error);
   }
   
   BGDBRestClientFinallyBlock finally = [self finallyBlock];
   if (finally)
   {
      finally();
   }
}

@end
