# app/models/trial_click_user.rb
class TrialClickUser < ApplicationRecord
  validates :company_description, presence: true
end
