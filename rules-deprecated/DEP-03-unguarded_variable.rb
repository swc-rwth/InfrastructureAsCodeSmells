rule 'DEPJUL030', 'You should probably enclose the variable being interpolated in the string in braces' do
  tags %w{implementation unguarded_variable}
  recipe do |ast, file|
    vararr = []
    reshash = []
    ast.xpath(%q{//var_field/ident/@value|//var_ref/ident/@value}).each do |var|
      unless vararr.include?(var.to_s)
       vararr << var.to_s
      end
    end
    #lines = File.readlines(file) #ERROR (just like wtf?) --> solved --> seems to be connected to return values, needs .compact
    lines = File.readlines(file)
    lines.collect.with_index do |line, index|
      quotes = line.scan(/'(.*)'|"(.*)"/) #array with subarrays(1 hit) as return values
      quotes.each do |subquotes| #each hit
        subquotes.compact.each do |quote| #each result per hit
          vararr.each do |var|
            #puts quote +"           " + var #debug
            #if ((quote =~ /^#{var}(\s)|(.*)(\s)#{var}(\s)(.*)|(\s)#{var}$/)) #beginning, end or surrounded by whitespaces, ToDo: exclude braces (interpolation) more effective
            if (quote =~ /(.*) ##{var} (.*)/) #smell only deals with missing braces!!!
              reshash << { #not working if we return directly here without array
                :filename => file,
                :matched => file,
                :line => index + 1,
                :column => 0
              }
            end
          end
        end
      end
    end
    reshash.each do |res| #workaround to return hashes
      res
    end#.compact
  end
end
