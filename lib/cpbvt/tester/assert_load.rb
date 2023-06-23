class Cpbvt::Tester::AssertLoad
  # key (string) -
  # AWS often returns data with a single property
  # so for arrays we often will want to find a record
  # and need to specific the key that we'll be looking
  # at for data
  # eg
  # { "UserPools" => {} }
  def initialize(
    describe_key:,
    spec_key:,
    report:,
    manifest:,
    manifest_payload_key:,
    key: nil
  )
    @report = report
    @describe_key = describe_key
    @spec_key = spec_key
    @data_raw = nil

    # load data
    begin
      @data_raw = manifest.get_output(manifest_payload_key)
      if @data_raw.is_a?(Hash)
        self.pass! kind: 'load_data', status: :pass, message: 'loaded data from manifest', data: { key: manifest_payload_key }
        if key
          if @data_raw.key?(key)
            @data_first_filter = @data_raw[key]
            if @data_first_filter.nil?
              self.fail! kind: 'load_data:first_filter', status: :fail, message: "first filter data returned nil", data: { key: key }
            else
              self.pass! kind: 'load_data:first_filter', status: :pass, message: "first filter data returned data", data: { key: key }
              return self
            end
          else
            self.fail! kind: 'load_data:first_filter', status: :fail, message: "first filter data key exists", data: { key: key }
          end # if @data_raw.key?
        end # if key
      elsif @data_raw.nil?
        self.fail! kind: 'load_data', status: :fail, message: 'loaded data from manifest and nil was found', data: {key: manifest_payload_key }
      else
        self.fail! kind: 'load_data', status: :fail, message: 'payload key found in manifest file', data: {key: manifest_payload_key}
      end # if @data_raw.is_a?
    rescue Errno::ENOENT
      self.fail! kind: 'load_data', status: :fail, message: 'File not found', data: {key: manifest_payload_key}
    rescue Errno::EACCES
      self.fail! kind: 'load_data', status: :fail, message: 'access denied', data: {key: manifest_payload_key}
    end # begin
  end # def initialize

  def find key, value
    data = @data_first_filter || @data_raw
    @data_found = data.find{|t| t[key] == value}
    if @data_found
      self.pass! kind: 'load_data:find', status: :pass, message: 'found value to match key', data: {
        key: key,
        expected_value: value
      }
      return self
    else
      values = data.map{|t| t[key] }
      self.fail! kind: 'load_data:find', status: :fail, message: 'failed to find value to match key', data: {
        key: key,
        expected_value: value,
        found_values: values
      }
    end
  end

  def returns key
    data = @data_found || @data_raw
    if key == :all || key.nil?
      self.fail! kind: 'load_data:return', status: :pass, message: 'return all data'
      return data 
    end
    if data.key?(key)
      self.fail! kind: 'load_data:return', status: :pass, message: 'return all data with provided key', data: { 
        provided_key: key 
      }
      return data[key]
    else
      self.fail! kind: 'load_data:return', status: :pass, message: 'failed to return data with provided key since key does not exist', data: {
        provided_key: key 
      }
    end
  end

  def pass! kind:, status:, message:, data: {}
    @report.pass!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      status: status,
      message: message,
      data: data
    )
  end

  def fail! kind:, status:, message:, data: {}
    @report.pass!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      status: status,
      message: message,
      data: data
    )
  end
end