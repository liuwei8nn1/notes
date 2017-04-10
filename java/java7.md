#异步IO通道

Java7之前，要异步实现对大文件的读写，借助java.util.concurrent中的相关类库也是可以实现的，只是依然会比较繁琐，实现起来也不是那么轻松。

Java7直接提供了用于异步操作io的各种通道。

新的异步功能的关键点，它们是Channel类的一些子集。包括：

AsynchronousFileChannel：针对文件；
AsynchronousSocketChannel ：针对客户端的socket；
AsynchronousServerSocketChannel：针对服务器端的异步socket，用来接收到来的连接。
一些需要访问较大，耗时的操作，或是其它的类似实例，可以考虑应用此功能。

这里，我们以针对文件的异步操作通道AsynchronousFileChannel来看看怎么用。

<pre><code>
package java7;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.AsynchronousFileChannel;
import java.nio.charset.Charset;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.Future;

/**
 * Created by alan on 2017/4/10.
 */
public class AsyncChannel {

    public static void main(String[] a) throws IOException {
        //定义要打开的文件对应的path
        Path path= Paths.get("/Users/xieqiang/test.txt");

        //打开一个可以异步读写文件的通道
        AsynchronousFileChannel channel=AsynchronousFileChannel.open(path);

        //通道是基于ByteBuff读写的，所以需要声明一个bytebuff来存储要读写的数据
        ByteBuffer bf=ByteBuffer.allocate(1024);//声明1024个字节的buff

        //从0(文件开头)异步读取文件内容到bf,由于是异步操作，不管文件有没有读取完成，这句代码执行后立刻就会执行后面的代码，通过future可以知道结果
        Future future=channel.read(bf,0);
        System.out.println("文件读取中...");
        //如果文件没有读完，可以继续干些别的事情
        while(!future.isDone()){
            System.out.println("我干别的了，你慢慢读");
        }
        System.out.println("文件读取完成");
        bf.flip();
        //打印bytebuff中的内容
        System.out.println(Charset.forName("utf-8").decode(bf));
        channel.close();
    }
}
</code></pre>
运行结果：
<pre>
文件读取中...
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
我干别的了，你慢慢读
文件读取完成
</pre>
hello,java7
大致原理

创建异步通道时，会创建任务执行线程池，如果没有指定线程池，那会为其分配一个系统默认的线程池。

你可以自己提供和配置一个线程池。参见api

AsynchronousFileChannel open(Path file,
Set<? extends OpenOption> options,
ExecutorService executor,
FileAttribute<?>... attrs)

执行异步操作时，会让线程池(executors)执行返回一个Future，
如果你熟悉java.util.concurrent的工具，应该不难理解。否则，
你应该去好好学习下java.util.concurrent中的相关技术。

#java7允许我们随机访问文件。

所谓随机访问就是允许我们不按照顺序的访问文件的内容，这里的访问包括读和写。

要随机的访问文件，我们就要打开文件，定位到指定的位置，然后读或写文件内容。

在Javs7中，SeekableByteChannel接口提供了这个功能。

SeekableByteChannel提供了一些简单易用的方法。依靠这些方法，我们能够设置或查询当前的位置，然后从当前位置读或者往当前位置写。

该接口提供的方法有：

    position – 查询通道当前的位置
    position(long) – 设置通道当前的位置
    read(ByteBuffer) – 从通道向缓冲区读字节内容
    write(ByteBffer) – 将缓冲区内的字节内容写入通道
    truncate(long) – 截断连接到通道的文件（或其他实体）

FileChannel实现了该接口。
	
在实际的使用中，我们可以用FileChannel.open获取一个 FileChannel。
 
FileChannel提供了一些高级的特性，如将文件的一部分直接映射到内存中来提高访问速度、锁定文件的一部分、直接在指定的绝对位置读或写而不影 响通道的当前位置等。

示例：
<pre><code>
package java7;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

/**
 * @author alan
 * @date 2017/4/10
 */
public class SeekChannal {

    public static void main(String[] arg) throws IOException {
        FileChannel fileChannel=FileChannel.open(Paths.get("f:\\test.txt"), StandardOpenOption.WRITE,StandardOpenOption.READ,StandardOpenOption.CREATE);
        fileChannel.write(ByteBuffer.wrap("hello,java".getBytes()));
        fileChannel.position(0);//定位到文件开头
        fileChannel.write(ByteBuffer.wrap("seek".getBytes()));
        fileChannel.position(fileChannel.size());//定位到文件末尾
        fileChannel.write(ByteBuffer.wrap("end".getBytes()));

        //将通道中的指定位置开始的内容传输到另一个通道中，这里传输到控制台
       fileChannel.transferTo(1,fileChannel.size(), Channels.newChannel(System.out));
    }
}
</code></pre>
该示例打开一个test.txt文件通道，先写入hello,java,然后再定位到文件开头，写入seek,这意味着会覆盖最开始的hell四个字符，然后定位到文件末尾，再写入end。然后通过transferTo将文件内容传入到控制台。

运行结果：
eeko,javaend


#java7快速读写文件


1.打开文件

Java 7可以直接用带缓冲区的读取器和写入器或输入输出流（为了和以前的Java I/O代码兼容）打开文件。下面的代码演示了Java 7如何用Files.newBufferedReader方法打开文件并按行读取其中的内容。

BufferedWriter writer=Files.newBufferedWriter(path, Charset.forName("utf-8"))
注意编码的设置，以防乱码。

打开一个用于写入的文件也很简单。 注意StandardOpenOption.WRITE选项的使用，这是可以添加的几个OpenOption变参之一。它可以确保写入的文件有正确的访问许可。其他常用的文件打开选项还有READ和APPEND。

BufferedWriter writer=Files.newBufferedWriter(path, Charset.forName("utf-8"), StandardOpenOption.APPEND);      
2.简化读取和写入 辅助类Files有两个辅助方法，用于读取文件中的全部行和全部字节。也就是说你没必要再用while循环把数据从字节数组读到缓冲区里去。

完整示例代码
<pre><code>
package java7;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.*;
import java.util.List;

/**
 * Created by alan on 2017/3/30.
 */public class QuickReadAndWrite {
    public static void main(String[] a) throws IOException {        Path path= Paths.get("/Users/xieqiang/test.txt");        try(            //如果文件存在则直接打开，否则创建文件    
            BufferedWriter writer=Files.newBufferedWriter(path, Charset.forName("utf-8"));            
            //可以指定打开文件的模式，这里表示追加文件
            //BufferedWriter writer=Files.newBufferedWriter(path, Charset.forName("utf-8"), StandardOpenOption.APPEND);
        ) {
            writer.write("hello,java7");
            writer.newLine();
            writer.write("test");
            System.out.println("ok");
        }        
        List<String> lines= Files.readAllLines(path);
        System.out.println(lines);
    }
}
</code></pre>