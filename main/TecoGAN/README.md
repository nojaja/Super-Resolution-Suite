# TecoGAN

## はじめに
このプロジェクトは自分用（Windows10）にTecoGANを使いやすくするためにソースコードを一部書き換えたものになります。

## 環境構築
まず、以下の「model.zip」をダウンロード

https://ge.in.tum.de/download/data/TecoGAN/model.zip

ダウンロード後、"TecoGAN/model"を作り、その中に解凍したものを入れる

次に、Anacondaのインストール後、「Anaconda Prompt」を起動

以下のコマンドでTecoGANで使用する環境を用意（tcgnの部分は仮想環境の名前なので自由に変更可）

```
conda create -n tcgn python=3.5 anaconda
```

以下を実行し仮想環境に入る

```
conda activate tcgn
```

### GPUを使用する場合
事前にインストールが必要なもの：
- CUDA9
- cuDNN 7.1.x

以下のコマンドを実行

```
conda install tensorflow-gpu keras-gpu opencv
```

### CPUを使用する場合
以下のコマンドを実行

```
conda install tensorflow keras opencv
```

## 実行
以下のコマンドを実行

```
python runGan.py 1
```

「LR」ディレクトリの「test」が処理され「result」ディレクトリ内の同名ファイルに保存される
## 自前の動画を使用したい場合
ffmegを用いてフレームの切り出しを行う

```
ffmpeg -i test.mp4 -vcodec png image_%03d.png
```

画像から動画に戻すときは以下のコマンドを実行

```
ffmpeg -r 24 -i output_image_%03d.png -vcodec libx264 -pix_fmt yuv420p -r 24 test.mp4
```

「24」はフレームレートなので、元の動画のフレームレートに書き換える

## 実行フォルダを変更するには
TecoGAN/runGan.pyの70行目の「test」という部分を任意のフォルダ名に書き換える

```
elif( runcase == 1 ): # inference a trained model

  dirstr = './results/' # the place to save the results
  testpre = ['calendar'] # the test cases  ★ココを別のディレクトリにする
```

## モデルの学習
今後書き加えていきます。

## 参考・引用リンク
https://www.eximradar.jp/?p=1944

https://wells12.com/tecogan-super-resolution/
