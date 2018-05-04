rule 'DEPJUL090', 'Metadata.rb is missing' do
  tags %w{design unstructured_module}
  cookbook do |filename|
    unless (File.exist?(File.join(filename, 'Metadata.rb')) || File.exist?(File.join(filename, 'metadata.rb')))
      [file_match(File.join(filename, 'Metadata.rb'))] #Why as an array? return is array of hashes? loop creates array?
    end
  end
end

rule 'DEPJUL091', 'Template folder contains files missing the .erb file ending' do
  tags %w{design unstructured_module}
  cookbook do |filename|
    res_arr = []
    templates = File.join(filename,'templates/')
    Dir[templates.to_s + "**/*"].each do |file|
      if (File.file?(file))
        unless (file =~ /.erb$/)
          res_arr << file_match(file)
        end
      end
    end
    res_arr.each do |res|
      res
    end
  end
end

rule 'DEPJUL092', 'Attributes folder missing' do
    tags %w{design unstructured_module}
    cookbook do |filename|
      attributes = File.join(filename,'attributes/')
      unless (Dir.exists?(attributes))
        [file_match(attributes)]
      end
    end
  end


rule 'DEPJUL093', 'Recipes folder missing' do
  tags %w{design unstructured_module}
  cookbook do |filename|
    recipes = File.join(filename,'recipes/')
    unless (Dir.exists?(recipes))
      [file_match(recipes)]
    end
  end
end

rule 'DEPJUL094', 'Attributes folder contains files with non .rb file ending' do
  tags %w{design unstructured_module}
  cookbook do |filename|
    res_arr = []
    attributes = File.join(filename,'attributes/')
    Dir[attributes.to_s + "**/*"].each do |file|
      if (File.file?(file))
        unless (file =~ /.rb$/)
          res_arr << file_match(file)
        end
      end
    end
    res_arr.each do |res|
      res
    end
  end
end


rule 'DEPJUL095', 'Recipes folder contains files with non .rb file ending' do
  tags %w{design unstructured_module}
  cookbook do |filename|
    res_arr = []
    recipes = File.join(filename,'recipes/')
    Dir[recipes.to_s + "**/*"].each do |file|
      if (File.file?(file))
        unless (file =~ /.rb$/)
          res_arr << file_match(file)
        end
      end
    end
    res_arr.each do |res|
      res
    end
  end
end
