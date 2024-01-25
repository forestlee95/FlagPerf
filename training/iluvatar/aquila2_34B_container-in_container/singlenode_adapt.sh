echo "iluvatar 34B environment"
export CUDA_DEVICE_MAX_CONNECTIONS=1
#export NCCL_SOCKET_IFNAME=$(ibdev2netdev | awk '{print $5}')
export NCCL_SOCKET_IFNAME=`ip -4 addr show | grep inet | grep 10.31.12. | sed -e 's/^.*global *//g'`
# export NCCL_SOCKET_IFNAME=$(ibdev2netdev | awk '{print $5}')
if [ -z "${NCCL_SOCKET_IFNAME}" ]; then echo "[E]: No ib for NCCL. Abort!" >&2; exit 1; fi
# export GLOO_SOCKET_IFNAME=$(ibdev2netdev | awk '{print $5}')
export GLOO_SOCKET_IFNAME=`ip -4 addr show | grep inet | grep 10.31.12. | sed -e 's/^.*global *//g'`
export NCCL_NET_SHARED_BUFFERS=0

export NCCL_FORCESYNC_DISABLE=1
export UMD_CCLINLASTCE=1
export ENABLE_FLASH_ATTENTION_WITH_IXDNN=1

# export NCCL_NET_SHARED_BUFFERS=0
export NCCL_DEBUG=TRACE
export NCCL_ALGO=Ring
export OMP_NUM_THREADS=4
export NCCL_USE_DIRECT=1