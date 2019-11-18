# 7.2.PCA/tSNE

本章我们将：

1.理解和掌握PCA和tSNE方法原理和意义；
2.利用python实现PCA和tSNE分析。

## 1\) PCA(principle component analysis)
* 通过线性组合得到贡献最大的、可解释的变量\(principle components\)
* 数据的降维和可视化
* 可参考的资料：
[PCA](https://zhuanlan.zhihu.com/p/37777074)  
[SVD](https://mp.weixin.qq.com/s/Dv51K8JETakIKe5dPBAPVg)  
[Hinton理解的PCA](https://www.jianshu.com/p/76c64cd0b5ad)  
[PCA和SVD的区别与联系](https://blog.csdn.net/wangjian1204/article/details/50642732)

### \(1\) principle

PCA的主要思想是将n维特征映射到k维上，这k维是新的彼此正交的特征，也被称为主成分。PCA的工作就是从原始的空间中顺序地找一组相互正交的坐标轴，新的坐标轴的选择与数据本身密切相关。其中，第一个新坐标轴选择是原始数据中方差最大的方向，第二个新坐标轴选取是与第一个坐标轴正交的平面中使得方差最大的，第三个轴是与第1,2个轴正交的平面中方差最大的。依次类推，可以得到n个这样的坐标轴。通过这种方式获得的新的坐标轴。

我们发现，大部分方差都包含在前面k个坐标轴中，后面的坐标轴所含的方差几乎为0。于是，我们可以忽略余下的坐标轴，只保留前面k个含有绝大部分方差的坐标轴，相当于只保留包含绝大部分方差的维度特征，而忽略包含方差几乎为0的特征维度，实现对数据特征的降维处理。

**如何得到这些包含最大差异性的主成分方向？**

通过计算数据矩阵的协方差矩阵，然后得到协方差矩阵的特征值特征向量，选择特征值最大\(即方差最大\)的k个特征所对应的特征向量组成的矩阵。这样就可以将数据矩阵转换到新的空间当中，实现数据特征的降维。  
由于得到协方差矩阵的特征值特征向量有两种方法：特征值分解协方差矩阵、奇异值分解协方差矩阵，所以PCA算法有两种实现方法：基于特征值分解协方差矩阵实现PCA算法、基于SVD分解协方差矩阵实现PCA算法。

**协方差矩阵表征了变量自身的“能量”/“信息”和彼此的关联性**
假设样本中某个主要的维度A能代表原始数据，是“我们真正想看到的东西”，它本身含有的“能量”\(即该维度的方差\)，本来应该是很大的，但由于它与其他维度有千丝万缕的相关性，受到这些个相关维度的干扰，它的能量被削弱了，我们就希望通过PCA处理后，使维度A与其他维度的相关性尽可能减弱，进而恢复维度A应有的能量，让我们“看的更清楚”。

最直观的思路就是将协方差矩阵只保留对角线上的元素，将其他元素变成零，在矩阵变换中这种操作被称为矩阵的对角化，方法包括特征值分解和奇异值分解。

###\( 2\) PCA算法推导

$$
X = \left( \begin{array} { c c c c c } { - 1 } & { - 1 } & { 0 } & { 2 } & { 0 } \\ { - 2 } & { 0 } & { 0 } & { 1 } & { 1 } \end{array} \right)
$$

以X为例，我们用PCA方法将这两行数据降到一行。

* 去平均值\(即去中心化\)，即每一位特征减去各自的平均值
* 算协方差矩阵
 $$\frac{1}{n} XX^T $$
* 用特征值分解方法求协方差矩阵$$\frac{1}{n}XX^T$$ 的特征值与特征向量
* 对特征值从大到小排序，选择其中最大的k个。然后将其对应的k个特征向量分别作为行向量组成特征向量矩阵P
* 将数据转换到k个特征向量构建的新空间中，即Y=PX

$$
C = \frac { 1 } { 5 } \left( \begin{array} { c c c c c } { - 1 } & { - 1 } & { 0 } & { 2 } & { 0 } \\ { - 2 } & { 0 } & { 0 } & { 1 } & { 1 } \end{array} \right) \left( \begin{array} { c c } { - 1 } & { - 2 } \\ { - 1 } & { 0 } \\ { 0 } & { 0 } \\ { 2 } & { 1 } \\ { 0 } & { 1 } \end{array} \right) = \left( \begin{array} { c c } { \frac { 6 } { 5 } } & { \frac { 4 } { 5 } } \\ { \frac { 4 } { 5 } } & { \frac { 6 } { 5 } } \end{array} \right)
$$

求解后的特征值为：

$$
\lambda _ { 1 } = 2 , \quad \lambda _ { 2 } = \frac { 2 } { 5 }
$$

对应的特征向量为：

$$
c _ { 1 } \left( \begin{array} { l } { 1 } \\ { 1 } \end{array} \right) , c _ { 2 } \left( \begin{array} { c } { - 1 } \\ { 1 } \end{array} \right)
$$

其中对应的特征向量分别是一个通解， c_{1} 和 c_{2} 可以取任意实数。那么标准化后的特征向量为:

$$
\left( \begin{array} { c } { \frac { 1 } { \sqrt { 2 } } } \\ { \frac { 1 } { \sqrt { 2 } } } \end{array} \right) , \left( \begin{array} { c } { - \frac { 1 } { \sqrt { 2 } } } \\ { \frac { 1 } { \sqrt { 2 } } } \end{array} \right)
$$

矩阵P为：

$$
P = \left( \begin{array} { c c } { \frac { 1 } { \sqrt { 2 } } } & { \frac { 1 } { \sqrt { 2 } } } \\ { - \frac { 1 } { \sqrt { 2 } } } & { \frac { 1 } { \sqrt { 2 } } } \end{array} \right)
$$

最后我们用P的第一行乘以数据矩阵X，就得到了降维后的表示:

$$
Y = \left( \begin{array} { c c } { \frac { 1 } { \sqrt { 2 } } } & { \frac { 1 } { \sqrt { 2 } } } \end{array} \right) \left( \begin{array} { c c c c c } { - 1 } & { - 1 } & { 0 } & { 2 } & { 0 } \\ { - 2 } & { 0 } & { 0 } & { 1 } & { 1 } \end{array} \right) = \left( \begin{array} { c c c c } { - \frac { 3 } { \sqrt { 2 } } } & { - \frac { 1 } { \sqrt { 2 } } } & { 0 } & { \frac { 3 } { \sqrt { 2 } } } & { - \frac { 1 } { \sqrt { 2 } } } \end{array} \right)
$$
### \(3\) PCA的Python实现
```python
from sklearn.decomposition import PCA
import numpy as np
X = np.array([[-1, 1], [-2, -1], [-3, -2], [1, 1], [2, 1], [3, 2]])
pca=PCA(n_components=1)
pca.fit(X)
print(pca.transform(X))
```
结果如下：
[[ 0.50917706]
 [ 2.40151069]
 [ 3.7751606 ]
 [-1.20075534]
 [-2.05572155]
 [-3.42937146]]


## 2\) t-SNE
### \(1\) principle
T 分布随机近邻嵌入（T-Distribution Stochastic Neighbour Embedding）是一种用于降维的机器学习方法，它能帮我们识别相关联的模式。t-SNE 主要的优势就是保持局部结构的能力。这意味着高维数据空间中距离相近的点投影到低维中仍然相近。
这里不过多介绍tSNE的详细推导，可参考以下文章：

[https://www.jiqizhixin.com/articles/2017-11-13-7](https://www.jiqizhixin.com/articles/2017-11-13-7)  
[http://www.datakit.cn/blog/2017/02/05/t\_sne\_full.html](http://www.datakit.cn/blog/2017/02/05/t_sne_full.html)  
[http://bindog.github.io/blog/2016/06/04/from-sne-to-tsne-to-largevis/](http://bindog.github.io/blog/2016/06/04/from-sne-to-tsne-to-largevis/)  
[t-SNE使用中的问题](http://bindog.github.io/blog/2018/07/31/t-sne-tips/)
### \(2\) t-SNE的Python实现
```python
from sklearn.manifold import TSNE
import numpy as np
X = np.array([[-1, 1], [-2, -1], [-3, -2], [1, 1], [2, 1], [3, 2]])
pca=TSNE(n_components=1)
X_new = pca.fit_transform(X)
print(X_new)
```
结果如下：
[[ -79.728195]
 [ -42.511387]
 [-144.62259 ]
 [-112.67397 ]
 [-177.55727 ]
 [-214.81148 ]]

## 3\) PCA and t-SNE analysis in Matrix Processing
本节讲解如何利用PCA和t-SNE对数据矩阵进行降维，并进行可视化。

### \(1\) Input data
| SampleID | Expression\_of\_miR_1 | Expression\_of\_miR_2 | Expression\_of\_miR_3 | Type |
| :--- | :--- | :--- | :--- | :--- |
| 1 | 12 | 55 | 74 | cancer |
| 2 | 87 | 44 | 46 | normal |
| 3 | 70 | 23 | 56 | normal |
| 4 | 74 | 35 | 69 | normal |
| 5 | 46 | 43 | 59 | cancer |
| 6 | 58 | 31 | 90 | cancer |
| 7 | 55 | 40 | 30 | normal |
| 8 | 33 | 50 | 76 | cancer |
| 9 | 60 | 20 | 34 | normal |
| 10 | 50 | 22 | 11 | normal |
| 11 | 70 | 50 | 60 | cancer |
| 12 | 22 | 60 | 90 | cancer |
| 13 | 68 | 10 | 9 | normal |
| 14 | 90 | 30 | 20 | normal |
| 15 | 10 | 40 | 39 | cancer |
| 16 | 78 | 50 | 23 | normal |
| 17 | 50 | 60 | 82 | cancer |
| 18 | 70 | 33 | 51 | normal |
| 19 | 81 | 31 | 12 | normal |
| 20 | 44 | 11 | 5 | normal |
| 21 | 20 | 56 | 44 | cancer |
| 22 | 51 | 31 | 17 | normal |
| 23 | 40 | 11 | 4 | normal |
| 24 | 30 | 60 | 57 | normal |
| 25 | 81 | 13 | 24 | normal |

Here, the first column stands for the ID number for each sample. The second to the fourth column stands for the expression value of a certain kind of miRNA \(1 to 3\). The last column represents whether this sample comes from a normal person or a cancer patient. In random forest machine learning, we train the neuron network with 80% of the above data and use the other 20% to test this model and draw ROC curve.
### \(2\) Visualization  by Python
**加载模块**
```python
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt
import seaborn as sns 
```
**定义可视化函数**
```python
def pac_plot(data,sampleclass,method_PCA = True,method_StandardScaler = True,size_dot=50):   
    if method_StandardScaler == True:
        X = np.log2(data + 0.001)
        X = StandardScaler().fit_transform(X)
        X = X.T
    else:
        X = np.array(data).T
    if method_PCA == True:
        transform = PCA(2)
    else:
        transform = TSNE(2)
    X_pca = transform.fit_transform(X.T)
    X_, y_ = X_pca, sampleclass
    pac_data = pd.DataFrame(X_)
    pac_data.columns = ['PCA_1', 'PCA_2']
    pac_data['label'] = np.array(y_)
    g = sns.scatterplot(x="PCA_1", y="PCA_2",hue="label", data=pac_data,s=size_dot)
    plt.legend(loc='best',fontsize='xx-small')
    # plt.savefig(outputpath+'/'+plot_name)
    # plt.close()
    plt.show()
    plt.close()
```
其中，data行为样本，列为特征；sampleclass为样本对应的标签；method_PCA为是否使用PCA，当为True时，使用PCA方法，False时使用t-SNE方法；method_StandardScaler是指是否对数据进行归一化处理；size_dot是画图时点的大小camshaft。

**加载数据并可视化**
```python
Expression_of_miR_1 =np.array([12, 87, 70, 74, 46, 58, 55, 33, 60, 50, 70, 22, 68, 90, 10, 78, 50, 70, 81, 44, 20, 51, 40, 30, 81])
Expression_of_miR_2= np.array([55, 44, 23, 35, 43, 31, 40, 50, 20, 22, 50, 60, 10, 30, 40, 50, 60, 33, 31, 11, 56, 31, 11, 60, 13])
Expression_of_miR_3 = np.array([74, 46, 56, 69, 59, 90, 30, 76, 34, 11, 60, 90, 9, 20, 39, 23, 82, 51, 12, 5, 44, 17, 4, 57, 24])
sampleclass = np.array(["cancer", "normal", "normal", "normal", "cancer", "cancer", "normal", "cancer", "normal", "normal", "cancer", "cancer", "normal", "normal", "cancer", "normal", "cancer", "normal", "normal", "normal", "cancer", "normal", "normal", "normal", "normal"])
data=np.vstack([Expression_of_miR_1,Expression_of_miR_2,Expression_of_miR_3]).T
pac_plot(data,sampleclass)
```
PCA的结果如下

![png](../../.gitbook/assets/7.2.PCA.png)

t-SNE的结果如下

![png](../../.gitbook/assets/7.2.tSNE.png)
## 4\) Homework
1.按照本章给出的教程，对对给定数据集BreastCancer进行可视化，画出PCA和tSNE降维后图，提交一个word/PDF文档。
>作业要求：
>1)数据为R中mlbench包中的数据集BreastCancer（可从利用提供[文件](https://github.com/lulab/teaching_book/tree/master/files/PART_II)）。数据集包括9个特征，两种类别，良性（benign）和恶性（malignant）。
如需了解更多关于BreastCancer数据集信息，可参考mlbench的文档。
数据可从此处下载。
>2)画图时需进行数据归一化，通过函数参数即可实现

2.**挑战题**：利用R语言将本章实现PCA、tSNE的可视化过程，利用本章3(1)给出的示例数据画图。
