Tr_s 
	串行时钟恢复代码，一个符号四个点
Cr_s
	串行载波恢复
TR_P_4samp
	并行时钟恢复代码，一个符号四个点（8路并行）
Cr_p
	并行载波恢复代码（2路并行）
	
基本每部分代码都包含对应的modelsim仿真程序，我用的版本是modelsim_ae_6.6d，时钟环仿真输入数据由matlab产生，载波环输入数据为时钟环输出



分数倍抽取模块Decimate_all\Fraction
	8路并行分数倍抽取模块（抽取率大于1小于2），modelsim内为仿真工程，modelsim/matlab中三个文件DecRateFraction_Gen.m，Dec_Data_gen.m，result_plot.m分别用于产生抽取率参数、产生仿真输入文件及仿真输出结果分析

整数倍抽取模块Decimate_all
	modelsim仿真路径Decimate_all\modelsim，记录内容在modelsim\记录.txt