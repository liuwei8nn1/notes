##Java7新特性三——遍历目录与目录树

Java7新特性之遍历目录树
虽然现在都使用Java8了，但是Java7的新特性你是否都知道了呢?

Java7之前，虽然能做到遍历目录与目录树，但比较麻烦，需要自己编码。

新的IO基于Path提供了方便的目录与目录树遍历及过滤等，非常简单方便。

目录遍历

通过Files的工具方法，可以获取某个path对应的DirectoryStream接口，通过此接口就能遍历改path下面(直接子path)的项目。

      Path dir= Paths.get("f:\\");
        //得到改path的目录流接口
        DirectoryStream<Path> directoryStream = Files.newDirectoryStream(dir);
      
        for(Path item : directoryStream){
            System.out.println(item.toAbsolutePath()+":"+item.getFileName());
        }

也可以方便的过滤某些形式的文件，如：
         //得到改path下所有.txt文件的目录流接口
        DirectoryStream<Path> txtStream=Files.newDirectoryStream(dir,"*.txt");

        System.out.println("===txt===");

        for(Path item : txtStream){
            System.out.println(item.toAbsolutePath()+":"+item.getFileName());
        }

目录树遍历

    新的api支持递归的遍历整改目录下的所有目录及文件。
   通过Files.walkFileTree(path,fileVisittor))即可实现。
第一个参数是要遍历的path
第二个参数是一个遍历过程中的处理接口FileVisitor。它提供了遍历文件树的各种操作：
 
	preVisitDirectory - 一个路径被访问时调用
 
	PostVisitDirectory - 一个路径的所有节点被访问后调用。如果有错误发生，exception会传递给这个方法
 
	visitFile - 文件被访问时被调用。该文件的文件属性被传递给这个方法
 
	visitFileFailed - 当文件不能被访问时，此方法被调用。Exception被传递给这个方法。
 
	如果你比较懒，不想实现所有方法。你可以选择继承 SimpleFileVisitor。它帮你实现了上述方法，你只需Override 你感兴趣的方法。

一个实例：
<pre><code>
package java7;

import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;

/**
 * 使用Java7提供的api进行目录及目录树遍历
 * @author qiang.xie
 * @date 2017/3/29
 */
public class DirList {

    public static void main(String[] arg) throws IOException {
        Path dir= Paths.get("f:\\");
        //得到改path的目录流接口
        DirectoryStream<Path> directoryStream = Files.newDirectoryStream(dir);

        for(Path item : directoryStream){
            System.out.println(item.toAbsolutePath()+":"+item.getFileName());
        }


        //得到改path下所有.txt文件的目录流接口
        DirectoryStream<Path> txtStream=Files.newDirectoryStream(dir,"*.txt");

        System.out.println("===txt===");

        for(Path item : txtStream){
            System.out.println(item.toAbsolutePath()+":"+item.getFileName());
        }

        System.out.println("===dir tree===");


        Files.walkFileTree(dir,new VisitorFile());


    }

    static class VisitorFile extends SimpleFileVisitor<Path>{
        //访问目录及子目录中的每个path的方法
        @Override
        public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
            System.out.println(file.toAbsolutePath()+":"+file.getFileName());
            //表示继续遍历
            return FileVisitResult.CONTINUE;
        }


        //访问某个path失败时调用的方法，默认抛出异常
        @Override
        public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {
            System.out.println(file+";"+exc.getClass());
            //表示继续遍历
            return FileVisitResult.CONTINUE;
        }
    }
}
</code></pre>
