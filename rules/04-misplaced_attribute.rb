rule 'JUL040', 'Parameter order is wrong or not accordingly to Chef styleguide' do
  tags %w{implementation misplaced_attribute}
  recipe do |ast,file|
    res_arr = []
		find_resources(ast).each do |resource|  #ToDO: not listing every resource? furthermore: listing do blocks?
  	  order = []
  	  i = 0
  	  parameters = resource_attributes(resource)
  	  parameters.each do |parameter|
  			case parameter[0]
  			when "source"
  			  order[i] = 1  #assigned numbers are priorities - source should be on top, then ownership, then permissions, etc.
  			when "owner","group"
  			  order[i] = 2
  			when "mode"
  			  order[i] = 3
  			when "action"
  			  order[i] = 4
  			end
  			i=i+1
  		end
  	  if order.compact != order.compact.sort
  		   res_arr << resource
  	  end
	  end
	  res_arr.each do |res|
      res
    end
  end
end
