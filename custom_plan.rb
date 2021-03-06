require 'zeus/rails'

class CustomPlan < Zeus::Rails

  def test
    require 'simplecov'
    SimpleCov.start 'rails'
    # SimpleCov.start 'rails' if using RoR

    # require all ruby files
    Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }

    # run the tests
    super
  end
end

Zeus.plan = CustomPlan.new