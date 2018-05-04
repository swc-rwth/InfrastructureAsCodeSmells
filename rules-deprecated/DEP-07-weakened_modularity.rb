#!!!This rule only works if the cookbooks to check are in the same subdirectory. Moreover it only does make sense if (nearly) all dependencies of all cookbooks are in that directory!!!
rule 'DEPJUL070', 'Cookbook may not follow high cohesion, low coupling principle' do
  tags %w{design weakened_modularity}
  cookbook do |cookbook_path|
    count_includes = 0 #number of includes of current cookbook
    recipes  = Dir["#{cookbook_path}/{#{standard_cookbook_subdirs.join(',')}}/**/*.rb"]
    recipes += Dir["#{cookbook_path}/*.rb"]
    count = 0
    recipes.collect do |recipe|
      lines = File.readlines(recipe)
      lines.collect.with_index do |line, index|
        count = count + 1
        if(line.include?("include_recipe ") && !line.include?("::"))  #only other cookbooks, not recipes in same cookbook
          count_includes = count_includes + 1
        end
      end
    end
    if (count_includes.to_f / count.to_f > 0.1 )
        [file_match(cookbook_path)]
    end
  end
end
