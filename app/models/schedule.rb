class Schedule < ActiveRecord::Base
  ## アソシエーション
  belongs_to :user
  belongs_to :organization
  belongs_to :group
  belongs_to :repeat_setting

  ## バリデーション
  validates :title, presence: true

  ## スコープ
  scope :mine, ->(user) { where( schedules: { user_id: user.id } ) }

  ## クラスメソッド
  # スケジュールハッシュ生成
  def self.generate_schedule_hash(current_date, user)
    schedule_hash = Hash.new{ |hash, key| hash[key] = Array.new }
    schedules = Schedule.mine(user).where(start_at: (current_date.beginning_of_month.beginning_of_day..current_date.end_of_month.end_of_day)).order("schedules.start_at ASC")
    schedules.each do |schedule|
      schedule_hash[schedule.start_at.strftime("%Y_%m_%d")].push(schedule)
    end

    return schedule_hash
  end

  # # 祝日ハッシュ生成
  # def self.generate_holiday_hash(current_date)
  #   holiday_hash = Hash.new
  #   HolidayJp.between(current_date.beginning_of_month, current_date.end_of_month).each do |h|
  #     holiday_hash[h.date] = h.name
  #   end

  #   return holiday_hash
  # end
end
