//
//  BCoreDataStorageAdapter.h
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 12/02/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ChatSDK/PStorageAdapter.h>

@interface BCoreDataStorageAdapter : NSObject<PStorageAdapter> {
    NSManagedObjectContext * _parentMoc;
    NSManagedObjectContext * _mainMoc;
    NSManagedObjectContext * _backgroundMoc;

    NSManagedObjectModel * _model;
    NSPersistentStoreCoordinator * _store;
    NSTimer * _saveTimer;
}



@end
