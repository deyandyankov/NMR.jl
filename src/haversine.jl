function haversine(x, y)
    @inbounds begin
        # longitudes
        Δλ = deg2rad(y[1] - x[1])

        # latitudes
        φ₁ = deg2rad(x[2])
        φ₂ = deg2rad(y[2])
    end

    Δφ = φ₂ - φ₁

    # haversine formula
    a = sin(Δφ/2)^2 + cos(φ₁)*cos(φ₂)*sin(Δλ/2)^2

    # distance on the sphere
    distance_in_meters = round(2 * 6371e3 * asin( min(√a, one(a)) )) # take care of floating point errors
    distance_in_miles = round(distance_in_meters / 1620, 2)
    distance_in_miles
end
