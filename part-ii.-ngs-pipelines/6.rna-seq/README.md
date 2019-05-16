# 6.RNA-seq

* [**Differential expression**](https://lulab.gitbooks.io/teaching/part-ii.-ngs-pipelines/6.1.differential-expression.html)
* [**Alternative splicing**](https://lulab.gitbooks.io/teaching/part-ii.-ngs-pipelines/6.2.alternative-splicing.html)

## More Reading: RNA-seq Analysis Pipelines

* Trapnell C et al. Nat Protoc. 2012, 7\(3\):562-78 Differential gene and transcript expression analysis of RNA-seq experiments with TopHat and Cufflinks. [Reference Link](http://www.ncbi.nlm.nih.gov/pubmed/22383036)
* [A survey of best practices for RNA-seq data analysis -- 2016](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0881-8#Abs1)
* RNA-seq analysis pipeline at GitHub: [https://github.com/mgonzalezporta/TeachingMaterial](https://github.com/mgonzalezporta/TeachingMaterial)
* lncRNA analysis pipeline: [http://webhome.weizmann.ac.il/home/igoru/PLAR/](http://webhome.weizmann.ac.il/home/igoru/PLAR/)
* \(Deprecated\) RNA-seq analysis pipeline @ Lu Lab: [RNAfinder](http://bioinformatics.life.tsinghua.edu.cn/new_home/lulab-software/rnafinder.html)

## 休息一会

**R，Robert, 23andMe**

![](../../.gitbook/assets/4-23andme.png)

> R语言是从S统计绘图语言演变而来。S语言上世纪70年代诞生于AT&T贝尔实验室，基于S语言开发的商业软件S-Plus，可以方便的编写函数、建立模型，具有良好的扩展性，在国外学术界应用很广。但是由于商业性特征，其软件价格昂贵。

1995年由新西兰Auckland大学统计系教授Robert Gentleman和他的同事Ross Ihaka，基于S语言的源代码，编写了一能执行S语言的软件，并将该软件的源代码全部公开，这就是R软件，因为主要编写的两位科学家名字首字母都是R，因此其命令统称为R语言。他们就是“R语言之父”。

有趣的是，两位“R语言之父”此后发展轨迹并不相似。 Ross于2017 年退休，此前一直担任新西兰Auckland大学统计学副教授。 Robert则从Auckland统计学教授慢慢变成了生物信息学家。2001年，Robert开始研究Bioconductor项目，以促进生物信息学和计算生物学开源工具的开发。2009年，Robert加入Genentech生物技术公司，担任生物信息学和计算生物学高级主管，同年他编写了一本书《R programming for bioinformatics》。2015年，Robert 加入23andMe，担任计算生物学副总裁，如今他专注于探索23andMe数据库中的人类遗传和性状数据如何用于鉴定新的疾病治疗方法。

23andMe公司由Linda Avey，Paul Cusenza和Anne Wojcicki于2006 年创立，旨在为个人消费者提供基因测试及相应服务，以正常人类细胞中的23对染色体命名，23andMe是第一家为提供祖源分析的常染色体DNA检测的公司。

23andMe基于唾液的直接面向消费者（DTC）的基因检测业务在2008 年被时代杂志评为“年度发明” 。2013年11月，因为基因检测报告中遗传疾病预测未得到充分临床经验验证等争议问题，FDA命令23andMe停止在美国销售其唾液收集试剂盒和个人基因组服务（PGS）。此后，23andMe开始扩宽海外市场，并停止提供健康相关的基因报告。经过几年的市场调研，23andMe验证了部分健康相关基因检测的准确性。2017年4月，FDA批准了其公司包括迟发性阿尔茨海默病，帕金森病等在内的10项基因检测申请。2018年3月，FDA批准了与乳腺癌相关的基因突变检测申请。

目前，国内主流的基因检测产品Wegen和23魔方都学习了23andMe的经验，甚至说模仿了23andMe的产品。

