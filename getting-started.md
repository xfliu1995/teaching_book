# Getting Started

## 1\) 预修课程准备

1. 基本生物课程： 如《遗传学》和/或《分子生物学》
2. 基本统计课程： 如《概率论》和/或《生物统计》
3. 基本数学课程： 如《微积分》和《线性代数》
4. 基本计算机课程：如《C语言》或《python》

## 2\) Learning Materials

* Tutorial
* **Basic Tutorial** \(this one\)
* [**Advanced Tutorial**](https://lulab.gitbook.io/training)

> see more learning materials in [Appendix I. Keep Learning](appendix/appendix1.keep-learning.md)

## 3\) GitHub - Document your work

[GitHub](https://github.com) 是一个源代码托管平台。

* 我们鼓励学生在 GitHub 上建立自己的仓库（repo）来托管项目，并添加好 `README.md` ，使用下文介绍的 Markdown 语言来解释你的工作。
* 我们也推荐有经验的读者用Git管理自己的代码，可以看这个[简易Git教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)。
* 在这里还可以找到海量的优秀开源项目代码，共同碰撞出思维的火花，实现 Social Coding。

[Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) 是一种通用标记语言，其[语法](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)远比 LaTeX 简洁，易于上手，使得用户能专心于写作，而不会被排版分心。

* 我们建议在Linux里**每个重要工作目录**都用这个语言来编辑一个README.md文件。
* md可以生成 HTML 文件发布在网站上。
* md也可以生成 PDF，具有很高的兼容性。

实例有：

* github \(例如：[README.md](https://github.com/lulab/Ribowave/blob/master/README.md) 及其 [wiki](https://github.com/lulab/Ribowave/wiki) \)
* github page （例如：[https://lulab.github.io](https://lulab.github.io) 的 [source code](https://github.com/lulab/lulab.github.io/blob/master/README.md)）
* gitbook \(例如：本文档） 

> 我们鼓励利用github，github自带的wiki，gitbook，清华云等云服务；对习惯离线编辑同学有如下软件推荐： Mac: [Bear](https://bear.app/), [MWeb](https://zh.mweb.im/); Windows: [typora](https://typora.io/), [Madoko](https://www.madoko.net/)

## 4\) 本教程使用说明

* 除非特殊说明，本章中的命令均是在自己电脑的 **Terminal** （终端）程序中进行。

> **特别注意:** 在Linux中空格有着专门的意义，所以要特别关注教程中列出的命令行中的空格符，**不可以省略空格**，否则Terminal里的命令会无法正确执行。

* 后面每一章的操作都在 Docker 中的一个独立的目录（位于用户家目录`/home/test`下）中进行，我们称其为**章节目录**。

> 例如， GSEA 这一章中提到 “以下操作均在 `gsea/` 目录下进行。”，指的就是在 `/home/test/gsea` 下进行该章所有操作，所有相对目录均是相对于该目录。

* 本教程全部作业均要求提供源代码和输出内容。提交作业格式可以是.doc/.txt/.md/.sh等，标有 "optional" 的题目选做，做对可获得额外加分。

## 5\) Homework

1. 注册一个GitHub账户，创建一个仓库，写好`README.md`。尝试使用Git管理自己的代码并同步至GitHub。
2. 尝试使用Markdown语言，熟悉其语法。

## 休息一会

**Craig Venter & Francis Collins** 人类基因组计划竞赛的故事

![](.gitbook/assets/hg-2000.png)

2000年6月26日，美国总统Clinton等六国领导人共同宣布人类基因组计划的草图完成。在新闻发布会现场，站在Clinton身侧的两位“科研明星”分别是人类基因组计划的官方领导人Collins和Celera 公司的领导人Venter。

此后，这两个人还共同出现在《时代》杂志的封面上。作为一个民间团体，并且是一个饱受争议的民间团体的领导人，Venter能够获得和政府资助的Collins平起平坐的机会。不论围绕在他身上的争议如何，正是由于他引发的这场“科研竞赛”，使原本预计 15年才能完成的计划，整整提前3年即告完成。

Francis Collins和Craig Venter两位杰出科学家身上的标签并不仅限于“人类基因组计划”。

**Craig Venter**

Craig Venter是一位极富有商业头脑的“科学狂人”，在Celera 公司之后，他又先后创建了合成基因组Synthetic Genomics 公司、J. Craig Venter 研究院和Human Longevity公司。他带领团队带领团队成功地把一个合成的基因组转移到了细胞里，这是全球第一个。 如今他也正在向延长人类寿命发出挑战。

Craig Venter 这位科学天才并不是一路优秀着长大的。他高中时期学习成绩并不理想，经常考C和D。据他自己所述，对他人生改变最大的是越南战争。

20岁的时候，他在越战中的海军医院服役，负责对从前线回来的受伤战士进行分组，他能决定哪些可以得到优先治疗。战争是残酷的，生命是如此脆弱，这种决定这谁能活谁会死的事情却让他承受了很大的心理压力，甚至多次想要自杀来逃避……在最艰苦、最恶劣的环境下，他对医学和科学开始产生兴趣。战场上生命如此廉价，这个二十岁的少年开始思考生命的意义，在越战的硝烟与血腥中他树立了自己人生的第一个小目标：如果活着离开越南就去研究生死。

经历了战争的九死一生之后， Craig Venter，这个当初高中都差点无法毕业的小伙子居然用6年是将拿到了生理和药理学的双料博士学位

**Francis Collins**

Francis Collins是优秀的医学-遗传学家，第一个受到两任美国总统（奥巴马和唐纳德川普）直接任命的美国国立卫生研究院院长（NIH director），领导美国精准医疗计划，向人类健康发出新挑战。

Francis Collins是美国国立卫生研究院院长（NIH director），领导人类基因组计划，并发现了多种疾病基因。

去年The David Rubenstein Show采访了 Francis Collins 。Rubenstein问他当年领导人类基因组计划的意义，他说到这些年癌症治疗的变化，个体化用药（personalized medicine），还举了个人例子。他做了基因测序，发现自己糖尿病的风险比普通人高许多，但父母都没有糖尿病，于是改变饮食增加运动，减了35磅体重，变成了另一个人。

Francis Collins是一位低调的科学家，但是他的两大爱好众所周知。他非常喜爱摇滚音乐，他和NIH同事组织了一个摇滚乐队，将生物研究的日常写进他们的歌词里面。摩托骑行是他的另一大爱好，据他自己所述，骑摩托车对他而言是一种享受生命的感觉，这种感觉难以用别的方式来代替。

