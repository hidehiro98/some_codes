# https://codeiq.jp/magazine/2017/03/49158/
# coding: UTF-8

import math
from janome.tokenizer import Tokenizer
import os

class NaiveBayes():
    def __init__(self):# 学習結果を記録するobjectたち
        self.categories={}#{文書のカテゴリc:カテゴリcに属する文書の数}
        self.words={}#{文書のカテゴリc:{単語w:カテゴリcの文書全体での単語wの出現数}}
        self.smoothing=1#初見の単語の確率
        self.texts={}#学習データ{カテゴリc:[カテゴリcの文書]}

#与えられたディレクトリに入ったテキストファイルを学習データに加工する
    def pre_training(self, dir):
        self.texts={c.name:[] for c in os.scandir(dir) if c.is_dir()}
        for c in self.texts:
            file_list=[dir+'/'+c+'/'+f.name for f in os.scandir('train_data/'+c) if f.name[-3:]=='txt']
            for file in file_list:
                f=open(file,'r')
                text=f.read()
                f.close()
                self.texts[c].append(text)

#実際にテキストファイルの単語の数を数えて学習させる
    def training(self, data):
        self.categories={c:len(data[c]) for c in data}
        self.words={c:{} for c in self.categories}
        for c in data:
            for text in data[c]:
                tokens=self.tokenize(text)
                for w in tokens:
                    if w not in self.words[c]:
                        self.words[c][w]=int()
                    self.words[c][w]+=1

        self.smoothing=.1/(sum([sum(self.words[c].values()) for c in self.categories]))#初見の単語の確率を小さく設定

#学習済み分類器をつかって与えられた文書の分類をする
    def classification(self, test, uselog=True):
        p_categories=probability(self.categories)
        p_words={c:probability(self.words[c]) for c in self.categories}
        test=self.tokenize(test)
        results={}

        #以下がベイズの定理を使うところ。ここではlogを使って実装している。
        if uselog:
            for c in self.categories:
                results[c]=math.log(p_categories[c])
                for t in test:
                    if t in self.words[c].keys():
                        results[c]+=math.log(p_words[c][t])
                    else:
                        results[c]+=math.log(self.smoothing)

        #logを使わないと以下のようになる。
        else:
            for c in self.categories:
                results[c]=p_categories[c]
                for t in test:
                    if t in self.words[c].keys():
                        results[c]*=p_words[c][t]
                    else:
                        results[c]*=self.smoothing
        return results

#与えられた文書を単語に分解する
    def tokenize(self,text):
        tokens=[]
        t=Tokenizer()
        pre_tokens=t.tokenize(text)
        for token in pre_tokens:
            tokens.append(token.surface)
        return tokens

#出現頻度を割合に変換する
def probability(dict):
    return {i:float(dict[i])/sum(dict.values()) for i in dict}


nb=NaiveBayes()
nb.pre_training('train_data')
nb.training(nb.texts)

#テストデータを用意する
file='test.txt'
f=open(file,'r')
text=f.read()
f.close()
#学習済み分類器で分類する
print(nb.classification(text))
