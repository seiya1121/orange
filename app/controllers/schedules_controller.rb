class SchedulesController < ApplicationController
  permits :user, :organization, :group, :repeat_setting, :title, :note, :start_at, :end_at

  # スケジュール一覧(カレンダー)
  def index(current_date: nil)
    @schedules = Schedule.all

    @current_date = current_date.present? ? Date.parse(current_date) : Date.today

    # スケジュールハッシュ生成
    @schedule_hash = Schedule.generate_schedule_hash(@current_date, current_user)

    # # 祝日ハッシュ生成
    # @holiday_hash = Schedule.generate_holiday_hash(@current_date)
  end

  # GET /schedules/1
  def show(id)
    @schedule = Schedule.find(id)
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit(id)
    @schedule = Schedule.find(id)
  end

  # POST /schedules
  def create(schedule)
    @schedule = Schedule.new(schedule)
    @schedule.user_id = current_user.id

    if @schedule.save
      redirect_to schedules_path, notice: 'Schedule was successfully created.'
    else
      render :new
    end
  end

  # PUT /schedules/1
  def update(id, schedule)
    @schedule = Schedule.find(id)

    if @schedule.update(schedule)
      redirect_to schedules_path, notice: 'Schedule was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /schedules/1
  def destroy(id)
    @schedule = Schedule.find(id)
    @schedule.destroy

    redirect_to schedules_url, notice: 'Schedule was successfully destroyed.'
  end
end
