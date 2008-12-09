def createProjectFile(prjname, basedir)
    
    packages = scanPackageTree(basedir)

    createContentsFile(prjname+'.hhc', basedir, packages)
    createIndexFile(prjname+'.hhk', basedir, packages)
    
    assetsexplise = /^$/
    title = getIndexTitle(basedir)
    
    file = open(prjname+'.hhp', 'w')
    file.puts "[OPTIONS]"
    file.puts "Compatibility=1.1 or later"
    file.puts "Compiled file=#{prjname}.chm"
    file.puts "Contents file=#{prjname}.hhc"
    file.puts "Default Window=default"
    file.puts "Display compile progress=Yes"
    file.puts "Default topic=#{basedir}/overview-summary.html"
    file.puts "Full-text search=Yes"
    file.puts "Index file=#{prjname}.hhk"
    # file.puts "Language=0x411 Japanese"
    file.puts "Language=0x409 English (U.S.)"
    file.puts "Title=#{title}"
    file.puts ""
    file.puts "[WINDOWS]"
    file.puts "default=\"#{title}\",\"#{prjname}.hhc\",\"#{prjname}.hhk\",\"#{basedir}/overview-summary.html\",\"#{basedir}/overview-summary.html\",,,,,0x2520,,0x384e,,,,,,,,0"
    file.puts ""
    file.puts ""
    file.puts "[FILES]"
    collectAssets(basedir, assetsexplise).each() do |path|
        file.puts(path)
    end
    file.puts ""
    file.close()
end

def getIndexTitle(basedir)
    title = ""
    open(basedir + '/index.html', 'r') do |fh|
        fh.read() =~ /\<title\>\n*(.+?)\n*\<\/title\>/i
        title = $1
    end
    return title
end

def collectAssets(assetsdir, assetsexplise)
    assets = []
    Dir.foreach(assetsdir) do |asset|
        assetpath = assetsdir + '/' + asset
        if File.stat(assetpath).ftype == 'file' then
            assets.push(assetpath) unless assetsexplise =~ assetpath
        elsif File.stat(assetpath).ftype == 'directory' and asset[0,1] != '.' then
            assets.concat(collectAssets(assetpath, assetsexplise))
        end
    end
    return assets
end

HEADER = '<HTML><HEAD><meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1"><!-- Sitemap 1.0 --></HEAD><BODY><OBJECT type="text/site properties"></OBJECT>'
FOOTER = '</BODY></HTML>'

def createContentsFile(filename, basedir, packages)
    
    file = open(filename, 'w')
    file.puts HEADER
    
    file.puts "<UL>"
    file.puts "\t" + '<LI> <OBJECT type="text/sitemap">'
    file.puts "\t" * 2 + '<param name="Name" value="Overview">'
    file.puts "\t" * 2 + '<param name="Local" value="' + basedir + '/overview-summary.html">'
    file.puts "\t" * 2 + '<param name="ImageNumber" value="21">'
    file.puts "\t" * 2 + '</OBJECT>'
    
    packages.each() do |pkg|
        file.puts "\t" + formatTopicItem(pkg['name'], basedir+'/'+pkg['file'])
        file.puts "\t" * 1 + "<UL>"
        pkg['classes'].each() do |cls|
            file.puts "\t" * 2 + formatTopicItem(cls['name'], basedir+'/'+cls['file'])
            file.puts "\t" * 2 + "<UL>"
            cls['details'].each() do |det|
                file.puts "\t" * 3 + formatTopicItem(det, basedir+'/'+cls['file']+'#'+det)
            end
            file.puts "\t" * 2 + "</UL>"
        end
        file.puts "\t" * 1 + "</UL>"
    end
    file.puts "</UL>"
    
    file.puts FOOTER
    file.close()
end

def createIndexFile(filename, basedir, packages)
    
    file = open(filename, 'w')
    file.puts HEADER
    
    indexes = {}
    packages.each() do |pkg|
        addKeywordToIndex(indexes, pkg['name'], pkg['name'], basedir+'/'+pkg['file'])
        pkg['classes'].each() do |cls|
            addKeywordToIndex(indexes, cls['name'], pkg['name']+'.'+cls['name'], basedir+'/'+cls['file'])
            cls['details'].each() do |det|
                addKeywordToIndex(indexes, det, pkg['name']+'.'+cls['name']+'.'+det, basedir+'/'+cls['file']+'#'+det)
            end
        end
    end
    
    file.puts "<UL>"
    indexes.keys.sort.each() do |keyword|
        file.puts "\t" + formatIndexItem(keyword, indexes[keyword])
    end
    file.puts "</UL>"
    
    file.puts FOOTER
    file.close()
end

def addKeywordToIndex(indexes, keyword, detail, file)
    if indexes[keyword] == nil then indexes[keyword] = {} end
    indexes[keyword][detail] = file
end


def scanPackageTree(basedir)
    packagelist = []
    rxpkg = /\<A\s+HREF\=\"([\w\d\-\/]+?)\/package\-frame\.html\"\s+target\=\"packageFrame\"\>([\w\d\.]+)\<\/A\>/i
    rxcls = /\<A\s+HREF\=\"([^\.][\w\d\-\.]+?)\"(\s+title\=\".+\")?\s+target\=\"classFrame\"\>(\<I\>)?([\w\d\.]+)(\<\/I\>)?\<\/A\>/i
    
    IO.foreach(basedir + "/overview-frame.html") do | line |
        if (line =~ rxpkg) != nil then
            pkgdir = $1
            pkgname = $2
            print "#{pkgname}\n"
            classes = []
            IO.foreach(basedir + '/' + pkgdir + '/package-frame.html') do | line |
                if (line =~ rxcls) != nil then
                    classfile = $1
                    classname = $4
                    print "#{pkgname}.#{classname}\n"
                    details = scanClassDocument(basedir+'/'+pkgdir+'/'+classfile)
                    classes.push({'name'=>classname, 'file'=>pkgdir+'/'+classfile, 'details'=>details})
                end
            end
            pkgfile = pkgdir + '/package-summary.html'
            packagelist.push({'name'=>pkgname, 'file'=>pkgfile, 'classes'=>classes})
        end
    end
    return packagelist
end

def scanClassDocument(file)
    scanstarts = false
    anchors = []
    IO.foreach(file) do |line|
        if (line =~ /\<A\s+NAME\=\"([^\"]+)\"\>/i) != nil then
            aname = $1
            if (aname =~ /\w+_detail$/i) != nil then
                scanstarts = true
            elsif (aname =~ /^navbar_\w+/i) != nil then
                scanstarts = false
            else
                if scanstarts then
                    anchors.push(aname)
                end
            end
        end
    end
    return anchors
end

def formatTopicItem(name, href)
    out = '<LI><OBJECT type="text/sitemap">'
    out += sprintf('<param name="Name" value="%s">', name)
    if href != nil then
        out += sprintf('<param name="Local" value="%s">', href)
    end
    out += "</OBJECT>"
    return out
end

def formatIndexItem(name, details)
    out = '<LI><OBJECT type="text/sitemap">'
    out += sprintf('<param name="Name" value="%s">', name)
    details.keys.each() do |det|
        out += sprintf('<param name="Name" value="%s">', det)
        out += sprintf('<param name="Local" value="%s">', details[det])
    end
    out += "</OBJECT>"
    return out
end

createProjectFile(ARGV[0], ARGV[1])
