rule 'DEPJUL080', 'A block of at least 150 characters is repeated at least once' do
  tags %w{design duplicate_block}
  recipe do |ast, filename|
    #parameters
    block_size = 150  #set block size which should get detected
    #end of parameters

    #variables
    res_arr = []
    file_arr = []
    line_count = []
    count_char_line = 0
    count_line = 0
    i = 0
    j = 0
    k = 0
    l = 0
    comp_arr = []
    comp_str = ""
    res_line = 0
    #end of variables

    #start reading file into array
    file = File.new(filename, "r")
    file.each_char do |char|
      file_arr[i]=char
      i = i + 1
    end
    #finished reading file into array

    #remember which caracter is in which line
    file_arr.each do |char|
      if (char=="\n")
        line_count[count_line] = count_char_line
        count_line = count_line + 1
      elsif (char != " ")
        count_char_line = count_char_line + 1
      end
    end
    #everything remembered

    #remove whitespaces and newlines
    file_arr.delete("\n")
    file_arr.delete(" ")
    cleaned_file = file_arr.join()
    #everything removed

    #start comparing
    while j < file_arr.size()-block_size do
      resline = 0  #not necessary as res_line cant decrease? performance hit
      for k in 0..block_size
        comp_arr[k] = file_arr[k+j]
      end
      comp_str = comp_arr.join()
      if (cleaned_file.scan(comp_str.to_s).count > 1) #ToDo: compare array --> tolerance --> not only exact matches
        while (line_count[res_line] < j)  #linecount has max char per line
          res_line = res_line + 1
        end
        res_arr << {        #ToDO: get resource?
         :filename => filename,
         :matched => filename,
         :line => res_line + 2 #+1 because array starts at 0 and lines at 1, and again +1 because its missing in while loop
        }
        j = j + block_size
        while (line_count[res_line] < j)
          res_line = res_line + 1
        end
        j= line_count[res_line]  #shall now continue in next line
      end
      j= j + 1
    end
    #finished comparing

    #return
    res_arr.each do |res|
      res
    end
    #end of return
  end
end
