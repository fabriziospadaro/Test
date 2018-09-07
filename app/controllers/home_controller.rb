class HomeController < ApplicationController
  def index
    city_ranker = CityRanker.new()
    city_ranker.rank_by_altitude()
    @datas = city_ranker.get_formatted_results()

    city_ranker.save_results()
    city_ranker.print_results()
  end
end
