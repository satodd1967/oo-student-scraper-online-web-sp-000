require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_info = doc.css(".student-card").collect {|info| {:name => info.css(".student-name").text, :location => info.css(".student-location").text, :profile_url => info.css("a").attr("href").value}}
    student_info
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    students = {}
    
    profile_quote = doc.css(".profile-quote").text
    
    profile_bio = doc.css(".description-holder").css("p").text
    
    doc.css(".social-icon-container").css("a").collect do |icons|
      if icons.attr("href").include?("twitter")
        students[:twitter] = icons.attr("href")
      elsif icons.attr("href").include?("linkedin")
        students[:linkedin] = icons.attr("href")
      elsif icons.attr("href").include?("github")
        students[:github] = icons.attr("href")
      elsif icons.attr("href").include?(".com/")
        students[:blog] = icons.attr("href")
        end
      end
    students[:profile_quote] = profile_quote
    students[:bio] = profile_bio
    students
  end

end

