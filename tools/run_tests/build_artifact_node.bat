@rem Copyright 2016, Google Inc.
@rem All rights reserved.
@rem
@rem Redistribution and use in source and binary forms, with or without
@rem modification, are permitted provided that the following conditions are
@rem met:
@rem
@rem     * Redistributions of source code must retain the above copyright
@rem notice, this list of conditions and the following disclaimer.
@rem     * Redistributions in binary form must reproduce the above
@rem copyright notice, this list of conditions and the following disclaimer
@rem in the documentation and/or other materials provided with the
@rem distribution.
@rem     * Neither the name of Google Inc. nor the names of its
@rem contributors may be used to endorse or promote products derived from
@rem this software without specific prior written permission.
@rem
@rem THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
@rem "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
@rem LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
@rem A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
@rem OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
@rem SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
@rem LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
@rem DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
@rem THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
@rem (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
@rem OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set node_versions=0.10.41 0.12.0 1.0.0 1.1.0 2.0.0 3.0.0 4.0.0 5.0.0

set PATH=%PATH%;C:\Program Files\nodejs\;%APPDATA%\npm

del /f /q BUILD || rmdir build /s /q

call npm update || goto :error

mkdir artifacts

for %%v in (%node_versions%) do (
  call node-pre-gyp configure build --target=%%v --target_arch=%1

@rem Try again after removing openssl headers
  rmdir "%HOMEDRIVE%%HOMEPATH%\.node-gyp\%%v\include\node\openssl" /S /Q
  rmdir "%HOMEDRIVE%%HOMEPATH%\.node-gyp\iojs-%%v\include\node\openssl" /S /Q
  call node-pre-gyp build package testpackage --target=%%v --target_arch=%1 || goto :error

  xcopy /Y /I /S build\stage\* artifacts\ || goto :error
)
if %errorlevel% neq 0 exit /b %errorlevel%

goto :EOF

:error
exit /b 1