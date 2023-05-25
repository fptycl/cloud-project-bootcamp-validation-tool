require_relative 'cpbvt/version'
require_relative 'cpbvt/uploader'
require_relative 'cpbvt/payloads/aws'
require_relative 'cpbvt/validations/aws_2023'

# Define all our modules so we don't have nest modules
# names in our files
module Cpbvt
  module Validations; end
  module Payloads
    module Aws: end
  end
end

class Cpbvt::Aws2023
  def self.run
    attrs = {
      project_scope: "aws-bootcamp-2023",
      user_uuid: 'da124fec-133b-45c5-8423-04b768c886c2',
      region: 'ca-central-1',
      output_path: '/workspace/cloud-project-bootcamp-validation-tool/output'
    }
    Cpbvt::Payloads::Aws::Runner.run :describe_vpcs, attrs.merge({filename: 'describe-vpcs.json'})
  end # def self.run
end # class AwsBootcamp2023