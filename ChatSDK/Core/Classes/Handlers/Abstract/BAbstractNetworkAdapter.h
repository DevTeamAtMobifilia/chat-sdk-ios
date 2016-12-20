//
//  BAbstractNetworkAdapter.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/BNetworkFacade.h>

@interface BAbstractNetworkAdapter : NSObject<BNetworkFacade>

@property (nonatomic, readwrite) id<PCoreHandler> core;
@property (nonatomic, readwrite) id<PPushHandler> push;
@property (nonatomic, readwrite) id<PUploadHandler> upload;
@property (nonatomic, readwrite) id<PVideoMessageHandler> videoMessage;
@property (nonatomic, readwrite) id<PAudioMessageHandler> audioMessage;
@property (nonatomic, readwrite) id<PImageMessageHandler> imageMessage;
@property (nonatomic, readwrite) id<PLocationMessageHandler> locationMessage;
@property (nonatomic, readwrite) id<PAuthenticationHandler> auth;
@property (nonatomic, readwrite) id<PContactHandler> contact;
@property (nonatomic, readwrite) id<PTypingIndicatorHandler> typingIndicator;
@property (nonatomic, readwrite) id<PModerationHandler> moderation;
@property (nonatomic, readwrite) id<PSearchHandler> search;
@property (nonatomic, readwrite) id<PPublicThreadHandler> publicThread;
@property (nonatomic, readwrite) id<PBlockingHandler> blocking;
@property (nonatomic, readwrite) id<PLastOnlineHandler> lastOnline;
@property (nonatomic, readwrite) id<PNearbyUsersHandler> nearbyUsers;
@property (nonatomic, readwrite) id<PReadReceiptHandler> readReceipt;
@property (nonatomic, readwrite) id<PStickerMessageHandler> stickerMessage;

@end
