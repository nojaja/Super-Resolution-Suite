@setlocal enabledelayedexpansion

set current_dir=%~dp0
PATH=%~dp0\dist\7-zip;%PATH%

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

curl -o ./dist/env/get-pip.py https://bootstrap.pypa.io/get-pip.py
rem python ./dist/get-pip.py

curl -o ./dist/tmp/model.zip https://ge.in.tum.de/download/data/TecoGAN/model.zip
tar -xf ./dist/tmp/model.zip -C ./dist/TecoGAN/model

curl -L -o ./dist/tmp/waifu2x-ncnn-vulkan.zip https://github.com/nihui/waifu2x-ncnn-vulkan/releases/download/20200818/waifu2x-ncnn-vulkan-20200818-windows.zip
rem tar -xf ./dist/tmp/waifu2x-ncnn-vulkan.zip -C ./dist/waifu2x
7z x -aoa -o./dist/waifu2x_/ ./dist/tmp/waifu2x-ncnn-vulkan.zip

for /d %i in (dist\waifu2x_\*) do (rename .\%i waifu2x)
move /Y .\dist\waifu2x_\waifu2x .\dist\waifu2x
rd .\dist\waifu2x_

curl -o ./dist/tmp/ffmpeg.7z https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-4.3.1-2020-11-19-full_build.7z
7z x -aoa -o./dist/ffmpeg_/ ./dist/tmp/ffmpeg.7z

for /d %i in (dist\ffmpeg_\*) do (rename .\%i ffmpeg)
move /Y .\dist\ffmpeg_\ffmpeg .\dist\ffmpeg
rd .\dist\ffmpeg_

