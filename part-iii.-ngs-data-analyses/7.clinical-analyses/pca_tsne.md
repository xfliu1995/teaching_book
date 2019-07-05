# 7.2.PCA/tSNE

```python
cd ~/projects/exSEEK_training/
```

```python
import gc, argparse, sys, os, errno
from functools import reduce
%pylab inline
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from tqdm import tqdm_notebook as tqdm
import scipy
import sklearn
from scipy.stats import pearsonr
import warnings
warnings.filterwarnings('ignore')
from bokeh.io import output_notebook, show
output_notebook()
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE
from sklearn.metrics import roc_curve,roc_auc_score,auc,precision_recall_curve,average_precision_score
from sklearn.preprocessing import RobustScaler,MinMaxScaler,StandardScaler
from sklearn.neighbors import NearestNeighbors
from bokeh.palettes import Category20c
from ipywidgets import interact,interactive, FloatSlider,IntSlider, RadioButtons,Dropdown,Tab,Text
np.random.seed(1234)
import IPython
from IPython.display import IFrame
```

## prerequisite

### load plotting functions

embed pdf; std\_plot; display dataframe

```python
#setup figure template
figure_template_path = 'bin'
if figure_template_path not in sys.path:
    sys.path.append(figure_template_path)
from importlib import reload
import figure_template
#force reload of the module
reload(figure_template)
from figure_template import display_dataframe, embed_pdf_figure, embed_pdf_pages,std_plot,legendhandle
```

## PCA&t-SNE visualization

### PCA \(principle component analysis\)

* 通过线性组合得到贡献最大的、可解释的变量\(principle components\)
* 数据的降维和可视化

[PCA](https://zhuanlan.zhihu.com/p/37777074)  
 [SVD](https://mp.weixin.qq.com/s/Dv51K8JETakIKe5dPBAPVg)  
 [Hinton理解的PCA](https://www.jianshu.com/p/76c64cd0b5ad)  
 [PCA和SVD的区别与联系](https://blog.csdn.net/wangjian1204/article/details/50642732)

PCA的主要思想是将n维特征映射到k维上，这k维是新的彼此正交的特征，也被称为主成分。PCA的工作就是从原始的空间中顺序地找一组相互正交的坐标轴，新的坐标轴的选择与数据本身密切相关。其中，第一个新坐标轴选择是原始数据中方差最大的方向，第二个新坐标轴选取是与第一个坐标轴正交的平面中使得方差最大的，第三个轴是与第1,2个轴正交的平面中方差最大的。依次类推，可以得到n个这样的坐标轴。通过这种方式获得的新的坐标轴。

我们发现，大部分方差都包含在前面k个坐标轴中，后面的坐标轴所含的方差几乎为0。于是，我们可以忽略余下的坐标轴，只保留前面k个含有绝大部分方差的坐标轴，相当于只保留包含绝大部分方差的维度特征，而忽略包含方差几乎为0的特征维度，实现对数据特征的降维处理。

**如何得到这些包含最大差异性的主成分方向？**

通过计算数据矩阵的协方差矩阵，然后得到协方差矩阵的特征值特征向量，选择特征值最大\(即方差最大\)的k个特征所对应的特征向量组成的矩阵。这样就可以将数据矩阵转换到新的空间当中，实现数据特征的降维。  
由于得到协方差矩阵的特征值特征向量有两种方法：特征值分解协方差矩阵、奇异值分解协方差矩阵，所以PCA算法有两种实现方法：基于特征值分解协方差矩阵实现PCA算法、基于SVD分解协方差矩阵实现PCA算法。

**为什么要用协方差矩阵？为什么要对协方差矩阵做特征值分解？**

$$
\text{均值： }\overline { x } = \frac { 1 } { n } \sum _ { i = 1 } ^ { N } x _ { i }\\
\text{方差： }S ^ { 2 } = \frac { 1 } { n - 1 } \sum _ { i = 1 } ^ { n } \left( x _ { i } - \overline { x } \right) ^ { 2 }\\
\text{协方差： }\begin{aligned} \operatorname { Cov } ( X , Y ) & = E [ ( X - E ( X ) ) ( Y - E ( Y ) ) ] \\ & = \frac { 1 } { n - 1 } \sum _ { i = 1 } ^ { n } \left( x _ { i } - \overline { x } \right) \left( y _ { i } - \overline { y } \right) \end{aligned}
$$

```python
fig, ax=plt.subplots(1,2,figsize=(10,5))
corr_mat= np.array([[1.0, 0.6, 0.3],
                    [0.6, 1.0, 0.5],
                    [0.3, 0.5, 1.0],
                   [0.5, 0.1, 1.0]])
ax[0].imshow(corr_mat,cmap=cm.binary_r)
ax[1].imshow(np.cov(corr_mat),cmap=cm.binary_r)
```

```python
np.cov(corr_mat)
```

**协方差矩阵表征了变量自身的“能量”/“信息”和彼此的关联性** 假设样本中某个主要的维度A能代表原始数据，是“我们真正想看到的东西”，它本身含有的“能量”\(即该维度的方差\)，本来应该是很大的，但由于它与其他维度有千丝万缕的相关性，受到这些个相关维度的干扰，它的能量被削弱了，我们就希望通过PCA处理后，使维度A与其他维度的相关性尽可能减弱，进而恢复维度A应有的能量，让我们“看的更清楚”。

最直观的思路就是将协方差矩阵只保留对角线上的元素，将其他元素变成零，在矩阵变换中这种操作被称为矩阵的对角化，方法包括特征值分解和奇异值分解。

#### PCA算法推导

$$
X = \left( \begin{array} { c c c c c } { - 1 } & { - 1 } & { 0 } & { 2 } & { 0 } \\ { - 2 } & { 0 } & { 0 } & { 1 } & { 1 } \end{array} \right)
$$

以X为例，我们用PCA方法将这两行数据降到一行。

* 去平均值\(即去中心化\)，即每一位特征减去各自的平均值
* 算协方差矩阵 $\frac{1}{n} XX^T $
* 用特征值分解方法求协方差矩阵$\frac{1}{n}XX^T$ 的特征值与特征向量
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

```python
url = 'https://pic2.zhimg.com/80/v2-f5b0a7ae6d0b400e65220a02a0f0c1c1_hd.jpg'
IPython.display.Image(url, width = 500)
```

#### 奇异值分解和应用

SVD英文是 Singular Value Decomposition，一般简称为 SVD。下面先给出它大概的意思：

对于任意一个$m \times n $的矩阵$M$，不妨假设$m &gt; n$，它可以被分解为$M = UDV^{T}$

其中

* $U$ 是一个$m \times n$的矩阵，满足$U^{T}U = I_{n}$，$I_{n}$ 是$n \times n$的单位阵
* $V$ 是一个$n \times n$的矩阵，满足$V^{T}V = I\_{n}$
* $D$ 是一个$n \times n$的对角矩阵，所有的元素都非负

上面这短短的三条可以引发出 SVD 许多重要的性质。

前面的表达式$M = UDV^{T}$可以用一种更容易理解的方式表达出来。如果我们把矩阵$U$用它的列向量表示出来，可以写成

$U = \(u\_1, u\_2,\ldots, u\_n\)$

其中每一个$u\_i$被称为$M$的左奇异向量。类似地，对于$V$，有&lt;/p&gt;

$V = \(v\_1,v\_2,\ldots,v\_n\)$

它们被称为右奇异向量。再然后，假设矩阵$D$的对角线元素为$d\_i$（它们被称为$M$的奇异值）并按降序排列，那么$M$就可以表达为

$M = d_1u\_1v\_1^T + d\_2u\_2v\_2^T + \cdots + d\_nu\_nv\_n^T = \sum_{i=1}^n d_iu\_iv\_i^T = \sum_{i=1}^n A\_i$

其中$A\_i = d\_iu\_iv\_i^T$是一个$m \times n$的矩阵。换句话说，我们把原来的矩阵$M$表达成了$n$个矩阵的和。

这个式子有什么用呢？注意到，我们假定$d\_i$是按降序排列的，它在某种程度上反映了对应项$A\_i$在$M$中的“贡献”。$d\_i$越大，说明对应的 $A\_i$在$M$的分解中占据的比重也越大。所以一个很自然的想法是，我们是不是可以提取出$A\_i$中那些对$M$贡献最大的项，把它们的和作为对 $M$的近似？也就是说，如果令

$ M_k = \sum_{i=1}^k A\_i$

那么我们是否可以用$M\_k$来对$M\_n \equiv M$进行近似？

答案是肯定的，主成分分析就是这样做的。在主成分分析中，我们把数据整体的变异分解成若干个主成分之和，然后保留方差最大的若干个主成分，而舍弃那些方差较小的。事实上，主成分分析就是对数据的协方差矩阵进行了类似的分解（特征值分解），但这种分解只适用于对称的矩阵，而 SVD 则是对任意大小和形状的矩阵都成立。

主成分分析降维就是用几组低维的主成分来记录原始数据的大部分信息，这也可以认为是一种信息的（有损）压缩。在 SVD 中也可以做类似的事情，也就是用更少项的求和$M\_k$来近似完整的$n$项求和。为什么要这么做呢？我们用一个图像压缩的例子来说明。

我们知道，电脑上的图像（特指位图）都是由像素点组成的，所以存储一张 1000×622 大小的图片，实际上就是存储一个 1000×622 的矩阵，共 622000 个元素。这个矩阵用 SVD 可以分解为 622 个矩阵之和，如果我们选取其中的前 100 个之和作为对图像数据的近似，那么只需要存储 100 个奇异值$d\_i$，100 个$u\_i$向量和 100 个$v\_i$向量，共计 100×\(1+1000+622\)=162300个 元素，大约只有原始的 26% 大小

```python
lena = imread('data/lena512color.tiff') 
imshow(lena)
```

```python
def rebuild_img(u, sigma, v, p): #p表示奇异值的百分比
    #print (p)
    m = len(u)
    n = len(v)
    a = np.zeros((m, n))

    count = (int)(sum(sigma))
    curSum = 0
    k = 0
    while curSum <= count * p:
        uk = u[:, k].reshape(m, 1)
        vk = v[k].reshape(1, n)
        a += sigma[k] * np.dot(uk, vk)
        curSum += sigma[k]
        k += 1
    #print ('k:',k)
    a[a < 0] = 0
    a[a > 255] = 255
    #按照最近距离取整数，并设置参数类型为uint8
    return np.rint(a).astype("uint8")
```

```python
reconstructed_img = {}
a = lena
for i in tqdm(range(1,11)):
    p = i/10
    u, sigma, v = np.linalg.svd(a[:, :, 0])
    R = rebuild_img(u, sigma, v, p)

    u, sigma, v = np.linalg.svd(a[:, :, 1])
    G = rebuild_img(u, sigma, v, p)

    u, sigma, v = np.linalg.svd(a[:, :, 2])
    B = rebuild_img(u, sigma, v, p)

    reconstructed_img[i] = np.stack((R, G, B), 2)
```

```python
fig,ax=plt.subplots(2,5,figsize=(20,8))
for i in range(2):
    for j in range(5):
        ax[i,j].imshow(reconstructed_img[i*5+j+1])
```

#### PCA 应用实例

```python
rate_data = pd.read_csv('data/select_table_chn.csv',index_col=0)
rate_data.head()
```

```python
input_mx = np.array(rate_data)
```

**screen plot**

```python
svd_solver = ['auto','full','arpack','randomized']
pca = PCA(svd_solver=svd_solver[0])
input_mx_ = StandardScaler().fit_transform(input_mx) #scale for columns
pca.fit(input_mx_)
#loadings = np.dot(np.diag(pca.singular_values_), pca.components_)
#how to reverse back: (X - np.mean(X, axis=0).reshape((1, -1))).dot(pca.components_.T)[0]

fig,ax=plt.subplots(figsize=(6,4))
plot_data = pd.DataFrame(np.concatenate((np.arange(1,pca.explained_variance_ratio_.shape[0]+1).reshape(-1,1).astype('int'),
                                         pca.explained_variance_ratio_.reshape(-1,1)),axis=1),columns=['Dimension','Percentage of explained variance'])
sns.barplot(data=plot_data,x='Dimension',y='Percentage of explained variance',color='blue',alpha=0.8)
ax=std_plot(ax,'Dimension','Percentage of explained variance','Screen Plot',
            xticklabel=np.arange(1,pca.explained_variance_ratio_.shape[0]+1),
            legendscale=False,legend_adj=False)
fig.tight_layout()
#embed_pdf_figure()
```

```python
pca
```

**Loading matrix**

```python
def zeroMean(dataMat):      
    meanVal=np.mean(dataMat,axis=0)     #按列求均值，即求各个特征的均值
    newData=dataMat-meanVal
    return newData,meanVal

def pca_own(dataMat,n=None):
    if n==None:
        n = dataMat.shape[1]
    newData,meanVal=zeroMean(dataMat)
    covMat=np.cov(newData,rowvar=0)    #求协方差矩阵,return ndarray；若rowvar非0，一列代表一个样本，为0，一行代表一个样本

    eigVals,eigVects=np.linalg.eig(np.mat(covMat))#求特征值和特征向量,特征向量是按列放的，即一列代表一个特征向量
    eigValIndice=np.argsort(eigVals)            #对特征值从小到大排序
    n_eigValIndice=eigValIndice[-1:-(n+1):-1]   #最大的n个特征值的下标
    n_eigVect=eigVects[:,n_eigValIndice]        #最大的n个特征值对应的特征向量
    lowDDataMat=newData*n_eigVect               #低维特征空间的数据
    reconMat=(lowDDataMat*n_eigVect.T)+meanVal  #重构数据
    return lowDDataMat,reconMat,n_eigVect

lowDDataMat,pca_mx,loadings = pca_own(input_mx)
```

```python
lowDDataMat.shape,pca_mx.shape
```

```python
fig,ax=plt.subplots(figsize=(10,60))
sns.heatmap(lowDDataMat,ax=ax,vmin=-1, vmax=1, annot=True, fmt='.2f', cmap='vlag')
```

```python
reconstructed_img = {}
a = lena
for i in tqdm(range(1,11)):
    p = i*2/100
    print (p)
    dim_retain = int(a.shape[0] * p)
    reconstructed_img[i] = np.zeros([a.shape[0],a.shape[1],a.shape[2]])
    for j in range(a.shape[2]):
        _,reconstructed_img[i][:,:,j],_ = pca_own(a[:,:,j],dim_retain)
    reconstructed_img[i] = reconstructed_img[i].astype('int')
    reconstructed_img[i][reconstructed_img[i]<=0] = 0
    reconstructed_img[i][reconstructed_img[i]>=255] = 255
```

```python
fig,ax=plt.subplots(2,5,figsize=(20,8))
for i in range(2):
    for j in range(5):
        ax[i,j].imshow(reconstructed_img[i*5+j+1])
```

```python
revise_columns = np.array([i.split('-')[2]+'-month' for i in rate_data.columns])
fig,ax=plt.subplots(figsize=(10,10))
#loadings_test = pca.components_*np.sqrt(pca.singular_values_)
sns.heatmap(loadings.T,ax=ax,vmin=-1, vmax=1, annot=True, fmt='.2f', cmap='vlag')
ax.set_title('PCA loading matrix')
ax.set_ylabel('PCs')
ax.set_xlabel('Variables')
ax.set_xticklabels(revise_columns,fontsize=10,rotation=90)
ax.set_yticklabels(np.array(['PC'+ str(i) for i in range(1,loadings.shape[0]+1)]))
fig.tight_layout()
#embed_pdf_figure()
```

**PCA visualization**

```python
filled_markers = ('o', 'v', '^', '<', '>', '8', 's', 'p', '*', 'h', 'H', 'D', 'd', 'P', 'X')
fontlegend = {'family':'Arial',
                  'weight' : 'normal', 
                  'size' : 6.5*1}
def PCA_plot_sns(ax,data,sampleclass,method = 'Origin'):
    #X = log_transfrom(data).T
    X = StandardScaler().fit_transform(data.T)
    if method=='Origin':
        X_pca=X
    if method == 'PCA':
        transform = PCA()
        X_pca = transform.fit_transform(X)
    elif method == 'tSNE':
        transform = TSNE()
        X_pca = transform.fit_transform(X)

    plot_table = pd.DataFrame(X_pca[:,:2])
    plot_table.index = data.columns
    plot_table = pd.concat((plot_table,sampleclass.loc[plot_table.index]),axis=1)
    plot_table.columns = ['dimension_1','dimension_2','class']
    classnum = np.unique(plot_table.iloc[:,2]).shape[0]

    sns.scatterplot(ax=ax,data=plot_table,x="dimension_1", y="dimension_2",markers=filled_markers,
                    palette=legendhandle(np.unique(plot_table['class'])), hue="class",style="class",s=30,linewidth=0.01)

    std_plot(ax,'Dimension 1','Dimension 2',
             title=method, legendtitle='class',legendsort=False
             ,xbins=6,ybins=6
            )
    legend = ax.legend(prop=fontlegend,
     bbox_to_anchor=(1.2,0.9),framealpha=0,labelspacing=0.24)
    ax.legend_.get_frame()._linewidth=0
    fig.tight_layout()
```

```python
input_table = rate_data
year_class = pd.DataFrame(np.concatenate((np.array(input_table.index).reshape(-1,1),np.array(['y'+i.split('-')[0] for i in 
                                input_table.index]).reshape(-1,1)),axis=1),columns=['sample','label'])
year_class = year_class.set_index('sample').astype('str')
month_class = pd.DataFrame(np.concatenate((np.array(input_table.index).reshape(-1,1),np.array(['m'+i.split('-')[1] for i in 
                                input_table.index]).reshape(-1,1)),axis=1),columns=['sample','label'])
month_class = month_class.set_index('sample').astype('str')
```

```python
fig, ax = plt.subplots(1,2,figsize=(7,3))
PCA_plot_sns(ax[0], input_table.T,year_class,'Origin')
PCA_plot_sns(ax[1], input_table.T,year_class,'PCA')
#embed_pdf_figure()
```

### t-SNE

[https://www.jiqizhixin.com/articles/2017-11-13-7](https://www.jiqizhixin.com/articles/2017-11-13-7)  
 [http://www.datakit.cn/blog/2017/02/05/t\_sne\_full.html](http://www.datakit.cn/blog/2017/02/05/t_sne_full.html)  
 [http://bindog.github.io/blog/2016/06/04/from-sne-to-tsne-to-largevis/](http://bindog.github.io/blog/2016/06/04/from-sne-to-tsne-to-largevis/)  
 [t-SNE使用中的问题](http://bindog.github.io/blog/2018/07/31/t-sne-tips/)

```python
IFrame('http://bindog.github.io/blog/2018/07/31/t-sne-tips/', width=800, height=450)
```

```python
fig, ax = plt.subplots(1,3,figsize=(9,3))
PCA_plot_sns(ax[0],input_table.T,month_class,'Origin')
PCA_plot_sns(ax[1],input_table.T,month_class,'PCA')
PCA_plot_sns(ax[2],input_table.T,month_class,'tSNE')
fig.tight_layout()
#embed_pdf_figure()
```

## PCA analysis in Matrix Processing

### environment

```python
import pandas as pd
import numpy as np
from matplotlib import pyplot
from tqdm import tqdm, tqdm_notebook
import matplotlib.pyplot as plt
import seaborn as sns
import gc, argparse, sys, os, errno
from IPython.core.display import HTML,Image
from functools import reduce
import h5py
%pylab inline
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from tqdm import tqdm_notebook as tqdm
import scipy
import sklearn
from scipy.stats import pearsonr
import warnings
warnings.filterwarnings('ignore')
from bokeh.io import output_notebook, show
output_notebook()
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE
import umap
from sklearn.metrics import roc_curve,roc_auc_score,auc
from sklearn.preprocessing import RobustScaler,MinMaxScaler,StandardScaler
from sklearn.neighbors import NearestNeighbors
from bokeh.palettes import Category20c,Set3,Pastel2
from ipywidgets import interact,interactive, FloatSlider,IntSlider, RadioButtons,Dropdown,Tab,Text
from IPython.core.display import HTML,Image
from matplotlib.backends.backend_pdf import PdfPages, PdfFile
from IPython.display import HTML, display, FileLink
from base64 import b64encode, b64decode
from io import StringIO, BytesIO
from contextlib import contextmanager
```

```python
cd ~chenxupeng/projects/exSEEK_training/
```

```python
# setup figure template
figure_template_path = 'bin'
if figure_template_path not in sys.path:
    sys.path.append(figure_template_path)
from importlib import reload
import figure_template
# force reload of the module
reload(figure_template)
from figure_template import display_dataframe, embed_pdf_figure, embed_pdf_pages,std_plot
```

```python
fontsize = 6.5
fontscale = 1
fontweight =  'normal'
fonttitle = {'family':'Arial',
                  'weight' : fontweight, 
                  'size' : fontsize*fontscale}
fontlabel = {'family':'Arial',
                  'weight' : fontweight, 
                  'size' : fontsize*fontscale}
fontticklabel = {'family':'Arial',
                  'weight' : fontweight, 
                  'size' : fontsize*fontscale}
fontlegend = {'family':'Arial',
                  'weight' : fontweight, 
              #'linewidth':0.5,
                  'size' : fontsize*fontscale}
fontcbarlabel = {'family':'Arial',
                 'weight' : fontweight, 
                 #'Rotation' : 270,
                 #'labelpad' : 25,
                 'size' : fontsize*fontscale}
fontcbarticklabel = {'family':'Arial',#Helvetica
                 'weight' : fontweight, 
                 'size' : (fontsize-1)*fontscale}

def std_plot(ax,xlabel=None,ylabel=None,title=None,
             legendtitle=None,bbox_to_anchor=None,
             labelspacing=0.2,borderpad=0.2,handletextpad=0.2,legendsort=False,markerscale=None,
             xlim=None,ylim=None,
             xbins=None,ybins=None,
             cbar=None,cbarlabel=None,
             moveyaxis=False,sns=False,left=True,rotation=None,xticklabel=None,legendscale=True,h=None,l=None,**kwards):
        # height = 2 font = 6.5
    def autoscale(fig):
        if isinstance(fig,matplotlib.figure.Figure):
            width,height = fig.get_size_inches()
        elif isinstance(fig,matplotlib.axes.Axes):
            width,height = fig.figure.get_size_inches()
        fontscale = height/2
        if width/fontscale > 8:
            warnings.warn("Please reset fig's width. When scaling the height to 2 in, the scaled width '%.2f' is large than 8"%(width/fontscale),UserWarning)
        return fontscale

    class fontprop:
        def init(self,fonttitle=None,fontlabel=None,fontticklabel=None,fontlegend=None,fontcbarlabel=None,fontcbarticklabel=None):
            self.fonttitle = fonttitle
            self.fontlabel = fontlabel
            self.fontticklabel = fontticklabel
            self.fontlegend = fontlegend
            self.fontcbarlabel = fontcbarlabel
            self.fontcbarticklabel = fontcbarticklabel
        def update(self,fontscale):
            self.fonttitle['size'] = self.fonttitle['size']*fontscale
            self.fontlabel['size'] = self.fontlabel['size']*fontscale
            self.fontticklabel['size'] = self.fontticklabel['size']*fontscale
            self.fontlegend['size'] = self.fontlegend['size']*fontscale
            self.fontcbarlabel['size'] = self.fontcbarlabel['size']*fontscale
            self.fontcbarticklabel['size'] = self.fontcbarticklabel['size']*fontscale
        def reset(self,fontscale):
            self.fonttitle['size'] = self.fonttitle['size']/fontscale
            self.fontlabel['size'] = self.fontlabel['size']/fontscale
            self.fontticklabel['size'] = self.fontticklabel['size']/fontscale
            self.fontlegend['size'] = self.fontlegend['size']/fontscale
            self.fontcbarlabel['size'] = self.fontcbarlabel['size']/fontscale
            self.fontcbarticklabel['size'] = self.fontcbarticklabel['size']/fontscale
    fontscale = autoscale(ax)
    font = fontprop()
    font.init(fonttitle,fontlabel,fontticklabel,fontlegend,fontcbarlabel,fontcbarticklabel)
    font.update(fontscale)

    pyplot.draw()
    #plt.figure(linewidth=30.5)
    if xlim is not None:  
        ax.set(xlim=xlim)
    if ylim is not None:
        ax.set(ylim=ylim)
    #pyplot.draw()
    if xbins is not None:
        locator = MaxNLocator(nbins=xbins)
        locator.set_axis(ax.xaxis)
        ax.set_xticks(locator())
    if ybins is not None:
        locator = MaxNLocator(nbins=ybins)
        locator.set_axis(ax.yaxis)
        ax.set_yticks(locator())
    pyplot.draw()
    ax.set_xticks(ax.get_xticks())
    ax.set_yticks(ax.get_yticks())
    ax.set_xlabel(xlabel,fontdict = font.fontlabel,labelpad=(fontsize-1)*fontscale)
    ax.set_ylabel(ylabel,fontdict = font.fontlabel,labelpad=(fontsize-1)*fontscale)
    if (rotation is not None) & (xticklabel is not None) :
        ax.set_xticklabels(xticklabel,fontticklabel,rotation=rotation)
    elif (xticklabel is not None) &(rotation is None):
        ax.set_xticklabels(xticklabel,fontticklabel)
    elif (xticklabel is None) &(rotation is None):
        ax.set_xticklabels(ax.get_xticklabels(),fontticklabel)
    elif (rotation is not None) & (xticklabel is None):
        ax.set_xticklabels(ax.get_xticklabels(),fontticklabel,rotation=rotation)
    ax.set_yticklabels(ax.get_yticklabels(),font.fontticklabel)

    if moveyaxis is True:
        #fontticklabel 
        ax.spines['left'].set_position(('data',0))
    ax.spines['left'].set_visible(left)
    ax.spines['right'].set_visible(not left)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_linewidth(0.5*fontscale)
    ax.spines['bottom'].set_linewidth(0.5*fontscale)
    ax.spines['left'].set_linewidth(0.5*fontscale)
    ax.spines['bottom'].set_color('k')
    ax.spines['left'].set_color('k')
    ax.spines['right'].set_color('k')

    ax.tick_params(direction='out', pad=2*fontscale,width=0.5*fontscale)
    #ax.spines['bottom']._edgecolor="#000000"
    #ax.spines['left']._edgecolor="#000000"
    if title is not None:
        ax.set_title(title,fontdict = font.fonttitle)
    if legendscale is True:
        if (h is None)&(l is None):
            legend = ax.legend(prop=font.fontlegend,
                  bbox_to_anchor=bbox_to_anchor,
                  labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                  edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
        else:
            legend = ax.legend(h,l,prop=font.fontlegend,
                  bbox_to_anchor=bbox_to_anchor,
                  labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                  edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
    if legendtitle is not None:
        #if legendloc is None:
        #    legendloc="best"
        legend = ax.legend(title=legendtitle,prop=font.fontlegend,
                      bbox_to_anchor=bbox_to_anchor,
                      labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                      edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
        ax.legend_.get_frame()._linewidth=0.5*fontscale
        legend.get_title().set_fontweight('normal')
        legend.get_title().set_fontsize(fontscale*fontsize)
        if legendsort is True:
            # h: handle l:label
            h,l = ax.get_legend_handles_labels()
            l,h = zip(*sorted(zip(l,h), key=lambda t: int(t[0]))) 
            legend = ax.legend(h,l,title=legendtitle,prop=font.fontlegend,
                      bbox_to_anchor=bbox_to_anchor,
                      labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                      edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
            ax.legend_.get_frame()._linewidth=0.5*fontscale
            legend.get_title().set_fontweight('normal')
            legend.get_title().set_fontsize(fontscale*fontsize)
        if sns is True:
            h,l = ax.get_legend_handles_labels()
            #l,h = zip(*sorted(zip(l,h), key=lambda t: int(t[0]))) 
            legend = ax.legend(h[1:],l[1:],title=legendtitle,prop=font.fontlegend,
                      bbox_to_anchor=bbox_to_anchor,
                      labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                      edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
            ax.legend_.get_frame()._linewidth=0.5*fontscale
            legend.get_title().set_fontweight('normal')
            legend.get_title().set_fontsize(fontscale*fontsize)
    else:
        legend = ax.legend(handles=h,labels=l,title=legendtitle,prop=font.fontlegend,
                      bbox_to_anchor=bbox_to_anchor,
                      labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                      edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
        ax.legend_.get_frame()._linewidth=0.5*fontscale
        legend.get_title().set_fontweight('normal')
        legend.get_title().set_fontsize(fontscale*fontsize)

    if cbar is not None:
        #locator, formatter = cbar._get_ticker_locator_formatter()
        #ticks, ticklabels, offset_string = cbar._ticker(locator, formatter)
        #cbar.ax.spines['top'].set_visible(False)
        #cbar.ax.spines['right'].set_visible(False)
        #cbar.ax.spines['bottom'].set_visible(False)
        #cbar.ax.spines['left'].set_visible(False)
        cbar.ax.tick_params(direction='out', pad=3*fontscale,width=0*fontscale,length=0*fontscale)
        cbar.set_label(cbarlabel,fontdict = font.fontcbarlabel,Rotation=270,labelpad=fontscale*(fontsize+1))
        cbar.ax.set_yticks(cbar.ax.get_yticks())
        cbar.ax.set_yticklabels(cbar.ax.get_yticklabels(),font.fontcbarticklabel)
    font.reset(fontscale)
    return ax
```

```python
savepath = '/home/chenxupeng/projects/exSEEK_training/'+'output/'+'fig3'+'/'

if not os.path.exists(savepath):
    os.mkdir(savepath)
```

### color

```python
sns.palplot(Pastel2[8])
```

```python
tableau10m = np.array([(114,158,206),(255,158,74),(103,191,92),(237,102,93),(173,139,201),
                       (168,120,110),(237,151,202),(162,162,162),(205,204,93),(109,204,218)])/255
sns.palplot(tableau10m)
```

```python
sns.palplot(Set3[12])
```

```python
tableau10l5 = np.array([(196,156,148),(247,182,210),(199,199,199),(219,219,141),(158,218,229)])/255
sns.palplot(tableau10l5)
```

```python
tableau20 = np.array([(31, 119, 180), (174, 199, 232), (255, 127, 14), (255, 187, 120),  
             (44, 160, 44), (152, 223, 138), (214, 39, 40), (255, 152, 150),  
             (148, 103, 189), (197, 176, 213), (140, 86, 75), (196, 156, 148),  
             (227, 119, 194), (247, 182, 210), (127, 127, 127), (199, 199, 199),  
             (188, 189, 34), (219, 219, 141), (23, 190, 207), (158, 218, 229)])/255.
sns.palplot(tableau20)
```

```python
def legendhandle(lists,porm=True,order=0):
    '''
        input: array,porm palette or marker
        palettesorder=0 dataset Category20c
        palettesorder=1 batch

        return a dic mapping levels of the hue variable to colors
        or return a dic mapping levels of the style variable to markers
        when use sns function, set palette=dic or markers=dic

    '''
    if porm == True:
        if order == 0:
            palette = np.array(Category20c[20]).reshape(4,-1).T.ravel()
        if order == 1:
            palette = Set3[12]
        lists.sort()
        dic={}
        for i in range(len(lists)):
            dic[lists[i]]=palette[i]
        return dic
    else:
        markerlist1 = ['v','^','<','>'] #triangle_down triangle_up triangle_left triangle_left
        markerlist2 = ['P','o','X','s'] #plus (filled) circle x (filled) square
        #markerlist3 = ['$CPM$','$CPM_top$','$RLE$','$TMM$']
        markerlist3 = ['$f$','$g$','$h$','$l$']
        markerlist3.sort()
        if order == 0:
            markers = markerlist2
        if order == 1:
            markers = markerlist1
        if order == 2:
            markers = markerlist3

        lists.sort()
        dic={}
        for i in range(len(lists)):
            dic[lists[i]]=markers[i]
        return dic
```

```python
tips = sns.load_dataset("tips")
legendhandle(np.unique(tips['smoker']),True,1)
```

```python
ax = sns.boxplot(x="day", y="total_bill", hue="smoker",data=tips, palette=legendhandle(np.unique(tips['smoker']),True,1))
```

```python
legendhandle(np.unique(tips['smoker']),True,0)
```

```python
tips = sns.load_dataset("tips")
ax = sns.boxplot(x="day", y="total_bill", hue="smoker",data=tips, palette=legendhandle(np.unique(tips['smoker']),True,0))
```

```python
A = ['Norm_RLE', 'Norm_RLE', 'Norm_RLE', 'Norm_RLE', 'Norm_CPM',
       'Norm_CPM', 'Norm_CPM', 'Norm_CPM', 'Norm_CPM_top', 'Norm_CPM_top',
       'Norm_CPM_top', 'Norm_CPM_top', 'Norm_TMM', 'Norm_TMM', 'Norm_TMM',
       'Norm_TMM']
```

```python
A
```

```python
legendhandle(np.unique(A),False,2)
```

### uca\_knn

```python
def convert_label_to_int(sample_class):
    classes, counts = np.unique(sample_class, return_counts=True)
    classes = np.argmax(sample_class.reshape((-1, 1)) == classes.reshape((1, -1)), axis=1)
    return classes

def unsupervised_clustering_accuracy(y, y_pred):
    from sklearn.utils.linear_assignment_ import linear_assignment
    assert len(y_pred) == len(y)
    u = np.unique(np.concatenate((y, y_pred)))
    n_clusters = len(u)
    mapping = dict(zip(u, range(n_clusters)))
    reward_matrix = np.zeros((n_clusters, n_clusters), dtype=np.int64)
    for y_pred_, y_ in zip(y_pred, y):
        if y_ in mapping:
            reward_matrix[mapping[y_pred_], mapping[y_]] += 1
    cost_matrix = reward_matrix.max() - reward_matrix
    ind = linear_assignment(cost_matrix)
    return sum([reward_matrix[i, j] for i, j in ind]) * 1.0 / y_pred.size, ind

def uca_scores(X,y, prediction_algorithm='knn'):
    from sklearn.metrics import adjusted_rand_score as ARI
    from sklearn.metrics import normalized_mutual_info_score as NMI
    from sklearn.metrics import silhouette_score
    from sklearn.mixture import GaussianMixture as GMM
    from sklearn.cluster import KMeans

    cluster_num = np.unique(y).shape[0]
    if prediction_algorithm == 'knn':
        labels_pred = KMeans(cluster_num, n_init=200).fit_predict(X)  
    elif prediction_algorithm == 'gmm':
        gmm = GMM(cluster_num)
        gmm.fit(X)
        labels_pred = gmm.predict(X)
    labels = y
    #asw_score = silhouette_score(X, labels)
    #nmi_score = NMI(labels, labels_pred)
    #ari_score = ARI(labels, labels_pred)
    labels_int = convert_label_to_int(labels)
    uca_score = unsupervised_clustering_accuracy(labels_int, labels_pred)[0]
    return uca_score

def get_uca_score(data,sampleclass,method_PCA = True,prediction_algorithm='knn'):
    X = np.log2(data + 0.001).T
    X = StandardScaler().fit_transform(X)
    if method_PCA == True:
        transform = PCA()
    else:
        transform = TSNE()
    X_pca = transform.fit_transform(X)
    X_, y_ = X_pca, sampleclass.loc[data.columns.values].values.ravel() 
    #knn_score_ = knn_score(X_, y_)
    uca_score = uca_scores(X_, y_, prediction_algorithm)
    return uca_score
```

```python
def knn_score(X, y, K=10):
    N = X.shape[0]
    assert K < N
    nn = NearestNeighbors(K)
    nn.fit(X)
    distances, indices = nn.kneighbors(X, K + 1)
    neighbor_classes = np.take(y, indices[:, 1:])
    same_class_fractions = np.sum(neighbor_classes == y[:, np.newaxis], axis=1)
    classes, counts = np.unique(y, return_counts=True)
    classes = np.argmax(y.reshape((-1, 1)) == classes.reshape((1, -1)), axis=1)
    counts = np.take(counts, classes)
    mean_r = K/(N - 1)*counts
    max_r = np.minimum(K, counts)
    #print (same_class_fractions.shape,mean_r.shape,max_r.shape)
    #scores = (np.mean(same_class_fractions) - mean_r)/(max_r - mean_r)
    scores = (same_class_fractions - mean_r)/(max_r - mean_r)
    #print(scores)
    return scores.mean()

def get_knn_score(data,sampleclass,method_PCA = True,prediction_algorithm='knn'):
    X = np.log2(data + 0.001).T
    X = StandardScaler().fit_transform(X)
    if method_PCA == True:
        transform = PCA()
    else:
        transform = TSNE()
    X_pca = transform.fit_transform(X)
    X_, y_ = X_pca, sampleclass.loc[data.columns.values].values.ravel() 
    knn_score_ = knn_score(X_, y_)
    return knn_score_
```

```python
methodlist = []
for i in normlist:
    for j in batchlist:
        methodlist.append(i+'.'+j)
methodlist
```

```python
batch_info = pd.read_table('/home/xieyufeng/fig3/data/cfRNA/batch_info.txt',index_col=0)
batch_info = pd.read_table('/home/zhaotianxiao/fig3/batch_info.txt', index_col=0)
batch_info[batch_info.dataset=='lulab_hcc']='GSE123972'
sampleclass = batch_info.iloc[:,0]
knn_list=[]
for i in tqdm(methodlist):
    table = pd.read_table('/home/xieyufeng/fig3/output/'+'cfRNA'+'/matrix_processing/'+i+'.mirna_and_domains.txt',
                           index_col=0)
    knn_list.append(get_knn_score(table,sampleclass))
knn_summary = pd.DataFrame(data={'preprocess_method':methodlist,'knn_score':list(knn_list)})
knn_summary = knn_summary.set_index('preprocess_method')
```

```python
class_info = pd.read_table('/home/xieyufeng/fig3/data/cfRNA/sample_classes.txt',index_col=0)
sampleclass = class_info
uca_list=[]
for i in tqdm(methodlist):
    table = pd.read_table('/home/xieyufeng/fig3/output/'+'cfRNA'+'/matrix_processing/'+i+'.mirna_and_domains.txt',
                           index_col=0)
    uca_list.append(get_uca_score(table,sampleclass))
uca_summary = pd.DataFrame(data={'preprocess_method':methodlist,'uca_score':list(uca_list)})
uca_summary = uca_summary.set_index('preprocess_method')
```

```python
get_uca_score(table,sampleclass)
```

```python
from scipy.stats import pearsonr
pearsonr(uca_summary,knn_summary)
```

```python
merge = pd.concat([knn_summary,uca_summary],axis=1)
merge['impute'] = [method.split('.')[1] for method in merge.index]
merge['normalization'] = [method.split('.')[2] for method in merge.index]
merge['batch'] = [method.split('.')[3] for method in merge.index]
sizelist=[10,50,200]
impute_list = np.unique(merge['impute'])
merge['imputation_size'] = merge['impute']
for i in np.arange(len(impute_list)):
    where = np.where(merge['imputation_size']==impute_list[i])
    for j in where:
        merge['imputation_size'].iloc[j]=sizelist[i]
merge.knn_score =1-merge.knn_score
```

```python
merge = merge.drop(merge.iloc[np.where(np.array([i.split('.')[-1] for i in merge.index]) == 'Batch_RUVn_1')[0]].index)
```

```python
fig,ax=plt.subplots(figsize=(6,4))
ax = sns.scatterplot(x='uca_score',y='knn_score',data = merge,hue='batch',style='normalization',
                     markers=legendhandle(np.unique(merge.normalization),False,1),
                     palette=legendhandle(np.unique(merge.batch),True,1),s=100)
#"PCC score:{:.2f}".format(pearsonr(uca_summary,knn_summary)[0][0]))

h,l=ax.get_legend_handles_labels()
l = np.array(l)
l[l=='batch']='batch removal method'
l[l=='Batch_ComBat_1']='ComBat'
l[l=='Batch_null']='null'
l[l=='Batch_RUV']='RUV'
l[l=='Batch_limma_1']='limma'
l[l=='normalization']='normalization method'
l[l=='Norm_RLE']='RLE'
l[l=='Norm_CPM']='CPM'
l[l=='Norm_CPM_top']='CPM-top'
l[l=='Norm_TMM']='TMM'
l = l.tolist()

#ax.legend_.remove()
std_plot(ax,'UCA score','mkNN score',h=h,l=l,markerscale=1.5,bbox_to_anchor=(1.05, 0.9))
ax.legend_.get_frame()._linewidth=0
fig.tight_layout()
#fig.savefig(savepath+'uca_knn_binbin_leg.eps')
#embed_pdf_figure()
```

#### understand UCA

```python
def convert_label_to_int(sample_class):
    classes, counts = np.unique(sample_class, return_counts=True)
    classes = np.argmax(sample_class.reshape((-1, 1)) == classes.reshape((1, -1)), axis=1)
    return classes

def unsupervised_clustering_accuracy(y, y_pred):
    from sklearn.utils.linear_assignment_ import linear_assignment
    assert len(y_pred) == len(y)
    u = np.unique(np.concatenate((y, y_pred)))
    n_clusters = len(u)
    mapping = dict(zip(u, range(n_clusters)))
    reward_matrix = np.zeros((n_clusters, n_clusters), dtype=np.int64)
    for y_pred_, y_ in zip(y_pred, y):
        if y_ in mapping:
            reward_matrix[mapping[y_pred_], mapping[y_]] += 1
    cost_matrix = reward_matrix.max() - reward_matrix
    ind = linear_assignment(cost_matrix)
    return sum([reward_matrix[i, j] for i, j in ind]) * 1.0 / y_pred.size, ind

def uca_scores(X,y, prediction_algorithm='knn'):
    from sklearn.metrics import adjusted_rand_score as ARI
    from sklearn.metrics import normalized_mutual_info_score as NMI
    from sklearn.metrics import silhouette_score
    from sklearn.mixture import GaussianMixture as GMM
    from sklearn.cluster import KMeans

    cluster_num = np.unique(y).shape[0]
    if prediction_algorithm == 'knn':
        labels_pred = KMeans(cluster_num, n_init=200).fit_predict(X) 
        print(labels_pred)
        print(np.unique(labels_pred,return_counts=True))
    elif prediction_algorithm == 'gmm':
        gmm = GMM(cluster_num)
        gmm.fit(X)
        labels_pred = gmm.predict(X)
    labels = y
    #asw_score = silhouette_score(X, labels)
    #nmi_score = NMI(labels, labels_pred)
    #ari_score = ARI(labels, labels_pred)
    labels_int = convert_label_to_int(labels)
    uca_score = unsupervised_clustering_accuracy(labels_int, labels_pred)[0]
    return uca_score,unsupervised_clustering_accuracy(labels_int, labels_pred)[1]

def get_uca_score(data,sampleclass,method_PCA = True,prediction_algorithm='knn'):
    X = np.log2(data + 0.001).T
    X = StandardScaler().fit_transform(X)
    if method_PCA == True:
        transform = PCA()
    else:
        transform = TSNE()
    X_pca = transform.fit_transform(X)
    X_, y_ = X_pca, sampleclass.loc[data.columns.values].values.ravel() 
    #knn_score_ = knn_score(X_, y_)
    uca_score,ind = uca_scores(X_, y_, prediction_algorithm)
```

```python
get_uca_score(table,sampleclass)
```

```python
labels = sampleclass.loc[table.columns.values].values.ravel() 
print(convert_label_to_int(labels))
print(np.unique(convert_label_to_int(labels),return_counts=True))
```

```python
def uca_scores(X,y, prediction_algorithm='knn'):
    from sklearn.metrics import adjusted_rand_score as ARI
    from sklearn.metrics import normalized_mutual_info_score as NMI
    from sklearn.metrics import silhouette_score
    from sklearn.mixture import GaussianMixture as GMM
    from sklearn.cluster import KMeans

    cluster_num = np.unique(y).shape[0]
    if prediction_algorithm == 'knn':
        labels_pred = KMeans(cluster_num, n_init=200).fit_predict(X) 
    elif prediction_algorithm == 'gmm':
        gmm = GMM(cluster_num)
        gmm.fit(X)
        labels_pred = gmm.predict(X)
    labels = y
    #asw_score = silhouette_score(X, labels)
    #nmi_score = NMI(labels, labels_pred)
    #ari_score = ARI(labels, labels_pred)
    labels_int = convert_label_to_int(labels)
    uca_score = unsupervised_clustering_accuracy(labels_int, labels_pred)[0]
    return uca_score,unsupervised_clustering_accuracy(labels_int, labels_pred)[1]
def get_uca_score(data,sampleclass,method_PCA = True,prediction_algorithm='knn'):
    X = np.log2(data + 0.001).T
    X = StandardScaler().fit_transform(X)
    if method_PCA == True:
        transform = PCA()
    else:
        transform = TSNE()
    X_pca = transform.fit_transform(X)
    X_, y_ = X_pca, sampleclass.loc[data.columns.values].values.ravel() 
    #knn_score_ = knn_score(X_, y_)
    uca_score,ind = uca_scores(X_, y_, prediction_algorithm)
    return ind
get_uca_score(table,sampleclass)
```

#### understand mkNN

**first alignment score**

$$
\text{Alignment\ Score} = \frac{1}{k-\frac{k}{N}}(k-\overline{x})
$$

其中$k$是最近邻算法（k nearest-neighbors, kNN）的前$k$个最近邻，$\overline{x}$是样本周围的样本同属一个批次的数量的平均，$N$表示样本数。 当两个批次样本完全分开时，$k=\overline{x}$，$\text{Alignment Score}=0$；当两个批次样本完全混杂时，比例因子$\frac{1}{k-\frac{k}{N}}$作用下，$\text{Alignment Score}$接近1。 exSEEK提出了适用于多种批次的mkNN指标，该指标由由史斌斌首次提出。

**mkNN**

$$
\text{Alignment\ Score} = 1-\frac{\overline{x}-\frac{k}{N}}{k-\frac{k}{N}}
$$

$$
\text{mkNN}=1-\frac{1}{B} \sum_{b=1}^{B} \frac{\overline{x}_{b}-k N_{b} /(N-1)}{\min \left(k, N_{b}\right)-k N_{b} /(N-1)}
$$

其中，$b$表示批次，$B$为批次数量，$N\_b$是批次$b$下样本的数量。批次效应越明显，该指标越接近0。

```python
IFrame('https://drive.google.com/file/d/1yWvw3fwWeSSrBgmhz_uaC4oQ0wltkIge/preview',
      width=800,height=600)
```

### PCA

```python
def PCA_plot_with_uca_score_sns(ax,data,sampleclass,batchinfo, method = 'PCA'):
    X = log_transform(data).T
    X = StandardScaler().fit_transform(X)
    if method == 'PCA':
        transform = PCA()
    elif method == 'tSNE':
        transform = TSNE()
    elif method == 'UMAP':
        transform = umap.UMAP(n_neighbors=5,min_dist=0.3,metric='correlation')

    X_pca = transform.fit_transform(X)
    plot_table = pd.DataFrame(X_pca[:,:2])
    plot_table.index = data.columns
    plot_table = pd.concat((plot_table,sampleclass.loc[plot_table.index],batchinfo.loc[plot_table.index]),axis=1)
    plot_table.columns = ['Dimension 1','Dimension 2','class','batch']
    plot_table = plot_table.sort_values(by='batch')
    classnum = np.unique(plot_table.iloc[:,2]).shape[0]
    sns.scatterplot(ax=ax,data=plot_table,x="Dimension 1", y="Dimension 2",
                    palette=legendhandle(np.unique(plot_table.batch)) , hue="batch",style='class',s=50,linewidth=0.01)

    #plt.figure(linewidth=30.5)

        #legend.get_title().set_fontweight('normal')
        #legend.get_title().set_fontsize(6.5)
    #ax.legend(bbox_to_anchor = (1, 1))
    #ax.spines['right'].set_visible(False)
    #ax.spines['top'].set_visible(False)
    #uca_score = get_clustering_score(data, sampleclass)
    #ax.set_title(method_type + ': ' +'UCA = {:.3f}'.format(uca_score) +', ' + 'kBET = {:.3f}'.format(kbet_score))
    #ax.annotate('UCA score: {:.6f}'.format(uca_score),xy=(1,0),xycoords='data',size=6.5)
    #print('Alignment score: {}'.format(knn_score(X_pca, sampleclass.loc[data.columns.values].values.ravel() )))


def log_transform(data, small = 0.01):
    return np.log2(data + small)
```

```python
fontsize = 6.5
fontscale = 1
fontweight =  'normal'
fonttitle = {'family':'Arial',
                  'weight' : fontweight, 
                  'size' : fontsize*fontscale}
fontlabel = {'family':'Arial',
                  'weight' : fontweight, 
                  'size' : fontsize*fontscale}
fontticklabel = {'family':'Arial',
                  'weight' : fontweight, 
                  'size' : fontsize*fontscale}
fontlegend = {'family':'Arial',
                  'weight' : fontweight, 
              #'linewidth':0.5,
                  'size' : fontsize*fontscale}
fontcbarlabel = {'family':'Arial',
                 'weight' : fontweight, 
                 #'Rotation' : 270,
                 #'labelpad' : 25,
                 'size' : fontsize*fontscale}
fontcbarticklabel = {'family':'Arial',#Helvetica
                 'weight' : fontweight, 
                 'size' : (fontsize-1)*fontscale}

def std_plot(ax,xlabel=None,ylabel=None,title=None,
             legendtitle=None,bbox_to_anchor=None,
             labelspacing=0.2,borderpad=0.2,handletextpad=0.2,legendsort=False,markerscale=None,
             xlim=None,ylim=None,
             xbins=None,ybins=None,
             cbar=None,cbarlabel=None,
             moveyaxis=False,sns=False,left=True,rotation=None,xticklabel=None,legendscale=True,h=None,l=None,**kwards):
        # height = 2 font = 6.5
    def autoscale(fig):
        if isinstance(fig,matplotlib.figure.Figure):
            width,height = fig.get_size_inches()
        elif isinstance(fig,matplotlib.axes.Axes):
            width,height = fig.figure.get_size_inches()
        fontscale = height/3
        if width/fontscale > 8:
            warnings.warn("Please reset fig's width. When scaling the height to 2 in, the scaled width '%.2f' is large than 8"%(width/fontscale),UserWarning)
        return fontscale

    class fontprop:
        def init(self,fonttitle=None,fontlabel=None,fontticklabel=None,fontlegend=None,fontcbarlabel=None,fontcbarticklabel=None):
            self.fonttitle = fonttitle
            self.fontlabel = fontlabel
            self.fontticklabel = fontticklabel
            self.fontlegend = fontlegend
            self.fontcbarlabel = fontcbarlabel
            self.fontcbarticklabel = fontcbarticklabel
        def update(self,fontscale):
            self.fonttitle['size'] = self.fonttitle['size']*fontscale
            self.fontlabel['size'] = self.fontlabel['size']*fontscale
            self.fontticklabel['size'] = self.fontticklabel['size']*fontscale
            self.fontlegend['size'] = self.fontlegend['size']*fontscale
            self.fontcbarlabel['size'] = self.fontcbarlabel['size']*fontscale
            self.fontcbarticklabel['size'] = self.fontcbarticklabel['size']*fontscale
        def reset(self,fontscale):
            self.fonttitle['size'] = self.fonttitle['size']/fontscale
            self.fontlabel['size'] = self.fontlabel['size']/fontscale
            self.fontticklabel['size'] = self.fontticklabel['size']/fontscale
            self.fontlegend['size'] = self.fontlegend['size']/fontscale
            self.fontcbarlabel['size'] = self.fontcbarlabel['size']/fontscale
            self.fontcbarticklabel['size'] = self.fontcbarticklabel['size']/fontscale
    fontscale = autoscale(ax)
    font = fontprop()
    font.init(fonttitle,fontlabel,fontticklabel,fontlegend,fontcbarlabel,fontcbarticklabel)
    font.update(fontscale)

    pyplot.draw()
    #plt.figure(linewidth=30.5)
    if xlim is not None:  
        ax.set(xlim=xlim)
    if ylim is not None:
        ax.set(ylim=ylim)
    #pyplot.draw()
    if xbins is not None:
        locator = MaxNLocator(nbins=xbins)
        locator.set_axis(ax.xaxis)
        ax.set_xticks(locator())
    if ybins is not None:
        locator = MaxNLocator(nbins=ybins)
        locator.set_axis(ax.yaxis)
        ax.set_yticks(locator())
    pyplot.draw()
    ax.set_xticks(ax.get_xticks())
    ax.set_yticks(ax.get_yticks())
    ax.set_xlabel(xlabel,fontdict = font.fontlabel,labelpad=(fontsize-1)*fontscale)
    ax.set_ylabel(ylabel,fontdict = font.fontlabel,labelpad=(fontsize-1)*fontscale)
    if (rotation is not None) & (xticklabel is not None) :
        ax.set_xticklabels(xticklabel,fontticklabel,rotation=rotation)
    elif (xticklabel is not None) &(rotation is None):
        ax.set_xticklabels(xticklabel,fontticklabel)
    elif (xticklabel is None) &(rotation is None):
        ax.set_xticklabels(ax.get_xticklabels(),fontticklabel)
    elif (rotation is not None) & (xticklabel is None):
        ax.set_xticklabels(ax.get_xticklabels(),fontticklabel,rotation=rotation)
    ax.set_yticklabels(ax.get_yticklabels(),font.fontticklabel)

    if moveyaxis is True:
        #fontticklabel 
        ax.spines['left'].set_position(('data',0))
    ax.spines['left'].set_visible(left)
    ax.spines['right'].set_visible(not left)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_linewidth(0.5*fontscale)
    ax.spines['bottom'].set_linewidth(0.5*fontscale)
    ax.spines['left'].set_linewidth(0.5*fontscale)
    ax.spines['bottom'].set_color('k')
    ax.spines['left'].set_color('k')
    ax.spines['right'].set_color('k')

    ax.tick_params(direction='out', pad=2*fontscale,width=0.5*fontscale)
    #ax.spines['bottom']._edgecolor="#000000"
    #ax.spines['left']._edgecolor="#000000"
    if title is not None:
        ax.set_title(title,fontdict = font.fonttitle)
    if legendscale is True:
        if (h is None)&(l is None):
            legend = ax.legend(prop=font.fontlegend,
                  bbox_to_anchor=bbox_to_anchor,
                  labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                  edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
        else:
            legend = ax.legend(h,l,prop=font.fontlegend,
                  bbox_to_anchor=bbox_to_anchor,
                  labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                  edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
    if legendtitle is not None:
        #if legendloc is None:
        #    legendloc="best"
        legend = ax.legend(title=legendtitle,prop=font.fontlegend,
                      bbox_to_anchor=bbox_to_anchor,
                      labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                      edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
        ax.legend_.get_frame()._linewidth=0.5*fontscale
        legend.get_title().set_fontweight('normal')
        legend.get_title().set_fontsize(fontscale*fontsize)
        if legendsort is True:
            # h: handle l:label
            h,l = ax.get_legend_handles_labels()
            l,h = zip(*sorted(zip(l,h), key=lambda t: int(t[0]))) 
            legend = ax.legend(h,l,title=legendtitle,prop=font.fontlegend,
                      bbox_to_anchor=bbox_to_anchor,
                      labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                      edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
            ax.legend_.get_frame()._linewidth=0.5*fontscale
            legend.get_title().set_fontweight('normal')
            legend.get_title().set_fontsize(fontscale*fontsize)
        if sns is True:
            h,l = ax.get_legend_handles_labels()
            #l,h = zip(*sorted(zip(l,h), key=lambda t: int(t[0]))) 
            legend = ax.legend(h[1:],l[1:],title=legendtitle,prop=font.fontlegend,
                      bbox_to_anchor=bbox_to_anchor,
                      labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                      edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
            ax.legend_.get_frame()._linewidth=0.5*fontscale
            legend.get_title().set_fontweight('normal')
            legend.get_title().set_fontsize(fontscale*fontsize)
    else:
        legend = ax.legend(handles=h,labels=l,title=legendtitle,prop=font.fontlegend,
                      bbox_to_anchor=bbox_to_anchor,
                      labelspacing=labelspacing,borderpad=borderpad,handletextpad=handletextpad,
                      edgecolor="#000000",fancybox=False,markerscale=markerscale,**kwards)
        ax.legend_.get_frame()._linewidth=0.5*fontscale
        legend.get_title().set_fontweight('normal')
        legend.get_title().set_fontsize(fontscale*fontsize)

    if cbar is not None:
        #locator, formatter = cbar._get_ticker_locator_formatter()
        #ticks, ticklabels, offset_string = cbar._ticker(locator, formatter)
        #cbar.ax.spines['top'].set_visible(False)
        #cbar.ax.spines['right'].set_visible(False)
        #cbar.ax.spines['bottom'].set_visible(False)
        #cbar.ax.spines['left'].set_visible(False)
        cbar.ax.tick_params(direction='out', pad=3*fontscale,width=0*fontscale,length=0*fontscale)
        cbar.set_label(cbarlabel,fontdict = font.fontcbarlabel,Rotation=270,labelpad=fontscale*(fontsize+1))
        cbar.ax.set_yticks(cbar.ax.get_yticks())
        cbar.ax.set_yticklabels(cbar.ax.get_yticklabels(),font.fontcbarticklabel)
    font.reset(fontscale)
    return ax
```

```python
sample_class = pd.read_table('/home/xieyufeng/fig3/data/cfRNA/sample_classes.txt', index_col=0)
batch_info = pd.read_table('/home/xieyufeng/fig3/data/cfRNA/batch_info.txt', index_col=0)
batch_info[batch_info.dataset=='lulab_hcc']='GSE123972'
```

```python
sample_class[sample_class.label=='Normal']='HD'
sample_class[sample_class.label!='HD']='HCC'
```

```python
batch_info = pd.read_table('/home/zhaotianxiao/fig3/batch_info.txt', index_col=0)
batch_info[batch_info.dataset=='lulab_hcc']='GSE123972'
```

```python
kbet_table = pd.read_table('/home/xieyufeng/fig3/output/cfRNA/select_preprocess_method/kbet_score/mirna_and_domains/summary.txt', index_col = 0)
uca_table = pd.read_table('/home/xieyufeng/fig3/output/cfRNA/select_preprocess_method/uca_score/mirna_and_domains/summary.txt', index_col = 0)
```

```python
kbet_table = pd.read_table('/home/shibinbin/projects/exSeek-dev/output/cfRNA/select_preprocess_method/kbet_score/mirna_and_domains/summary.txt', index_col = 0)
uca_table = pd.read_table('/home/shibinbin/projects/exSeek-dev/output/cfRNA/select_preprocess_method/uca_score/mirna_and_domains/summary.txt', index_col = 0)
```

```python
knn_summary = pd.read_csv('/home/shibinbin/projects/exSeek-dev/output/cfRNA/select_preprocess_method/knn_score/mirna_and_domains/summary.txt',sep='\t')
knn_summary = knn_summary.set_index('preprocess_method')
```

```python
fontsize
```

```python
method = 'filter.null.Norm_RLE.Batch_limma_1'
data = pd.read_table('/home/xieyufeng/fig3/output/cfRNA/matrix_processing/'+method+'.mirna_and_domains.txt',
                          index_col = 0)
fig, (ax,lax) = plt.subplots(ncols=2, gridspec_kw={"width_ratios":[4,1]},figsize=(8.5,6))
PCA_plot_with_uca_score_sns(ax,data,sample_class, batch_info,method='PCA')

h,l=ax.get_legend_handles_labels()
for loc in range(len(l)):
    if l[loc] == 'GSE94582_NEBNext':
        l[loc] = 'GSE94582_1'
    elif l[loc] == 'GSE94582_Other':
        l[loc] = 'GSE94582_2'
    elif l[loc] == 'GSE94582_TruSeq':
        l[loc] = 'GSE94582_3'

std_plot(ax,'Dimension 1','Dimension 2',
             title='RLE with Limma',
             xbins=4,ybins=5,h=h,l=l,bbox_to_anchor=(0.9,0.8),markerscale=1.5)
ax.legend_.remove()
lax.axis("off")
std_plot(lax,h=h,l=l,bbox_to_anchor=(1,0.8),markerscale=2,labelspacing=0.3)
lax.legend_.get_frame()._linewidth=0
fig.tight_layout()
#fig.savefig(savepath+'RLE with Limma.eps')
#embed_pdf_figure()
print('UCA = {:.3f}'.format(uca_summary.loc[method].values[0]) +', ' + 'mkNN = {:.3f}'.format(1-knn_summary.loc[method].values[0]))
```

```python
knn_summary
```

```python
method = 'filter.null.Norm_RLE.Batch_null'
data = pd.read_table('/home/xieyufeng/fig3/output/cfRNA/matrix_processing/'+method+'.mirna_and_domains.txt',
                          index_col = 0)

fig, ax = plt.subplots(figsize=(6.1,6))
PCA_plot_with_uca_score_sns(ax,data,sample_class, batch_info,method='PCA')
std_plot(ax,'Dimension 1','Dimension 2',title='RLE',xbins=4,ybins=5)

ax.legend_.remove()
fig.tight_layout()
#fig.savefig(savepath+'RLE with Null_noleg.eps')
#embed_pdf_figure()
method = 'filter.null.Norm_RLE.Batch_null'
#print('UCA = {:.3f}'.format(uca_summary.loc[method].values[0]) +', ' + 'mkNN = {:.3f}'.format(1-knn_summary.loc[method].values[0]))
```

#### variance explained

```python
def var_ex(mat,anno_info):
    from scipy.stats import f
    def list201(array):
        dataframe = pd.DataFrame()
        for i in np.unique(array):
            dataframe[i] = array==i
        return dataframe

    rsquared_mat = pd.DataFrame()
    bms = pd.DataFrame()
    wms = pd.DataFrame()
    fvalue = pd.DataFrame()
    p = pd.DataFrame()
    rsquared_cutoff=pd.DataFrame()
    tss_all = (np.var(mat.T)*mat.shape[1]).tolist()
    var_list = anno_info.columns
    for var in var_list:
        anno = anno_info[var]
        if len(np.unique(anno))<=1:
            warnings.warn("ignoring '%s' with fewer than 2 unique levels"%var,UserWarning)
        keep = ~anno.isna()
        if np.all(keep):
            tss = tss_all
        else:
            anno = anno[keep]
            mat = mat.loc[:,keep]
            tss = np.array(np.var(mat.T)*mat.shape[1])
        anno2class = list201(anno)
        wss = 0
        for i in anno2class.columns:
            mat_select=mat.iloc[:,np.where(anno2class[i])[0]]
            wss = wss + np.array(np.var(mat_select.T)*mat_select.shape[1])
        #display(wss)
        rsquared_mat[var] = 1-wss/tss
        bms[var] = (tss-wss)/(anno2class.shape[1]-1)
        wms[var] = wss/(len(anno)-anno2class.shape[1])
        fvalue[var] = bms[var]/wms[var]
        p[var] = [1-f.cdf(i,anno2class.shape[1]-1,len(anno)-anno2class.shape[1]) for i in fvalue[var]]
        rsquared_cutoff[var] = [1-1/(f.isf(0.05, anno2class.shape[1]-1, len(anno)-anno2class.shape[1])*\
                               (anno2class.shape[1]-1)/(len(anno)-anno2class.shape[1])+1)]
    return rsquared_mat,rsquared_cutoff,p
```

```python
batchinfo_path ="/home/xieyufeng/fig3/data/cfRNA/batch_info.txt"
batchinfo_path ="/home/xieyufeng/fig3/data/cfRNA/batch_info.txt"
classinfo_path = "/home/xieyufeng/fig3/data/cfRNA/sample_classes.txt"
mat1_path="/home/xieyufeng/fig3/output/cfRNA/matrix_processing/filter.null.Norm_RLE.Batch_null.mirna_and_domains.txt"
mat2_path="/home/xieyufeng/fig3/output/cfRNA/matrix_processing/filter.null.Norm_RLE.Batch_limma_1.mirna_and_domains.txt"
```

```python
mat1 = pd.read_csv(mat1_path,sep='\t')
mat2 = pd.read_csv(mat2_path,sep='\t')
batch_info = pd.read_csv(batchinfo_path,sep='\t')
batch_info = pd.read_table('/home/zhaotianxiao/fig3/batch_info.txt')
sample_info = pd.read_csv(classinfo_path,sep='\t')
anno_info = pd.merge(batch_info,sample_info,on=['sample_id'])
anno_info = anno_info.set_index('sample_id')
anno_info = anno_info.loc[mat1.columns]
#anno_info = anno_info.reset_index()
rsquared_mat1,rsquared_cutoff1,p1 = var_ex(mat1,anno_info)
anno_info = anno_info.loc[mat2.columns]
rsquared_mat2,rsquared_cutoff2,p2 = var_ex(mat2,anno_info)
```

```python
import matplotlib.gridspec as gridspec
def r2mat21class(rsquared_mat1=None,rsquared_mat2=None,rsquared_cutoff=rsquared_cutoff1,p1=None,p2=None):
    fig =plt.figure(figsize=(6,4))
    gs = gridspec.GridSpec(2, rsquared_mat1.shape[1],height_ratios=[4,1])
    #fig,(axes,lax)=plt.subplots(2,rsquared_mat1.shape[1],gridspec_kw={"height_ratios":[4,1]},figsize=(6,4))
    lax = fig.add_subplot(gs[1, :])
    pyplot.draw()
    for i in range(len(rsquared_mat1.columns)):
        axes = fig.add_subplot(gs[0, i])
        var = rsquared_mat1.columns[i]
        plot_mat = pd.DataFrame([rsquared_mat1[var],rsquared_mat2[var]]).T
        plot_mat.columns=['before batch removal','after batch removal']
        cutoff = rsquared_cutoff[var].iloc[0]
        #axes[i].set_xscale('log',subsx=[-2,-1,0,1,2])
        #axes[i].hist(plot_mat.before,500,density=1)
        sns.kdeplot(plot_mat['before batch removal'],ax=axes,c='#80b1d3')#,bw=0.001,kernel='gau')
        sns.kdeplot(plot_mat['after batch removal'],ax=axes,c='#fb8072')#,bw=0.001)
        axes.axvline(x=cutoff,linestyle='--',linewidth=0.5,c='k')
        axes.set_xticks([-2,-1,0,1,2])#,cutoff])
        axes.set_xticklabels([0.01,0.1,1,10,100])#,'%.1f'%math.pow(10,cutoff)])
        ymax,ymin = max(axes.get_yticks()),min(axes.get_yticks())
        axes.annotate('%.2f'%math.pow(10,cutoff),xy=(cutoff+0.1,0.05*ymin+0.95*ymax),fontfamily='Arial',fontsize=6.5*autoscale(fig))
        axes.legend(title='state',prop=fontlegend)
        if i==0:
            if var=='dataset':
                std_plot(axes,'Variance explained%','Density',legendtitle='state',legendsort=False,title='Batches',xlim=[-2,2],bbox_to_anchor=(1, 0.75))
            elif var=='label':
                std_plot(axes,'Variance explained%','Density',legendtitle='state',legendsort=False,title='Cancer/Normal',xlim=[-2,2],bbox_to_anchor=(1, 0.75))
        else:
            if var=='dataset':
                std_plot(axes,'Variance explained%','',legendtitle='state',legendsort=False,title='Batches',xlim=[-2,2],bbox_to_anchor=(1,-0.2))
            elif var=='label':  
                std_plot(axes,'Variance explained%','',legendtitle='state',legendsort=False,title='Cancer/Normal',xlim=[-2,2],bbox_to_anchor=(1,-0.3),ncol=2)
        axes.legend_.get_frame()._linewidth=0
        #axes[i].legend(title='s',prop=fontlegend)

        p_mat = pd.DataFrame([p1[var],p2[var]]).T
        p_mat.columns=['before','after']
        #display(p_mat)
        #table = axes[i].table(cellText=np.array([np.int_(np.sum(p_mat<0.05)),
        #                           ['%.2f'%i for i in (np.sum(p_mat<0.05)/len(p_mat))]]),
        #         colLabels=['before','after'],rowLabels=['amount','percentage'],
        #                      colWidths=[0.3,0.3],
        #                      bbox=[0,0,0.5,0.35])
        #table.set_fontsize(6.5)
        if i != len(rsquared_mat1.columns)-1:
            axes.legend_.remove()
        #plt.subplots_adjust(left=0.4, bottom=0.4)
    #axes[-1].axis('off')
    lax.axis("off")
    h,l=axes.get_legend_handles_labels()
    axes.legend_.remove()
    std_plot(lax,h=h,l=l,bbox_to_anchor=(1,1),markerscale=2,labelspacing=0.3,ncol=2)
    fig.tight_layout() 
    #fig.savefig(savepath+'variance_explained.eps')

    #embed_pdf_figure()
r2mat21class(np.log10(rsquared_mat1*100),np.log10(rsquared_mat2*100),np.log10(rsquared_cutoff1*100),p1,p2)
```

```python
p_mat = pd.DataFrame([p1.label,p2.label]).T
p_mat.columns=['before','after']
np.sum(p_mat<0.01)
```

