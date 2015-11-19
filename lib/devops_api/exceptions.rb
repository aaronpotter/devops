# Exception classes fir the api
module DevopsApi::Exceptions
  # DevopsApi::Exceptions::MissingReqiredOption
  class MissingReqiredOption < Exception; end
  # DevopsApi::Exceptions::HostedZoneFound
  class HostedZoneFound < Exception; end
end
