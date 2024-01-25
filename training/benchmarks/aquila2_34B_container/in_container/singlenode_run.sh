#!/bin/bash

ifconfig

git log | head -n 5

TB_PATH=./aquila2_34B_perfermance_01
mkdir -p $TB_PATH

SCALEHOME=$1

DATADIR=$2
DATASET=$3
TRAININGSAMPLES=$4

TP=$5
PP=$6
MBS=$7
GBS=$8

NODERANK=$9
NNODES=${10}
MASTERADDR=${11}
MASTERPORT=${12}

VENDOR_SHELL=${13}

export PYTHONPATH=$PYTHONPATH:$SCALEHOME/megatron

VOCAB_FILE=$SCALEHOME/examples/aquila/tokenizer/vocab.json
MERGE_FILE=$SCALEHOME/examples/aquila/tokenizer/merges.txt
SPECIAL_TOKENS_FILE=$SCALEHOME/examples/aquila/tokenizer/special_tokens.txt

DISTRIBUTED_ARGS="
    --nproc_per_node 16 \
    --nnodes $NNODES \
    --node_rank $NODERANK \
    --master_addr $MASTERADDR \
    --master_port $MASTERPORT
"

TRAINING_ARGS="
    --mlp-g1-tp-overlap \
    --mlp-g2-tp-overlap \
    --attn-g1-tp-overlap \
    --attn-g2-tp-overlap \
    --mlp-g1-overlap-size 4 \
    --mlp-g2-overlap-size 4 \
    --attn-g1-overlap-size 4 \
    --attn-g2-overlap-size 4 \
    --mlp-g1-save-total-input-for-backward \
    --attn-g1-save-total-input-for-backward \
    --train-samples $TRAININGSAMPLES \
    --eval-iters 0 \
    --eval-interval 2000 \
    --tensor-model-parallel-size $TP \
    --pipeline-model-parallel-size $PP \
    --micro-batch-size $MBS \
    --global-batch-size $GBS \
    --disable-bias-linear \
    --use-distributed-optimizer \
    --use-flash-attn \
    --num-layers-per-virtual-pipeline-stage 5 \
    --recompute-granularity full \
    --recompute-method uniform \
    --recompute-num-layers 1 \
    --recompute-method-per-stage 11 0 1 1 \
    --recompute-num-layers-per-stage 11 1 1 1 \
    --sequence-parallel
"

MIXED_PRECISION_ARGS="
    --bf16 \
    --attention-softmax-in-fp32 \
    --embedding-weights-in-fp32 \
    --rotary-position-embeddings-in-fp32 \
    --accumulate-allreduce-grads-in-fp32
"

DATA_ARGS="
    --data-path $DATADIR/$DATASET \
    --tokenizer-type AquilaTokenizer \
    --vocab-file $VOCAB_FILE \
    --vocab-size 100008\
    --merge-file $MERGE_FILE \
    --special-tokens-file $SPECIAL_TOKENS_FILE \
"

NETWORK_ARGS="
    --num-layers 60 \
    --hidden-size 6144 \
    --num-attention-heads 48 \
    --group-query-attention \
    --num-query-groups 8 \
    --hidden-dim-multiplier 1.3 \
    --swiglu \
    --multiple-of 4096\
    --seq-length 4096 \
    --max-position-embeddings 4096 \
    --layernorm-epsilon 1e-5 \
    --layernorm-init-weight 0.3 \
    --use-rotary-position-embeddings \
    --no-position-embedding \
    --apply-layernorm-rms \
    --make-vocab-size-divisible-by 64 \
    --untie-embeddings-and-output-weights
"

INITIALIZATION_ARGS="
    --init-method-std 0.02 \
    --seed 42 
"

REGULARIZATION_ARGS="
    --attention-dropout 0.0 \
    --hidden-dropout 0.0 \
    --weight-decay 0.1 \
    --adam-beta1 0.9 \
    --adam-beta2 0.95 \
    --clip-grad 1.0
"

LEARNING_RATE_ARGS="
    --lr 9.65e-6 \
    --lr-decay-style linear \
    --lr-warmup-fraction 0.1 \
    --min-lr 0.0 \
"

LOG_ARGS="
    --log-interval 1 \
    --tensorboard-dir $TB_PATH \
    --tensorboard-log-interval 1
"

source $VENDOR_SHELL
cmd="torchrun $DISTRIBUTED_ARGS $SCALEHOME/pretrain_gpt.py \
              $TRAINING_ARGS \
              $MIXED_PRECISION_ARGS \
              $DATA_ARGS \
              $NETWORK_ARGS \
              $INITIALIZATION_ARGS \
              $REGULARIZATION_ARGS \
              $LEARNING_RATE_ARGS \
              $LOG_ARGS
    "
echo $cmd
eval $cmd