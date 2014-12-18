class Participation < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :group
end
