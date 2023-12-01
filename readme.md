# BiuBiuBiu

（施工中）

一系列与B站有关的自动化脚本。（暂时）不是一个工具，而是一个构建自己的自动化工具的工具箱。

大部分逻辑来自[此项目](https://github.com/JiaQiZJQ/bilibiliTask/tree/main)。

## 安装

由于作者比较懒，现在所有任务只能在factor应用内部运行。（其实是作者还不会factor应用打包）

所有方法的第一步是登录B站，按F12，在"Application"菜单下找到"bili_jct"，"SESSDATA"，"DedeUserID"三个选项，记住它们对应的值。然后可以使用`<bilibili-key>`一词将其存入数据结构中。

### 方法一：加入factor词汇

1. 下载代码
2. 把所有文件放入factor所在的文件夹的work/bilibili目录中
3. 自己看着用

## 工作流程&代码组织

（doc稍后再写）

就作者目前的认知，B站的api分为两类。
1. 向此api发送get请求，可以获得一定信息。将其称为“询问（query）”api。
2. 向此api发送post请求，并提供一定数据，可以完成某种操作。将其称为“操作（operation）”api。

所以工作流大致如下：
1. 访问询问api，获得你需要的所有信息
2. 对数据进行处理，得到执行某种操作需要的信息
3. 使用信息执行操作

在bilibili.api中，每一个数据结构对应一个api。可以通过`get-$data`从B站获得数据，用`$do-$data`将数据提交给B站从而实现某种操作的自动化，比如看视频，投币等。

bilibili.tasks词汇中有使用bilibili.api进行自动化操作的例子。