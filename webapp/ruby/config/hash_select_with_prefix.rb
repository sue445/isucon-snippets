module HashSelectWithPrefix
  refine(Hash) do
    # 特定のprefixのkeyのみを持つHashを返す
    #
    # @param prefix [String,Symbol]
    # @return [Hash] prefixを除いたkeyのHash
    def select_with_prefix(prefix)
      prefix = prefix.to_s

      each_with_object({}) do |(k, v), response|
        str_key = k.to_s

        if str_key.start_with?(prefix)
          new_key = str_key.gsub(prefix, "").to_sym
          response[new_key] = v
        end
      end
    end
  end
end
