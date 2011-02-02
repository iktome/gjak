module Gjak

	# TODO: read these from config file or db
	CARB_INSULIN_RATIO    = (1/10.to_f).freeze
	GLUCOSE_INSULIN_RATIO = (1/40.to_f).freeze

	def insulin_from_carbs(carbs)
		carbs ||= 0
		(CARB_INSULIN_RATIO * carbs).round
	end

	def insulin_from_glucose(glucose)
		glucose ||= 0
		(GLUCOSE_INSULIN_RATIO * glucose).round	
	end

	def insulin(args)
		# TODO: add validation
		carbs, glucose = args[:carbs], args[:glucose]
		insulin_from_carbs(carbs) + insulin_from_glucose(glucose)
	end

end


if $0 == __FILE__
	require 'test/unit'

	class TestConvsersions < Test::Unit::TestCase
		include Gjak

		def setup
			@carbs, @glucose = 40, 276
			@glucose_insulin = ((1/40.to_f)*@glucose).round
			@carbs_insulin   = ((1/10.to_f)*@carbs).round
		end

		def test_insulin_from_carbs
			assert_equal @carbs_insulin, insulin_from_carbs(@carbs)	
		end

		def test_insulin_from_glucose
			assert_equal @glucose_insulin, insulin_from_glucose(@glucose)
		end

		def test_insulin
			assert_equal @glucose_insulin + @carbs_insulin,
				insulin(:carbs => @carbs, :glucose => @glucose)
		end

		def test_insulin_with_only_glucose
			assert_equal insulin_from_glucose(@glucose),
				insulin(:glucose => @glucose)
		end

		def test_insulin_with_only_carbs
			assert_equal insulin_from_carbs(@carbs),
				insulin(:carbs => @carbs)
		end

	end
end
