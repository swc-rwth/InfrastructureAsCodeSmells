rule 'JUL990', 'print AST' do
  tags %w{debug}
  recipe do |ast, file|
    ap ast
  end
end

rule 'JUL991', 'print parser tree' do
  tags %w{debug}
  recipe do |ast, file|
    content = File.read(file)
      begin
      parsed, comments = Parser::CurrentRuby.parse_with_comments(content)
      rescue
      end
      puts parsed
      puts comments
  end
end


