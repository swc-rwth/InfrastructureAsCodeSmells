rule 'DEPJUL050', 'Recipe too large' do
  tags %w{design insufficient_modularization}
  recipe do |ast, file|
    lines = File.readlines(file)
    linecount = 0
    lines.collect.with_index do |line,index|
      if index > 60 && linecount == 0 #ToDo think about value
      #if index == 50 #alternative
        linecount = 1
        {
          :filename => file,
          :matched => file,
       }
      end
    end.compact
  end
end

rule 'DEPJUL051', 'Recipe complexity too high --> Nesting depth to high' do
  tags %w{design insufficient_modularization}
  recipe do |ast, file|
    #nesting depth greater 3 --> only do's and if's
    res = []

    if (recNesting(ast) > 3)
     res << {
      :filename => file,
      :matched => file
     }
    end

    res.each do |res|
      res
    end
  end
end
