
What's this?:
  This software generates an HTML Help(CHM) from generic javadoc style API documents.
  It's a easy way to search something from javadoc with pre-compiled full text index.

Requirements:
  Windows
  Ruby (JRuby enabled)
  HTML Help Workshop

How to:
1.If you have non Shift_JIS Japanese HTML files encoded by EUC-JP or UTF-8(e.g. JDK-ja),
  copy these files to working directory with converting to Shift_JIS.

  ruby encodefilter.rb <jdkdoc-ja-dir-src> <workdir-dest>

2.Paese documents and generate a HTML Help project.

  ruby createhhp.rb <help-file-basename> <javadoc-dir>

  Remarks: javadoc-dir is workdir-dest above.
  If you passed step #1, you can run this script towards javadoc dir which has index.html file.

3.Compile the HTML Help
  "C:\Program Files\HTML Help Workshop\hhc.exe" <help-file-basename>.hhp

To change a language option of CHM, modify a part of createhhp.rb.
  # file.puts "Language=0x411 Japanese"
  file.puts "Language=0x409 English (U.S.)"

License:
  GPL

Author:
  Hisateru Tanaka  tanakahisateru@gmail.com
