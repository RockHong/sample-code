一个给图片马赛克的小app

细节信息见工程目录里的readme


## dev log

- 反选功能
toolbar上有个item；可以切换正选/反选；怎么指示现在是正选还是反选？直接看实时的画面；

- 图片的裁剪
选择图片后，给用户一个裁剪的机会；
裁剪好之后，进入马赛克编辑见面；

- 图片的移动和放大
在屏幕上可以用两个手指放大；缩小（不能缩到比起始状态还小）；放大、缩小的手势作为最优先的手势；（相比于path的拖动、拖放来说）
处于放大状态时，手指放在path区域之外的地方时，可以拖动

- 有哪几个view、view controller，它们之间的交互和切换

