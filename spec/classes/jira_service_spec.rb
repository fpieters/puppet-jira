require 'spec_helper.rb'

describe 'jira' do
  describe 'jira::service' do
    context 'default params' do
      let(:params) {{
        :javahome => '/opt/java',
      }}
      it { should contain_service('jira')}
      it { should contain_file('/etc/init.d/jira')
        .with_content(/Short-Description: Start up JIRA/) }
    end
    context 'overwriting service_manage param' do
      let(:params) {{
        :service_manage => false,
        :javahome => '/opt/java',
      }}
      it { should_not contain_service('jira')}
    end
    context 'overwriting service_manage param with bad boolean' do
      let(:params) {{
        :service_manage => 'false',
        :javahome => '/opt/java',
      }}
      it do
        expect {
          should compile
        }.to raise_error(Puppet::Error, /is not a boolean/)
      end
    end
    context 'overwriting service params' do
      let(:params) {{
        :javahome => '/opt/java',
        :service_ensure => 'stopped',
        :service_enable => false,
      }}
      it { should contain_service('jira').with({
        'ensure' => 'stopped',
        'enable' => 'false',
      })}
    end
    context 'RedHat/CentOS 7 systemd init script' do
      let(:params) {{
        :javahome => '/opt/java',
      }}
      let(:facts) {{
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
      }}
      it { should contain_file('/usr/lib/systemd/system/jira.service')
        .with_content(/Atlassian Systemd Jira Service/) }
    end

  end
end
