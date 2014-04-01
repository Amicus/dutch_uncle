module DutchUncle
  class Alerter

    def notify!(name, message, params={})
      Honeybadger.notify(name, message, params)
    end

  end
end