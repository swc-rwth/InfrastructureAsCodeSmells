=begin
### implementation never tested, due to bug --> see comment
rule 'DEPJUL060', 'Resources not following single responsibility principle' do
  tags %w{design multifaceted_abstraction}
  recipe do |ast, file|
    find_resources(ast,type: 'execute').find_all do |cmd|
      cmd_str = (resource_attribute(cmd, 'command')) #buggy since string is not complete due to variables being interpolated
      #puts cmd_str
      #puts resource_attributes(cmd)
      if (cmd_str.include?('&&'))
        {
         :filename => file,
         :matched => file
        }
      end
    end.compact
  end
end
=end

rule 'DEPJUL061', 'Resources not following single responsibility principle - alternative' do
  tags %w{design multifaceted_abstraction}
  recipe do |ast, file|
    resarr = []
    find_resources(ast,type: 'execute').find_all do |cmd|
      line = nil
      cmd.xpath(%q{.//pos}).each do |pos| #get line where resource starts
        currentline = Integer(pos.xpath(%q{@line}).to_s)
        if (line == nil)
          line = currentline
        elsif (currentline < line)
          line = currentline
        end
      end
      cmd.xpath(%q{.//tstring_content/@value}).each do |query|
          if (query.to_s.scan("&&").any? || query.to_s.scan(";").any?) #include? not working
          resarr << {
            :filename => file,
            :matched => file,
            :line => line
          }
        end
      end
    end
    resarr.each do |res|
      res
    end
  end
end
