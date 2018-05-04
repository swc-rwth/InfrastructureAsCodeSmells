rule 'JUL020', 'Try to keep lines under 140 characters long' do
  tags %w{implementation long_statement}
  cookbook do |path|
    recipes  = Dir["#{path}/{recipes,attributes}/**/*.rb"]
    recipes.collect do |file|
      lines = File.readlines(file)
      lines.collect.with_index do |line, index|
        if line.length > 140
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
end
