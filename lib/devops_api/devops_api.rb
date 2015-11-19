# main class
module DevopsApi
  module InstanceMethods
    def initialize profile='default', region='us-east-1'
      aws_init profile, region
    end
    def servers filter, tag='Name'
      rx_filter = /#{filter}/ if filter.class == String
      rx_filter = filter if filter.class == Regexp
      ec2.instances.select do |i|
        found = i.tags.select{|t| t.key == tag}
        next if found.empty?
        found.first.value =~ rx_filter
      end
    end
    def get_object_path bucket_name, regex
      found_obj = s3.bucket(bucket_name).objects.find{|f| f.key =~ regex }
      raise 'S3 Object not found!' if found_obj.nil?
      found_obj.key
    end
    def get_hosted_zone_list
      r53.list_hosted_zones.hosted_zones.map{ |z| { name: z.name, id: z.id } }
    end
    def get_record_list hosted_zone_id
      r53.list_resource_record_sets(hosted_zone_id: hosted_zone_id)
    end
    def change_zone_records changes
      r53.change_resource_record_sets changes
    end
    def r53_client
      Aws::Route53::Client.new
    end
    alias_method :r53, :r53_client
    def s3
      Aws::S3::Resource.new
    end
    def ec2
      Aws::EC2::Resource.new
    end
    def ec2_client
      Aws::EC2::Client.new
    end
    def aws_init profile, region
      conf_file = File.expand_path(File.join('~', '.aws', 'credentials'))
      if File.exists?(conf_file)
        Aws.config.update(region: region, credentials: Aws::SharedCredentials.new(profile_name: profile))
      else
        fail "#{conf_file} file is missing!"
      end
    end
  end

  module ClassMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
