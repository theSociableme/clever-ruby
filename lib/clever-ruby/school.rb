module Clever
  class School < APIResource
    include Clever::APIOperations::List

    def optional_attributes
      [:state_id, :sis_id, :nces_id, :low_grade, :high_grade, :principal, :location, :phone]
    end
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
    uri = links.detect { |link| link[:rel] == resource_type }[:uri]
    response = Clever.request(:get, uri, filters)
    Util.convert_to_clever_object(response[:data])
  end

end
