//
//  UIScrollView+AGCategory.m
//  AGFoundation
//
//  Created by Andrew Garn on 24/06/2012.
//  Copyright (c) 2012 Andrew Garn. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UIScrollView+AGCategory.h"

#ifdef AGFOUNDATION_FRAMEWORK
FIX_CATEGORY_BUG(UIScrollView_AGCategory);
#endif

@implementation UIScrollView (AGCategory)

#pragma mark -

- (void)scrollToTop_AG
{
    [self scrollToTopAnimated_AG:YES];
}

- (void)scrollToTopAnimated_AG:(BOOL)animated
{
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (void)scrollToBottom_AG
{
    [self scrollToBottomAnimated_AG:YES];
}

- (void)scrollToBottomAnimated_AG:(BOOL)animated
{
    [self setContentOffset:CGPointMake(0, (self.contentSize.height - self.frame.size.height)) animated:animated];
}

@end