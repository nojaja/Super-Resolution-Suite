@setlocal enabledelayedexpansion

set current_dir=%~dp0
PATH=%~dp0\dist\7-zip;%PATH%
set python_venv=%~dp0\dist\env

rem xcopy main dist\main /e/h/c/i/q
xcopy main dist /e/h/c/i/q

mkdir dist
mkdir dist\env
mkdir dist\tmp
mkdir dist\results
mkdir dist\LR
mkdir dist\LR\catalog
mkdir dist\TecoGAN\model

curl -o ./dist/tmp/python.zip https://www.python.org/ftp/python/3.7.9/python-3.7.9-embed-amd64.zip
tar -xf ./dist/tmp/python.zip -C ./dist/env/
PATH=%python_venv%;%python_venv%\Library\mingw-w64\bin;%python_venv%\Library\usr\bin;%python_venv%\Library\bin;%python_venv%\Scripts;%python_venv%\bin;%PATH%

del /Q .\dist\env\python37._pth

rem Microsoft Visual C++ 2015 再頒布可能パッケージ Update 3
rem https://www.microsoft.com/ja-jp/download/confirmation.aspx?id=53587&6B49FDFB-8E5B-4B07-BC31-15695C5A2143=1

curl -o ./dist/env/get-pip.py https://bootstrap.pypa.io/get-pip.py
python ./dist/env/get-pip.py

rem echo import site >> ./dist/env/python37._pth
rem echo ./Lib/site-packages >> ./dist/env/python37._pth

rem curl -o ./dist/env/termcolor.whl https://download.lfd.uci.edu/pythonlibs/z4tqcw5k/termcolor-1.1.0-py2.py3-none-any.whl

rem pip install ./dist/env/termcolor.whl

rem pip install youtube-dl
rem pip install future
pip install certifi
pip install wincertstore

rem pip install importlib-metadata==1.7.0
rem pip install traitlets==4.3.3

rem pip3 install --ignore-installed --upgrade tensorflow-gpu # or tensorflow
pip install tensorflow-gpu==1.15.4
rem pip install tensorflow==1.15.4
pip install keras==2.3.1
rem pip install keras-gpu
rem pip install opencv
pip install opencv-python==4.3.0.36
pip install scikit-image==0.17.2
pip install numpy==1.16.0

pip3 install -r ./dist/TecoGAN/requirements.txt

curl -o ./dist/tmp/model.zip https://ge.in.tum.de/download/data/TecoGAN/model.zip
tar -xf ./dist/tmp/model.zip -C ./dist/TecoGAN/model

curl -o ./dist/tmp/ofrvsr.zip http://ge.in.tum.de/download/2019-TecoGAN/FRVSR_Ours.zip
tar -xf ./dist/tmp/ofrvsr.zip -C ./dist/TecoGAN/model

rem curl -L -o ./dist/tmp/waifu2x-ncnn-vulkan.zip https://github.com/nihui/waifu2x-ncnn-vulkan/releases/download/20200818/waifu2x-ncnn-vulkan-20200818-windows.zip
rem 7z x -aoa -o./dist/waifu2x_/ ./dist/tmp/waifu2x-ncnn-vulkan.zip

rem for /d %i in (dist\waifu2x_\*) do (rename .\%i waifu2x)
rem move /Y .\dist\waifu2x_\waifu2x .\dist\waifu2x
rem rd .\dist\waifu2x_

curl -L -o ./dist/tmp/waifu2x-caffe.zip https://github.com/lltcggie/waifu2x-caffe/releases/download/1.2.0.4/waifu2x-caffe.zip
7z x -aoa -o./dist/waifu2x_/ ./dist/tmp/waifu2x-caffe.zip
for /d %%i in (dist\waifu2x_\*) do (rename .\%%i waifu2x)
move /Y .\dist\waifu2x_\waifu2x .\dist\waifu2x
rd .\dist\waifu2x_


curl -o ./dist/tmp/ffmpeg.7z https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-4.3.1-2020-11-19-full_build.7z
7z x -aoa -o./dist/ffmpeg_/ ./dist/tmp/ffmpeg.7z
for /d %%i in (dist\ffmpeg_\*) do (rename .\%%i ffmpeg)
move /Y .\dist\ffmpeg_\ffmpeg .\dist\ffmpeg
rd .\dist\ffmpeg_

rem CUDA_PATH
