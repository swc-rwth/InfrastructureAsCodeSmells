rule 'DEPJUL160', 'Existing default recipe, but should be empty' do
  tags %w{implementation best_practice}
  cookbook do |path|
    #avoid printing of parser errors
    def capture_stderr(&block)
      original_stderr = $stderr
      $stderr = fake = StringIO.new
      begin
        ret = yield
      ensure
        $stderr = original_stderr
      end
      ret
    end

    recipes  = Dir["#{path}/{recipes}/**/*.rb"]
    res_arr = []
    boolean = 0
    parsed = nil
    recipes.collect do |recipe|
      if (File.basename(recipe, "").eql? "default.rb")
        boolean = 1
        content = File.read(recipe)
        begin
        parsed, comments = capture_stderr{Parser::CurrentRuby.parse_with_comments(content)}
        rescue
        end
        if (parsed != nil)
          res_arr << [file_match(path)]
        end
      end
    end
    if boolean == 0
      res_arr << [file_match(path)]
    end
    res_arr.each do |res|
      res
    end
  end
end
