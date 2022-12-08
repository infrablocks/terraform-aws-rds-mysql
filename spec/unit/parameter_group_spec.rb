# frozen_string_literal: true

require 'spec_helper'

describe 'parameter group' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:database_family) do
    var(role: :root, name: 'database_family')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates an RDS DB parameter group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_parameter_group')
              .once)
    end

    it 'includes the component and deployment identifier in the name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_parameter_group')
              .with_attribute_value(
                :name,
                including(component)
                  .and(including(deployment_identifier))
              ))
    end

    it 'includes the component and deployment identifier in the description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_parameter_group')
              .with_attribute_value(
                :description,
                including(component)
                  .and(including(deployment_identifier))
              ))
    end

    it 'uses the provided database family' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_parameter_group')
              .with_attribute_value(:family, database_family))
    end

    it 'does not include any parameters' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_parameter_group')
              .with_attribute_value(:parameter, a_nil_value))
    end

    it 'includes component and deployment identifier tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_instance')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'includes a name tag including component and deployment identifier' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_instance')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Name: including(component)
                          .and(including(deployment_identifier))
                )
              ))
    end
  end

  describe 'when no database parameters are provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.database_parameters = []
      end
    end

    it 'does not include any parameters' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_parameter_group')
              .with_attribute_value(:parameter, a_nil_value))
    end
  end

  describe 'when one database parameter is provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.database_parameters = [
          {
            name: 'long_query_time',
            value: '2',
            apply_method: 'immediate'
          }
        ]
      end
    end

    it 'includes the provided parameter' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_db_parameter_group')
              .with_attribute_value(
                :parameter,
                [
                  {
                    name: 'long_query_time',
                    value: '2',
                    apply_method: 'immediate'
                  }
                ]
              ))
    end
  end

  describe 'when many database parameters are provided' do
    before(:context) do
      @parameters = [
        {
          name: 'long_query_time',
          value: '2',
          apply_method: 'immediate'
        },
        {
          name: 'binlog_format',
          value: 'ROW',
          apply_method: 'immediate'
        },
        {
          name: 'max_execution_time',
          value: '270000',
          apply_method: 'immediate'
        }
      ]
      @plan = plan(role: :root) do |vars|
        vars.database_parameters = @parameters
      end
    end

    it 'includes the provided parameters' do
      @parameters.each do |parameter|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_db_parameter_group')
                .with_attribute_value(
                  :parameter,
                  a_collection_including(
                    {
                      name: parameter[:name],
                      value: parameter[:value],
                      apply_method: parameter[:apply_method]
                    }
                  )
                ))
      end
    end
  end
end
