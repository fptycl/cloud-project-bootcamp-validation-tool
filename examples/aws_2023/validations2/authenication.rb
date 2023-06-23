Cpbvt::Tester::Runner.describe :authenication do
  spec :should_have_cognito_user_pool do |cognito_user_pool_name|
    pool_id   = assert_load('cognito-idp-list-user-pools').find('Name',cognito_user_pool_name).returns('Id')
    #user_pool = assert_load("cognito-idp-describe-user-pool__#{pool_id}").returns('UserPool')

    #assert_json(user_pool,'EstimatedNumberOfUsers').expects_gt(0)

    #set_pass_message "Found user pool: #{cognito_user_pool_name} with some users in it"
    #set_fail_message "Failed to find a user pool: #{cognito_user_pool_name} with some users in it"
  end

  spec :should_have_trigger_on_post_confirmation do |cognito_user_pool_name, vpc_id|
    #pool_id   = assert_load('cognito-idp-list-user-pools').find('Name',cognito_user_pool_name).returns('Id')
    #user_pool = assert_load("cognito-idp-describe-user-pool__#{pool_id}").returns('UserPool')

    #lambda_arn = assert_json('LambdaConfig','PostConfirmation').returns(:all)
    #lambda_name = lambda_arn.split(':').last

    #lambda_config = assert_load("lambda-get-function__#{lambda_name}").returns('Configuration')
    
    #assert_json(lambda_config,'Runtime').expects_match('python3')
    #assert_json(lambda_config,'CodeSize').expects_gt(0)
    #assert_json(lambda_config,'VpcConfig','VpcId').expects_eq(vpc_id)

    #set_pass_message "Found a Congnito post confirmation python lambda in the custom VPC"
    #set_fail_message "Failed to find a Cognito post confirmation python lambda in the custom VPC"
  end
end