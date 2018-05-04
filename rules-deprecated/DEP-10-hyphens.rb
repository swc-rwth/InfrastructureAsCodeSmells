rule 'DEPJUL100', 'Avoid Hyphens in Cookbook Names' do
  tags %w{design hyphens}
  cookbook do |filename|
    #cookbook_name(file) #buggy
    if (Pathname.new(filename).basename.to_s.include?("-"))
      [file_match(filename)]
    end
  end
end
