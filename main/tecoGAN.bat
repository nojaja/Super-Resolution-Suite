@echo off
@setlocal enabledelayedexpansion
set current_dir=%~dp0

call envset.bat

cd tecoGAN
:del /Q ./results/LR/calendar/*.png
set filename=%1
echo filename : %filename%


echo ==================================
echo GPU情報
echo ==================================
python -c "from tensorflow.python.client import device_lib;print(device_lib.list_local_devices());"

:分割箇所抽出
echo ==================================
echo 分割箇所抽出
echo ==================================

IF NOT EXIST %current_dir%LR\catalog (
mkdir %current_dir%LR\catalog
ffmpeg -i %filename% -filter:v "select='gt(scene,0.2)',showinfo" -vcodec png -vsync 0 %current_dir%LR/catalog/image_%%05d.png 2>%current_dir%tmp\ffout
) ELSE (
echo ==================================
echo 分割箇所抽出 skip
echo ==================================
)

grep showinfo %current_dir%tmp\ffout | grep "in time_base" | grep "time_base: 1/[0-9.]*" -o | grep [0-9.]*$ -o > %current_dir%tmp\time_base
:pts_timeは精度が低いので自前で計算する
grep showinfo %current_dir%tmp\ffout | grep pts:[0-9.]* -o | grep [0-9.]* -o > %current_dir%tmp\timestamps
grep Stream %current_dir%tmp\ffout | grep "Video: png" | grep "fps, [0-9.]*" -o | grep [0-9.]* -o > %current_dir%tmp\fps

for /f "usebackq" %%A in (`type %current_dir%tmp\time_base`) do set time_base=%%A
echo -----------------------------
echo time_base %time_base%
echo -----------------------------


for /f "usebackq" %%A in (`type %current_dir%tmp\fps`) do set fps=%%A
echo -----------------------------
echo fps %fps%
echo -----------------------------

set st=0
set en=0
set num=1
rem 分割リスト分だけ繰り返す
for /f "tokens=1" %%a in (%current_dir%tmp\timestamps) do (

set st=!en!
for /f "usebackq" %%n in (`powershell -c "&{%%a/%time_base%}"`) do @set en=%%n

set splitid=0!num!
set splitid=!splitid:~-2,2!

echo ==================================
echo 処理開始 split!splitid! !st!-!en!
echo ==================================

rem 画像抽出
echo ----------------------------------
echo 画像抽出 split!splitid! !st!-!en!
echo ----------------------------------
IF NOT EXIST %current_dir%LR/split!splitid!/ (
mkdir %current_dir%LR\split!splitid!
ffmpeg -y -i %filename% -vcodec png -ss !st! -to !en! %current_dir%LR/split!splitid!/image_%%05d.png
) ELSE (
echo 画像抽出 split!splitid! !st!-!en! skip
)

rem 画像ファイルの数からframe数取得

echo -----------------------------
echo 画像ファイルの数からframe数取得
dir /A-D /B "%current_dir%LR\split!splitid!" | find /c /v "" > %current_dir%tmp\frameCount
for /f "usebackq" %%A in (`type %current_dir%tmp\frameCount`) do set frameCount=%%A

echo -----------------------------
echo frame数 !frameCount!
echo -----------------------------

:waifu2x
echo ----------------------------------
echo waifu2x split!splitid! !st!-!en!
echo ----------------------------------
mkdir %current_dir%LR\split!splitid!_2x
rem 2x画像ファイルの数からframe数取得
dir /A-D /B "%current_dir%LR\split!splitid!_2x" | find /c /v "" > %current_dir%tmp\frameCount2x
for /f "usebackq" %%A in (`type %current_dir%tmp\frameCount2x`) do set frameCount2x=%%A
if /I !frameCount! NEQ !frameCount2x! (
 rem waifu2x-caffe-cui --model_dir %current_dir%waifu2x-caffe/models/upconv_7_photo -i LR/split!splitid!/ -m noise --noise_level 3 -p cpu --tta 1 --model_type upconv_7_photo -o LR/split!splitid!_2x/
 rem waifu2x-ncnn-vulkan -m models-upconv_7_photo -i %current_dir%LR/split!splitid!/ -o %current_dir%LR/split!splitid!_2x/ -n 3 -s 2 -j 4,4,4 -x
 rem waifu2x-ncnn-vulkan -m models-upconv_7_photo -i %current_dir%LR/split!splitid!/ -o %current_dir%LR/split!splitid!_2x/ -n 3 -s 2 -x
 waifu2x-caffe-cui --model_dir %current_dir%waifu2x/models/upconv_7_photo -i %current_dir%LR/split!splitid!/ -o %current_dir%LR/split!splitid!_2x/ -m noise --noise_level 3 -p cudnn --tta 1 --model_type upconv_7_photo
) else (
 echo waifu2x split!splitid! !st!-!en! skip
)

rem TecoGAN
echo ----------------------------------
echo TecoGAN split!splitid! !st!-!en!
echo ----------------------------------
mkdir %current_dir%results\split!splitid!_2x
rem 2x画像ファイルの数からframe数取得
dir /A-D /B "%current_dir%results/split!splitid!_2x" | find /c /v "" > %current_dir%tmp\resultsframeCount
for /f "usebackq" %%A in (`type %current_dir%tmp\resultsframeCount`) do set resultsframeCount=%%A
if /I !frameCount! NEQ !resultsframeCount! (
python main.py --cudaID 0 --output_dir %current_dir%results/ --summary_dir %current_dir%results/log/ ^
--mode inference --input_dir_LR %current_dir%LR/split!splitid!_2x --output_pre split!splitid!_2x  ^
--num_resblock 16  --checkpoint ./model/TecoGAN --output_ext png
) else (
 echo TecoGAN split!splitid! !st!-!en! skip
)

:エンコード
echo ----------------------------------
echo ffmpeg split!splitid! !st!-!en!
echo ----------------------------------
if /I !frameCount! EQU !resultsframeCount! (
IF NOT EXIST %current_dir%results/split!splitid!_2x.mp4 (
ffmpeg -y -r %fps% -i %current_dir%results/split!splitid!_2x/output_image_%%05d.png -vcodec h264_nvenc -pix_fmt yuv420p %current_dir%results/split!splitid!_2x.mp4
) 
) ELSE (
echo ffmpeg split!splitid! !st!-!en! skip
)

 set /a num+=1
)


cd %current_dir%