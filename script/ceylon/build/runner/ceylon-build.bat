@echo off
setlocal EnableDelayedExpansion

set "USAGE=[<compiler-option...>] <module>/<version> <goal>..."
set "DESCRIPTION=Runs your ceylon.build script"
set LONG_USAGE=This command compiles and runs your build project, ^
written for ceylon.build^

^

For running your build, you need to provide the module and ^
version of your build script. Furthermore you need to ^
provide the goals to run.^

^

Default source directory for the build script is ^
'./build-source'. You can also use the compiler options ^
described below for compiling the build module.^

^

OPTIONS^

^

--cacherep=url^

Specifies the folder to use for caching downloaded modules. (^
default: '~/.ceylon/cache')^

^

--cwd=dir^
Specifies the current working directory for this tool. (default: ^
the directory where the tool is run from)^

^

--define=key=value^

Set a system property^

^

--encoding=encoding^

Sets the encoding used for reading source files(default: platform-^
specific).^

^

--javac=option^

Passes an option to the underlying java compiler.^

^

--no-default-repositories^

Indicates that the default repositories should not be used.^

^

--offline^

Enables offline mode that will prevent connections to remote ^
repositories.^

^

--rep=url^

Specifies a module repository containing dependencies. Can be ^
specified multiple times. (default: 'modules', '~/.ceylon/repo', '^
http://modules.ceylon-lang.org/repo/1')^

^

--resource=dirs^

Path to directory containing resource files. Can be specified ^
multiple times; you can also specify several paths separated by ^
your operating system's 'PATH' separator. (default: './resource')^

^

--source=dirs^

An alias for '--src' (default: './build-ource')^

^

--src=dirs^

Path to directory containing source files. Can be specified ^
multiple times; you can also specify several paths separated by ^
your operating system's 'PATH' separator. (default: ^
'./build-source')^

^

--sysrep=url^

Specifies the system repository containing essential modules. (^
default: '$CEYLON_HOME/repo')^



rem two empty lines required

call %CEYLON_HOME%\bin\ceylon-sh-setup %*

if "%errorlevel%" == "1" (
    exit /b 0
)

%CEYLON% run ceylon.build.runner/1.1.1 %*
