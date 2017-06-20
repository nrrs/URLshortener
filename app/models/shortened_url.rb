# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string           not null
#  short_url    :string           not null
#  submitter_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


class ShortenedUrl < ApplicationRecord
  include SecureRandom

  validates :short_url, presence: true, uniqueness: true

  def self.random_code
    random_16 = SecureRandom.urlsafe_base64
    return random_16 unless ShortenedUrl.exists?(short_url: random_16)
  end

  def self.create(user, long_url)
    ShortenedUrl.create!(
      long_url: long_url,
      submitter_id: user.id,
      short_url: self.random_code)
  end

  # Association for User ShortenedUrl
  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :submitter_id,
    class_name: :User

  # Assocation for ShortenedUrl Visit User
  has_many :visits,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :Visit

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitors

  def num_clicks
    visits.count
  end

  def num_uniques
    visits.select(:visitor_id).count
  end

  def num_recent_uniques
    distinct_visits = visits.select(:visitor_id).distinct
    distinct_visits.where(["created_at >= ?", 10.minutes.ago]).count
  end
end
