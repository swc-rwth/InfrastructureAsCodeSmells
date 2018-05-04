#recipe block is buggy and pulls all kind of files --> possibly use cookbook block with exclusions
rule 'JUL000', 'Do not use tabulator character' do
  tags %w{implementation improper_alignment}
  recipe do |ast, file|
    lines = File.readlines(file)
    lines.collect.with_index do |line, index|
      if line.match("\t")
        {
          :filename => file,
          :matched => file,
          :line => index + 1,
          :column => 0
        }
      end
    end.compact
  end
end

rule 'JUL001', 'The resource is not properly aligned' do  #ToDo: There are some cases where the rule does not detect incorrect indentation
  tags %w{style improper_alignment}
  recipe do |ast, file| #resource block not working?!
    lines = File.readlines(file)
    res_arr = []
    count = 0
    if recNesting(ast) <= 1
      find_resources(ast).each do |resource|  #ToDO: not listing every resource? furthermore: listing do blocks?
        unless (resource.to_s.include?("bash"))  #exclude bash, because columns not correctly detected for code <<-EOH ... EOH "blocks"
          line = []  #line.clear
          resource.xpath(%q{.//pos}).each do |pos|
            temp_line = Integer(pos.xpath(%q{@line}).to_s)
            temp_column = Integer(pos.xpath(%q{@column}).to_s)
            if (line[temp_line] == nil)
              line[temp_line]=temp_column
            elsif (temp_column < line[temp_line])  #get positions of smallest column for each line....have to be the same for each line inside resource
                line[temp_line]=temp_column
            end
          end
          check_same = nil
          first_marker = 0
          first_marker_line = nil
          #line_contains_do = 0  #ToDo: if a recipe blocks contains a do somewhere then ignore that block, because indentation cant be detected correctly with this method
          lines.collect.with_index do |linecont,index|  #possibly exclude first and last?
            if(line[index] != nil)  #check if array contains only elements with same value, apart from nils
              if (first_marker == 0)
                first_marker = 1
                first_marker_line = index
              elsif (check_same == nil)
                check_same = line[index]
              elsif (check_same != line[index])
                res_arr << {
                  :filename => file,
                  :matched => file,
                  :line => first_marker_line
                }
              #res_arr << resource
                break #return only 1 time per resource; not necessary
              end
            end
          end
        end
      end
    end
    res_arr.each do |res|
      res
    end
  end
end

#alternative implementation of rule JUL001
=begin
rule 'JUL002', 'tabulator character' do
  tags %w{style improper_alignment}
  cookbook do |path|
    puts standard_cookbook_subdirs()
    recipes  = Dir["#{path}/{#{standard_cookbook_subdirs.join(',')}}/**/*.rb"]
    recipes += Dir["#{path}/*.rb"]
    recipes.collect do |recipe|
      lines = File.readlines(recipe)
      lines.collect.with_index do |line, index|
        if line.match("\t")
          {
            :filename => recipe,
            :matched => recipe,
            :line => index + 1,
            :column => 0
          }
        end
      end.compact
    end
  end
end
=end
