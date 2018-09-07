require 'csv'

class CityRanker
  attr_reader :results,:formatted_results

  def initialize()
    @results = []
    @formatted_results = []
  end

  def rank_by_altitude()
    csv = CSV.open("#{Rails.root}/app/exercise/in/World_Cities_Location_table.csv", :col_sep => ";")
    tmp_region = city_name = region_name = ""
    top_altitude = -99999999


    csv.each do |row|
      tmp_region = row[1] if(tmp_region == "")
      #new region, select the city with the best altitude of the previous region
      #before moving on
      if(tmp_region != row[1])
        @results << { region: region_name, city: city_name, altitude: top_altitude.to_i}
        tmp_region = row[1]
        top_altitude = -99999999
      end

      if(row[5].to_f > top_altitude)
        city_name = row[2]
        region_name = row[1]
        top_altitude = row[5].to_f
      end

    end
    #push the last calculated result
    @results << { region: region_name, city: city_name, altitude: top_altitude}
    #format it in a nice way

    return
  end

  def get_formatted_results()
    @formatted_results = @results.sort_by {|city| -city[:altitude]}.map do |item|
      item[:altitude].to_s+"m - "+item[:city].capitalize+", "+item[:region].capitalize
    end
    return @formatted_results
  end

  def save_results()
    File.open("#{Rails.root}/app/exercise/out/sorted_list.txt", "w") do |f|
      f.write(@formatted_results.join("\n"))
    end
  end

  def print_results()
    puts @formatted_results
  end


end
