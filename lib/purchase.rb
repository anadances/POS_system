class Purchase < ActiveRecord::Base
  belongs_to :sale
end