require 'pp'
class Cpbvt::Tester::Runner
  @@describes = {}
  @@loaded = false

  def self.run!(
    validations_path:, 
    manifest:, 
    general_params:, 
    specific_params:, 
    dynamic_params:
  )
    report = Cpbvt::Tester::Report.new
    # loads the validations files
    # and the registers the describes and their specs
    unless @loadded
      pattern_path_files = File.join(validations_path,"*.rb")
      path_files = Dir.glob(pattern_path_files)
      path_files.each do |path|
        require path
      end
    end

    # run the actual specs
    @@describes.each do |describe_key,describe_instance|
      describe_instance.specs.each do |spec_key,spec_instance|
        spec_instance.evaluate! report, manifest, general_params, specific_params, dynamic_params
      end
    end

    # output the report
    results = JSON.parse(report.to_json)
    pp results

  end

  def self.describe key, &block
    describe = Cpbvt::Tester::Describe.new(
      key: key.to_sym,
      context: block
    )
    raise "describe key already in use: #{key}" if @@describes.key?(key)
    @@describes[key] = describe
  end
end