### 天数智芯 BI-V150 GPU配置与运行信息参考

#### 环境配置

- ##### 硬件环境
    - 机器、加速卡型号: Iluvatar BI-V150 64GB

- ##### 软件环境
   - OS版本：Ubuntu 20.04
   - OS kernel版本:  5.4.0-148-generic x86_64    
   - 加速卡驱动版本：3.3.0
   - Docker 版本：20.10.21
   - 训练框架版本：torch-1.13.1+corex.3.3.0
                   FlagScale.git@543f725
   - 依赖软件版本：sentencepiece
   
- ##### 并行策略

   - 并行技术：张量、流水、数据混合并行，具体并行方案见“运行情况”章节
   - 实施者：FlagScale
   - 实施细节：/

- ##### 优化策略

   - flash attention 2

### 运行情况

* 输入批尺寸
  1. local_batchsize(micro_batchsize)，简写为LBS，即实际进入模型的张量批尺寸，为config_A100x1x8.py中所写，在本case中默认为1
  2. seqlength(max_position_embedding)，简写为MPE，即实际进入模型的序列长度，为config_A100x1x8.py中所写，在本case中默认为2048
  3. gradient_accumulate_steps，简写为GAS，即梯度累加步数，为ds_config.json中所写，在本case中默认为9
  4. global_batchsize恒等于local_batchsize\*gradient_accumulate_steps\*data_parallel_size。在本case中，data_parallel_size=world_size/TPsize/PPsize。

* 通用指标

| 指标名称     | 指标值                     | 特殊说明                           |
| ------------ | -------------------------- | ---------------------------------- |
| 任务类别     | 自然语言理解               |                                    |
| 模型         | aquila2_7b                  |                                    |
| 数据集       | pile wikipedia   |                                    |
| 数据精度     | amp                        |                                    |
| 超参修改     | parallel,见“性能指标” | 格式为TPxPPyDPz，例如TP2PP1DP4 |
| 超参修改     | fix_hp,见“性能指标”        | 跑满硬件设备评测吞吐量所需特殊超参 |
| 硬件设备简称 | BI-V150                    |                                    |
| 硬件存储使用 | mem,见“性能指标”           | 通常称为“显存”,单位为GiB           |
| 计算使用率 | MFU,见“性能指标”           | 参见PaLM论文定义 |
| **吞吐量**   | **token/p/s,见“性能指标”** | 平均单卡每秒处理的token数          |

* 性能指标

| 配置                | parallel |  fix_hp           | token/p/s | loss | mem       | MFU       |
| ------------------- | ------ | ---------------- | ------ | ------- | --------- | --------- |
| BI-V150单机8卡（1x8）  | TP1PP1DP8 |  /                |  |  |  |  |
| BI-V150单机8卡（1x8）  | TP8PP1DP1 |  LBS=8            |  |  |  |  |
| BI-V150单机8卡（1x8）  | TP1PP8DP1 |  LBS=4       |  |  |  |  |
| BI-V150单机8卡（1x8）  | TP2PP2DP2 |  LBS=4       |  |  |  |  |


