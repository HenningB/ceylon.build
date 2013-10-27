import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { buildCompileCommand, all, loader, cmrloader, benchmark, code, ast }

test void shouldCreateCompileCommand() {
    assertEquals{
        expected = "ceylon compile mymodule";
        actual = buildCompileCommand {
            ceylon = "ceylon";
            currentWorkingDirectory = null;
            compilationUnits = ["mymodule"];
            encoding = null;
            sourceDirectories = [];
            javacOptions = null;
            outputRepository = null;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            user = null;
            password = null;
            offline = false;
            noDefaultRepositories = false;
            verboseModes = [];
            arguments = [];
        };
    };
}

test void shouldCreateCompileCommandWithAllVerboseFlag() {
    assertEquals{
        expected = "ceylon compile --verbose mymodule";
        actual = buildCompileCommand {
            ceylon = "ceylon";
            currentWorkingDirectory = null;
            compilationUnits = ["mymodule"];
            encoding = null;
            sourceDirectories = [];
            javacOptions = null;
            outputRepository = null;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            user = null;
            password = null;
            offline = false;
            noDefaultRepositories = false;
            verboseModes = all;
            arguments = [];
        };
    };
}

test void shouldCreateCompileCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "./ceylon compile --cwd=. --encoding=UTF-8 --src=source-a --src=source-b" +
                " --javac=-g:source,lines,vars --out=~/.ceylon/repo --rep=dependencies" +
                " --sysrep=system-repository --cacherep=cache-rep --user=ceylon-user --pass=ceylon-user-password" +
                " --offline --no-default-repositories --verbose=loader,ast,code,cmrloader,benchmark" +
                " --src=foo --src=bar mymodule1 file1.ceylon file2.ceylon";
        actual = buildCompileCommand {
            ceylon = "./ceylon";
            currentWorkingDirectory = ".";
            compilationUnits = ["mymodule1", "file1.ceylon", "file2.ceylon"];
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            javacOptions = "-g:source,lines,vars";
            outputRepository = "~/.ceylon/repo";
            repositories = ["dependencies"];
            systemRepository = "system-repository";
            cacheRepository = "cache-rep";
            user = "ceylon-user";
            password = "ceylon-user-password";
            offline = true;
            noDefaultRepositories = true;
            verboseModes = [loader, ast, code, cmrloader, benchmark];
            arguments = ["--src=foo", "--src=bar"];
        };
    };
}
