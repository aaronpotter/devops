# resp = client.change_resource_record_sets({
#   hosted_zone_id: "ResourceId", # required
#   change_batch: { # required
#     comment: "ResourceDescription",
#     changes: [ # required
#       {
#         action: "CREATE", # required, accepts CREATE, DELETE, UPSERT
#         resource_record_set: { # required
#           name: "DNSName", # required
#           # required, accepts SOA, A, TXT, NS, CNAME, MX, PTR, SRV, SPF, AAAA
#           type: "SOA",
#           set_identifier: "ResourceRecordSetIdentifier",
#           weight: 1,
#           # accepts us-east-1, us-west-1, us-west-2, eu-west-1,
#           #    eu-central-1, ap-southeast-1, ap-southeast-2, ap-northeast-1,
#           #    sa-east-1, cn-north-1
#           region: "us-east-1",
#           geo_location: {
#             continent_code: "GeoLocationContinentCode",
#             country_code: "GeoLocationCountryCode",
#             subdivision_code: "GeoLocationSubdivisionCode",
#           },
#           failover: "PRIMARY", # accepts PRIMARY, SECONDARY
#           ttl: 1,
#           resource_records: [
#             {
#               value: "RData", # required
#             },
#           ],
#           alias_target: {
#             hosted_zone_id: "ResourceId", # required
#             dns_name: "DNSName", # required
#             evaluate_target_health: true, # required
#           },
#           health_check_id: "HealthCheckId",
#         },
#       },
#     ],
#   },
# })
module DevopsApi
  # future Route53 Features
  class Route53
    # code
  end
end
