class GeneratePost < ApplicationRecord
  belongs_to :mail_list, optional: true
end
