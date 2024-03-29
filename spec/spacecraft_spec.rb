# frozen_string_literal: true

require_relative '../spacecraft'

RSpec.describe Spacecraft do
  describe '#calculate_fuel' do
    context 'when passed params are correct' do
      it 'calculates the correct fuel needed for APOLLO 11' do
        mass = 28801
        flight_route = [
          ['launch', 9.807], # Launch from Earth
          ['land', 1.62],    # Land on Moon
          ['launch', 1.62],  # Launch from Moon
          ['land', 9.807]    # Land back on Earth
        ]

        spacecraft = Spacecraft.new(mass, flight_route)
        total_fuel_needed = spacecraft.calculate_fuel
        expect(total_fuel_needed).to eq(51898)
      end

      it 'calculates the correct fuel needed for MISSION ON MARS' do
        mass = 14606
        flight_route = [
          ['launch', 9.807], # Launch from Earth
          ['land', 3.711],   # Land on Mars
          ['launch', 3.711], # Launch from Mars
          ['land', 9.807]    # Land back on Earth
        ]

        spacecraft = Spacecraft.new(mass, flight_route)
        total_fuel_needed = spacecraft.calculate_fuel
        expect(total_fuel_needed).to eq(33388)
      end

      it 'calculates the correct fuel needed for PASSENGER MARS' do
        mass = 75432
        flight_route = [
          ['launch', 9.807], # Launch from Earth
          ['land', 1.62],    # Land on Moon
          ['launch', 1.62],  # Launch from Moon
          ['land', 3.711],   # Land on Mars
          ['launch', 3.711], # Launch from Mars
          ['land', 9.807]    # Land back on Earth
        ]

        spacecraft = Spacecraft.new(mass, flight_route)
        total_fuel_needed = spacecraft.calculate_fuel
        expect(total_fuel_needed).to eq(212_161)
      end
    end

    context 'when spacecraft mass is less than 0' do
      it 'raises an error' do
        mass = -100
        flight_route = [['launch', 9.807]]

        expect { Spacecraft.new(mass, flight_route) }
          .to raise_error(ArgumentError, 'Spacecraft mass must be greater than or equal to 0')
      end
    end

    context 'when flight route is absent' do
      it 'returns 0' do
        mass = 1000
        flight_route = []

        spacecraft = Spacecraft.new(mass, flight_route)
        total_fuel_needed = spacecraft.calculate_fuel
        expect(total_fuel_needed).to eq(0)
      end
    end

    context 'when the flight route contains incorrect directive' do
      it 'raises an ArgumentError' do
        mass = 1000
        flight_route = [
          ['launch', 9.807],
          [nil, 1.62],       # Missing directive
          ['launch', 1.62],
          ['land', 9.807]
        ]

        spacecraft = Spacecraft.new(mass, flight_route)
        expect { spacecraft.calculate_fuel }.to raise_error(ArgumentError, 'Invalid directive value')
      end
    end

    context 'when the flight route contains incorrect gravity' do
      it 'raises an ArgumentError' do
        mass = 1000
        flight_route = [
          ['launch', 9.807],
          ['land', 1.62],
          ['launch', nil], # Missing gravity
          ['land', 9.807]
        ]

        spacecraft = Spacecraft.new(mass, flight_route)
        expect { spacecraft.calculate_fuel }.to raise_error(ArgumentError, 'Invalid gravity value')
      end
    end
  end
end
