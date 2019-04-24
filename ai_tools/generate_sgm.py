#coding=utf-8
#生成sgm文件用于计算中文bleu

import os
import argparse

def get_sgm(fplain, fsgm, mode):
    pline = fplain.readline().replace('\n', '')
    if mode == 'src':
        fsgm.write('<srcset setid="newsdev2017" srclang="en">\n<doc sysid="ref" docid="abcnews.199680" genre="news" origlang="en">')
    elif mode == 'tgt':
        fsgm.write('<refset setid="newsdev2017" srclang="en" trglang="zh">\n<doc sysid="ref" docid="abcnews.199680" genre="news" origlang="en">')
    else:
        fsgm.write('<tstset trglang="zh" setid="newsdev2017" srclang="en">\n<DOC sysid="DemoSystem" sysid="ref" docid="abcnews.199680" genre="news" origlang="en">')
    cnt = 1
    while pline is not None and pline != '':
        fsgm.write('\n<seg id="' + str(cnt) + '">' + pline + '</seg>')
        pline = fplain.readline().replace('\n', '')
        cnt += 1
    if mode == 'src':
        fsgm.write('\n</doc>\n</srcset>\n')
    elif mode == 'tgt':
        fsgm.write('\n</doc>\n</refset>\n')
    else:
        fsgm.write('\n</doc>\n</tstset>\n')

def generate_sgm(args):
    if not os.path.exists(args.save_dir):
        os.mkdir(args.save_dir)
    if args.save_dir[-1] == '/':
        save_dir = args.save_dir
    else:
        save_dir = args.save_dir + '/'
    fsrc = open(args.src_path, 'r')
    ftgt = open(args.tgt_path, 'r')
    finfer = open(args.infer_path, 'r')
    fsrc_sgm = open(save_dir + 'src.sgm', 'w')
    ftgt_sgm = open(save_dir + 'ref.sgm', 'w')
    finfer_sgm = open(save_dir + 'hyp.sgm', 'w')
    get_sgm(fsrc, fsrc_sgm, 'src')
    get_sgm(ftgt, ftgt_sgm, 'tgt')
    get_sgm(finfer, finfer_sgm, 'infer')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='test')
    parser.add_argument('--save-dir', type=str, default=None,
                        help=None)
    parser.add_argument('--src-path', type=str, default=None,
                        help=None)
    parser.add_argument('--tgt-path', type=str, default=None,
                        help=None)
    parser.add_argument('--infer-path', type=str, default=None,
                        help=None)
    args = parser.parse_args()
    generate_sgm(args)
