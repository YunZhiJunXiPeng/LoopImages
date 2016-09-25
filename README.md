# LoopImages
用两个 UIImageView 实现了无限轮播图

云之君兮鹏简书地址：
http://www.jianshu.com/users/3efd78affaff/latest_articles

思路分析：

        用数组把需要展示的照片名称存进去， 有时间再去写加载网络照片吧！
        用一个属性记录当前展示的图片的下标，那么前一张和后一张的下标自然可以表示出来。
        给封装的View添加平移手势， 让当前的ImageView跟随者手势一起移动。
        我们用两个UIImageView展示图片， 当前ImageView展示着当前下标的照片，手势向 左（右）滑动的时候，另个ImageView紧挨着当前的ImageView，位于当前ImageView的右（左）侧！两个ImageView一起滑动！
        手势停止的时候，判断需要展示哪个ImageView！并把记录当前照片的ImageView指针指向这个展示的照片，记录下一个照片的指针指向不在视线的哪个ImageView。
        这样就完成了一次滑动切换照片，其他重复这样的操作就好了，在这基础上添加定时器实现自动切换功能！
