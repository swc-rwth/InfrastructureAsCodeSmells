#optional
require 'pry' #used for debugging
require 'awesome_print' #used for printing of AST for correct implementations  - DEPJUL990

#required
require 'pathname'  #required for getting pathname, instead of
require 'parser/current' #set version
require 'tempfile'
require 'fuzzystringmatch'
require 'unparser'



#lib
def recNesting(thisast)
 unless (thisast.xpath(%q{do_block|if}).empty?)
   #puts "cond1"
   maxBlock = 0
   #puts thisast.xpath(%q{do_block|if}).size
   thisast.xpath(%q{do_block|if}).each do |result| #loop not necessary
     tempmax=recNesting(result)
     if(tempmax > maxBlock)
       maxBlock = tempmax
     end
   end
   return 1+ maxBlock
 else
   unless (thisast.xpath(%q{child::node()}).empty?)
     #puts "cond2"
     maxChild = 0
     #puts thisast.xpath(%q{child::node()}).size
     thisast.xpath(%q{child::node()}).each do |result|
       tempmax_child = recNesting(result)
       if(tempmax_child > maxChild)
         maxChild = tempmax_child
       end
     end
     return 0 + maxChild
   else
     #puts "cond3"
     return 0
   end
 end
end
