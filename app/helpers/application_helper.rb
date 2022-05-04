module ApplicationHelper
  def self.normalize_time(time)
    results = /(?<minutes>\d+:)?(?<seconds>\d+.\d+)/.match(time).named_captures

    return results['seconds'] if results['minutes'].nil?

    results['minutes'].to_i * 60 + results['seconds'].to_f
  end
end
