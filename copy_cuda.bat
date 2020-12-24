@setlocal enabledelayedexpansion

set current_dir=%~dp0
PATH=%~dp0\dist\7-zip;%PATH%
set python_venv=%~dp0\dist\env

IF NOT EXIST "%CUDA_PATH%" (exit)

:set CUDA_PATH="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin"
set CUDA_PATH=.\cuda10
copy %CUDA_PATH%\bin\cublas64_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\cudart32_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\cudart64_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\cudnn64_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\cufft64_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\cufftw64_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\cuinj64_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\curand64_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\cusolver64_*.dll %python_venv% /v /y
copy %CUDA_PATH%\bin\cusparse64_*.dll %python_venv% /v /y

pause
exit

copy %CUDA_PATH%\nppc64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppial64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppicc64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppicom64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppidei64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppif64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppig64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppim64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppist64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppisu64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nppitc64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\npps64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nvblas64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nvgraph64_100.dll %python_venv% /v /y
copy %CUDA_PATH%\nvrtc-builtins64_100.dll %python_venv% /v /y
