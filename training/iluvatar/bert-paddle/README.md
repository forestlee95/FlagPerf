
### 模型Checkpoint下载
[模型Checkpoint下载](../../benchmarks/bert/README.md#模型checkpoint下载)


### 测试数据集下载
[测试数据集下载](../../benchmarks/bert/README.md#测试数据集下载)


### Paddle版本运行指南

单卡运行命令：
● 依赖包，paddlepaddle-gpu

'''
python -m pip install paddlepaddle-gpu==2.4.0rc0 -i https://pypi.tuna.tsinghua.edu.cn/simple
'''

● bash环境变量:
```
export MASTER_ADDR=user_ip
export MASTER_PORT=user_port
export WORLD_SIZE=1
export NODE_RANK=0
export CUDA_VISIBLE_DEVICES=0,1#可用的GPU索引
export RANK=0
export LOCAL_RANK=0
```
example：
```
export MASTER_ADDR=10.21.226.184
export MASTER_PORT=29501
export WORLD_SIZE=1
export NODE_RANK=0
export CUDA_VISIBLE_DEVICES=0,1#可用的GPU索引
export RANK=0
export LOCAL_RANK=0
```

● 运行脚本:

在该路径目录下

```
python run_pretraining.py
--data_dir data_path
--extern_config_dir config_path
--extern_config_file config_file.py
```

example：
```
python run_pretraining.py
--data_dir /ssd2/yangjie40/data_config
--extern_config_dir /ssd2/yangjie40/flagperf/training/nvidia/bert-pytorch/config
--extern_config_file config_A100x1x2.py
```


### 天数智芯 BI-V100 GPU配置与运行信息参考
#### 环境配置
- ##### 硬件环境
    - 机器、加速卡型号: Iluvatar BI-V100 32GB

- ##### 软件环境
   - OS版本：Ubuntu 20.04
   - OS kernel版本:  4.15.0-156-generic x86_64    
   - 加速卡驱动版本：3.0.0
   - Docker 版本：20.10.8
   - 训练框架版本：torch-1.10.2+corex.3.0.0
   - 依赖软件版本：无


### 运行情况
| 训练资源 | 配置文件        | 运行时长(s) | 目标精度 | 收敛精度 | Steps数 | 性能(samples/s)|
| -------- | --------------- | ----------- | -------- | -------- | ------- | ---------------- |
| 单机8卡  | config_BI-V100x1x8 |     |     |    |     |            |

