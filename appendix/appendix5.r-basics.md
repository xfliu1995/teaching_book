# Appendix V. R Basics

How to make professional and beautiful plots

> **Tips:**
>
> Do things with multiple ways
>
> Efficient Writing: Bash &gt; R &gt; Perl/Python &gt; Excel &gt; C,C++

## 1. Install and Use R

### 1a\) Install R

See the official site of R: [https://www.r-project.org/](https://www.r-project.org/) （Docker中已经安装好）

Here is an example of installation in Linux:

* For CentOS

  ```bash
  yum -y install epel-release
  yum -y install R
  ```

* For Ubuntu

  ```bash
  apt -y install r-base
  ```

### 1b\) Install RStudio

If you like a nice interface to use R instead of Linux command line, you can try **RStudio:** [https://www.rstudio.com/](https://www.rstudio.com/)

We have some instruction of Rstudio in [Appendix. Plot with R](appendix.plots.md)

### 1c\) Use R

* how to enter?
  * On Mac or Linux, you can open a Terminal and type

    ```text
    R
    ```

  * On Windows or Mac, you can find a program with this logo: ![](../.gitbook/assets/r-logo.png)
* How to quit?

  `q()`

* How to get help?

  For example, we use use `?t.test` to we get help for `t.test()` function

## 2. Basic Data Types

### 2a\) basic type

```r
> x = 10.5 # assign a decimal value
> x # print the value of x
[1] 10.5
> class(x) # print the class name of x
[1] "numeric"

> y = as.integer(3)
> y # print the value of y
[1] 3
> class(y) # print the class name of y
[1] "integer"

> z = 1 + 2i # create a complex number
> z # print the value of z
[1] 1+2i
> class(z) # print the class name of z
[1] "complex"

> x = 1; y = 2 # sample values
> z = x > y # is x larger than y?
> z # print the logical value
[1] FALSE
> class(z) # print the class name of z
[1] "logical"

> x = as.character(10.5)
> x # print the character string
[1] "10.5"
> class(x) # print the class name of x
[1] "character"
```

### 2b\) vector

```r
> c(2, 3, 5)
[1] 2 3 5

> n = c(2, 3, 5)
> s = c("aa", "bb", "cc", "dd", "ee")
> c(n, s)
[1] "2" "3" "5" "aa" "bb" "cc" "dd" "ee"

> s = c("aa", "bb", "cc", "dd", "ee")
> s[3]
[1] "cc"
```

### 2c\) matrix

```r
> B = matrix(
+ c(2, 4, 3, 1, 5, 7),
+ nrow=3,
+ ncol=2)

> B # B has 3 rows and 2 columns
     [,1] [,2]
[1,]    2    1
[2,]    4    5
[3,]    3    7
```

### 2d\) list

```r
> n = c(2, 3, 5)
> s = c("aa", "bb", "cc", "dd", "ee")
> b = c(TRUE, FALSE, TRUE, FALSE, FALSE)
> x = list(n, s, b, 3) # x contains copies of n, s, b

> x
[[1]]
[1] 2 3 5

[[2]]
[1] "aa" "bb" "cc" "dd" "ee"

[[3]]
[1]  TRUE FALSE  TRUE FALSE FALSE

[[4]]
[1] 3
```

### 2e\) data frame

```r
> n = c(2, 3, 5)
> s = c("aa", "bb", "cc")
> b = c(TRUE, FALSE, TRUE)
> df = data.frame(n, s, b) # df is a data frame
> df
  n  s     b
1 2 aa  TRUE
2 3 bb FALSE
3 5 cc  TRUE
```

## 3. Examples

### 3a\) A simple example of t test

* start R and type:

```r
x=c(5.6,7.9,8.9,19.5,20.5,39.5)
y=c(6.5,8.3,9.1,17.9,29.4,22.8)
write.table(x, file = "foo1")
write.table(y, file = "foo2")

a<-read.table("foo1") # read the file
b<-read.table("foo2") # read the file

t.test(a,b,alternative=c("less"))
t.test(a[[1]],b[[1]],altrenative=c("less"),paired=TRUE) # paired t test
```

* You can also write these into a file, script.R, then run

  `R CMD BATCH script.R`

### 3b\) More R Examples

* [Appendix. Plot with R](appendix.plots.md)
* [John's Github](https://github.com/urluzhi/scripts/tree/master/Rscript) 

## 4. More Readings and Practices

### 4a\) Basic

* &lt;&lt; Bioinformatics Data Skills &gt;&gt;
  * A Rapid Introduction to the R Language
* [Quick R](https://www.statmethods.net/) 可以从如下章节开始 :
  * Learning R  
  * R Interface  
  * Data Input  
  * Statistics

### 4b\) Advanced

* [Advanced R Tutorial](https://lulab.gitbook.io/training/part-i-basic-skills/4.r)
* &lt;&lt; Bioinformatics Data Skills &gt;&gt;
  * Working with Range Data
* [Quick R](https://www.statmethods.net/) 

