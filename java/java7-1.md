##Java7语言特性一

Java7新特性
虽然现在都使用Java8了，但是Java7的新特性你是否都知道了呢

1.自动资源管理(TWR)--try with resource

Java中某些资源是需要手动关闭的，如InputStream，Writes，Sockets，Sql classes等。这个新的语言特性允许try语句本身申请更多的资源，这些资源作用于try代码块，并自动关闭。

以前的写法：

          BufferedReader br = new BufferedReader(new FileReader(path));
          try {
                  return br.readLine();
               } finally {
                    br.close();
               } 
现在可以：（有点像C#）

          try (BufferedReader br = new BufferedReader(new FileReader(path)) {
              return br.readLine();
          } 


  

2.钻石语法
  

类型推断是一个特殊的烦恼，如下面的代码：

1 Map<String, List<String>> anagrams = new HashMap<String, List<String>>(); 
通过类型推断后变成：

1 Map<String, List<String>> anagrams = new HashMap<>();
注：这个<>被叫做diamond（钻石）运算符，Java 7后这个运算符从引用的声明中推断类型。


3.数字字面量下划线支持

很长的数字可读性不好，在Java 7中可以使用下划线分隔长int以及long了。如：

int one_million = 1_000_000;
这个跟int one_million=1000000;是一致的效果

4.switch中使用string

  以前在switch中只能使用number或enum。现在可以使用string了


 5.二进制字面量

由于继承C语言，Java代码在传统上迫使程序员只能使用十进制，八进制或十六进制来表示数(numbers)。

由于很少的域是以bit导向的，这种限制可能导致错误。你现在可以使用0b前缀创建二进制字面量：

1 int binary = 0b1001_1001; 
 现在，可以使用二进制字面量这种表示方式，并且使用非常简短的代码，可将二进制字符转换为数据类型，如在byte或short。

1 byte aByte = (byte)0b001;    
2  short aShort = (short)0b010;

6.改善后的异常处理

一个catch子句捕获多个异常

在Java7之前的异常处理语法中，一个catch子句只能捕获一类异常。在要处理的异常种类很多时这种限制会很麻烦。每一种异常都需要添加一个catch子句，而且这些catch子句中的处理逻辑可能都是相同的，从而会造成代码重复。虽然可以在catch子句中通过这些异常的基类来捕获所有的异常，比如使用Exception作为捕获的类型，但是这要求对这些不同的异常所做的处理是相同的。另外也可能捕获到某些不应该被捕获的非受检查异常。而在某些情况下，代码重复是不可避免的。比如某个方法可能抛出4种不同的异常，其中有2种异常使用相同的处理方式，另外2种异常的处理方式也相同，但是不同于前面的2种异常。这势必会在catch子句中包含重复的代码。

对于这种情况，Java7改进了catch子句的语法，允许在其中指定多种异常，每个异常类型之间使用“|”来分隔。如例：
try {
            //..............
        } catch (ExceptionA | ExceptionB ab) { 
        } catch (ExceptionC c) {    
        }


异常重抛

在意外的异常处理中，经常有如下代码：
    try {
            //..............
        
        } catch (Exception c) {    
            throw c;
        }
  这样你捕获的真实异常可能是IOException，然而你抛出的会是Exception，真正的异常类型丢失了，Java7中抛出的却会是真实的异常类型，这被称为异常重抛。为了能意识到这个作用，建议在过渡期添加一个final关键字，虽然不是必须的：
 try {
            //..............
        
        } catch (final Exception c) {    
            throw c;
        }