@echo off
REM Save the current DOCKER_HOST (if set)
set "oldDockerHost=%DOCKER_HOST%"

REM Temporarily override DOCKER_HOST to use the local Docker daemon on port 2375
set "DOCKER_HOST=tcp://127.0.0.1:2375"
set env=%settix_cluster%
set host=%COMPUTERNAME%
set wrkdir="%CD%\src\One.StepTracking.Configuration\public:/confs"
echo DOCKER_HOST temporarily set to %DOCKER_HOST%

CALL :setVaraiabless One.StepTracking.Service.json One.StepTracking.Service

REM Run the Docker command; ensure your current directory is the project root

goto :eof
:setVaraiabless
SETLOCAL
set file=%1
set app=%2

echo Calling... Sett1x.exe open -a %app% -c %env% -m %host% -j %file% -o consul -h http://consul.local.com:8500

docker run --rm ^
  -v %wrkdir% ^
  1softwareorg/sett1x.cli ^
  open -d /confs -a %app% -c %env% -m %host% -j %file% -o consul -h http://consul.local.com:8500

REM Restore the original DOCKER_HOST value
set "DOCKER_HOST=%oldDockerHost%"
echo DOCKER_HOST restored to %DOCKER_HOST%