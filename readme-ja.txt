
����͉�?
  ���̃\�t�g�E�F�Ajavadoc�`����API�h�L�������g����HTML Help(CHM)�𐶐����܂��B
  �R���p�C���ς݂̃t���e�L�X�g�������g����javadoc���牽���T���A�ȒP�ȕ��@�ł��B

�K�v��
  Windows
  Ruby (JRuby��)
  HTML Help Workshop

�菇
1.EUC-JP��UTF-8�ŃG���R�[�h���ꂽ�A��Shift_JIS���{��HTML�t�@�C���̏ꍇ(���{��JDK�Ȃ�)�A
  �����̃t�@�C����ShiftJIS�ɕϊ����č�ƃf�B���N�g���ɃR�s�[���܂��B

  ruby encodefilter.rb <jdkdoc-ja-dir-src> <workdir-dest>

2.�h�L�������g����͂��AHTML�w���v�v���W�F�N�g���쐬���܂��B

  ruby createhhp.rb <help-file-basename> <javadoc-dir>

  ���Fjavadoc-dir�͏�L��workdir-dest�ł��B
  �����菇1���ʂ������ꍇ�Aindex.html�t�@�C��������javadoc�f�B���N�g���ɑ΂��Ď��s���Ă����܂��܂���B

3.HTML�w���v���R���p�C��

  "C:\Program Files\HTML Help Workshop\hhc.exe" <help-file-basename>.hhp

CHM�t�@�C�����̂̌���ݒ�𒲐�����ɂ́Acreatehhp.rb�̈ꕔ�����������Ă��������B
  # file.puts "Language=0x411 Japanese"
  file.puts "Language=0x409 English (U.S.)"


���C�Z���X
  GPL����

���
  �c���v�P tanakahisateru@gmail.com
