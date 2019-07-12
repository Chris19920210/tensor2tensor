USR_DIR=/home/wudong/t2t_aan/preprocess
PROBLEM=translatespm_enzh_ai32k
DATA_DIR=/home/wudong/t2t_aan/t2t_data_bpe_tok_enzh_same_all_32k
#TMP_DIR=/home/chenrihan/nmt_datasets_1
MODEL=aan_transformer
HPARAMS=aan_transformer_base
TRAIN_DIR=/home/wudong/t2t_aan/$PROBLEM/$MODEL-$HPARAMS-bpe-tok-xl-64
export CUDA_VISIBLE_DEVICES=6,7
export PYTHONPATH=$USR_DIR:$PYTHONPATH

t2t-trainer \
  --data_dir=$DATA_DIR \
  --problem=$PROBLEM \
  --model=$MODEL \
  --hparams_set=$HPARAMS \
  --output_dir=$TRAIN_DIR \
  --t2t_usr_dir=$USR_DIR \
  --train_steps=1300000 \
  --hparams="batch_size=8192,split_targets_chunk_length=64" \
  --random_seed=210 \
  --worker_gpu=2