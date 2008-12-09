require "kconv.rb"
require "fileutils.rb"

def convertFile(orgpath, targetpath)
    print orgpath + "\n"
    if orgpath =~ /.*\.html?/ then
        text = ""
        open(orgpath, 'r') do |fin|
            text = fin.read().tosjis
            text.sub!(
                /\<meta\s+http-equiv=\"Content-Type\"\s+content=\"text\/html;\s*charset=.+?\"\>/i,
                "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=shift_jis\">")
        end
        open(targetpath, 'w') do |fout|
            fout.write(text)
        end
    else
        FileUtils.cp(orgpath, targetpath)
    end
end

def convert(orgpath, targetpath)
    t = File.ftype(orgpath)
    if t == 'file' then
        convertFile(orgpath, targetpath)
    elsif t == 'directory' then
        FileUtils.mkdir(targetpath) unless File.exists?(targetpath)
        Dir.foreach(orgpath) do |subfile|
            if subfile[0,1] != '.' then
                convert(orgpath + '/' + subfile, targetpath + '/' + subfile)
            end
        end
    end
end

convert(ARGV[0], ARGV[1])
