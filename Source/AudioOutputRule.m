//
//	PowerRule.m
//	ControlPlane
//
//	Created by David Jennes on 24/09/11.
//	Copyright 2011. All rights reserved.
//

#import "AudioOutputRule.h"
#import "AudioOutputSource.h"
#import "SourcesManager.h"
#import <IOKit/audio/IOAudioTypes.h>

@implementation AudioOutputRule

#pragma mark - Source observe functions

- (void) sourceChangedWithOld: (UInt32) oldSource andNew: (UInt32) newSource {
	UInt32 param = (UInt32) [[self.data objectForKey: @"parameter"] intValue];
	
	self.match = (param == newSource);
}

#pragma mark - Required implementation of 'Rule' class

- (NSString *) name {
	return NSLocalizedString(@"Audio Output", "Rule type");
}

- (void) beingEnabled {
	[SourcesManager.sharedSourcesManager registerRule: self toSource: @"AudioOutputSource"];
	
	// currently a match?
	AudioOutputSource *source = (AudioOutputSource *) [SourcesManager.sharedSourcesManager getSource: @"AudioOutputSource"];
	[self sourceChangedWithOld: 0 andNew: source.source];
}

- (void) beingDisabled {
	[SourcesManager.sharedSourcesManager unRegisterRule: self fromSource: @"AudioOutputSource"];
}

- (NSArray *) suggestedValues {
	return [NSArray arrayWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:
			 [NSNumber numberWithInt: kIOAudioOutputPortSubTypeInternalSpeaker], @"parameter",
			 NSLocalizedString(@"Internal Speakers", @"AudioOutputRule value suggestion"), @"description", nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
			 [NSNumber numberWithInt: kIOAudioOutputPortSubTypeHeadphones], @"parameter",
			 NSLocalizedString(@"Headphones", @"AudioOutputRule value suggestion"), @"description", nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
			 [NSNumber numberWithInt: kIOAudioOutputPortSubTypeExternalSpeaker], @"parameter",
			 NSLocalizedString(@"External speakers", @"AudioOutputRule value suggestion"), @"description", nil],
			nil];
}

@end
