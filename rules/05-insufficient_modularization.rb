rule 'JUL050', 'Recipe too large' do
  tags %w{design insufficient_modularization}
  cookbook do |path|
    recipes  = Dir["#{path}/{recipes}/**/*.rb"]
    recipes.collect do |file|
      lines = File.readlines(file)
      linecount = 0
      lines.collect.with_index do |line,index|
        if index > 60 && linecount == 0 
          linecount = 1
          {
            :filename => file,
            :matched => file,
         }
        end
      end.compact
    end
  end
end

rule 'JUL051', 'Recipe complexity too high --> Nesting depth to high' do
  tags %w{design insufficient_modularization}
  cookbook do |path|
    recipes  = Dir["#{path}/{recipes}/**/*.rb"]
    res = []
    recipes.collect do |file|

      ast = read_ast(file)

      #nesting depth greater 3 --> only do's and if's
      if (recNesting(ast) > 3)
       res << {
        :filename => file,
        :matched => file
       }
      end
    end
    res.each do |res|
      res
    end
  end
end
