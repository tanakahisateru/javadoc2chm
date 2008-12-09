
これは何?
  このソフトウェアjavadoc形式のAPIドキュメントからHTML Help(CHM)を生成します。
  コンパイル済みのフルテキスト索引を使ってjavadocから何か探す、簡単な方法です。

必要環境
  Windows
  Ruby (JRuby可)
  HTML Help Workshop

手順
1.EUC-JPやUTF-8でエンコードされた、非Shift_JIS日本語HTMLファイルの場合(日本版JDKなど)、
  それらのファイルをShiftJISに変換して作業ディレクトリにコピーします。

  ruby encodefilter.rb <jdkdoc-ja-dir-src> <workdir-dest>

2.ドキュメントを解析し、HTMLヘルププロジェクトを作成します。

  ruby createhhp.rb <help-file-basename> <javadoc-dir>

  注：javadoc-dirは上記のworkdir-destです。
  もし手順1をぬかした場合、index.htmlファイルを持つjavadocディレクトリに対して実行してもかまいません。

3.HTMLヘルプをコンパイル

  "C:\Program Files\HTML Help Workshop\hhc.exe" <help-file-basename>.hhp

CHMファイル自体の言語設定を調整するには、createhhp.rbの一部を書き換えてください。
  # file.puts "Language=0x411 Japanese"
  file.puts "Language=0x409 English (U.S.)"


ライセンス
  GPL扱い

作者
  田中久輝 tanakahisateru@gmail.com
