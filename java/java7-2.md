##Java7新特性二

Java7新特性之IO
虽然现在都使用Java8了，但是Java7的新特性你是否都知道了呢?

Java7中重大的变更之一是新的IO及NIO操作。

Path

在新的文件I/O中，Path是必须掌握的关键类之一，用Path对象来实现对文件或者文件夹的操作。Path通常代表文件系统中的位置，比如C:\workspace\java7developer（Windows文件系统中的目录）或/usr/bin/zip（*nix文件系统中zip程序的位置）。

注意：Path是一个抽象构造，你所创建和处理的Path可以不马上绑定到对应的物理位置上。

java.nio.file.Paths 包含了用于创建Path对象的静态方法
java.nio.file.Path 包含了大量用于操纵文件路径的方法
java.nio.file.FileSystems 用于访问文件系统的类
java.nio.file.FileSystem 代表了一种文件系统，例如Unix下的根目录为 / ，而Windows下则为C盘

一旦获得某个路径对应的Path对象，我们就能方便的获取文件系统中的各种信息，已及操作该path。

获得一个Path对象的方法有很多，主要有以下两种：

使用FileSystem对象的getPath方法
使用Path对象的get方法

    Path path = FileSystems.getDefault().getPath("F:\\test.txt");
    System.out.printf("文件名称: %s\n", path.getFileName());
    System.out.printf("根目录: %s\n", path.getRoot());
    for (int index = 0; index < path.getNameCount(); index++) {
        System.out.printf("getName(%d): %s\n", index, path.getName(index));
    }
    System.out.printf("路径截取: %s\n", path.subpath(0, 2));
    System.out.printf("父目录: %s\n", path.getParent());
    System.out.println("是否绝对路径:"+path.isAbsolute());

    path = Paths.get("F", "test.txt");
    System.out.printf("绝对路径地址: %s", path.toAbsolutePath());

示例中FileSystems的getDefault方法，会由JVM返回一个代表了当前文件系统的FileSystem对象，我们可以通过FileSystem来获得Path对象。

一个Path可以由多个子Path组成，子Path可以可通用过subpath方法来获得。

使用Paths类的get方法同样可以获得一个Path对象，如果你查看JDK的源码你会发现，它的实现方式和用FileSystem是一样的。

获取文件信息

获得了文件path对象后，我们可以使用新的Files.readAttributes轻松获取文件的详细信息

Path path = Paths.get("D:/home/projects/note.txt");
    BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
    System.out.println("Creation Time: " + attributes.creationTime());
    System.out.println("Last Accessed Time: " + attributes.lastAccessTime());
    System.out.println("Last Modified Time: " + attributes.lastModifiedTime());
    System.out.println("File Key: " + attributes.fileKey());
    System.out.println("isDirectory: " + attributes.isDirectory());
    System.out.println("Other Type of File: " + attributes.isOther());
    System.out.println("Regular File: " + attributes.isRegularFile());
    System.out.println("Symbolic File: " + attributes.isSymbolicLink());
    System.out.println("Size: " + attributes.size());


操作文件

通用，Java7也提供了简单的api可以让我们非常简单的复制、移动和删除文件以及路径。

    Path directoryPath = Paths.get("D:/home/sample");
    //创建目录
    Files.createDirectory(directoryPath);
    System.out.println("Directory created successfully!");
    Path filePath = Paths.get("D:/home/sample/test.txt");
    //创建文件
    Files.createFile(filePath);
    System.out.println("File created successfully!");

在调用createFile方法时，如果想要创建的文件已经存在，FileAlreadyExistsException会被抛出。createFile和createDirectory这个两个方法都是原子性的，即要不整个操作都能成功或者整个操作都失败。

复制一个文件同样非常简单，Files的copy方法就可以实现。在复制文件时，我们可以对复制操作加一个参数来指明具体如何进行复制。
java.lang.enum.StandardCopyOption这个枚举可以用作参数传递给copy方法。

ATOMIC_MOVE	原子性的复制
COPY_ATTRIBUTES	将源文件的文件属性信息复制到目标文件中
REPLACE_EXISTING	替换已存在的文件

删除文件可以使用Files的delete和deleteIfExists这两个方法。顾名思义，当文件不存在时deleteIfExists的删除结果为false。


Path newFile = Paths.get("D:/home/sample/newFile.txt");
Path copiedFile = Paths.get("D:/home/sample/copiedFile.txt");
Files.createFile(newFile);
System.out.println("File created successfully!");
Files.copy(newFile, copiedFile, StandardCopyOption.REPLACE_EXISTING);
System.out.println("File copied successfully!");
Path sourceFile = Paths.get("D:/home/projects/note_bak1.txt");
boolean result = Files.deleteIfExists(sourceFile);
if (result) {
    System.out.println("File deleted successfully!");
}
sourceFile = Paths.get("D:/home/projects/note_bak2.txt");
Files.delete(sourceFile);
System.out.println("File deleted successfully!");

为了便于将Java7之前的File转换成Path，Java7中对File类新增了一个toPath方法，用来将一个File转换成Path，这样我们就可以基于Path使用新的Java io api了。

忘记java.io.File，忘记之前的操作文件的方式吧！