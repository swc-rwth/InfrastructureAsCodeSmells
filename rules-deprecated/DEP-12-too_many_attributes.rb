rule 'DEPJUL120', 'Recipe uses too many attributes' do
  tags %w{design too_many_attributes}
  recipe do |ast, file|
    vararr = []
    ast.xpath(%q{//var_field/ident/@value|//var_ref/ident/@value}).each do |var|
      unless vararr.include?(var.to_s)
       vararr << var.to_s
      end
    end
    line_count = File.readlines(file).size
    if line_count > 5
      if vararr.length.to_f / line_count.to_f > 0.3 #ToDo: good value?
        #[ast]
        file_match(file)
      end
    end
  end
end
