rule 'JUL130', 'Try to avoid comments, but instead code clean' do
  tags %w{design avoid_comments}
  cookbook do |path|
    recipes  = Dir["#{path}/{recipes}/**/*.rb"]
    res_arr = []
    recipes.collect do |file|

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



      #strip first comment lines from file (often licensing, general information --> decided to be excluded)
      tempfile = Tempfile.new('content')
      out_lines = []
      beginning = 1
      lines = File.readlines(file)
      lines.each do |line|
        unless line.start_with?("\#") && beginning == 1
          beginning = 0
          out_lines << line
        end
      end
      File.open(tempfile, 'w') do |f|
        out_lines.each do |line|
          f.write line
        end
      end

      #parsing and getting comments
      content = File.read(tempfile)
      begin
      parsed, comments = capture_stderr{Parser::CurrentRuby.parse_with_comments(content)}
      rescue
      end
      unless comments == nil
        if comments.any?
          res_arr << file_match(file)
        end
      end
    end
    res_arr.each do |res|
      res
    end
  end
end
