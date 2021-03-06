class SchedulesController < ApplicationController
  permits :repeat_setting, :title, :note, :start_at, :end_at

  before_action :set_organization
  before_action :check_member

  # スケジュール一覧(カレンダー)
  def index(current_date: nil, organization_id: nil)
    # @schedules = Schedule.where(organization_id: @organization.id)

    @current_date = current_date.present? ? Date.parse(current_date) : Date.today

    # スケジュールハッシュ生成
    @schedule_hash = Schedule.generate_schedule_hash(@current_date, current_user, organization_id)
  end

  # GET /schedules/1
  def show(id)
    @schedule = Schedule.find_by(id: id, user_id: current_user.id)
  end

  # GET /schedules/new
  def new(organization_id, day)
    @schedule = Schedule.new
    @day      = Date.parse(day)
  end

  # GET /schedules/1/edit
  def edit(id, day)
    @schedule = Schedule.find_by(id: id, user_id: current_user.id)
    @day      = Date.parse(day)
  end

  # POST /schedules
  def create(organization_id, schedule, group_ids: nil)
    @schedule = Schedule.new(schedule)
    @schedule.user_id         = current_user.id
    @schedule.organization_id = organization_id

    if @schedule.save
      # グループ紐付け
      if group_ids.present?
        group_ids.each do |group_id|
          Participation.create(schedule_id: @schedule.id, group_id: group_id, organization_id: organization_id)
        end
      end

      redirect_to organization_schedules_path(@schedule.organization_id, current_date: @schedule.start_at.to_date)
    else
      render :new
    end
  end

  # PUT /schedules/1
  def update(id, schedule, group_ids: nil)
    @schedule = Schedule.find_by(id: id, user_id: current_user.id)

    if @schedule.update(schedule)
      # グループ紐付け
      if group_ids.present?
        delete_group_ids = @schedule.group_ids - group_ids.map{|x| x.to_i }

        group_ids.each do |group_id|
          Participation.where(schedule_id: @schedule.id, group_id: group_id, organization_id: @schedule.organization_id).first_or_create
        end
      end

      Participation.where(schedule_id: @schedule.id, group_id: delete_group_ids, organization_id: @schedule.organization_id).delete_all

      redirect_to organization_schedules_path(@schedule.organization_id, current_date: @schedule.start_at.to_date)
    else
      render :edit
    end
  end

  # DELETE /schedules/1
  def destroy(organization_id, id)
    @schedule = Schedule.find_by(organization_id: organization_id, id: id, user_id: current_user.id)
    @schedule.destroy

    redirect_to organization_schedules_path(@schedule.organization_id, current_date: @schedule.start_at.to_date), notice: "「#{@schedule.title}」を削除しました。" and return
  end

  # オートページャー
  def pager(target_month: nil, page: 1, organization_id: nil)
    current_date = target_month.present? ? Date.parse("#{target_month}-01") : Date.today
    current_date = Date.parse(current_date.since(page.to_i.month).strftime("%Y-%m-01"))

    # スケジュールハッシュ生成
    schedule_hash = Schedule.generate_schedule_hash(current_date, current_user, organization_id)

    render partial: '/schedules/calendar', locals: { organization: Organization.find(organization_id), current_date: current_date, schedule_hash: schedule_hash, current_page: (page.to_i + 1) }
  end

  private

  # 組織情報取得
  def set_organization
    @organization = Organization.find_by(id: params[:organization_id])

    redirect_to root_path, alert: '組織情報がありません。' and return if @organization.blank?
  end

  # 組織情報取得
  def check_member
    unless Member::OrganizationMember.where(organization_id: params[:organization_id], user_id: current_user.id).exists?
      redirect_to root_path, alert: 'メンバーとして登録されていません。' and return
    end
  end
end
