//
//  MKiCloudSync.m
//  iCloud1
//
//  Created by Mugunth Kumar (@mugunthkumar) on 20/11/11.
//  Copyright (C) 2011-2020 by Steinlogic

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

//  As a side note, you might also consider
//	1) tweeting about this mentioning @mugunthkumar
//	2) A paypal donation to mugunth.kumar@gmail.com
//  Usage : Call startWithPrefix:(NSString*) prefixToSync in the app starts.

#import "MKiCloudSync.h"

static NSString *prefix;
@implementation MKiCloudSync

+(void) updateToiCloud:(NSNotification*) notificationObject {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    __block BOOL acaiaSet = false ;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if([key hasPrefix:prefix]) {
            [[NSUbiquitousKeyValueStore defaultStore] setObject:obj forKey:key];
            acaiaSet = true ;
        }
    }];
    
    if (acaiaSet)
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

+(void) updateFromiCloud:(NSNotification*) notificationObject {
    NSDictionary *userInfo = [notificationObject userInfo];
    NSNumber *reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    if (reasonForChange)
    {
        // get the reason for the notification (initial download, external change or quota violation change)
        NSInteger reasonForChangeValue = [[userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey] integerValue];
        
        if (reasonForChangeValue == NSUbiquitousKeyValueStoreInitialSyncChange)
        {
            NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
            NSDictionary *dict = [iCloudStore dictionaryRepresentation];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:NSUserDefaultsDidChangeNotification
                                                          object:nil];
            [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                if([key hasPrefix:prefix]) {
                    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
                    NSLog(@"hydrated reset key %@ obj %@" , key , obj);
                }
            }];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // enable NSUserDefaultsDidChangeNotification notifications again
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(updateToiCloud:)
                                                         name:NSUserDefaultsDidChangeNotification
                                                       object:nil];
        }
    }
}

+(void) startWithPrefix:(NSString*) prefixToSync {
    
    prefix = prefixToSync;
    if([NSUbiquitousKeyValueStore defaultStore]) {  // is iCloud enabled
        
        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector (updateFromiCloud:)
         name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
         object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateToiCloud:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
        
    } else {
        NSLog(@"iCloud not enabled");
    }
}

@end
