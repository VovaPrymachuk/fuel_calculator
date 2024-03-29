# frozen_string_literal: true

class Spacecraft
  LAUNCH_COEFFICIENT = 0.042
  LAND_COEFFICIENT = 0.033
  LAUNCH_ADJUSTMENT = 33
  LAND_ADJUSTMENT = 42

  def initialize(mass, flight_route)
    raise ArgumentError, 'Spacecraft mass must be greater than or equal to 0' if mass.negative?
    raise ArgumentError, 'Flight route cannot be nil' if flight_route.nil?

    @spacecraft_mass = mass
    @mass = mass
    @flight_route = flight_route.reverse
  end

  def calculate_fuel
    @flight_route.each do |directive, gravity|
      raise ArgumentError, 'Invalid directive value' unless %w[land launch].include?(directive)
      raise ArgumentError, 'Invalid gravity value' unless gravity.is_a?(Numeric)

      fuel_needed = calculate_basic_fuel(gravity, directive)
      additional_fuel = calculate_additional_fuel(fuel_needed, gravity, directive)
      @mass += fuel_needed + additional_fuel
    end

    @mass - @spacecraft_mass
  end

  private

  def calculate_basic_fuel(gravity, directive)
    coefficient = directive == 'launch' ? LAUNCH_COEFFICIENT : LAND_COEFFICIENT
    adjustment = directive == 'launch' ? - LAUNCH_ADJUSTMENT : - LAND_ADJUSTMENT
    (@mass * gravity * coefficient + adjustment).to_i
  end

  def calculate_additional_fuel(mass, gravity, directive)
    return 0 if mass <= 0

    coefficient = directive == 'launch' ? LAUNCH_COEFFICIENT : LAND_COEFFICIENT
    adjustment = directive == 'launch' ? - LAUNCH_ADJUSTMENT : - LAND_ADJUSTMENT

    fuel_needed = (mass * gravity * coefficient + adjustment).to_i
    additional_fuel = [fuel_needed, 0].max
    additional_fuel + calculate_additional_fuel(additional_fuel, gravity, directive)
  end
end
