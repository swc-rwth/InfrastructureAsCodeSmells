rule 'JUL120', 'Recipe uses too many attributes' do
  tags %w{design too_many_attributes}
  cookbook do |path|
    recipes  = Dir["#{path}/{recipes}/**/*.rb"]
    recipes.collect do |file|
      ast = read_ast(file)
      vararr = []
      ast.xpath(%q{//var_field/ident/@value|//var_ref/ident/@value}).each do |var|
        unless vararr.include?(var.to_s)
         vararr << var.to_s
        end
      end
      line_count = File.readlines(file).size
      if line_count > 5
        if vararr.length.to_f / line_count.to_f > 0.3 #ToDo: good value?
          #[ast] #eventually buggy
          [file_match(file)]
        end
      end
    end.compact
  end
end
