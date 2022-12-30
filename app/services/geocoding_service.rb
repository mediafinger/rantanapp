class GeocodingService
  class << self
    def call(lat:, long:, address:, service: :geoapify) # or: :nominatim, :mapbox, :here, :google
      # Either reverse with coordinates or forward with address - fail if both are given
      raise ArgumentError, "either lat and long or address must be given" if lat.nil? && long.nil? && address.nil?
      raise ArgumentError, "lat and long XOR address must be given" if lat && long && address
      raise ArgumentError, "coordinate missing, lat and long must be given" if address.nil? && (lat.nil? || long.nil?)
      raise ArgumentError, "lat out of range" if lat && (lat < -90 || lat > 90)
      raise ArgumentError, "long out of range" if long && (long < -180 || long > 180)
      raise ArgumentError, "address too short to yield plausible result" if address && address.length < 12 # hmmm...?

      retries ||= 0

      if address?
        {
          method: :forward,
          response: forward_geocode(address: address, service: service),
        }
      else
        {
          method: :reverse,
          response: reverse_geocode(lat: lat, long: long, service: service),
        }
      end
    rescue StandardError => e
      raise e if (retries += 1) >= 2 # retry only once in error case, otherwise raise

      retry
    end

    private

    def forward_geocode(address:, service:)
      # Geocoder::Lookup.get(service).query_url(Geocoder::Query.new("..."))
    end

    def reverse_geocode(lat:, long:, service:)
      # Geocoder::Lookup.get(service).query_url(Geocoder::Query.new("..."))
    end
  end
end