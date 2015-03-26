module Analytics
  module Models
    class Tokens

      #FIXME: need support for multiple method pipes & method pipes with args
      TOKEN_PATTERN = Regexp.union(
        /\$(\w+)(?:\|(\w+))?/m,
        /\$\$/m
      )

      def self.parse content, lookup={}
        lookup = lookup.with_indifferent_access
        content.gsub(TOKEN_PATTERN) do |match|
          if match == '$$'
            '$'
          else
            # puts "##$2 on #$1"
            if lookup.has_key? $1
              if $2 && lookup[$1].respond_to?($2)
                lookup[$1].send($2)
              else
                lookup[$1]
              end
            else
              #TODO: [Error Handling] even if one token didn't match remove the whole content
              "$#$1"
            end
          end
        end
      end

    end
  end
end

