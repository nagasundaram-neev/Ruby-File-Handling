class File_Search
 
 def initialize(filename)
  @filename=  filename
  @MAX_LINES=10
 end

 def create
  file = File.new(@filename, "w+")
   if file
      puts "Enter text atleast #{@MAX_LINES} lines Type EOF from your Keyboard to finish"
      i=0
      while true
        text=gets.chomp
        if (text).eql?('EOF') | (text).eql?('eof')
          if i <@MAX_LINES
            puts "Please enter minimum #{@MAX_LINES} lines"
          else
            puts "Data Save in #{@filename}"
            file.close
            break
          end
        else
        file.puts(text)
        i += 1
        end
      end
     else
       puts "Unable to open file!"
    end
  end

  def search 
    File.open(@filename, "r+")
    text=File.readlines(@filename)
    
    print "Enter the Pattern to find: "
    input_patrn=gets.chomp
    
    print "You want to IGNORECASE (y/n) :"
    ignore_case=gets.chomp

    if ignore_case == "y"
      pattern=Regexp.new(input_patrn,Regexp::IGNORECASE)
    else
      pattern=Regexp.new(input_patrn)
    end
    
    find(text.to_s,pattern,ignore_case)
    
    highlight(input_patrn,text.to_s) 
   end

  def highlight(pattern, text)
   temp=text.to_s
   temp.gsub!(Regexp.new(pattern,Regexp::IGNORECASE), "<b style=background-color:green>#{pattern}</b>") 
   htmlfile = File.new("output.html", "w+")
   htmlfile.puts(temp.to_s)
   puts "please check the Visual output in browser \"firefox output.html\" "
   system 'sleep 3'
   system 'firefox output.html'
  end
 def find(text,pattern,ignore_case)
    i=0
    found=0
  begin  
    f = File.open(@filename)
    f.each {|line|
       i=i+1
       if line.match(pattern) 
       puts "word found at line #{i} at #{line.enum_for(:scan, pattern).map { Regexp.last_match.begin(0) + 1 }}"
       found=1
      end
      if line.match(/\d+/)
        print "Numbers at line #{i}:  "
        puts line.scan(/\d+/).join    
      end
    }
    if found==0
      raise "not found"
    end
  rescue
      puts "Search Pattern Not Found"
  end
  f.close
 end
end
print "Enter the filename:"
filename=gets.chomp
f=File_Search.new(filename)
f.create
f.search
