module Clever
  class School < APIResource
    include Clever::APIOperations::List

    def optional_attributes
      [:state_id, :sis_id, :nces_id, :low_grade, :high_grade, :principal, :location, :phone]
    end


    def teachers(filters={})
      get_linked_resources 'teachers', filters
    end

    def sections(filters={})
      get_linked_resources 'sections', filters
    end


    def students(filters={})
      get_linked_resources 'students', filters
    end

    private

    def get_linked_resources(resource_type, filters={})
      refresh

      page_count     = 1000
      page_n         = 1
      filters[:limit] = page_count
      filters[:page] = page_n
      objects        = []
      uri = links.detect { |link| link[:rel] == resource_type }[:uri]
      response = Clever.request(:get, uri, filters)
      page = Util.convert_to_clever_object(response[:data])
      objects += page

      while page.size == page_count
        page_n  += 1
        filters[:page] = page_n
        response = Clever.request(:get, uri, filters)
        page = Util.convert_to_clever_object(response[:data])
        objects += page
        puts "Fetched #{page.size}/#{objects.size} (page #{page_n}) of #{self.name.gsub("Clever::", "")}" if ENV["DEBUG"]
      end

      objects.compact
    end
  end
end
