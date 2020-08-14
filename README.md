# X86-Course_BUAA
本仓库包含X86课程四次作业。

## 概述

- 时间：2020春季
- 学分：2学分
- 授课教师：熊桂喜
- 上课方式：半学期课堂授课
- 考核方式及占比：打卡5% + 4次编程实验作业30% + 期末考试65%

## 授课

### 第一章：机器基础知识

掌握二进制及其运算、记忆常见字符的ASCII码；了解PC机的基本组成；掌握X86寄存器及其功能；掌握X86内存机制，数据的位宽，大小端概念

### 第二章：指令系统

掌握并灵活应用与数据有关的6种寻址方式；掌握X86的数据通路图；熟练掌握数据传送、算术逻辑运算、控制转移指令及其用法；掌握标志寄存器的作用及其读写时机；掌握与转移调用指令有关的4种寻址方式；会快速排查指令中的致命错误，包括但不限于语法错误、寻址寄存器错误、数据通路错误、位宽不匹配等；会根据要求的功能编写指令序列

### 第三章：X86程序结构

熟练掌握三段式程序结构；会定义数据段中的变量、常量、数组；会定义函数（PROC）和宏（MACRO）；会画程序运行的内存图、堆栈图

### 第四章：编程实战

掌握十进制、十六进制、二进制整数以及字符串的输入输出方法；掌握十进制、十六进制数的加减乘法；掌握各种字符串处理指令及其适用范围；掌握函数式程序设计，会用堆栈保存寄存器数据，掌握函数传参的三种方法

## 考核

### 打卡：5%

每次都打卡

### 实验作业：30%

4次实验作业，需要手写代码+编程，最后交上去，需要写一个简单的报告，截图展示代码的运行结果。这个非常重要，不仅作为平时成绩的一部分，而且实验作业基本上涵盖了考试编程题的所有内容，认真做下来考试没问题；千万不要COPY代码，首先老师如果查出雷同，后果很严重，其次如果单纯COPY而不掌握，到期末连哭的机会都没有。手写代码比较累，但是期末考试也是手写代码。每次实验都有附加题，实验拿满分必须做附加题！！**本仓库包括四次作业完整代码及实验报告，仅供参考。**

### 期末考试：65%

卷面分100分，题型包括填空、简答、程序片段题和2道完整编程题，编程题的题量比实验作业小。考试内容全是讲过的PPT的内容，相对简单，所有的重点老师都强调过。最后有2道编程题需要手写代码，跟平时实验难度差不多，比平时实验的附加题简单很多。

## 学习经验

### 平常学习

- 8086汇编和MIPS汇编差别还是比较大，但是仍然有类似的地方，学习的时候注意区分不同点和归纳相似点。

- 平时作业的实验要拿满分，必须做附加题，附加题难度不大，不会做可以问问同学啊！且有可能在考试题中出现类似附加题的题目。

- 教材上的文字很多，不一定能看得进去；看得进去了也不一定会编程，因此要对教材中的程序实例掌握清楚。

- X86的难点并不在于编程本身，因为我们都学过C语言，也学过MIPS汇编，程序设计思路什么的都是相通的。这门课最难的地方在于，X86属于CISC体系结构，各种寻址方式眼花缭乱，不像MIPS那样只有立即数和寄存器寻址；而且还有一些“七拐八弯”的规定，比如间接寻址只能用`BX BP SI DI`，基址寄存器只能是`BX BP`，移位数要用`CL`寄存器的值表示，有的指令或操作数要用`PTR`指明位宽等等，初学者上来面对这么多复杂的规则，肯定是一脸懵B。

  解决这个问题没有捷径，只有靠不断地编程试错，只有错的多了才能“长记性”。总而言之一定要多动手，实践出真知，如果光是纸上谈兵，期末会死的很惨。

### 考试复习

- 这学期由于是线上授课，期末测试是开卷，很多零碎的语句或是知识点不需要去背，但是之后课程的期末测试估计都是闭卷，很多零碎的知识点和平时写的程序作业还是要熟记。

- 期末考试简单，都是讲过的内容，重视PPT，PPT有的都要会，尤其是老师手写的内容。

- 教材后的习题可以自己做一遍，题量不大，但是没有答案，可以和同学对答案（判断题比较重要）。

- 老师反复强调的重点大概率会在考试中出现。


### 评价

- 这门课是良心好课，任务量小，课时数少，而且好掌握，前提是你认真去做。最后给分非常高。熊桂喜老师认真负责，解答问题也很耐心，最可贵的是期末成绩公布之后还给我们指出哪里错了。
- 知识也很实用，虽说16位DOS汇编已过时（某些嵌入式系统还在使用），但32位、64位X86的语法和DOS汇编大同小异。