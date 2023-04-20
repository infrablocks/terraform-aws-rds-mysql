# frozen_string_literal: true

require 'spec_helper'

describe 'security group' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:allowed_cidrs) do
    var(role: :root, name: 'allowed_cidrs')
  end
  let(:vpc_id) do
    output(role: :prerequisites, name: 'vpc_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'includes the component and deployment identifier in the name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :name,
                including(component)
                  .and(including(deployment_identifier))
              ))
    end

    it 'includes the component and deployment identifier in the description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :description,
                including(component)
                  .and(including(deployment_identifier))
              ))
    end

    it 'uses the provided VPC ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:vpc_id, vpc_id))
    end

    it 'allows ingress on port 3306 to nodes within the provided ' \
       'allowed CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                [:ingress, 0],
                a_hash_including(
                  from_port: 3306,
                  to_port: 3306,
                  protocol: 'tcp',
                  cidr_blocks: allowed_cidrs
                )
              ))
    end

    it 'includes component and deployment identifier tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
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
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Name: including(component)
                          .and(including(deployment_identifier))
                )
              ))
    end
  end

  describe 'when database_port provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.database_port = '3307'
      end
    end

    it 'allows ingress on the provided port to nodes within the provided ' \
       'allowed CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                [:ingress, 0],
                a_hash_including(
                  from_port: 3307,
                  to_port: 3307,
                  protocol: 'tcp',
                  cidr_blocks: allowed_cidrs
                )
              ))
    end
  end
end
