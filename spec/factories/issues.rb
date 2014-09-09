# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  created_by_id :integer          not null
#  title         :string(255)      not null
#  description   :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  location      :spatial          geometry, 4326
#  photo_uid     :string(255)
#
# Indexes
#
#  index_issues_on_created_by_id  (created_by_id)
#  index_issues_on_location       (location)
#

FactoryGirl.define do
  factory :issue do
    sequence(:title) { |n| "Issue #{n}" }
    description 'Whose leg do you have to hump to get a dry martini around here?'
    location 'POINT(-122 47)'
    association :created_by, factory: :user

    factory :issue_with_json_loc do
      loc_json '{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0.14,52.27]}}'
    end

    trait :with_tags do
      tags { FactoryGirl.build_list(:tag, 2) }
    end

    trait :with_photo do
      photo { File.read(test_photo_path) }
    end

    factory :issue_within_quahog do
      location 'POINT(0.11906 52.20792)'
    end

    factory :issue_outside_quahog do
      location 'POINT(10 80)'
    end

  end
end
