# What's this?

This software generates an HTML Help(CHM) from generic javadoc style API documents.
It's a easy way to search something from javadoc with pre-compiled full text index.

# Requirements

- [Ruby](http://www.ruby-lang.org/) ([JRuby](http://jruby.codehaus.org/) enabled)
- [HTML Help Workshop](http://msdn.microsoft.com/en-us/library/ms669985.aspx)

# How to

If you have non Shift_JIS Japanese HTML files encoded by EUC-JP or UTF-8(e.g. JDK-ja), copy these files to working directory with converting to Shift_JIS.

```
ruby encodefilter.rb <jdkdoc-ja-dir-src> <workdir-dest>
```

Parse documents and generate a HTML Help project.

```
ruby createhhp.rb <help-file-basename> <javadoc-dir>
```

Remarks: javadoc-dir is workdir-dest above. If you passed step #1, you can run this script towards javadoc dir which has index.html file.

Compile the HTML Help

```
"C:\Program Files\HTML Help Workshop\hhc.exe" <help-file-basename>.hhp
```

To change the default language option of hhp file, modify a part of createhhp.rb.

```
# file.puts "Language=0x411 Japanese"
file.puts "Language=0x409 English (U.S.)"
```

# Resources
[jd2chm](http://www.burgaud.com/jd2chm/) is a Python implementation which can do it in lesser steps, but it doesn't allow you to customize compiler parameters such as language option, toolbar buttons or contents structure. Windows executable(not requires Python) is distributed.

[GnoCHM](http://gnochm.sourceforge.net/) enables you to open CHM on Linux. You can use [xchm](http://xchm.sourceforge.net/) on any Unix desktop. [CHM Reader](https://addons.mozilla.org/firefox/addon/3235)enables you on FireFox.
