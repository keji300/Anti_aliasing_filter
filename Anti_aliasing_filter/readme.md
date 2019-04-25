#### 抗混叠滤波
- 采样频率为128Khz
- 目标信号频率为2Khz
- `通过2次滤波实现，第一次滤波将滤波器的通带设置为16Khz,获得16Khz的信号（采样频率128Khz）然后将信号抽样平均降采样成16Khz,第二次滤波将信号的通带设置为2Khz.`
#### 对应文件
1. src:verilog 源代码
2. testbench:仿真测试代码
3. matlab:matlab模拟滤波文件
#### 平台
- Xilinx zynq xc7z035
