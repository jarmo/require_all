#--
# Copyright (C)2009 Tony Arcieri
# You can redistribute this under the terms of the MIT license
# See file LICENSE for details
#++

module LoadGlob
  # Load all files matching the given glob, handling dependencies between
  # the files gracefully
  def load_glob(glob)
    files = Dir[glob].map { |file| File.expand_path file }
            
    begin
      failed = []
      first_name_error = nil
      
      # Attempt to load each file, rescuing which ones raise NameError for
      # undefined constants.  Keep trying to successively reload files that 
      # previously caused NameErrors until they've all been loaded or no new
      # files can be loaded, indicating unresolvable dependencies.
      files.each do |file|
        begin
          require file
        rescue NameError => ex
          failed << file
          first_name_error ||= ex
        rescue ArgumentError => ex
          # Work around ActiveSuport freaking out... *sigh*
          #
          # ActiveSupport sometimes throws these exceptions and I really
          # have no idea why.  Code loading will work successfully if these
          # exceptions are swallowed, although I've run into strange 
          # nondeterministic behaviors with constants mysteriously vanishing.
          # I've gone spelunking through dependencies.rb looking for what 
          # exactly is going on, but all I ended up doing was making my eyes 
          # bleed.
          #
          # FIXME: If you can understand ActiveSupport's dependencies.rb 
          # better than I do I would *love* to find a better solution
          raise unless ex.message["is not missing constant"]
          
          STDERR.puts "Warning: load_glob swallowed ActiveSupport 'is not missing constant' error"
          STDERR.puts ex.backtrace[0..9]
        end
      end
      
      # If this pass didn't resolve any NameErrors, we've hit an unresolvable
      # dependency, so raise one of the exceptions we encountered.
      if failed.size == files.size
        raise first_name_error
      else
        files = failed
      end
    end until failed.empty?
    
    true
  end
end

include LoadGlob