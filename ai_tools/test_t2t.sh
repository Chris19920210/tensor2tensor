#!/bin/bash
USR_DIR=/home/chenrihan/DipML/preprocess
PROBLEM=translatespm_enzh_ai32k
MODEL=aan_transformer
HPARAMS=transformer_base
DATA_DIR=/home/chenrihan/nmt_datasets_spm/t2t_data_bpe_tok_enzh_same_all_32k
TRAIN_DIR=/home/chenrihan/nmt/t2t_train/$PROBLEM/$MODEL-$HPARAMS-bpe-tok
BEAM_SIZE=5
ALPHA=0.9
INFER_RESULT=infer_result.txt
export CUDA_VISIBLE_DEVICES=6
export PYTHONPATH=/home/chenrihan/DipML/preprocess:$PYTHONPATH


t2t-decoder \
  --data_dir=$DATA_DIR \
  --problem=$PROBLEM \
  --model=$MODEL \
  --t2t_usr_dir=$USR_DIR \
  --hparams_set=$HPARAMS \
  --output_dir=$TRAIN_DIR \
  --decode_hparams="beam_size=$BEAM_SIZE,alpha=$ALPHA,batch_size=10" \
  --decode_from_file=/home/chenrihan/nmt_datasets_final/test/ai_challenger_en-zh.en.tok.test \
  --decode_to_file=$INFER_RESULT
