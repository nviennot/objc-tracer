Objective-C Method tracer
==========================

Introduction
-------------

This library allows to print all the methods that are being called using
Objective-C runtime.

objc-tracer is compatible with iOS (ARM) and MacOS (x86\_64) platforms.

The goal is to have an output similar to [ltrace](http://ltrace.org/).

Installation
------------

Edit the Makefile to select your architecture, and `make`.

Limitations
-----------

1. All the functions are hijacked, but some of the stubs are empty.
2. The method arguments are on the stack, but are not pushed to the debugging
   function, so the arguments are currently not printed.

Send me some pull requests !

Usage
------

    $ DYLD_INSERT_LIBRARIES=/absolute_path/objc-tracer.dylib DYLD_FORCE_FLAT_NAMESPACE=1 executable

Example
--------

This is a simple hello world program:

    #import <Foundation/Foundation.h>
    
    @interface Hello : NSObject
    {}
    +(void) class_print;
    -(void) instance_print;
    @end
    
    @implementation Hello
    +(void) class_print
    {
            NSLog(@"Class: Hello World");
    }
    -(void) instance_print
    {
            NSLog(@"Instance: Hello World");
    }
    @end
    
    int main (int argc, const char * argv[])
    {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
            [Hello class_print];
            [[Hello new] instance_print];
    
            [pool drain];
            return 0;
    }
    

By Running:

    $ DYLD_INSERT_LIBRARIES=/absolute_path/objc-tracer.dylib DYLD_FORCE_FLAT_NAMESPACE=1 ./hello

We get the following trace:

    -objc->    NSArray::alloc()
    -objc->    NSRecursiveLock::new()
    -objc->    NSRecursiveLock::alloc()
    -objc->    NSRecursiveLock::init()
    -objc->    NSRecursiveLock::new()
    -objc->    NSRecursiveLock::alloc()
    -objc->    NSRecursiveLock::init()
    -objc->    NSLock::new()
    -objc->    NSLock::alloc()
    -objc->    NSLock::init()
    -objc->    NSLock::new()
    -objc->    NSLock::alloc()
    -objc->    NSLock::init()
    -objc->    NSLock::new()
    -objc->    NSLock::alloc()
    -objc->    NSLock::init()
    -objc->    NSRecursiveLock::new()
    -objc->    NSRecursiveLock::alloc()
    -objc->    NSRecursiveLock::init()
    -objc->    NSLock::new()
    -objc->    NSLock::alloc()
    -objc->    NSLock::init()
    -objc->    NSRecursiveLock::new()
    -objc->    NSRecursiveLock::alloc()
    -objc->    NSRecursiveLock::init()
    -objc->    NSRecursiveLock::new()
    -objc->    NSRecursiveLock::alloc()
    -objc->    NSRecursiveLock::init()
    -objc->    NSThread::currentThread()
    -objc->    NSThread::new()
    -objc->    NSThread::alloc()
    -objc->    NSThread::init()
    -objc->    _NSThreadData::new()
    -objc->    _NSThreadData::alloc()
    -objc->    _NSThreadData::init()
    -objc->    NSMutableDictionary::new()
    -objc->    NSMutableDictionary::alloc()
    -objc->    NSDictionary::self()
    -objc->    NSMutableDictionary::self()
    -objc->    __NSPlaceholderDictionary::mutablePlaceholder()
    -objc->    __NSPlaceholderDictionary::init()
    -objc->    __NSPlaceholderDictionary::initWithCapacity:()
    -objc->    NSThread::retain()
    -objc->    NSThread::release()
    -objc->    NSArray::self()
    -objc->    __NSPlaceholderArray::immutablePlaceholder()
    -objc->    __NSArrayI::__new::()
    -objc->    __NSPlaceholderArray::initWithObjects:count:()
    -objc->    __NSArrayI::__new::()
    -objc->    NSAutoreleasePool::alloc()
    -objc->    NSAutoreleasePool::allocWithZone:()
    -objc->    NSAutoreleasePool::init()
    -objc->    Hello::class_print()
    -objc->    NSTimeZone::defaultTimeZone()
    -objc->    NSTimeZone::systemTimeZone()
    -objc->    NSTimeZone::timeZoneWithName:()
    -objc->    NSTimeZone::alloc()
    -objc->    NSTimeZone::self()
    -objc->    __NSPlaceholderTimeZone::immutablePlaceholder()
    -objc->    __NSPlaceholderTimeZone::alloc()
    -objc->    NSTimeZone::self()
    -objc->    __NSPlaceholderTimeZone::allocWithZone:()
    -objc->    __NSPlaceholderTimeZone::initWithName:()
    -objc->    __NSPlaceholderTimeZone::__initWithName:cache:()
    -objc->    __NSTimeZone::__new:cache:()
    -objc->    NSCache::new()
    -objc->    NSCache::alloc()
    -objc->    NSCache::init()
    -objc->    NSCache::setName:()
    -objc->    NSCache::objectForKey:()
    -objc->    NSCache::evictsObjectsWithDiscardedContent()
    -objc->    nil::conformsToProtocol:()
    -objc->    NSCache::setObject:forKey:()
    -objc->    NSCache::setObject:forKey:cost:()
    -objc->    __NSTimeZone::retain()
    -objc->    __NSTimeZone::autorelease()
    -objc->    __NSTimeZone::retain()
    -objc->    __NSTimeZone::retain()
    -objc->    __NSTimeZone::retain()
    -objc->    __NSTimeZone::name()
    -objc->    NSDate::alloc()
    -objc->    NSDate::self()
    -objc->    __NSPlaceholderDate::immutablePlaceholder()
    -objc->    __NSPlaceholderDate::alloc()
    -objc->    NSDate::self()
    -objc->    __NSPlaceholderDate::allocWithZone:()
    -objc->    __NSPlaceholderDate::initWithTimeIntervalSinceReferenceDate:()
    -objc->    __NSTaggedDate::__new:()
    -objc->    NSTimeZone::systemTimeZone()
    -objc->    __NSTimeZone::retain()
    -objc->    __NSTimeZone::release()
    -objc->    __NSTimeZone::release()
    2012-02-23 00:12:24.838 hello[79399:60b] Class: Hello World
    -objc->    Hello::new()
    -objc->    Hello::alloc()
    -objc->    Hello::init()
    -objc->    Hello::instance_print()
    -objc->    NSTimeZone::defaultTimeZone()
    -objc->    __NSTimeZone::retain()
    -objc->    __NSTimeZone::name()
    -objc->    NSDate::alloc()
    -objc->    NSDate::self()
    -objc->    __NSPlaceholderDate::immutablePlaceholder()
    -objc->    __NSPlaceholderDate::initWithTimeIntervalSinceReferenceDate:()
    -objc->    __NSTaggedDate::__new:()
    -objc->    NSTimeZone::systemTimeZone()
    -objc->    __NSTimeZone::retain()
    -objc->    __NSTimeZone::release()
    -objc->    __NSTimeZone::release()
    2012-02-23 00:12:24.839 hello[79399:60b] Instance: Hello World
    -objc->    NSAutoreleasePool::drain()

License
--------

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
