class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 一覧ページでのソート方向変更用メソッド
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  # ソート時に検索条件を引き継ぐためのメソッド
  def take_search_params
    { searched: { user_name: @search_params.try(:[], :user_name),
                  item_name: @search_params.try(:[], :item_name),
                  tag_name: @search_params.try(:[], :tag_name),
                  status: @search_params.try(:[], :status) } }
  end

  helper_method :sort_direction, :take_search_params

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile_text, :avatar])
    end

end
