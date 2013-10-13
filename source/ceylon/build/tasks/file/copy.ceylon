import ceylon.build.task { Task, Context }
import ceylon.file { Path, Resource, Nil, File, Directory, Visitor }

shared class IOException(String message) extends Exception(message) {}
shared class CreateDirectoryException(String message) extends IOException(message) {}
shared class FileCopyException(String message) extends IOException(message) {}

"""Returns a `Task` to copy files and directories from `source` to `destination`
   
   All files in `source` matching `filter` will be copied to same relative path from `source` into `destination`.
   
   If `destination` doesn't exist and `source` is a `Directory`, it will attempt to create missing directories.
   For example, if `destination` is set to `"foo/bar/baz"` but only `"foo"` exists, directories `"foo/bar"` and
   `"foo/bar/baz"` will be created (except if `"foo"` is a `File` in which case `CreateDirectoryException` will
   be thrown)."""
throws(
    `class FileCopyException`,
    "When files with same names already exists in destination and `overwrite` is set to `false`")
throws(
    `class CreateDirectoryException`,
    "If destination doesn't exist and can't be created because parent element in path is not a `Directory`")
shared Task copy(
        "Source path from where files will be taken"
        Path source,
        "Destination path where files will be copied"
        Path destination,
        """If `true`, will overwrite already existing files.
           If `false` and a file with a same name already exist in `destination`, `FileCopyException` will be raised"""
        Boolean overwrite = false,
        "Copy `FileFilter` has to return `true` to copy files, `false` to copy them"
        FileFilter filter = allFiles
        ) {
    return function(Context context) {
        context.writer.info("copying ``source`` to ``destination``");
        try {
            copyFiles(source, destination, overwrite, filter);
            return true;
        } catch (IOException exception) {
            context.writer.error("error during copy");
            context.writer.error(exception.message);
            return false;
        }
    };
}

"""Copies files and directories from `source` to `destination`
   
   All files in `source` matching `filter` will be copied to same relative path from `source` into `destination`.
   
   If `destination` doesn't exist and `source` is a `Directory`, it will attempt to create missing directories.
   For example, if `destination` is set to `"foo/bar/baz"` but only `"foo"` exists, directories `"foo/bar"` and
   `"foo/bar/baz"` will be created (except if `"foo"` is a `File` in which case `CreateDirectoryException` will
   be thrown)."""
throws(
    `class FileCopyException`,
    "When files with same names already exists in destination and `overwrite` is set to `false`")
throws(
    `class CreateDirectoryException`,
    "If destination doesn't exist and can't be created because parent element in path is not a `Directory`")
shared void copyFiles(
        "Source path from where files will be taken"
        Path source,
        "Destination path where files will be copied"
        Path destination,
        """If `true`, will overwrite already existing files.
           If `false` and a file with a same name already exist in `destination`, `FileCopyException` will be raised"""
        Boolean overwrite = false,
        "Copy `FileFilter` has to return `true` to copy files, `false` to copy them"
        FileFilter filter = allFiles
        ) {
    value destinationResource = destination.resource;
    value sourceResource = source.resource;
    if (is Directory sourceResource, is Nil destinationResource) {
        createDirectory(destinationResource);
    }
    Path targettedDestination;
    if (is File sourceResource, is Directory destinationResource) {
        [String*] elements = source.elements;
        assert(nonempty elements);
        value name = elements.last;
        targettedDestination = destination.childPath(name);
    } else {
        targettedDestination = destination;
    }
    source.visit(CopyVisitor(source, targettedDestination, overwrite, filter));
}

shared void createDirectory(Resource directory) {
    if (is Nil directory) {
        createDirectory(directory.path.absolutePath.parent.resource);
        directory.createDirectory();
    } else if (is File directory) {
        throw CreateDirectoryException("cannot create sub-directory of a file: ``directory.path``");
    }
}

class CopyVisitor(
        Path source,
        Path destination,
        Boolean overwrite,
        FileFilter filter
        ) extends Visitor() {
    
    shared actual Boolean beforeDirectory(Directory directory) {
        value target = targetPath(directory.path).resource;
        if (is Nil target) {
            target.createDirectory();
        }
        return true;
    }
    
    shared actual void file(File file) {
        if (filter(file)) {
            value target = targetPath(file.path).resource;
            if (is Nil target) {
                file.copy(target);
            } else if (is File target) {
                if (overwrite) {
                    file.copyOverwriting(target);
                } else {
                    throw FileCopyException("destination file ``target.path`` already exists");
                }
            } else {
                throw FileCopyException("destination file ``target.path`` already exists and is a directory");
            }
        }
    }
    
    Path targetPath(Path path) {
        value pathFromRootSource = path.relativePath(source);
        return destination.childPath(pathFromRootSource.string);
    }
}
