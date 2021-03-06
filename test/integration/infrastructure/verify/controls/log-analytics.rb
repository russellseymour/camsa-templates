resource_group_name = input('resource_group_name', value: 'InSpec-AMA', description: 'Name of the resource group to interogate')
unique_string = input('unique_string', value: '9j2f')
la_location = input('la_location', value: 'westeurope')
provider = input('provider', value: '2680257b-9f22-4261-b1ef-72412d367a68')
prefix = input('prefix', value: 'inspec')

title 'Ensure that the Log Analytics workspace is configured correctly'

control 'CAMSA Log Analytics Workspace' do
  impact 1.0
  title 'Log Analytics workspace'

  describe azure_generic_resource(group_name: resource_group_name, name: format('%s-%s-LogAnalytics', prefix, unique_string)) do
    its('type') { should eq 'Microsoft.OperationalInsights/workspaces' }
    its('location') { should cmp la_location }

    its('properties.provisioningState') { should cmp 'Succeeded' }
    its('properties.sku.name') { should cmp 'free' }
    its('properties.retentionInDays') { should eq 7 }

    its('tags') { should include 'provider' }
    its('tags') { should include 'description' }
    its('provider_tag') { should cmp provider }
    its('description_tag') { should include 'Log Analytics workspace to capture information about the health of the Chef Automate Managed App' }
  end
end

