# VHDL-learning

Refer to master branch for files

modeles:
1.优先编码器
输入： 256-bit（位宽不要写死，后面可能会换成128-bit或512-bit）的DIN
输出：1-bit的DZ和8-bit的DOUT
功能：如果DIN所有比特都是0则DZ为1，否则为0；DOUT为DIN里第一个1的索引，即如果DIN的第一个1出现在第7位，则DOUT为7

2.最大值求解器
输入：在8个存储模块中存储了8个不同的16-bit正整数，每个时钟周期从MSB向LSB按位读取出1个比特作为输入，即如果数据是A,B,C,…,H，第一个时钟周期输入为{A{15}, B{15}, C{15},…, H{15}}，下一时钟周期输入为{A{14}, B{14}, C{14},…, H{14}},以此类推
输出：A,B,C,…,H中最大的一个数，以及这个数的索引（例如A就是0，H就是7）

3.加法树
输入：128-bit的A和128-bit的B，其中A、B两两交叉排放，即{A{0}, B{0}, A{1},B{1}, … }
输出：9-bit的累加值R
功能：R=(A{0} + A{1} + … + A{127})*2 + (B{0} + B{1} + … + B{127})

4.移位累加器
输入：9-bit的R，1-bit的符号位标志SIGN
输出：16-bit累加值Z
功能：如图，注意两个DFF由两个不同的RST信号分别重置
 

5.矩阵乘单元（只要求验证算法，用上3.加法树和4.移位累加器）
输入：128个8-bit的A，128个8-bit的W，均为补码表示，A≥0，W正态分布
输出：16-bit输出Z=A[0]*W[0] + A[1]*W[1] + … + A[127]*W[127]
功能：必须按照如下算法实现，并验证这个算法正确：
1.对于128个W，读取最高位（符号位），记作W[0:127]{7}
2.对于128个A，读取最高的两位，记作A[0:127]{7:6}
3.通过128个1bx2b的乘法器，计算W[0:127]{7} × A[0:127]{7:6}
4.把计算结果输入到3.加法树，求得9-bit累加值R
5.把R累加到4.移位累加器（左）上
6.重复第2~5步三次，把A[0:127]{5:4}，A[0:127]{3:2}，A[0:127]{1:0}都和W[0:127]{7}做完乘法并累加到4.移位累加器（左），注意每次移位是移2位
7.把4.移位累加器（左）的值累加到4.移位累加器（右）上，由于W读取的是符号位，SIGN信号应该置高，也就是累加的是- W[0:127]{7} × A[0:127]
8.重复1~7步七次，把W的剩余的七个比特都计算一次，并累加到4.移位累加器（右）上，，注意每次移位是移1位
