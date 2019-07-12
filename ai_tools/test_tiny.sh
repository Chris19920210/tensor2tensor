#!/bin/bash
USR_DIR=/home/wudong/t2t_aan/preprocess
PROBLEM=translatespm_enzh_ai32k
DATA_DIR=/home/wudong/t2t_aan/t2t_data_bpe_tok_enzh_same_all_32k
#TMP_DIR=/home/chenrihan/nmt_datasets_1
MODEL=aan_transformer
HPARAMS=aan_transformer_tiny
TRAIN_DIR=/home/wudong/t2t_aan/$PROBLEM/$MODEL-$HPARAMS-bpe-tok

BEAM_SIZE=5
ALPHA=0.9
RESULT_DIR=/home/wudong/t2t_aan/$PROBLEM/$MODEL-res
if [ ! -d $RESULT_DIR  ];then
    mkdir $RESULT_DIR
fi
INFER_RESULT=$RESULT_DIR/infer_result.txt
SRC_TEXT=/home/wudong/nmt_datasets_final/ai_challenger_en-zh.en.tok.test
REF_TEXT=/home/wudong/nmt_datasets_final/ai_challenger_en-zh.zh.tok.test
CODE_BASE=/home/wudong/t2t_aan/tensor2tensor
export CUDA_VISIBLE_DEVICES=3
export PYTHONPATH=$USR_DIR:$PYTHONPATH

t2t-decoder \
  --data_dir=$DATA_DIR \
  --problem=$PROBLEM \
  --model=$MODEL \
  --t2t_usr_dir=$USR_DIR \
  --hparams_set=$HPARAMS \
  --output_dir=$TRAIN_DIR \
  --decode_hparams="beam_size=$BEAM_SIZE,alpha=$ALPHA,batch_size=10" \
  --decode_from_file=$SRC_TEXT \
  --decode_to_file=$INFER_RESULT

python $CODE_BASE/ai_tools/generate_sgm.py --src-path=$SRC_TEXT --tgt-path=$REF_TEXT --infer-path=$INFER_RESULT --save-dir=$RESULT_DIR

python $CODE_BASE/ai_tools/mt-score-main.py -rs $RESULT_DIR/ref.sgm -hs $RESULT_DIR/hyp.sgm -ss $RESULT_DIR/src.sgm --id $PROBLEM-$MODEL-$HPARAMS | tee $RESULT_DIR/$HPARAMS-score
