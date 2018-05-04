#https://de.wikipedia.org/wiki/Gesetz_von_Demeter
#!!!This rule only works if the cookbooks to check are in the same subdirectory.
#Moreover it only does make sense if (nearly) all dependencies of all cookbooks are in that directory!!!
#Due to kisters-base cookbook being included in many (all?) supermarket cookbooks this smell occurs often, though this does not mean that those occurences indicate a problem
rule 'JUL140', 'Cookbook violates Law of Demeter - transitive dependencies' do
  tags %w{design law_of_demeter}
  cookbook do |cookbook_path|
    res_arr = []
    cookbooks_to_scan = []
    includes = []
    cookbooks_to_scan_specific_recipes = []
    includes_specific_recipes =  []
    cookbook_name = File.basename(cookbook_path, ".*") #use API? cookbook_name(cookbook_path)
    recipes  = Dir["#{cookbook_path}/recipes/**/*.rb"]
    recipes.collect do |recipe|
      lines = File.readlines(recipe)
      lines.collect.with_index do |line, index| #use API? included_recipes
        if(line.include?("include_recipe ") && !line.include?(cookbook_name + "::"))  #only other cookbooks, not recipes in same cookbook, since whole cookbooks is scanned either way
          quote = line.scan(/'(.*)'/).flatten | line.scan(/"(.*)"/).flatten
          if line.include?("::")
            temp_arr = quote[0].to_s.split("::")
            #for cookbooks
            includes << quote[0].to_s
            includes << temp_arr[0]
            #for specific recipes
            cookbooks_to_scan_specific_recipes << temp_arr[0]
            includes_specific_recipes << temp_arr[1]
          else
            cookbooks_to_scan << quote[0].to_s
            includes << quote[0].to_s
          end
        end
      end
    end
    #ToDo in future: Download all ;)
    #for whole cookbooks
    all_cookbooks_path_relative = File.dirname(cookbook_path) #parent dir / dir of all cookbooks
    all_cookbooks_path = File.expand_path(all_cookbooks_path_relative) #absolute path
    Dir.chdir(all_cookbooks_path)
    Dir.glob("*/").each do |each_cookbook_path|   #Dir.glob does not change subdir, subsequently we do not need another Dir.chdir()
      if cookbooks_to_scan.include?(each_cookbook_path.delete('\/').squeeze(' '))
        each_path = File.expand_path(each_cookbook_path) #relative --> absolute
        each_recipes  = Dir["#{each_path}/{#{standard_cookbook_subdirs.join(',')}}/**/*.rb"]
        each_recipes += Dir["#{each_path}/*.rb"]
        each_recipes.collect do |each_recipe|
          each_lines = File.readlines(each_recipe)
          each_lines.collect.with_index do |each_line, each_index|
            if(each_line.include?("include_recipe ") && !each_line.include?(File.basename(each_cookbook_path, ".*") + "::"))  #&& !each_line.include?(cookbook_name + "::")) --> is not included in array includes, because its excluded at line 19
              quote = each_line.scan(/'(.*)'/).flatten | each_line.scan(/"(.*)"/).flatten
                if includes.include?(quote[0].to_s)
                  res_arr << [file_match(cookbook_path)] #adding always the same entry
              end
            end
          end
        end
      end
    end
    #for specific recipes
    Dir.chdir(all_cookbooks_path)
    Dir.glob("*/").each do |each_cookbook_path|   #Dir.glob does not change subdir, subsequently we do not need another Dir.chdir()
      if cookbooks_to_scan_specific_recipes.include?(each_cookbook_path.delete('\/').squeeze(' '))
        each_path = File.expand_path(each_cookbook_path) #relative --> absolute
        each_recipes  = Dir["#{each_path}/{#{standard_cookbook_subdirs.join(',')}}/**/*.rb"]
        each_recipes += Dir["#{each_path}/*.rb"]
        each_recipes.collect do |each_recipe|
          if(includes_specific_recipes.include?(File.basename(each_recipe, ".*")))
            each_lines = File.readlines(each_recipe)
            each_lines.collect.with_index do |each_line, each_index|
              if(each_line.include?("include_recipe ") && !each_line.include?(File.basename(each_cookbook_path, ".*") + "::"))  #&& !each_line.include?(cookbook_name + "::")) #always exclude dependencies in own cookbook
                quote = each_line.scan(/'(.*)'/).flatten | each_line.scan(/"(.*)"/).flatten
                if includes.include?(quote[0].to_s)
                  res_arr << [file_match(cookbook_path)]
                end
              end
            end
          end
        end
      end
    end
    #output
    res_arr.each do |res|
      res
    end
  end
end
