# escape=`

ARG BASE_TAG=latest_1803

FROM mback2k/windows-buildbot-mingw:${BASE_TAG}

USER ContainerAdministrator

SHELL ["powershell", "-command"]

ARG MINGW_W64_X86="https://prdownloads.sourceforge.net/mingw-w64/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/8.1.0/threads-win32/sjlj/i686-8.1.0-release-win32-sjlj-rt_v6-rev0.7z?download"
ARG MINGW_W64_X64="https://prdownloads.sourceforge.net/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-win32/sjlj/x86_64-8.1.0-release-win32-sjlj-rt_v6-rev0.7z?download"

RUN curl.exe -L "$env:MINGW_W64_X86" --output "C:\Windows\Temp\mingw-w64-x86.7z"; `
    Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, "C:\Windows\Temp\mingw-w64-x86.7z", `-oC:\MinGW\mingw-w64 -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Get-Item -Path 'C:\MinGW\mingw-w64\mingw32';

RUN curl.exe -L "$env:MINGW_W64_X64" --output "C:\Windows\Temp\mingw-w64-x64.7z"; `
    Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, "C:\Windows\Temp\mingw-w64-x64.7z", `-oC:\MinGW\mingw-w64 -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Get-Item -Path 'C:\MinGW\mingw-w64\mingw64';

RUN Add-Content -Path 'C:\MinGW\msys\1.0\etc\fstab' -Value 'C:/MinGW/mingw-w64/mingw32 /mingw32'; `
    Add-Content -Path 'C:\MinGW\msys\1.0\etc\fstab' -Value 'C:/MinGW/mingw-w64/mingw64 /mingw64';

ADD scripts/mingw32.sh C:\MinGW\msys\1.0\bin\mingw32.sh
ADD scripts/mingw64.sh C:\MinGW\msys\1.0\bin\mingw64.sh

USER Buildbot
