//
//  BMessageCache.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 20/12/2016.
//
//

#import "BMessageCache.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

#define bMessagePositionKey @"bMessagePositionKey"
#define bNextMessageKey @"bNextMessageKey"

@implementation BMessageCache

static BMessageCache * cache;

+(BMessageCache *) sharedCache {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(cache == nil) {
            // Allocate and initialize an instance of this class
            cache = [[self alloc] init];
        }
    }
    return cache;
}

-(id) init {
    if ((self = [super init])) {
        _messageInfo = [NSMutableDictionary new];
        _messageBubbleImages = [NSMutableDictionary new];
    }
    return self;
}

-(UIImage *) bubbleForMessage: (id<PMessage>) message withColorWeight: (float) weight {
    
    bMessagePosition pos = [self positionForMessage:message];
    BOOL isMine = [self isMine:message];
    
    NSString * bubbleImageName = @"";
    switch (pos) {
        case bMessagePositionFirst:
            bubbleImageName = @"chat_bubble_right_0S.png";
            break;
        case bMessagePositionMiddle:
            bubbleImageName = @"chat_bubble_right_SS.png";
            break;
        case bMessagePositionLast:
            bubbleImageName = @"chat_bubble_right_ST.png";
            break;
        case bMessagePositionSingle:
            bubbleImageName = @"chat_bubble_right_0T.png";
            break;
    }
    
    // Color
    NSString * colorString = Nil;
    if (bAllowUserDefinedMessageColor) {
        colorString = message.userModel.messageColor;
    }
    if (isMine) {
        colorString = bDefaultMessageColorMe;
    }
    else {
        colorString = bDefaultMessageColorReply;
    }

    NSString * imageIdentifier = [NSString stringWithFormat:@"%@%@%i%f", bubbleImageName, colorString, isMine, weight];
    if(_messageBubbleImages[imageIdentifier]) {
        return _messageBubbleImages[imageIdentifier];
    }
    else {
        
        bubbleImageName = [NSBundle res: bubbleImageName];

        UIImage * bubbleImage = [UIImage imageNamed:bubbleImageName];

        if (isMine) {
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:bLeftCapRight topCapHeight:bTopCap];
        }
        else {
            bubbleImage = [UIImage imageWithCGImage:bubbleImage.CGImage
                                                            scale:bubbleImage.scale
                                                      orientation:UIImageOrientationUpMirrored];
            
            bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:bLeftCapRight topCapHeight:bTopCap];
            
        }
        
        UIColor * color = [BCoreUtilities colorWithHexString:colorString withColorWeight:weight];
        
        UIImage * image = [BMessageCell bubbleWithImage:bubbleImage withColor:color];
        
        _messageBubbleImages[imageIdentifier] = image;
        
        return image;
    }
    
}

-(BOOL) shouldCacheMessage: (id<PMessage>) message {
    NSArray * messages = message.thread.messagesOrderedByDateAsc;
    NSInteger index = [messages indexOfObject:message];
    
    // If the message isn't the last message, then it's type won't change
    return index < messages.count - 1;

}

-(bMessagePosition) positionForMessage: (id<PMessage>) message {
    bMessagePosition pos;
    if([self isMessageCached:message]) {
        pos = [[self infoForMessage:message][bMessagePositionKey] intValue];
    }
    else {
        pos = message.messagePosition;
        if ([self shouldCacheMessage:message]) {
            [self infoForMessage:message][bMessagePositionKey] = @(pos);
        }
    }
    return pos;
}

-(id<PMessage>) nextMessageForMessage: (id<PMessage>) message {
    id<PMessage> nm;
    if([self isMessageCached:message]) {
        nm = [self infoForMessage:message][bNextMessageKey];
    }
    else {
        nm = message.nextMessage;
        if ([self shouldCacheMessage:message]) {
            [self infoForMessage:message][bNextMessageKey] = nm;
        }
    }
    return nm;
}

-(NSMutableDictionary *) infoForMessage: (id<PMessage>) message {
    // Have we already seen this message?
    NSMutableDictionary * messageInfo = _messageInfo[message.entityID];
    if(!messageInfo) {
        messageInfo = [NSMutableDictionary new];
        _messageInfo[message.entityID] = messageInfo;
    }
    return messageInfo;
}

-(BOOL) isMessageCached: (id<PMessage>) message {
    return _messageInfo[message.entityID] != Nil;
}

-(BOOL) isMine: (id<PMessage>) message {
    return [message.userModel.entityID isEqualToString: self.currentUserEntityID];
}

-(void) clear {
    _currentUserEntityID = Nil;
    [_messageBubbleImages removeAllObjects];
    [_messageInfo removeAllObjects];
}

-(NSString *) currentUserEntityID {
    if(!_currentUserEntityID) {
        _currentUserEntityID = [BNetworkManager sharedManager].a.core.currentUserModel.entityID;
    }
    return _currentUserEntityID;
}

@end
