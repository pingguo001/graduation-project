//
// Created by Zhangziqi on 4/13/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "RequestScheduler.h"
#import "NetworkRequest.h"
#import "NetworkClient.h"
#import "ResponseDelegate.h"

#define DEFAULT_CAPACITY 10

@interface RequestScheduler () <ResponseDelegate>
@property(nonatomic, strong) NetworkClient *client;             /**< 网络请求类 */
@property(nonatomic, strong) NSMutableArray<NetworkRequest *> *waitingRequests;   /**< 等待中的请求 */
@property(nonatomic, strong) NSMutableArray<NetworkRequest *> *ongoingRequests;   /**< 进行中的请求 */
@property(nonatomic) NSInteger ongoingPriority;                 /**< 进行中请求的优先级 */
@property(nonatomic) NSInteger waitingPriority;                 /**< 等待中的最高优先级 */
@end

@implementation RequestScheduler

static void *ObserveContext = &ObserveContext;

#pragma -
#pragma initialize & dealloc

/**
 *  获取单例对象
 *
 *  @return RequestScheduler 单例对象
 */
+ (instancetype)sharedInstance {
    static RequestScheduler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestScheduler alloc] init];
    });
    return instance;
}

/**
 *  初始化方法
 *
 *  @return RequestScheduler 对象
 */
- (instancetype)init {
    if (self = [super init]) {
        [self initWaitingQueue];
        [self initOngoingQueue];
        _client = [[NetworkClient alloc] init];
        _ongoingPriority = NSIntegerMin;
        _waitingPriority = NSIntegerMin;
    }
    return self;
}

/**
 *  初始化等待中请求的数组，并添加KVO绑定到 RequestScheduler 对象
 */
- (void)initWaitingQueue {
    _waitingRequests = [[NSMutableArray alloc] initWithCapacity:DEFAULT_CAPACITY];
    [self addObserver:self
           forKeyPath:NSStringFromSelector(@selector(waitingRequests))
              options:NSKeyValueObservingOptionNew
              context:ObserveContext];
}

/**
 *  初始化进行中请求的数组，并添加KVO绑定到 RequestScheduler 对象
 */
- (void)initOngoingQueue {
    _ongoingRequests = [[NSMutableArray alloc] initWithCapacity:DEFAULT_CAPACITY];
    [self addObserver:self
           forKeyPath:NSStringFromSelector(@selector(ongoingRequests))
              options:NSKeyValueObservingOptionNew
              context:ObserveContext];
}

/**
 *  释放方法，注销KVO
 */
- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(waitingRequests))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(ongoingRequests))];
}

#pragma -
#pragma enqueue request

/**
 *  加入一个需要处理的请求数组，所有请求都为非中断模式
 *
 *  @param requests 待处理的请求数组
 */
- (void)enqueueRequests:(NSArray *)requests {
    for (NetworkRequest *request in requests) {
        [self enqueueRequest:request];
    }
}

/**
 *  加入一个需要处理的请求，默认为非中断模式
 *
 *  @param request 待处理的请求
 */
- (void)enqueueRequest:(NetworkRequest *)request {
    [self enqueueRequest:request needInterrupt:NO];
}

/**
 *  加入一个需要处理的请求，可以选择中断、非中断模式，
 *  在中断模式下，且待处理的请求优先级比当前进行中的请求优先级都高，
 *  那么会取消掉所有当前进行中的请求，优先处理这个待处理的请求，而所有被取消的请求，
 *  会重新加入等待中的数组，等待下一次请求；
 *  如果是非中断模式，那么会把这个待处理的请求加入到进行中的数组，与进行中的请求一并处理
 *
 *  @param request   待处理的请求
 *  @param interrupt 是否是中断模式
 */
- (void)enqueueRequest:(NetworkRequest *)request needInterrupt:(BOOL)interrupt {
    if (request.priority > _ongoingPriority) {
        if (interrupt) {
            [self interruptRequests:_ongoingRequests];
        }

        [self enqueueOngoingArray:request];
    } else if (request.priority == _ongoingPriority) {
        [self enqueueOngoingArray:request];
    } else {
        [self enqueueWaitingArray:request];
    }
}

#pragma -
#pragma private methods

/**
 *  线程安全的把请求加入到进行中数组
 *
 *  @param request 待加入的请求
 */
- (void)enqueueOngoingArray:(NetworkRequest *)request {
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    // 如果直接改变NSMutableArray的内容不回触发KVO，所以必须使用此方式访问
    [[self mutableArrayValueForKey:NSStringFromSelector(@selector(ongoingRequests))] addObject:request];
    [lock unlock];
}

/**
 *  线程安全的把请求加入到等待中数组
 *
 *  @param request 待加入的请求
 */
- (void)enqueueWaitingArray:(NetworkRequest *)request {
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    // 如果直接改变NSMutableArray的内容不回触发KVO，所以必须使用此方式访问
    [[self mutableArrayValueForKey:NSStringFromSelector(@selector(waitingRequests))] addObject:request];
    [lock unlock];
}

/**
 *  线程安全的把请求从进行中数组移出
 *
 *  @param request 待移出的请求
 *
 *  @return 被移出的请求
 */
- (NetworkRequest *)dequeueOngoingArray:(NetworkRequest *)request {
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    [_ongoingRequests removeObject:request];
    [lock unlock];
    return request;
}

/**
 *  线程安全的把请求从等待中数组移出
 *
 *  @param request 待移出的请求
 *
 *  @return 被移出的请求
 */
- (NetworkRequest *)dequeueWaitingArray:(NetworkRequest *)request {
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    [_waitingRequests removeObject:request];
    [lock unlock];
    return request;
}

/**
 *  取消请求
 *
 *  @param request 待取消的请求
 */
- (void)cancelRequest:(NetworkRequest *)request {
    [request.session cancel];
    [request setState:CANCELED];
}

/**
 *  打断进行中的请求，内部调用了 cancelRequest:
 *
 *  @param requests 待打断的请求
 */
- (void)interruptRequests:(NSArray *_Nonnull)requests {
    NSArray *requestsCopy = [requests copy];
    
    for (NetworkRequest *request in requestsCopy) {
        [self cancelRequest:request];
        [self dequeueOngoingArray:request];
        [self enqueueWaitingArray:request];
    }
}

/**
 *  发送请求
 *
 *  @param request 待发送的请求
 */
- (void)sendRequest:(NetworkRequest *)request {
    
    WNLog(@"send request to url : %@", request.url);
    
    request.state = STARTED;
    switch (request.type) {
        case NONE:
            break;
        case GET:
            request.session = [_client get:request withDelegate:self];
            break;
        case POST:
            request.session = [_client post:request withDelegate:self];
            break;
        default:
            break;
    }
}

/**
 *  处理下一优先级的请求组
 */
- (void)enqueueWaitingPriorityRequests {
    NSMutableArray *pending = [NSMutableArray arrayWithCapacity:10];
    NSArray *waitingRequestsCopy = [_waitingRequests copy];
    
    for (NetworkRequest *request in waitingRequestsCopy) {
        if (request.priority == _waitingPriority) {
            [pending addObject:request];
            [self dequeueWaitingArray:request];
        }
    }
    
    _ongoingPriority = _waitingPriority;
    _waitingPriority = [self findHighestPriority:_waitingRequests];
    [self enqueueRequests:pending];
}

/**
 *  在给定的请求组中，查找最高的优先级
 *
 *  @param requests 给定的请求组
 *
 *  @return 最高的优先级
 */
- (NSInteger)findHighestPriority:(NSArray *_Nonnull)requests {
    NSInteger priority = NSIntegerMin;
    for (NetworkRequest *request in requests) {
        if (request.priority > priority) {
            priority = request.priority;
        }
    }
    return priority;
}

/**
 *  KVO的回调方法
 *
 *  @param keyPath 监听的Key
 *  @param object  Key归属的对象
 *  @param change  发生的变化
 *  @param context 添加KVO传入的
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context != ObserveContext) {
        return;
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(waitingRequests))]) {
        [self waitingRequestsChanged:change];
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(ongoingRequests))]) {
        [self ongoingRequestsChanged:change];
    }
}

/**
 *  当等待中的请求数组新增时，判断新增的请求优先级是否比当前等待的所有请求优先级都高，
 *  如果是，那么写入等待中优先级
 *
 *  @param change 发生的变化
 */
- (void)waitingRequestsChanged:(NSDictionary *)change {
    NSArray *new = change[@"new"];
    if ([new count]) {
        for (NetworkRequest *request in new) {
            if (request.priority > _waitingPriority) {
                _waitingPriority = request.priority;
            }
        }
    }
}

/**
 *  当进行中的请求数组新增时，判断新增的请求优先级是否比当前进行中的所有请求优先级都高，
 *  如果是，那么写入请求中优先级
 *
 *  @param change 发生的变化
 */
- (void)ongoingRequestsChanged:(NSDictionary *)change {
    NSArray *new = change[@"new"];
    if ([new count]) {
        for (NetworkRequest *request in new) {
            if (request.priority > _ongoingPriority) {
                _ongoingPriority = request.priority;
            }
            [self sendRequest:request];
        }
    }
}

#pragma -
#pragma response delegate

/**
 *  RequestScheduler 拦截了请求成功时的回调，当请求完成时，
 *  把请求从进行中队列移除，之后再触发真正成功的回调，
 *  如果进行中队列此时为空，那么开始执行下一优先级的请求
 *
 *  @param request  原始的请求
 *  @param response 请求的返回值
 */
- (void)request:(NetworkRequest *_Nonnull)request
        success:(id _Nonnull)response {
    [self dequeueOngoingArray:request];
    if (request.delegate && [request.delegate respondsToSelector:@selector(request:success:)]) {
        [request.delegate request:request success:response];
    }
    if ([_ongoingRequests count] == 0) {
        if ([_waitingRequests count] != 0) {
            [self enqueueWaitingPriorityRequests];
        } else {
            _ongoingPriority = NSIntegerMin;
        }
    }
}

/**
 *  RequestScheduler 拦截了请求失败时的回调，当请求完成时，
 *  把请求从进行中队列移除，之后再触发真正的失败回调
 *
 *  @param request  原始的请求
 *  @param response 返回的错误
 */
- (void)request:(NetworkRequest *_Nullable)request
        failure:(NSError *_Nonnull)error {
    [self dequeueOngoingArray:request];
    if (request.delegate && [request.delegate respondsToSelector:@selector(request:failure:)]) {
        [request.delegate request:request failure:error];
    }
    if ([_ongoingRequests count] == 0) {
        if ([_waitingRequests count] != 0) {
            [self enqueueWaitingPriorityRequests];
        } else {
            _ongoingPriority = NSIntegerMin;
        }
    }
}

@end
