class SchedulesController < ApplicationController
  permits :user, :organization, :group, :repeat_setting, :title, :note, :start_at, :end_at

  # スケジュール一覧(カレンダー)
  def index(current_date: nil)
    @schedules = Schedule.all

    @current_date = current_date.present? ? Date.parse(current_date) : Date.today

    # スケジュールハッシュ生成
    @schedule_hash = Schedule.generate_schedule_hash(@current_date, current_user)
  end

  # GET /schedules/1
  def show(id)
    @schedule = Schedule.find_by(id: id, user_id: current_user.id)
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit(id)
    @schedule = Schedule.find_by(id: id, user_id: current_user.id)
  end

  # POST /schedules
  def create(schedule)
    @schedule = Schedule.new(schedule)
    @schedule.user_id = current_user.id

    if @schedule.save
      redirect_to schedules_path(current_date: @schedule.start_at.to_date)
    else
      render :new
    end
  end

  # PUT /schedules/1
  def update(id, schedule)
    @schedule = Schedule.find_by(id: id, user_id: current_user.id)

    if @schedule.update(schedule)
      redirect_to schedules_path(current_date: @schedule.start_at.to_date)
    else
      render :edit
    end
  end

  # DELETE /schedules/1
  def destroy(id)
    @schedule = Schedule.find_by(id: id, user_id: current_user.id)
    @schedule.destroy

    redirect_to schedules_url, notice: 'Schedule was successfully destroyed.'
  end

  # オートページャー
  def pager(target_month: nil, page: 1)
    current_date = target_month.present? ? Date.parse("#{target_month}-01") : Date.today
    current_date = Date.parse(current_date.since(page.to_i.month).strftime("%Y-%m-01"))

    # スケジュールハッシュ生成
    schedule_hash = Schedule.generate_schedule_hash(current_date, current_user)

    render partial: '/schedules/calendar', locals: { current_date: current_date, schedule_hash: schedule_hash, current_page: (page.to_i + 1) }
  end
end
