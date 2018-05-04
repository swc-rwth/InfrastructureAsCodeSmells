#!!!This rule only works if the cookbooks to check are in the same subdirectory. Moreover it only does make sense if (nearly) all dependencies of all cookbooks are in that directory!!!
#Due to kisters-base cookbook being included in many (all?) supermarket cookbooks this smell occurs often, though this does not mean that those occurences indicate a problem
#rule does not work on includes with a string interpolation
rule 'JUL150', 'Cookbook violates consistency of includes - not correct if includes contains variable interpolation' do
  tags %w{design}
  cookbook do |cookbook_path|
    res_arr = []
    dependencies = []
    bool=0
    recipes  = Dir["#{cookbook_path}/recipes/**/*.rb"]
    recipes.collect do |recipe|
      lines = File.readlines(recipe)
      lines.collect.with_index do |line, index|
        if(line.include?("include_recipe ") && !line.include?("::") && !line.include?("#\{"))  #only other cookbooks, not recipes in same cookbook
          quote = line.scan(/'(.*)'/).flatten | line.scan(/"(.*)"/).flatten
          dependencies << quote[0].to_s
        end
      end
      #included_recipes(read_ast(recipe)).each do |included| #use of api instead of commented code above, both has its pros and cons
      #  if (!included[0].include?("::"))
      #    dependencies << included[0]
      #  end
      #end
    end
    dependencies.delete("")
    #ToDo in future: Download all dependencies ;)
    cookbook_name = File.basename(cookbook_path, ".*")
    all_cookbooks_path_relative = File.dirname(cookbook_path) #parent dir / dir of all cookbooks
    all_cookbooks_path = File.expand_path(all_cookbooks_path_relative) #absolute path
    Dir.chdir(all_cookbooks_path)
    Dir.glob("*/").each do |each_cookbook_path|   #Dir.glob does not change subdir, subsequently we do not need another Dir.chdir()
      if dependencies.include?(each_cookbook_path.delete('\/').squeeze(' '))
        each_path = File.expand_path(each_cookbook_path) #relative --> absolute
        each_recipes  = Dir["#{each_path}/{#{standard_cookbook_subdirs.join(',')}}/**/*.rb"]
        each_recipes += Dir["#{each_path}/*.rb"]
        each_recipes.collect do |each_recipe|
          each_lines = File.readlines(each_recipe)
          each_lines.collect.with_index do |each_line, each_index|
            if(each_line.include?("include_recipe ") && !each_line.include?("::")  && !each_line.include?("#\{"))
              quote = each_line.scan(/'(.*)'/).flatten | each_line.scan(/"(.*)"/).flatten
              dependencies.each do |dep|
                if ((dep.include?(quote[0].to_s) || quote[0].to_s.include?(dep)) && dep!=quote[0].to_s) #ToDo: and partial match too
                  bool = 1
                  puts "Cookbook Include Inconsistency: <<< |" + dep.to_s + "| matches |" + quote[0].to_s + "| in " + each_recipe.to_s + " >>>"
                end
              end
            end
          end
          #dependencies.each do |dep|  #use of api instead of commented code above
          #  included_recipes(read_ast(each_recipe)).each do |included|
          #    if (!included[0].include?("::"))
          #      if ((dep.include?(included[0].to_s) || included[0].to_s.include?(dep)) && dep!=included[0].to_s) #ToDo: and partial match too
          #        bool = 1
          #      end
          #    end
          #  end
          #end
        end
      end
    end
    if bool == 1
      [file_match(cookbook_path)]
    end
  end
end
