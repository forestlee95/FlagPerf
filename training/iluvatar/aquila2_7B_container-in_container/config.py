# =========================================================
# network
# =========================================================
SSH_PORT = "10022"

net_cmd = "export CUDA_DEVICE_MAX_CONNECTIONS=1;export NCCL_SOCKET_IFNAME=`ip -4 addr show | grep inet | grep 10.31.12. | sed -e 's/^.*global *//g'`;export GLOO_SOCKET_IFNAME=`ip -4 addr show | grep inet | grep 10.31.12. | sed -e 's/^.*global *//g'`;export NCCL_NET_SHARED_BUFFERS=0;export NCCL_DEBUG=INFO"

# =========================================================
# chip attribute
# =========================================================
flops_16bit = "192000000000000"

# =========================================================
# env attribute
# =========================================================
env_cmd = "export LD_LIBRARY_PATH=/usr/local/corex-3.3.0/lib:;export PATH=/usr/local/corex-3.3.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

