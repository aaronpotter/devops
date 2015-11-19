# devops-packer-uimapi
1.To prepare the depndencies to be used by chef-solo, run this command inside elkstack directory:
bundle exec berks vendor ../../cookbook

2.Edit packer.json according to your cookbook directory

3.To run packer build run this command:(You can get the values of ACCESSKEY and SECRETKEY from passpack)
packer build \
    -var 'aws_access_key=ACCESSKEY' \
    -var 'aws_secret_key=SECRETKEY' \
    packer.json
