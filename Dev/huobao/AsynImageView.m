#import "AsynImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AsynImageView

@synthesize imageURL = _imageURL;
@synthesize placeholderImage = _placeholderImage;

@synthesize fileName = _fileName;
@synthesize canDownload;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 2.0;
        self.backgroundColor = [UIColor grayColor];
        self.canDownload = YES;
        
    }
    return self;
}

-(id)init
{
    if (self = [super init]) {
        canDownload = YES;
    }
    return self;
}

-(id)initWithTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        // Initialization code
        self.tag = tag;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 2.0;
        self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

//重写placeholderImage的Setter方法
-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    canDownload = YES;
    if(placeholderImage != _placeholderImage )
    {
        _placeholderImage = placeholderImage;
        self.image = _placeholderImage;    //指定默认图片
    }
}

//重写imageURL的Setter方法
-(void)setImageURL:(NSString *)imageURL
{

    if(imageURL != _imageURL)
    {
        self.image = _placeholderImage;    //指定默认图片
        _imageURL = imageURL;
        self.imageURL = imageURL;
    }
    
    if(self.imageURL && canDownload)
    {
        //确定图片的缓存地址
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *docDir = [path objectAtIndex:0];
        NSString *tmpPath=[docDir stringByAppendingPathComponent:@"AsynImage"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        
        if(![fm fileExistsAtPath:tmpPath])
        {
            [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSArray *lineArray = [self.imageURL componentsSeparatedByString:@"/"];
        NSMutableString *tempfilename = [[NSMutableString alloc] initWithCapacity:0];
        for (int i = [lineArray count] - 1; i >= [lineArray count] - 3 && i >= 0; i--) {
            NSString *str = [lineArray objectAtIndex:i];
            [tempfilename insertString:str atIndex:0];
        }
        self.fileName = [NSString stringWithFormat:@"%@/%@",tmpPath,tempfilename];
        
        //判断图片是否已经下载过，如果已经下载到本地缓存，则不用重新下载。如果没有，请求网络进行下载。
        if(![[NSFileManager defaultManager] fileExistsAtPath:_fileName])
        {
            if (self.tag == -1) {
                [self loadImage];
                return;
            }
            //下载图片，保存到本地缓存中
            Reachability *reach = [Reachability reachabilityForInternetConnection];
            switch ([reach currentReachabilityStatus]) {
                case NotReachable:
                {
                    break;
                }
                case ReachableViaWWAN:
                {
                    
                    break;
                }
                case ReachableViaWiFi:
                {
                    [self loadImage];
                    break;
                }
            }
        }
        else
        {
            //本地缓存中已经存在，直接指定请求的网络图片
            self.image = [UIImage imageWithContentsOfFile:_fileName];
        }
    }
}




//网络请求图片，缓存到本地沙河中
-(void)loadImage
{
    //对路径进行编码
    @try {
        //请求图片的下载路径
        //定义一个缓存cache
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        /*设置缓存大小为1M*/
        [urlCache setMemoryCapacity:1*124*1024];
        
        //设子请求超时时间为30s
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.imageURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
        
        //从请求中获取缓存输出
        NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
        if(response != nil)
        {
            //            NSLog(@"如果又缓存输出，从缓存中获取数据");
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        }
        
        /*创建NSURLConnection*/
        if(!connection)
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        //开启一个runloop，使它始终处于运行状态
        
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    }
    @catch (NSException *exception) {
        //        NSLog(@"没有相关资源或者网络异常");
    }
    @finally {
        ;//.....
    }
}

#pragma mark - NSURLConnection Delegate Methods
//请求成功，且接收数据(每接收一次调用一次函数)
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(loadData==nil)
    {
        loadData=[[NSMutableData alloc]initWithCapacity:2048];
    }
    [loadData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
    //    NSLog(@"将缓存输出");
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //    NSLog(@"即将发送请求");
    return request;
}
//下载完成，将文件保存到沙河里面
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    
    NSString *imageStr = [[NSString alloc] initWithData:loadData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",imageStr);
    
    if (imageStr != nil) {
        @try {
            NSRange rang1=[imageStr rangeOfString:@"<title>"];
            NSMutableString *imageStr2=[[NSMutableString alloc]initWithString:[imageStr substringFromIndex:rang1.location+rang1.length]];
            
            NSRange rang2=[imageStr2 rangeOfString:@"</title>"];
            NSMutableString *errorString = [[NSMutableString alloc]initWithString:[imageStr2 substringToIndex:rang2.location]];
            if ([errorString isEqualToString:@"404 Not Found"]) {
                UIApplication *app = [UIApplication sharedApplication];
                app.networkActivityIndicatorVisible = NO;
                
                //如果发生错误，则重新加载
                connection = nil;
                loadData = nil;
                self.canDownload = NO;
                self.image = self.placeholderImage;
                return;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception = %@",exception);
        }
        @finally {
            
        }
    }
    

//    if ([loadData length] < 400 && self.tag != 100) {
//        UIApplication *app = [UIApplication sharedApplication];
//        app.networkActivityIndicatorVisible = NO;
//        
//        //如果发生错误，则重新加载
//        connection = nil;
//        loadData = nil;
////        self.imageURL = nil;
//        self.canDownload = NO;
//        self.image = self.placeholderImage;
//        
//        
//        return;
//    }
    if([loadData writeToFile:_fileName atomically:YES])
    {
        self.image = [UIImage imageWithContentsOfFile:_fileName];
    }
    else{
        NSLog(@"写入图片失败");
    }
    connection = nil;
    loadData = nil;
    
}


- (NSString *) getBookAddr:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if(error) {
        NSLog(@"Error:%@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *tdNode = [bodyNode findChildTag:@"body"];
    HTMLNode *linkNode = nil;
    NSString *bookAddrString = nil;
    
    if(tdNode != nil && (linkNode = [tdNode findChildTag:@"a"]) != nil && (bookAddrString = [linkNode getAttributeNamed:@"href"]) != nil) {
        //        [parser release];
        return bookAddrString;
    } else {
        //        [parser release];
        return nil;
    }
}

//网络连接错误或者请求成功但是加载数据异常
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    //如果发生错误，则重新加载
    connection = nil;
    loadData = nil;
    self.imageURL = nil;
    //    [self loadImage];
}




//-(void)dealloc
//{
//    
//    [_fileName release];
//    [loadData release];
//    [connection release];
//    
//    [_placeholderImage release];
//    [_imageURL release];
//    
//    [super dealloc];
//}

@end