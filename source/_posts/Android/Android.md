---
title: Android开发
date: 2020-7-6
categories: Android
---
    Even miracle take a moment 
    Do what feels right to you

### 安卓开发功能

```
	AlbumMainActivity(专辑主页面)，首先初始化页面，获取AlbumList，得到专辑id，onActivityResult用于页面传值。onResume和onPause调用友盟。
```
<!--more-->
```java
	// NetHelper 解析，创建单例，用于调用，初始化检查设备在线的状态，如果是wifi，开始局域网扫描，扫描先shotdownNow()，然后通过广播地址（255.255.255.255）,通过定时执行0秒延时，隔3秒，执行线程池中执行发送信号（也就是url，DEVICE_DISCOVERY = "/discovery?param=xiaotingting&port=255.255.255.255";）线程执行sendBroadcast（数据，ip），通过DatagramPacket（就像通信的船），（DatagramSocket是两个港口），其中DatagramPacket会使用四个参数，字节，长度，广播地址（255...），端口号
	// 发送广播
	        mSendSocket.setBroadcast(true);
            mSendSocket.setSoTimeout(5000);
            mSendSocket.send(sendPacket);




    private void startVboxPoll() {
        if (mPollExecutor != null || mDeviceId == 0) return;
        int period = isSendLAN ? 1 : 3; //局域网1秒轮询，远程3秒轮询
        mDateCheckOnline = new Date();
        mPollExecutor = new ScheduledThreadPoolExecutor(1);
        mPollExecutor.scheduleAtFixedRate(this::doPollRunnable, 0, period, TimeUnit.SECONDS);
    }
    @SuppressLint("CheckResult")
    private void doDiscoverRunnable() {
        if (isInWIFI && !isSendLAN) {

            //发送discovery命令
            sendDeviceDiscovery();
            // 此方法用于轮询若是局域网，则1秒轮询，若是远程3秒执行轮询
            startVboxPoll();
        }
    }
        mPollExecutor = new ScheduledThreadPoolExecutor(1);
        mPollExecutor.scheduleAtFixedRate(this::doPollRunnable, 0, period, TimeUnit.SECONDS);
    public void init(long userId) {
        LogUtils.d("NetHelper 初始化 userId:" + userId);
        if (userId == 0) {
            closeConnect();
            return;
        }
        if (mLanBusiness == null) mLanBusiness = new LANBusiness();
        if (mNetDataHelper == null) mNetDataHelper = new NetDataHelper();
        if (mMQTTBusiness == null) mMQTTBusiness = new MQTTBusiness();
        mDateRecData = null;
        mDateSendPoll = null;
        mDateCheckOnline = null;
        mNetDataHelper.init(userId);
        mLanBusiness.startListen();
        mMQTTBusiness.init(userId);
        checkDeviceOnline();

    }

    /**
     * 设置设备Id
     * @param deviceId
     */
    public void setDeviceId(long deviceId) {
        mDeviceId = deviceId;
        if (mLanBusiness != null) mLanBusiness.setDeviceId(deviceId);
        if (mMQTTBusiness != null) mMQTTBusiness.setDeviceId(deviceId);
        checkDeviceOnline();//重新切换局域网设备发现
        // 切换设备的话需要重新链接
    }

/*
	通过局域网的广播发送数据，同网段都能收到
*/

play

 初始化
     public void setVboxPoll(boolean isVboxPoll) {

        this.isVboxPoll = isVboxPoll;

        if (this.isVboxPoll) {
            startVboxPoll();
        } else {
            stopVboxPoll();
        }
    }
    //如果设备不是真待机的情况下就打开轮训开关
    NetHelper.getInstance().setVboxPoll(true);
//处理子线程发送的信息
    handleMessage() 
    //其余是处理各种点击事件，但是真正的处理逻辑是在AppPlayControlManager里面
    //AppPlayControlManager用于处理真正的逻辑，创建单例，进度条监视器，播放监听，
// PlayManager.getInstance().setAppPlayState(state);设置播放状态为正常或者其他.
    // 初始化PhonePlayView()
    private void initPhonePlayView() {
        // 初始化界面信息
        setAppPlayInfoAndUi(PlayManager.getInstance().getPhoneCurrentVoiceInfo());
        // 得到播放状态 播放状态可以分为normal playing，pause，error
        setAppPlayStateAndUi(PlayManager.getInstance().getAppPlayState());
        // 得到播放顺序的模式
        setAppPlayModeAndUi(PlayManager.getInstance().getPhonePlayMode());
        // 进度条
        setAppUiPlayProgressUi(0, 0, 0, 0);
//        initPhonePlayKeyView();
        // 
        playGifControlTop();
        //mPlayCoverTopGif.setImageDrawable(mGifDrawable);

        if(PlayManager.getInstance().getAppPlayState() == PlayData.APP_PLAY_STATE_PAUSE){
            pauseGifControlTop();
        }
    }
// 其余为各种事件的处理
```
```java
    //高斯模糊
//        Glide.with(mContext).load(voiceInfo.getCoverUrl()).apply(RequestOptions.bitmapTransform(new BlurTransformation(25,5))).into(new CustomTarget<Drawable>() {
//            @Override
//            public void onResourceReady(@NonNull Drawable resource, @Nullable Transition<? super Drawable> transition) {
//                Drawable drawable = resource.getCurrent();
//                drawable = DrawableCompat.wrap(drawable);
//                drawable.setColorFilter(Color.GRAY, PorterDuff.Mode.MULTIPLY);
//                mPlayMainLayout.setBackground(drawable);
//            }
//
//            @Override
//            public void onLoadCleared(@Nullable Drawable placeholder) {
//
//            }
//        });
```
登陆接口采用jbush，采用rustful接口方式，对接后台比较方便，
绑定订阅到rxjava 

rxjava的原理，被观察者产生一系列的事件，通过订阅者传递给观察者，观察者通过一些列的事件作出响应的模式（特点：链式调用）

Rxjava 的优雅实现

```java
        Observable.create(new ObservableOnSubscribe<Integer>() {

            @Override
            public void subscribe(@NonNull ObservableEmitter<Integer> emitter) {
                emitter.onNext(1);
                emitter.onNext(2);
                emitter.onNext(3);
                emitter.onComplete();
            }
        }).subscribe(new Observer<Integer>() {
            @Override
            public void onSubscribe(@NonNull Disposable d) {
                Log.e("TAG","onSubscribe"+d);
            }

            @Override
            public void onNext(@NonNull Integer integer) {
                Log.e("TAG","onNext"+integer);
            }

            @Override
            public void onError(@NonNull Throwable e) {
                Log.e("TAG","onError"+e);
            }

            @Override
            public void onComplete() {
                Log.e("TAG","onComplete");
            }
        });
        // 基本形式，被观察者.subscribe(观察者)，subscribe 有多个重载版本

        Disposable disposable // 可切断观察者和被观察者的链接
```
<img src="Rxjava1.png">

```java
new Observer<Integer>() {
            private Disposable disposable;
            @Override
            public void onSubscribe(@NonNull Disposable d) {
                Log.e("TAG","onSubscribe"+d);
                this.disposable = d;
            }

            @Override
            public void onNext(@NonNull Integer integer) {
                Log.e("TAG","onNext"+integer);
                if (integer == 2){
                    disposable.dispose();
                    Log.e("TAG","断开链接");
                }

            }
```
<img src="Rxjava2.png">

#### Rxjava创建操作符

Rxjava 快速创建observable```just()```快速创建，最多发送10个参数

```java
        Observable.just(3,1,2,4).subscribe(new Observer<Integer>(){

            @Override
            public void onSubscribe(@NonNull Disposable d) {
                
            }
            ...
```

​	```fromArray()```快速创建一个被观察者对象，发送10个以上事件数组形式

```java
Integer[] items = {0,1,2,3,4};
Observable.fromArray(items).subscribe(...)
```

```fromIterable()```传入```List```数据，会将数组中的数据转换为Obersvable对象。

额外方法：

![image-20200814151328887](/Users/philxling/Library/Application Support/typora-user-images/image-20200814151328887.png)

延迟创建(经过x秒后，自动执行某操作或周期行任务)

```defer```(直到有观察者时，才动态创建被观察者&发送事件)

```timer``` 延迟后发送一个事件

```java
        Observable.timer(2, TimeUnit.SECONDS).subscribe(new Observer<Long>() {
            @Override
            public void onSubscribe(@NonNull Disposable d) {
                
            }

            @Override
            public void onNext(@NonNull Long aLong) {

            }
```

```interval```创建一个被观察者对象，每隔指定时间就发送。

```java
//interval(第一次延迟时间，间隔时间数字，时间单位)
Observable.interval(3,1,TimeUnit.SECONDS).subscribe(...)
```

```intervalRange()```创建一个被观察者对象，每隔指定时间发送事件，可以指定发送的数量。

```java
// 参数1 事件序列起始点没，参数2 事件数量，参数3 第一次事件延迟发送时间，参数4 时间间隔，参数5 时间单位
Observable.interval(3,10,2,1,TimeUnit.SECONDS).subscribe(...)
```

```range```发送一个事件序列，指定范围。

```java
/**
* 1 起始点
* 2 事件数量
*/
Observable.range(3,10).subscribe(...)
```

```rangeLong()``` 支持long数据类型

Rxjava + Retrofit 轮询发送请求

```java
implementation 'io.reactivex.rxjava3:rxjava:3.0.4'
implementation 'io.reactivex.rxjava3:rxandroid:3.0.0'

    // Android 支持 Retrofit
implementation'com.squareup.retrofit2:retrofit:2.1.0'

    // 支持Gson解析
implementation 'com.squareup.retrofit2:converter-gson:2.1.0'

implementation 'com.squareup.retrofit2:adapter-rxjava3:2.9.0'
// 添加Rxjava+Retrofit+adapter
```

创建请求接口

```java
public interface GetRequest_Interface {
  @GET("ajax.php?a=fy&f=auto&t=auto&w=hei%20world")
  Observable<Translation> getCall();
}
// 会自动封装url
提供model
  public class Translation {
    private int status;
    private content content;
    private static class content{
      private String from;
      private String to;
      private String vendor;
      private String out;
      private int errNo;     
    }
    public void show(){
      Log.e("Rxjava",content.out);
    }
  }
// 执行请求 2 秒后执行吗，每隔一秒执行请求
Observable.interval(2,1,TimeUnit.SECONDS).doOnNext(new Consumer<Long>() {
  @Override
  public void accept(Long aLong) throws Throwable {
    Log.e("TAG","第" + aLong + "次轮询");

    Retrofit retrofit = new Retrofit.Builder().baseUrl("https://fy.iciba.com/").addConverterFactory(GsonConverterFactory.create()).addCallAdapterFactory(RxJava3CallAdapterFactory.create()).build();
    // 创建网络请求接口
    GetRequest_Interface request_interface = retrofit.create(GetRequest_Interface.class);
    // 封装
    Observable<Translation> observable = request_interface.getCall();
    // 先在io线程执行，在mainThread处理结果
    observable.subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).subscribe(new Observer<Translation>() {
      @Override
      public void onSubscribe(@NonNull Disposable d) {

      }

      @Override
      public void onNext(@NonNull Translation translation) {
        translation.show();
      }

      @Override
      public void onError(@NonNull Throwable e) {
        Log.e("TAG","请求失败"+e);
      }

      @Override
      public void onComplete() {

      }
    });
  }
}).subscribe(new Observer<Long>() {
  @Override
  public void onSubscribe(@NonNull Disposable d) {

  }

  @Override
  public void onNext(@NonNull Long aLong) {

  }

  @Override
  public void onError(@NonNull Throwable e) {
    Log.e("error","处理error"+e);
  }

  @Override
  public void onComplete() {

  }
});
```

![](https://upload-images.jianshu.io/upload_images/944365-71eb569b296c1f18.png)

```.FlatMap()```将被观察者的事件序列进行拆分，单独转换，在合并成一个新的事件序列，最后在进行发送，即为事件中的每个事件创建Observable对象，进行转换后的新事件都放在Observable对象，最终合并到总的Observable对象。进行发送。

![](https://upload-images.jianshu.io/upload_images/944365-a6f852c071db2f15.png)

```java
// 采用RxJava基于事件流的链式操作
        Observable.create(new ObservableOnSubscribe<Integer>() {
            @Override
            public void subscribe(ObservableEmitter<Integer> emitter) throws Exception {
                emitter.onNext(1);
                emitter.onNext(2);
                emitter.onNext(3);
            }

            // 采用flatMap（）变换操作符
        }).flatMap(new Function<Integer, ObservableSource<String>>() {
            @Override
            public ObservableSource<String> apply(Integer integer) throws Exception {
                final List<String> list = new ArrayList<>();
                for (int i = 0; i < 3; i++) {
                    list.add("我是事件 " + integer + "拆分后的子事件" + i);
                    // 通过flatMap中将被观察者生产的事件序列先进行拆分，再将每个事件转换为一个新的发送三个String事件
                    // 最终合并，再发送给被观察者
                }
                return Observable.fromIterable(list);
            }
        }).subscribe(new Consumer<String>() {
            @Override
            public void accept(String s) throws Exception {
                Log.d(TAG, s);
            }
        });
```

```.ConcatMap()```拆分重新合并生成的事件序列顺序=被观察者旧序列生成的顺序。新合并的事件是有序的。

![](https://upload-images.jianshu.io/upload_images/944365-f4340f283e5a954d.png)

```java
.concatMap(new Function<Integer, ObservableSource<String>>() {
            @Override
            public ObservableSource<String> apply(Integer integer) throws Exception {
                final List<String> list = new ArrayList<>();
                for (int i = 0; i < 3; i++) {
                    list.add("我是事件 " + integer + "拆分后的子事件" + i);
                    // 通过concatMap中将被观察者生产的事件序列先进行拆分，再将每个事件转换为一个新的发送三个String事件
                    // 最终合并，再发送给被观察者
                }
                return Observable.fromIterable(list);
            }
        }).
```

```Buffer()```每次取一定的事件放在缓存区中，然后发送。

![](https://upload-images.jianshu.io/upload_images/944365-5278a339e4337494.png)

```java
        Observable.just(1,2,3,4,5).buffer(3,1).subscribe(new Observer<List<Integer>>() {
            @Override
            public void onSubscribe(@NonNull Disposable d) {

            }

            @Override
            public void onNext(@NonNull List<Integer> integers) {
                Log.e("TAG","buffer"+integers);

            }

            @Override
            public void onError(@NonNull Throwable e) {

            }

            @Override
            public void onComplete() {

            }
        });
```

![image-20200817110844146](/Users/philxling/blog/source/_posts/Android/image-20200817110844146.png)

原理：一次接收3个事件，并且步长为一，所以每次指针向后移动一个。

![](https://upload-images.jianshu.io/upload_images/944365-33a49ffd2ec60794.png)

![](https://upload-images.jianshu.io/upload_images/944365-dc0a7df673324e21.png)

```java
//组合多个观察者
concat()/concatArray()// 组合多个Observable对象 串行发送，concat组合被观察者数量<=4,而concatArray()则可>4
  
  
        Observable.concat(Observable.just(1, 2, 3),
                           Observable.just(4, 5, 6),
                           Observable.just(7, 8, 9),
                           Observable.just(10, 11, 12))
          // 注：串行执行
        Observable.concatArray(Observable.just(1, 2, 3),
                           Observable.just(4, 5, 6),
                           Observable.just(7, 8, 9),
                           Observable.just(10, 11, 12),
                           Observable.just(13, 14, 15))
  
  
  // marge
  merge()// 数量< = 4
  mergeArray() //数量>4 组合被观察者并行执行
  
  
  
  // merge（）：组合多个被观察者（＜4个）一起发送数据
        // 注：合并后按照时间线并行执行
        Observable.merge(
                Observable.intervalRange(0, 3, 1, 1, TimeUnit.SECONDS), // 从0开始发送、共发送3个数据、第1次事件延迟发送时间 = 1s、间隔时间 = 1s
                Observable.intervalRange(2, 3, 1, 1, TimeUnit.SECONDS)) // 从2开始发送、共发送3个数据、第1次事件延迟发送时间 = 1s、间隔时间 = 1s
  
  
  
```

``` concatDelayError()/ mergeDelayError()```

 ```java
// 如果第一个事件发生error则会在后面的事发送完事件后再继续发送。
Observable.concatArrayDelayError(
                Observable.create(new ObservableOnSubscribe<Integer>() {
                    @Override
                    public void subscribe(ObservableEmitter<Integer> emitter) throws Exception {

                        emitter.onNext(1);
                        emitter.onNext(2);
                        emitter.onNext(3);
                        emitter.onError(new NullPointerException()); // 发送Error事件，因为使用了concatDelayError，所以第2个Observable将会发送事件，等发送完毕后，再发送错误事件
                        emitter.onComplete();
                    }
                }),
                Observable.just(4, 5, 6))
 ```

Zip()合并多个事件

<img src="https://upload-images.jianshu.io/upload_images/944365-3fa4b1fd4f561820.png" style="zoom:67%;" />

组合方式严格按照原先事件序列，进行对位合并，最终合并的事件数量等于多个被观察者中数量最少的数量。

![image-20200817121034116](/Users/philxling/blog/source/_posts/Android/image-20200817121034116.png)

在rxjava3中，不会发送没有合并的事件。

```java
Observable.zip(Observable.create(new ObservableOnSubscribe<Integer>() {
            @Override
            public void subscribe(@NonNull ObservableEmitter<Integer> emitter) throws Throwable {
                emitter.onNext(1);
                emitter.onNext(2);
                emitter.onNext(3);



            }
        }), Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(@NonNull ObservableEmitter<String> emitter) throws Throwable {
                emitter.onNext("A");
                Thread.sleep(1000);
                emitter.onNext("B");
                Thread.sleep(1000);
                emitter.onNext("C");
                Thread.sleep(1000);
                emitter.onNext("D");
                Thread.sleep(1000);
                emitter.onComplete();


            }
        }).subscribeOn(Schedulers.newThread()), new BiFunction<Integer, String, String>() {

            @Override
            public String apply(Integer integer, String s) throws Throwable {
                return integer+s;
            }
        }).subscribe(new Consumer<String>() {
            @Override
            public void accept(String s) throws Throwable {
                Log.e("TAG",s);
            }
        });
```

```combineLatest()```按时间合并，即在同一个时间点上合并

```combineLatestDelayError（）```错误处理

```reduce()```把被观察者发送的事件聚合成一个事件，聚合的逻辑自己写

```java
        // reduce()
        Observable.just(1,2,3,4).reduce(new BiFunction<Integer, Integer, Integer>() {
            @Override
            public Integer apply(Integer integer, Integer integer2) throws Throwable {
                return integer * integer2;
            }
        }).subscribe(new Consumer<Integer>() {
            @Override
            public void accept(Integer integer) throws Throwable {
                Log.e("TAG","reduce"+"------------"+integer);
            }
        });
// E/TAG: reduce------------24
```

```java
collect()  //事件收集到一个数据结构中

startWith() //  发送事件前追加单个数据

startWithArray() // 追加多个数据

count() // 统计被观察者发送事件的数量
  
```

常见的合并/组合操作符

![](https://upload-images.jianshu.io/upload_images/944365-214478680237ffb8.png)

例：获取数据，若缓存中有则取缓存，否则取磁盘，否则在请求网络获取数据。

```java
        String memoryCache = null;

        String diskCache = "磁盘缓存";

        Observable memory = Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(@NonNull ObservableEmitter<String> emitter) throws Throwable {
                if(memoryCache != null){
                    emitter.onNext(memoryCache);
                }else {
                    emitter.onComplete();
                }
            }
        });
        Observable disk = Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(@NonNull ObservableEmitter<String> emitter) throws Throwable {
                if(diskCache != null){
                    emitter.onNext(diskCache);
                }else {
                    emitter.onComplete();
                }
            }
        });

        Observable network = Observable.just("从网络获取");

        Observable.concat(memory,disk,network).firstElement().subscribe(new Consumer<String>() {
            @Override
            public void accept(String s) throws Throwable {
                Log.e("TAG",s);
            }
        });
```

网络获取多个数据进行合并输出

```java
// 创建retrofit
Retrofit retrofit = new Retrofit.Builder().baseUrl("https://fy.iciba.com/").addConverterFactory(GsonConverterFactory.create()).addCallAdapterFactory(RxJava3CallAdapterFactory.create()).build();
// 请求接口
        GetRequest_Interface getRequest_interface = retrofit.create(GetRequest_Interface.class);
// 新建线程调用
        Observable<Translation>  observable = getRequest_interface.getCall().subscribeOn(Schedulers.io());
        Observable<Translation1>  observable1 = getRequest_interface.getCall_2().subscribeOn(Schedulers.io());
// 合并输出
        Observable.zip(observable1, observable, new BiFunction<Translation1, Translation, String>() {

            @Override
            public String apply(Translation1 translation1, Translation translation) throws Throwable {
                return translation1.show()+translation.show();
            }
        }).subscribe(new Consumer<String>() {
            @Override
            public void accept(String s) throws Throwable {
                Log.e("TAG", "最终返回的数据" + s);
            }
        }, new Consumer<Throwable>() {
            @Override
            public void accept(Throwable throwable) throws Throwable {
                Log.e("TAG","登陆失败");
            }
        });
```

![image-20200817171213846](/Users/philxling/blog/source/_posts/Android/image-20200817171213846.png)

 利用```conbineLatest()```进行空值判断：

```java
        /*
         * 步骤1：设置控件变量 & 绑定
         **/
        EditText name,age,job;
        Button list;

        name = (EditText) findViewById(R.id.name);
        age = (EditText) findViewById(R.id.age);
        job = (EditText) findViewById(R.id.job);
        list = (Button) findViewById(R.id.list);

        /*
         * 步骤2：为每个EditText设置被观察者，用于发送监听事件
         * 说明：
         * 1. 此处采用了RxBinding：RxTextView.textChanges(name) = 对对控件数据变更进行监听（功能类似TextWatcher），需要引入依赖：compile 'com.jakewharton.rxbinding2:rxbinding:2.0.0'
         * 2. 传入EditText控件，点击任1个EditText撰写时，都会发送数据事件 = Function3（）的返回值（下面会详细说明）
         * 3. 采用skip(1)原因：跳过 一开始EditText无任何输入时的空值
         **/
        Observable<CharSequence> nameObservable = RxTextView.textChanges(name).skip(1);
        Observable<CharSequence> ageObservable = RxTextView.textChanges(age).skip(1);
        Observable<CharSequence> jobObservable = RxTextView.textChanges(job).skip(1);

        /*
         * 步骤3：通过combineLatest（）合并事件 & 联合判断
         **/
        Observable.combineLatest(nameObservable,ageObservable,jobObservable,new Function3<CharSequence, CharSequence, CharSequence,Boolean>() {
            @Override
            public Boolean apply(@NonNull CharSequence charSequence, @NonNull CharSequence charSequence2, @NonNull CharSequence charSequence3) throws Exception {

                /*
                 * 步骤4：规定表单信息输入不能为空
                 **/
                // 1. 姓名信息
                boolean isUserNameValid = !TextUtils.isEmpty(name.getText()) ;
                // 除了设置为空，也可设置长度限制
                // boolean isUserNameValid = !TextUtils.isEmpty(name.getText()) && (name.getText().toString().length() > 2 && name.getText().toString().length() < 9);

                // 2. 年龄信息
                boolean isUserAgeValid = !TextUtils.isEmpty(age.getText());
                // 3. 职业信息
                boolean isUserJobValid = !TextUtils.isEmpty(job.getText()) ;

                /*
                 * 步骤5：返回信息 = 联合判断，即3个信息同时已填写，"提交按钮"才可点击
                 **/
                return isUserNameValid && isUserAgeValid && isUserJobValid;
            }

                }).subscribe(new Consumer<Boolean>() {
            @Override
            public void accept(Boolean s) throws Exception {
                /*
                 * 步骤6：返回结果 & 设置按钮可点击样式
                 **/
                Log.e(TAG, "提交按钮是否可点击： "+s);
                list.setEnabled(s);
            }
        });
```

Rxjava 线程工作原理

![](https://upload-images.jianshu.io/upload_images/944365-3997d7540acda975.png)

| 类型                           | 含义                | 应用                             |
| ------------------------------ | ------------------- | -------------------------------- |
| Schedulers.immediate()         | 当前线程=不指定线程 | 默认                             |
| AndroidSchedulers.mainThread() | Android主线程       | main                             |
| Schedulers.newThread()         | 常规新线程          | 耗时的操作                       |
| Schedulers.io()                | io操作线程          | 网络请求，读写文件等io密集型操作 |
| Schedulers.compution()         | cpu计算线程         | 大量计算                         |

使用：

```java
Observable.subscribeOn()指定
```

```java
// 1. 整体方法调用顺序：观察者.onSubscribe（）> 被观察者.subscribe（）> 观察者.doOnNext（）>观察者.onNext（）>观察者.onComplete() 
// 2. 观察者.onSubscribe（）固定在主线程进行
```



