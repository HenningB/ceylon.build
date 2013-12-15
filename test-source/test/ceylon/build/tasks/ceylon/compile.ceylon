import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { compileCommand, all, loader, cmr, benchmark, code, ast }

test void shouldCreateCompileCommand() {
    assertEquals{
        expected = "compile mymodule";
        actual = compileCommand {
            currentWorkingDirectory = null;
            modules = ["mymodule"];
            encoding = null;
            sourceDirectories = [];
            resourceDirectories = [];
            javacOptions = null;
            outputRepository = null;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            user = null;
            password = null;
            offline = false;
            noDefaultRepositories = false;
            systemProperties = [];
            verboseModes = [];
            arguments = [];
        };
    };
}

test void shouldCreateCompileCommandWithAllVerboseFlag() {
    assertEquals{
        expected = "compile --verbose myfile.ceylon";
        actual = compileCommand {
            currentWorkingDirectory = null;
            modules = [];
            files = ["myfile.ceylon"];
            encoding = null;
            sourceDirectories = [];
            resourceDirectories = [];
            javacOptions = null;
            outputRepository = null;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            user = null;
            password = null;
            offline = false;
            noDefaultRepositories = false;
            systemProperties = [];
            verboseModes = all;
            arguments = [];
        };
    };
}

test void shouldCreateCompileCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "compile --cwd=. --encoding=UTF-8 --source=source-a --source=source-b" +
                " --resource=resource-a --resource=resource-c" +
                " --javac=-g:source,lines,vars --out=~/.ceylon/repo --rep=dependencies" +
                " --sysrep=system-repository --cacherep=cache-rep --user=ceylon-user --pass=ceylon-user-password" +
                " --offline --no-default-repositories" +
                " --define=ENV_VAR1=42 --define=ENV_VAR2=foo --verbose=loader,ast,code,cmr,benchmark" +
                " --source=foo --source=bar module1 module2 file1.ceylon file2.ceylon";
        actual = compileCommand {
            currentWorkingDirectory = ".";
            modules = ["module1", "module2"];
            files = ["file1.ceylon", "file2.ceylon"];
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            resourceDirectories = ["resource-a", "resource-c"];
            javacOptions = "-g:source,lines,vars";
            outputRepository = "~/.ceylon/repo";
            repositories = ["dependencies"];
            systemRepository = "system-repository";
            cacheRepository = "cache-rep";
            user = "ceylon-user";
            password = "ceylon-user-password";
            offline = true;
            noDefaultRepositories = true;
            systemProperties = ["ENV_VAR1" -> "42", "ENV_VAR2" -> "foo"];
            verboseModes = [loader, ast, code, cmr, benchmark];
            arguments = ["--source=foo", "--source=bar"];
        };
    };
}
