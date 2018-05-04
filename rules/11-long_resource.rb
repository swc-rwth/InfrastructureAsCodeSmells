=begin
rule 'JUL110', 'The resource is too long' do
  tags %w{style long_resource}
  recipe do |ast, file|
    res_array = []
    #content = File.read(file)
    #begin
    #parsed = Parser::CurrentRuby.parse(content)
    #rescue
    #end
    #p parsed
    find_resources(ast,type: 'execute').find_all do |resource|
      line = []
      resource.xpath(%q{.//pos}).each do |pos|
        unless line.include?(Integer(pos.xpath(%q{@line}).to_s))
          line << Integer(pos.xpath(%q{@line}).to_s)
        end
      end
      if line.length > 7 #ToDo: pick good value
        res_array << resource
      end
    end
    find_resources(ast,type: 'bash').find_all do |resource|
      line = []
      resource.xpath(%q{.//pos}).each do |pos|
        unless line.include?(Integer(pos.xpath(%q{@line}).to_s))
          line << Integer(pos.xpath(%q{@line}).to_s)
        end
      end
      if line.length > 7 #ToDo: pick good value
        res_array << resource
      end
    end
    res_array.each do |res|
      res
    end
  end
end
=end

rule 'JUL111', 'The resource is too long' do
  tags %w{style long_resource}
  recipe do |ast, file|
    res_array = []
    #content = File.read(file)
    #begin
    #parsed = Parser::CurrentRuby.parse(content)
    #rescue
    #end
    #p parsed
    find_resources(ast).find_all do |resource|
      line = []
      resource.xpath(%q{.//pos}).each do |pos|
        unless line.include?(Integer(pos.xpath(%q{@line}).to_s))
          line << Integer(pos.xpath(%q{@line}).to_s)
        end
      end
      if line.length > 15 #ToDo: pick good value
        res_array << resource
      end
    end
    res_array.each do |res|
      res
    end
  end
end
