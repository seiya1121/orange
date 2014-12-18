class Schedule < ActiveRecord::Base
  ## アソシエーション
  belongs_to :user
  belongs_to :organization
  # belongs_to :group
  belongs_to :repeat_setting
  has_many   :participations, dependent: :destroy
  has_many   :groups, through: :participations

  ## バリデーション
  validates :title, presence: true

  ## スコープ
  scope :mine, ->(user) { where( schedules: { user_id: user.id } ) }

  ## クラスメソッド
  # スケジュールハッシュ生成
  def self.generate_schedule_hash(current_date, user, organization_id)
    schedule_hash = Hash.new{ |hash, key| hash[key] = Array.new }
    # schedules = Schedule.where(organization_id: organization_id).where(start_at: (current_date.beginning_of_month.beginning_of_day..current_date.end_of_month.end_of_day)).order("schedules.start_at ASC")
    schedules = Schedule.where(organization_id: organization_id, user_id: user.id).where(start_at: (current_date.beginning_of_month.beginning_of_day..current_date.end_of_month.end_of_day)).order("schedules.start_at ASC")
    schedules.each do |schedule|
      schedule_hash[schedule.start_at.strftime("%Y_%m_%d")].push(schedule)
    end

    return schedule_hash
  end
end
